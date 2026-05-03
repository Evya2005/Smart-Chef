import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/utils/logger.dart';
import '../../../shared/models/ingredient_model.dart';
import '../../../shared/models/unit_type.dart';
import '../models/recipe_model.dart';
import '../models/substitution_model.dart';

class SubstitutionService {
  const SubstitutionService({required this.apiKey});

  final String apiKey;

  static const _systemPrompt = '''
You are a professional culinary assistant. Given a recipe and a specific ingredient the user wants to replace,
analyze the culinary role of that ingredient and suggest substitutions.

Return ONLY a single valid JSON object — no markdown, no explanation.

Rules:
1. Identify the culinary role (e.g., "חומר תפיחה", "ממתיק", "מייצב", "שומן")
2. Provide 2-4 substitutions grouped by category: "בריא", "טבעוני", "אין לי את זה"
3. Each substitution includes only the steps that need modification (stepUpdates)
4. All text fields must be in Hebrew
5. Units must be from: grams, kilograms, milliliters, liters, teaspoon, tablespoon, cup, piece, pinch, to_taste, none
6. Quantities should be equivalent amounts to the original ingredient

Return JSON matching this schema exactly:
{
  "role": "string — culinary role of the ingredient in Hebrew",
  "substitutions": [
    {
      "category": "בריא|טבעוני|אין לי את זה",
      "name": "string",
      "quantity": number,
      "unit": "string",
      "prepNote": "string or null",
      "stepUpdates": [
        {"stepNumber": integer, "instruction": "updated instruction in Hebrew"}
      ]
    }
  ]
}
''';

  GenerativeModel get _model {
    if (apiKey.isEmpty) {
      throw const SubstitutionException(
          'לא הוגדר מפתח Gemini API. אנא הגדר מפתח בהגדרות.');
    }
    return GenerativeModel(model: AppConstants.geminiModel, apiKey: apiKey);
  }

  Future<({String role, List<SubstitutionModel> substitutions})>
      findSubstitutions(
    RecipeModel recipe,
    IngredientModel target,
  ) async {
    final ingredientsList = recipe.ingredients
        .map((i) {
          final unit =
              i.unit == UnitType.none ? '' : ' ${i.unit.displayLabel}';
          final prep = i.prepNote != null ? ' (${i.prepNote})' : '';
          return '- ${_formatQty(i.quantity)}$unit ${i.name}$prep';
        })
        .join('\n');

    final stepsList = recipe.steps
        .map((s) => '${s.stepNumber}. ${s.instruction}')
        .join('\n');

    final targetUnit =
        target.unit == UnitType.none ? '' : ' ${target.unit.displayLabel}';
    final userPrompt = '''
מתכון: ${recipe.title}

מצרכים:
$ingredientsList

שלבי הכנה:
$stepsList

המצרך להחלפה: ${_formatQty(target.quantity)}$targetUnit ${target.name}
''';

    String rawJson;
    try {
      final parts = <Part>[
        TextPart(_systemPrompt),
        TextPart(userPrompt),
      ];
      final response =
          await _model.generateContent([Content.multi(parts)]);
      rawJson = response.text ?? '';
      AppLogger.d(
          'Substitution raw response: ${rawJson.substring(0, rawJson.length.clamp(0, 200))}...');
    } catch (e, st) {
      AppLogger.e('Substitution API call failed', e, st);
      if (e is SubstitutionException) rethrow;
      throw SubstitutionException('קריאה ל-Gemini נכשלה.', e);
    }

    try {
      return _parseJson(rawJson);
    } on FormatException catch (e) {
      AppLogger.w('Substitution JSON parse failed, retrying. Error: $e');
      try {
        final retryParts = [
          TextPart(_systemPrompt),
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
        throw SubstitutionException(
            'Gemini החזיר JSON לא תקין לאחר ניסיון חוזר.', retryError);
      }
    }
  }

  ({String role, List<SubstitutionModel> substitutions}) _parseJson(
      String rawJson) {
    final cleaned = rawJson
        .replaceAll(RegExp(r'^```[a-z]*\s*', multiLine: true), '')
        .replaceAll(RegExp(r'```\s*$', multiLine: true), '')
        .trim();

    final json = jsonDecode(cleaned) as Map<String, dynamic>;
    final role = json['role'] as String? ?? '';

    final substitutions =
        (json['substitutions'] as List<dynamic>? ?? []).map((s) {
      final map = s as Map<String, dynamic>;
      final stepUpdates =
          (map['stepUpdates'] as List<dynamic>? ?? []).map((su) {
        final suMap = su as Map<String, dynamic>;
        return StepUpdate(
          stepNumber: (suMap['stepNumber'] as num?)?.toInt() ?? 0,
          instruction: suMap['instruction'] as String? ?? '',
        );
      }).toList();

      return SubstitutionModel(
        category: map['category'] as String? ?? 'אין לי את זה',
        name: map['name'] as String? ?? '',
        quantity: (map['quantity'] as num?)?.toDouble() ?? 0,
        unit: UnitType.fromString(map['unit'] as String? ?? 'none'),
        prepNote: map['prepNote'] as String?,
        stepUpdates: stepUpdates,
      );
    }).toList();

    return (role: role, substitutions: substitutions);
  }

  String _formatQty(double qty) {
    if (qty == qty.truncateToDouble()) return qty.toInt().toString();
    return qty.toStringAsFixed(1);
  }
}
