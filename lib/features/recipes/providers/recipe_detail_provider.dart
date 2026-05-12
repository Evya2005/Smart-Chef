import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/repositories/auth_repository.dart';
import '../models/recipe_model.dart';
import '../repositories/recipe_repository.dart';

part 'recipe_detail_provider.g.dart';

@riverpod
Stream<RecipeModel> recipeDetail(Ref ref, String recipeId) {
  final user = ref.watch(authRepositoryProvider).currentUser;
  if (user == null) throw Exception('Not authenticated.');
  return ref
      .watch(recipeRepositoryProvider)
      .watchRecipeWithFallback(user.uid, recipeId);
}

/// Admin-only: watch a recipe that belongs to [ownerUserId].
/// Allowed by the Firestore collection-group admin rule.
@riverpod
Stream<RecipeModel> recipeDetailAdmin(
    Ref ref, String recipeId, String ownerUserId) {
  final user = ref.watch(authRepositoryProvider).currentUser;
  if (user == null) throw Exception('Not authenticated.');
  return ref
      .watch(recipeRepositoryProvider)
      .watchRecipe(ownerUserId, recipeId);
}
