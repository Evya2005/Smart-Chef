import 'dart:convert';
import 'dart:io' as dart_io;

import 'package:http/http.dart' as http;

import '../../../core/errors/app_exception.dart';
import '../../../core/utils/logger.dart';

class SocialMediaService {
  const SocialMediaService();

  static const _base = 'https://graph.facebook.com/v18.0';

  Future<String> fetchPostText(String url, String accessToken) async {
    AppLogger.d('SocialMediaService: fetchPostText url=$url');
    final isInstagram = Uri.parse(url).host.contains('instagram');

    // For Facebook, the user already has a valid token — try the Graph API
    // first (no app review needed for public post fields with a user token).
    if (!isInstagram && accessToken.isNotEmpty) {
      try {
        final text = await _fetchFacebookViaGraphApi(url, accessToken);
        if (text.length >= 20) return text;
        AppLogger.d('SocialMediaService: Graph API returned too little content');
      } catch (e) {
        AppLogger.w('SocialMediaService: Graph API attempt failed: $e');
      }
    }

    // Fallback (and primary path for Instagram): Jina reader.
    return _fetchViaJina(url);
  }

  // ─── Facebook Graph API ───────────────────────────────────────────────────

  Future<String> _fetchFacebookViaGraphApi(
      String url, String accessToken) async {
    // 1. Resolve share / short URL to the canonical Facebook URL.
    final finalUrl = await _resolveRedirect(url);
    AppLogger.d('SocialMediaService: resolved url → $finalUrl');

    // 2. Extract the post / video / reel ID.
    final postId = _extractFacebookId(finalUrl) ?? _extractFacebookId(url);
    if (postId == null) {
      throw Exception('could not extract post ID from $finalUrl');
    }
    AppLogger.d('SocialMediaService: post ID → $postId');

    // 3. Fetch fields from the Graph API.
    final response = await http
        .get(
          Uri.parse('$_base/$postId').replace(queryParameters: {
            'fields': 'message,description,name',
            'access_token': accessToken,
          }),
        )
        .timeout(const Duration(seconds: 20));

    AppLogger.d(
        'SocialMediaService: Graph API status=${response.statusCode}');

    if (response.statusCode != 200) {
      throw Exception(
          'Graph API ${response.statusCode} → ${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final parts = [
      (json['message'] as String?)?.trim() ?? '',
      (json['description'] as String?)?.trim() ?? '',
      (json['name'] as String?)?.trim() ?? '',
    ];
    return parts.reduce((a, b) => a.length >= b.length ? a : b);
  }

  /// Follows HTTP redirects and returns the final URL.
  Future<String> _resolveRedirect(String url) async {
    try {
      final client = dart_io.HttpClient();
      try {
        final request = await client.getUrl(Uri.parse(url));
        request.followRedirects = true;
        request.maxRedirects = 5;
        final response = await request.close();
        await response.drain<void>();
        if (response.redirects.isNotEmpty) {
          final loc = response.redirects.last.location;
          // location may be relative — resolve against original URI
          return Uri.parse(url).resolveUri(loc).toString();
        }
        return url;
      } finally {
        client.close();
      }
    } catch (e) {
      AppLogger.d('SocialMediaService: redirect resolve failed: $e');
      return url;
    }
  }

  /// Extracts a Facebook post / video / reel ID from a URL.
  static String? _extractFacebookId(String url) {
    final patterns = [
      RegExp(r'/reel/([A-Za-z0-9_-]+)'),
      RegExp(r'/videos/([A-Za-z0-9_-]+)'),
      RegExp(r'/posts/([A-Za-z0-9_-]+)'),
      RegExp(r'/permalink/([A-Za-z0-9_-]+)'),
      RegExp(r'[?&]story_fbid=([A-Za-z0-9_-]+)'),
      RegExp(r'[?&]fbid=([A-Za-z0-9_-]+)'),
      // share/r/{id} short link
      RegExp(r'/share/r/([A-Za-z0-9_-]+)'),
    ];
    for (final p in patterns) {
      final m = p.firstMatch(url);
      if (m != null) return m.group(1);
    }
    return null;
  }

  // ─── Jina fallback ────────────────────────────────────────────────────────

  Future<String> _fetchViaJina(String url) async {
    AppLogger.d('SocialMediaService: Jina fetch → $url');
    final response = await http
        .get(
          Uri.parse('https://r.jina.ai/$url'),
          headers: {'Accept': 'text/plain'},
        )
        .timeout(const Duration(seconds: 30));

    AppLogger.d('SocialMediaService: Jina status=${response.statusCode} '
        'len=${response.body.length}');

    if (response.statusCode != 200) {
      AppLogger.e('SocialMediaService: Jina error ${response.statusCode}');
      throw IngestionException(
        'שגיאה בגישה לפוסט (קוד ${response.statusCode}). ודא שהפוסט ציבורי.',
      );
    }

    final text = response.body.trim();

    if (_isLoginWall(text)) {
      AppLogger.w('SocialMediaService: login wall detected for $url');
      throw const IngestionException(
        'הפוסט דורש התחברות לצפייה בתוכן.\n'
        'העתק את כיתוב הפוסט/ריל והדבק אותו בתיבת "הדבק טקסט".',
      );
    }

    if (text.length < 50) {
      throw const IngestionException(
        'לא נמצא תוכן בפוסט זה. ודא שהפוסט ציבורי.',
      );
    }
    return text;
  }

  static bool _isLoginWall(String text) =>
      text.contains('Log into Instagram') ||
      text.contains('See everyday moments') ||
      text.contains('instagram.com/accounts/login') ||
      text.contains('Log in to Facebook') ||
      text.contains('log in to Facebook') ||
      text.contains('facebook.com/login') ||
      text.contains('You must log in to continue') ||
      text.contains('Connect with Facebook');
}
