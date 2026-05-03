import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/models/ingredient_model.dart';
import '../services/recipe_scaling_service.dart';
import 'recipe_detail_provider.dart';

part 'scaling_provider.g.dart';

@riverpod
class ServingCount extends _$ServingCount {
  @override
  int build(String recipeId) {
    // Default is loaded from the recipe's defaultServings.
    final recipe = ref.watch(recipeDetailProvider(recipeId));
    return recipe.value?.defaultServings ?? 2;
  }

  void increment() => state = state + 1;

  void decrement() {
    if (state > 1) state = state - 1;
  }

  void setCount(int count) {
    if (count >= 1) state = count;
  }
}

@riverpod
Future<List<IngredientModel>> scaledIngredients(
    Ref ref, String recipeId) async {
  final recipe = await ref.watch(recipeDetailProvider(recipeId).future);
  final targetServings = ref.watch(servingCountProvider(recipeId));
  const service = RecipeScalingService();
  return service.scale(
    recipe.ingredients,
    recipe.defaultServings,
    targetServings,
  );
}
