import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/utils/logger.dart';
import '../../../shared/models/cook_step_model.dart';
import '../../../shared/models/ingredient_model.dart';
import '../../../shared/models/unit_type.dart';
import '../../recipes/models/recipe_model.dart';
import 'url_scraper_service.dart';

class GeminiService {
  GeminiService({required String apiKey, UrlScraperService? scraper})
      : _apiKey = apiKey,
        _scraper = scraper ?? const UrlScraperService(),
        _uuid = const Uuid();

  final String _apiKey;
  final UrlScraperService _scraper;
  final Uuid _uuid;

  static const _systemPrompt = '''
You are a recipe data extraction engine. Return ONLY a single valid JSON object —
no markdown, no explanation. Strip all SEO content, blog stories, and ads.

Rules:
1. Normalize units to: grams, kilograms, milliliters, liters, teaspoon,
   tablespoon, cup, piece, pinch, to_taste, none
2. Convert all fractions to decimals (1/2 → 0.5)
3. If an ingredient appears in steps but is missing from the ingredient list,
   add it with inferred: true
4. Tags must be from: [vegan, vegetarian, gluten-free, dairy-free, spicy,
   quick, breakfast, lunch, dinner, dessert, snack, bake, grill, fry]
5. If a step has a specific duration, set timerSeconds to that value in seconds
6. IMPORTANT: Translate ALL text fields to Hebrew — title, description, notes,
   ingredient names, prepNotes, and step instructions. Units stay as their enum
   values (grams, cup, etc.). Tags stay in English. Numbers stay numeric.

Return JSON matching this schema exactly:
{
  "title": "string",
  "description": "string or null",
  "notes": "string or null — chef tips, storage/make-ahead info, substitutions, serving suggestions extracted from the source. Summarize if scattered or lengthy. Translate to Hebrew. null if none.",
  "tags": ["string"],
  "activeTimeMinutes": integer,
  "totalTimeMinutes": integer,
  "defaultServings": integer,
  "ingredients": [{
    "name": "string",
    "quantity": number,
    "unit": "string",
    "prepNote": "string or null",
    "category": "Produce|Dairy|Pantry|Meat|Seafood|Bakery|Spices|Other",
    "inferred": boolean
  }],
  "steps": [{
    "stepNumber": integer,
    "instruction": "string",
    "timerSeconds": integer or null,
    "timerLabel": "string or null"
  }]
}
''';

  GenerativeModel get _model {
    if (_apiKey.isEmpty) {
      throw const IngestionException(
          'לא הוגדר מפתח Gemini API. אנא הגדר מפתח בהגדרות.');
    }
    return GenerativeModel(model: AppConstants.geminiModel, apiKey: _apiKey);
  }

  Future<RecipeModel> parseFromText(String text) async {
    final prompt = 'Extract the recipe from this text:\n\n$text';
    return _callGemini(prompt);
  }

  Future<RecipeModel> parseFromImageBytes(Uint8List imageBytes) =>
      parseFromMultipleImages([imageBytes]);

  Future<RecipeModel> parseFromMultipleImages(
      List<Uint8List> imageBytesList) async {
    final prompt = imageBytesList.length == 1
        ? 'Extract the recipe from this image.'
        : 'Extract the recipe from these ${imageBytesList.length} images. '
            'They show different parts of the same recipe (e.g. ingredients page + steps page).';
    final imageParts = imageBytesList
        .map((bytes) => DataPart('image/jpeg', bytes))
        .toList();
    return _callGemini(prompt, imageParts);
  }

  Future<RecipeModel> parseFromPdf(String extractedText) async {
    return parseFromText(extractedText);
  }

  Future<RecipeModel> parseFromUrl(String url) async {
    final text = await _scraper.fetch(url);
    final recipe = await parseFromText(text);
    return recipe.copyWith(sourceUrl: url, sourceType: 'url');
  }

  /// Generates a food photo for the recipe using Imagen 3 Fast.
  /// Returns null on any failure (non-fatal).
  Future<Uint8List?> generateRecipeImage(
      String title, List<String> ingredientNames) async {
    if (_apiKey.isEmpty) return null;

    try {
      final topIngredients = ingredientNames.take(5).join(', ');
      final prompt =
          'Professional food photography of $title, $topIngredients, '
          'overhead shot, natural lighting, appetizing, high resolution';

      final uri = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/'
        'imagen-3.0-fast-generate-001:predict?key=$_apiKey',
      );

      final body = jsonEncode({
        'instances': [
          {'prompt': prompt}
        ],
        'parameters': {'sampleCount': 1, 'aspectRatio': '1:1'},
      });

      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(const Duration(seconds: 60));

      if (response.statusCode != 200) {
        AppLogger.w(
          'Imagen API returned ${response.statusCode}: '
          '${response.body.substring(0, response.body.length.clamp(0, 200))}',
        );
        return null;
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final predictions = json['predictions'] as List<dynamic>?;
      if (predictions == null || predictions.isEmpty) return null;

      final encoded = predictions.first['bytesBase64Encoded'] as String?;
      if (encoded == null || encoded.isEmpty) return null;

      return base64.decode(encoded);
    } catch (e, st) {
      AppLogger.e('Imagen generation failed', e, st);
      return null;
    }
  }

  Future<RecipeModel> _callGemini(
    String userPrompt, [
    List<Part> extraParts = const [],
  ]) async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final parts = <Part>[
      TextPart(_systemPrompt),
      TextPart(userPrompt),
      ...extraParts,
    ];

    String rawJson;
    try {
      final response =
          await _model.generateContent([Content.multi(parts)]);
      rawJson = response.text ?? '';
      AppLogger.d(
          'Gemini raw response: ${rawJson.substring(0, rawJson.length.clamp(0, 200))}...');
    } catch (e, st) {
      AppLogger.e('Gemini API call failed', e, st);
      if (e is IngestionException) rethrow;
      throw IngestionException('Gemini API call failed.', e);
    }

    try {
      return _parseJson(rawJson, uid);
    } on FormatException catch (e) {
      AppLogger.w('JSON parse failed, retrying. Error: $e');
      // One retry with an explicit correction prompt.
      try {
        final retryParts = [
          TextPart(_systemPrompt),
          TextPart(userPrompt),
          ...extraParts,
          TextPart(
            'Your previous response was not valid JSON. '
            'Return only the JSON object, no surrounding text.\n'
            'Previous bad response: $rawJson',
          ),
        ];
        final retryResponse =
            await _model.generateContent([Content.multi(retryParts)]);
        final retryJson = retryResponse.text ?? '';
        return _parseJson(retryJson, uid);
      } catch (retryError) {
        throw IngestionException(
            'Gemini returned invalid JSON after retry.', retryError);
      }
    }
  }

  RecipeModel _parseJson(String rawJson, String uid) {
    // Strip accidental markdown fences.
    final cleaned = rawJson
        .replaceAll(RegExp(r'^```[a-z]*\s*', multiLine: true), '')
        .replaceAll(RegExp(r'```\s*$', multiLine: true), '')
        .trim();

    final json = jsonDecode(cleaned) as Map<String, dynamic>;

    final ingredients = (json['ingredients'] as List<dynamic>? ?? [])
        .map((i) {
          final map = i as Map<String, dynamic>;
          return IngredientModel(
            name: map['name'] as String? ?? '',
            quantity: (map['quantity'] as num?)?.toDouble() ?? 0,
            unit: UnitType.fromString(map['unit'] as String? ?? 'none'),
            prepNote: map['prepNote'] as String?,
            category: map['category'] as String?,
            inferred: map['inferred'] as bool? ?? false,
          );
        })
        .toList();

    final steps = (json['steps'] as List<dynamic>? ?? [])
        .map((s) {
          final map = s as Map<String, dynamic>;
          return CookStepModel(
            stepNumber: (map['stepNumber'] as num?)?.toInt() ?? 0,
            instruction: map['instruction'] as String? ?? '',
            timerSeconds: (map['timerSeconds'] as num?)?.toInt(),
            timerLabel: map['timerLabel'] as String?,
          );
        })
        .toList();

    final now = DateTime.now();
    return RecipeModel(
      id: _uuid.v4(),
      userId: uid,
      title: json['title'] as String? ?? 'Untitled Recipe',
      description: json['description'] as String?,
      notes: json['notes'] as String?,
      tags: List<String>.from(json['tags'] as List<dynamic>? ?? []),
      activeTimeMinutes: (json['activeTimeMinutes'] as num?)?.toInt() ?? 0,
      totalTimeMinutes: (json['totalTimeMinutes'] as num?)?.toInt() ?? 0,
      defaultServings: (json['defaultServings'] as num?)?.toInt() ?? 2,
      ingredients: ingredients,
      steps: steps,
      createdAt: now,
      updatedAt: now,
    );
  }
}
