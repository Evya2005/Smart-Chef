import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repositories/categories_repository.dart';

part 'categories_provider.g.dart';

@Riverpod(keepAlive: true)
Stream<List<String>> recipeCategories(Ref ref) {
  return ref.watch(categoriesRepositoryProvider).watchCategories();
}
