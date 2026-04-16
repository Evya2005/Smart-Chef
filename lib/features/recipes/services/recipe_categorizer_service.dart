import 'package:google_generative_ai/google_generative_ai.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/logger.dart';
import '../models/recipe_model.dart';

/// Classifies a single recipe into one Hebrew category using Gemini.
/// Never throws — any error returns the default category.
class RecipeCategorizerService {
  const RecipeCategorizerService({
    required this.apiKey,
    this.categories = AppConstants.kRecipeCategories,
  });

  final String apiKey;
  final List<String> categories;

  Future<String> categorize(RecipeModel recipe) async {
    try {
      if (apiKey.isEmpty) return AppConstants.defaultCategory;

      final model =
          GenerativeModel(model: AppConstants.geminiModel, apiKey: apiKey);

      final ingredientNames = recipe.ingredients
          .take(5)
          .map((i) => i.name)
          .join(', ');

      final prompt = '''
אתה מנוע סיווג מתכונים. עליך לסווג מתכון לקטגוריה אחת בלבד מהרשימה הבאה.

קטגוריות אפשריות: ${categories.join(', ')}

פרטי המתכון:
- שם: ${recipe.title}
- תגיות: ${recipe.tags.join(', ')}
- מרכיבים עיקריים: $ingredientNames

החזר אך ורק את שם הקטגוריה בעברית, ללא הסברים, ללא פיסוק, ללא גרשיים.
הקטגוריה חייבת להיות בדיוק אחת מהרשימה שלעיל.
''';

      final response = await model.generateContent([Content.text(prompt)]);
      final text = response.text?.trim() ?? '';
      if (categories.contains(text)) return text;
      AppLogger.w(
          'RecipeCategorizerService: unexpected category "$text", using ${AppConstants.defaultCategory}');
      return AppConstants.defaultCategory;
    } catch (e, st) {
      AppLogger.e('RecipeCategorizerService: categorize failed', e, st);
      return AppConstants.defaultCategory;
    }
  }
}
