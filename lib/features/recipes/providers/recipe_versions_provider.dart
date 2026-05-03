import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/repositories/auth_repository.dart';
import '../models/recipe_version_model.dart';
import '../repositories/recipe_version_repository.dart';

part 'recipe_versions_provider.g.dart';

@riverpod
Stream<List<RecipeVersionModel>> recipeVersions(
    Ref ref, String recipeId) {
  final user = ref.watch(authRepositoryProvider).currentUser;
  if (user == null) return const Stream.empty();
  return ref
      .watch(recipeVersionRepositoryProvider)
      .watchVersions(user.uid, recipeId);
}
