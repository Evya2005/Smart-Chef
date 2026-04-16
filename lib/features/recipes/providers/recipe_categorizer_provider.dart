import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/app_constants.dart';
import '../../auth/repositories/auth_repository.dart';
import '../../settings/providers/categories_provider.dart';
import '../../settings/providers/user_settings_provider.dart';
import '../providers/recipe_list_provider.dart';
import '../repositories/recipe_repository.dart';
import '../services/recipe_categorizer_service.dart';

part 'recipe_categorizer_provider.g.dart';

enum CategorizerStatus { idle, running, done, error }

@riverpod
class RecipeCategorizer extends _$RecipeCategorizer {
  @override
  CategorizerStatus build() => CategorizerStatus.idle;

  Future<void> runNow() async {
    state = CategorizerStatus.idle;
    await runIfNeeded();
  }

  Future<void> runIfNeeded() async {
    if (state != CategorizerStatus.idle) return;
    final recipes = ref.read(recipeListProvider).value;
    if (recipes == null) return;
    final uncategorized = recipes
        .where((r) => r.category == AppConstants.defaultCategory)
        .toList();
    if (uncategorized.isEmpty) {
      state = CategorizerStatus.done;
      return;
    }
    state = CategorizerStatus.running;
    final uid = ref.read(authRepositoryProvider).currentUser?.uid;
    if (uid == null) {
      state = CategorizerStatus.error;
      return;
    }
    final apiKey = ref.read(geminiApiKeyProvider).asData?.value ?? '';
    final cats = ref.read(recipeCategoriesProvider).asData?.value
        ?? AppConstants.kRecipeCategories;
    final repo = ref.read(recipeRepositoryProvider);
    final service = RecipeCategorizerService(apiKey: apiKey, categories: cats);
    try {
      // Process 3 at a time to avoid burst calls to Gemini.
      for (var i = 0; i < uncategorized.length; i += 3) {
        final batch = uncategorized.skip(i).take(3).toList();
        await Future.wait(batch.map((r) async {
          final cat = await service.categorize(r);
          await repo.updateCategoryField(uid, r.id, cat);
        }));
      }
      state = CategorizerStatus.done;
    } catch (_) {
      state = CategorizerStatus.error;
    }
  }
}
