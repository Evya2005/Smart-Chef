import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/repositories/auth_repository.dart';
import '../models/recipe_model.dart';
import '../repositories/recipe_repository.dart';

part 'recipe_list_provider.g.dart';

@riverpod
Stream<List<RecipeModel>> recipeList(Ref ref) {
  final user = ref.watch(authRepositoryProvider).currentUser;
  if (user == null) return const Stream.empty();
  return ref.watch(recipeRepositoryProvider).watchRecipes(user.uid);
}

@riverpod
Stream<List<RecipeModel>> publicRecipes(Ref ref) {
  final user = ref.watch(authRepositoryProvider).currentUser;
  if (user == null) return const Stream.empty();
  return ref
      .watch(recipeRepositoryProvider)
      .watchPublicRecipes()
      .map((recipes) => recipes.where((r) => r.userId != user.uid).toList());
}
