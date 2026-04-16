import 'dart:convert';

import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;

import '../../../core/errors/app_exception.dart';
import '../../../core/utils/logger.dart';

class UrlScraperService {
  const UrlScraperService();

  // FB/IG domains supported via in-app WebView authentication.
  static const _webViewSupportedDomains = {
    'facebook.com',
    'www.facebook.com',
    'm.facebook.com',
    'instagram.com',
    'www.instagram.com',
  };

  /// True for FB/IG URLs — must go through the WebView path.
  static bool isSupportedSocialMediaUrl(String url) {
    try {
      return _webViewSupportedDomains
          .contains(Uri.parse(url).host.toLowerCase());
    } catch (_) {
      return false;
    }
  }

  // Social-media domains that require login and cannot be scraped.
  static const _loginWallDomains = {
    'facebook.com',
    'www.facebook.com',
    'm.facebook.com',
    'instagram.com',
    'www.instagram.com',
    'tiktok.com',
    'www.tiktok.com',
    'twitter.com',
    'x.com',
  };

  // Rotate through a few common desktop UA strings to avoid bot detection.
  static const _userAgents = [
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:126.0) Gecko/20100101 Firefox/126.0',
  ];

  /// Fetches the URL and returns both the recipe text and an image URL (if found).
  Future<({String text, String? imageUrl})> scrapeWithImage(String url) async {
    try {
      final uri = Uri.parse(url);

      if (_loginWallDomains.contains(uri.host)) {
        throw const IngestionException(
          'לא ניתן לייבא מתכון ישירות מרשתות חברתיות (פייסבוק, אינסטגרם וכו\') '
          'כי הן מחייבות התחברות.\n'
          'העתיקו את טקסט המתכון מהפוסט והדביקו אותו בשדה "טקסט".',
        );
      }

      final ua = _userAgents[uri.host.length % _userAgents.length];

      AppLogger.d('Fetching URL directly: $url');
      final response = await http.get(
        uri,
        headers: {
          'User-Agent': ua,
          'Accept':
              'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8',
          'Accept-Language': 'en-US,en;q=0.9',
          'Accept-Encoding': 'gzip, deflate, br',
          'Cache-Control': 'max-age=0',
          'Connection': 'keep-alive',
          'Upgrade-Insecure-Requests': '1',
          'sec-fetch-dest': 'document',
          'sec-fetch-mode': 'navigate',
          'sec-fetch-site': 'none',
          'sec-fetch-user': '?1',
          'sec-ch-ua':
              '"Google Chrome";v="125", "Chromium";v="125", "Not.A/Brand";v="24"',
          'sec-ch-ua-mobile': '?0',
          'sec-ch-ua-platform': '"Windows"',
        },
      ).timeout(const Duration(seconds: 20));

      AppLogger.d(
        'Direct fetch $url → ${response.statusCode} '
        '(server: ${response.headers['server'] ?? '-'}, '
        'cf-ray: ${response.headers['cf-ray'] ?? '-'})',
      );

      if (response.statusCode != 200) {
        // Bot-protection detected — fall back to Jina Reader (no image available).
        AppLogger.d(
          'Direct fetch blocked (${response.statusCode}), '
          'trying Jina Reader fallback for $url',
        );
        final jinaText = await _fetchViaJina(url);
        return (text: jinaText, imageUrl: null);
      }

      final document = html_parser.parse(response.body);

      // 1. Try JSON-LD structured data first (most reliable for recipe sites).
      final recipeJsonLd = _findRecipeJsonLd(document);
      if (recipeJsonLd != null) {
        final ldText = _formatRecipeJsonLd(recipeJsonLd);
        if (ldText.length > 100) {
          AppLogger.d(
              'Extracted ${ldText.length} chars from JSON-LD in $url');
          final imageUrl = _extractImageUrlFromJsonLd(recipeJsonLd);
          return (text: ldText, imageUrl: imageUrl);
        }
      }

      // 2. Try <meta> OpenGraph/Twitter description + article body.
      final meta = _extractMetaContent(document);
      final ogImage = _extractOgImage(document);

      // 3. Fall back to cleaned body text.
      _removeUnwantedElements(document);
      final bodyText = document.body?.text
              .replaceAll(RegExp(r'\s{3,}'), '\n\n')
              .trim() ??
          '';

      final combined =
          [if (meta.isNotEmpty) meta, bodyText].join('\n\n').trim();

      AppLogger.d('Scraped ${combined.length} chars from $url');

      if (combined.length < 200) {
        // Direct scrape yielded too little — try Jina as a fallback.
        AppLogger.d(
          'Direct scrape too short (${combined.length} chars), '
          'trying Jina Reader fallback for $url',
        );
        // Keep og:image even when text comes from Jina.
        final jinaText = await _fetchViaJina(url);
        return (text: jinaText, imageUrl: ogImage);
      }

      return (text: combined, imageUrl: ogImage);
    } on IngestionException {
      rethrow;
    } catch (e, st) {
      AppLogger.e('URL scrape failed', e, st);
      throw IngestionException('Failed to fetch URL: $url', e);
    }
  }

  /// Fetches the URL and returns only the recipe text.
  Future<String> fetch(String url) async {
    final result = await scrapeWithImage(url);
    return result.text;
  }

  /// Fetches a URL via Jina AI Reader (r.jina.ai), a free public proxy that
  /// uses a real headless browser — bypasses Cloudflare and JS-rendered pages.
  Future<String> _fetchViaJina(String url) async {
    final jinaUri = Uri.parse('https://r.jina.ai/$url');
    AppLogger.d('Jina Reader fetch: $jinaUri');

    final response = await http.get(
      jinaUri,
      headers: {
        'Accept': 'text/plain',
        'X-Return-Format': 'text',
      },
    ).timeout(const Duration(seconds: 30));

    AppLogger.d(
      'Jina fetch → ${response.statusCode}, '
      '${response.body.length} chars',
    );

    if (response.statusCode != 200) {
      throw IngestionException(
        'לא ניתן לאחזר את המתכון מה-URL הזה (קוד: ${response.statusCode}).\n'
        'נסו להעתיק את טקסט המתכון ולהדביקו בשדה "טקסט".',
      );
    }

    final text = response.body.trim();
    if (text.length < 200) {
      throw const IngestionException(
        'לא ניתן לחלץ תוכן מתכון מה-URL הזה.\n'
        'ייתכן שהאתר מחייב התחברות — העתיקו את טקסט המתכון ידנית.',
      );
    }
    return text;
  }

  /// Finds the Schema.org Recipe JSON-LD object on the page, if present.
  Map<String, dynamic>? _findRecipeJsonLd(dom.Document document) {
    final scripts =
        document.querySelectorAll('script[type="application/ld+json"]');

    for (final script in scripts) {
      try {
        final raw = script.text.trim();
        if (raw.isEmpty) continue;

        // Handle both single object and @graph array.
        final decoded = jsonDecode(raw);
        final candidates = <dynamic>[];

        if (decoded is List) {
          candidates.addAll(decoded);
        } else if (decoded is Map && decoded['@graph'] is List) {
          candidates.addAll(decoded['@graph'] as List);
        } else {
          candidates.add(decoded);
        }

        for (final candidate in candidates) {
          if (candidate is! Map<String, dynamic>) continue;
          final type = candidate['@type'];
          final isRecipe = type == 'Recipe' ||
              (type is List && type.contains('Recipe'));
          if (isRecipe) return candidate;
        }
      } catch (_) {
        // Malformed JSON-LD — skip.
      }
    }
    return null;
  }

  /// Extracts an image URL from a Recipe JSON-LD object.
  /// Handles String, List<String>, ImageObject, and List<ImageObject> formats.
  String? _extractImageUrlFromJsonLd(Map<String, dynamic> recipe) {
    final image = recipe['image'];
    if (image == null) return null;

    String? url;
    if (image is String) {
      url = image;
    } else if (image is List && image.isNotEmpty) {
      final first = image.first;
      if (first is String) {
        url = first;
      } else if (first is Map) {
        url = first['url'] as String?;
      }
    } else if (image is Map) {
      url = image['url'] as String?;
    }

    return _validateImageUrl(url);
  }

  /// Reads the og:image meta tag value.
  String? _extractOgImage(dom.Document document) {
    final url = document
        .querySelector('meta[property="og:image"]')
        ?.attributes['content'];
    return _validateImageUrl(url);
  }

  /// Returns [url] if it passes basic image URL validation, otherwise null.
  String? _validateImageUrl(String? url) {
    if (url == null || url.length < 20) return null;
    if (!url.startsWith('https://')) return null;
    final lower = url.toLowerCase();
    if (lower.endsWith('.svg') || lower.endsWith('.gif')) return null;
    return url;
  }

  String _formatRecipeJsonLd(Map<String, dynamic> recipe) {
    final buf = StringBuffer();

    void add(String label, dynamic value) {
      if (value == null) return;
      buf.writeln('$label: $value');
    }

    add('Title', recipe['name']);
    add('Description', recipe['description']);
    add('Author', _jsonLdAuthor(recipe['author']));
    add('Yield', recipe['recipeYield']);
    add('Prep time', recipe['prepTime']);
    add('Cook time', recipe['cookTime']);
    add('Total time', recipe['totalTime']);
    add('Category', recipe['recipeCategory']);
    add('Cuisine', recipe['recipeCuisine']);
    add('Keywords', recipe['keywords']);

    final ingredients = recipe['recipeIngredient'];
    if (ingredients is List && ingredients.isNotEmpty) {
      buf.writeln('\nIngredients:');
      for (final ing in ingredients) {
        buf.writeln('- $ing');
      }
    }

    final instructions = recipe['recipeInstructions'];
    if (instructions != null) {
      buf.writeln('\nInstructions:');
      if (instructions is List) {
        var step = 1;
        for (final ins in instructions) {
          if (ins is String) {
            buf.writeln('$step. $ins');
          } else if (ins is Map) {
            // HowToStep or HowToSection
            final text = ins['text'] ?? ins['name'];
            if (text != null) buf.writeln('$step. $text');
            // HowToSection has itemListElement
            final items = ins['itemListElement'];
            if (items is List) {
              for (final item in items) {
                if (item is Map) {
                  final t = item['text'] ?? item['name'];
                  if (t != null) buf.writeln('$step. $t');
                }
                step++;
              }
              continue;
            }
          }
          step++;
        }
      } else if (instructions is String) {
        buf.writeln(instructions);
      }
    }

    // Nutrition block if present.
    final nutrition = recipe['nutrition'];
    if (nutrition is Map) {
      buf.writeln('\nNutrition (per serving):');
      nutrition.forEach((k, v) {
        if (k != '@type') buf.writeln('  $k: $v');
      });
    }

    return buf.toString().trim();
  }

  String? _jsonLdAuthor(dynamic author) {
    if (author == null) return null;
    if (author is String) return author;
    if (author is Map) return author['name'] as String?;
    if (author is List && author.isNotEmpty) {
      final first = author.first;
      if (first is Map) return first['name'] as String?;
      return first.toString();
    }
    return null;
  }

  String _extractMetaContent(dom.Document document) {
    final selectors = [
      'meta[property="og:description"]',
      'meta[name="description"]',
      'meta[name="twitter:description"]',
    ];
    for (final sel in selectors) {
      final content =
          document.querySelector(sel)?.attributes['content'];
      if (content != null && content.length > 50) return content;
    }
    return '';
  }

  void _removeUnwantedElements(dom.Document document) {
    const selectors = [
      'script',
      'style',
      'noscript',
      'nav',
      'header',
      'footer',
      'aside',
      '[class*="ad-"]',
      '[class*="sidebar"]',
      '[class*="newsletter"]',
      '[class*="social"]',
      '[class*="comment"]',
      '[id*="sidebar"]',
      '[id*="ad-"]',
      '[class*="popup"]',
      '[class*="modal"]',
      '[class*="cookie"]',
      '[class*="banner"]',
    ];
    for (final selector in selectors) {
      document
          .querySelectorAll(selector)
          .forEach((el) => el.remove());
    }
  }
}
