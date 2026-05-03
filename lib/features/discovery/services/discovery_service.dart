import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/utils/logger.dart';
import '../../../shared/models/cook_step_model.dart';
import '../../../shared/models/ingredient_model.dart';
import '../../../shared/models/unit_type.dart';
import '../../recipes/models/recipe_model.dart';

class DiscoveryService {
  const DiscoveryService();

  static const _uuid = Uuid();

  static const _systemPrompt = '''
You are a creative chef. Given a basket of ingredients, create a surprising, original recipe
that uses primarily those ingredients. You may add up to 5 common pantry staples.

Return ONLY a single valid JSON object — no markdown, no explanation.

Rules:
1. Normalize units to: grams, kilograms, milliliters, liters, teaspoon,
   tablespoon, cup, piece, pinch, to_taste, none
2. Convert all fractions to decimals (1/2 → 0.5)
3. Tags must be from: [vegan, vegetarian, gluten-free, dairy-free, spicy,
   quick, breakfast, lunch, dinner, dessert, snack, bake, grill, fry]
4. If a step has a specific duration, set timerSeconds to that value in seconds
5. IMPORTANT: Translate ALL text fields to Hebrew — title, description, notes,
   ingredient names, prepNotes, and step instructions. Units stay as their enum
   values. Tags stay in English. Numbers stay numeric.
6. Be creative and surprising — don't just make the most obvious dish.

Return JSON matching this schema exactly:
{
  "title": "string",
  "description": "string or null",
  "notes": "string or null",
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

  GenerativeModel get _model =>
      FirebaseAI.googleAI().generativeModel(model: AppConstants.geminiModel);

  Future<RecipeModel> generateFromBasket(List<String> ingredients) async {
    final ingredientsList = ingredients
        .asMap()
        .entries
        .map((e) => '${e.key + 1}. ${e.value}')
        .join('\n');

    final userPrompt =
        'צור מתכון מפתיע ומקורי עם המצרכים הבאים:\n$ingredientsList\n\n'
        'השתמש בעיקר במצרכים אלו. ניתן להוסיף עד 5 מרכיבי מזווה נפוצים.';

    String rawJson;
    try {
      final parts = <Part>[
        const TextPart(_systemPrompt),
        TextPart(userPrompt),
      ];
      final response =
          await _model.generateContent([Content.multi(parts)]);
      rawJson = response.text ?? '';
      AppLogger.d(
          'Discovery raw response: ${rawJson.substring(0, rawJson.length.clamp(0, 200))}...');
    } catch (e, st) {
      AppLogger.e('Discovery API call failed', e, st);
      throw DiscoveryException('קריאה ל-Gemini נכשלה.', e);
    }

    try {
      return _parseJson(rawJson);
    } on FormatException catch (e) {
      AppLogger.w('Discovery JSON parse failed, retrying. Error: $e');
      try {
        final retryParts = [
          const TextPart(_systemPrompt),
          TextPart(userPrompt),
          TextPart(
            'Your previous response was not valid JSON. '
            'Return only the JSON object, no surrounding text.\n'
            'Previous bad response: $rawJson',
          ),
        ];
        final retryResponse =
            await _model.generateContent([Content.multi(retryParts)]);
        final retryJson = retryResponse.text ?? '';
        return _parseJson(retryJson);
      } catch (retryError) {
        throw DiscoveryException(
            'Gemini החזיר JSON לא תקין לאחר ניסיון חוזר.', retryError);
      }
    }
  }

  RecipeModel _parseJson(String rawJson) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

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
      title: json['title'] as String? ?? 'מתכון חדש',
      description: json['description'] as String?,
      notes: json['notes'] as String?,
      tags: List<String>.from(json['tags'] as List<dynamic>? ?? []),
      activeTimeMinutes: (json['activeTimeMinutes'] as num?)?.toInt() ?? 0,
      totalTimeMinutes: (json['totalTimeMinutes'] as num?)?.toInt() ?? 0,
      defaultServings: (json['defaultServings'] as num?)?.toInt() ?? 2,
      ingredients: ingredients,
      steps: steps,
      sourceType: 'discovery',
      createdAt: now,
      updatedAt: now,
    );
  }
}
