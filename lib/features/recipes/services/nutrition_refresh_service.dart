import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/logger.dart';
import '../models/nutrition_model.dart';
import '../models/recipe_model.dart';

/// Fetches per-serving nutrition estimates for a single recipe using Gemini.
/// Never throws — returns null on any failure.
class NutritionRefreshService {
  const NutritionRefreshService({required this.apiKey});

  final String apiKey;

  Future<NutritionModel?> fetchNutrition(RecipeModel recipe) async {
    if (apiKey.isEmpty) return null;
    try {
      final model =
          GenerativeModel(model: AppConstants.geminiModel, apiKey: apiKey);

      final ingredientList = recipe.ingredients
          .map((i) => '${i.quantity} ${i.unit.name} ${i.name}')
          .join(', ');

      final prompt = '''
Estimate the nutritional values per serving for the following recipe.
Recipe: ${recipe.title}
Servings: ${recipe.defaultServings}
Ingredients: $ingredientList

Return ONLY a valid JSON object with these fields (all numbers, no units in values):
{
  "calories": number (kcal),
  "protein": number (grams),
  "fat": number (grams),
  "carbs": number (grams),
  "fiber": number (grams),
  "sugar": number (grams),
  "sodium": number (mg),
  "saturatedFat": number (grams)
}
No markdown, no explanation — just the JSON object.
''';

      final response =
          await model.generateContent([Content.text(prompt)]);
      final rawText = response.text ?? '';

      // Strip markdown fences if present.
      final cleaned = rawText
          .replaceAll(RegExp(r'^```[a-z]*\s*', multiLine: true), '')
          .replaceAll(RegExp(r'```\s*$', multiLine: true), '')
          .trim();

      final json = jsonDecode(cleaned) as Map<String, dynamic>;
      return NutritionModel(
        calories: (json['calories'] as num?)?.toDouble() ?? 0,
        protein: (json['protein'] as num?)?.toDouble() ?? 0,
        fat: (json['fat'] as num?)?.toDouble() ?? 0,
        carbs: (json['carbs'] as num?)?.toDouble() ?? 0,
        fiber: (json['fiber'] as num?)?.toDouble() ?? 0,
        sugar: (json['sugar'] as num?)?.toDouble() ?? 0,
        sodium: (json['sodium'] as num?)?.toDouble() ?? 0,
        saturatedFat: (json['saturatedFat'] as num?)?.toDouble() ?? 0,
      );
    } catch (e, st) {
      AppLogger.e('NutritionRefreshService: fetchNutrition failed', e, st);
      return null;
    }
  }
}
