// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(recipeList)
final recipeListProvider = RecipeListProvider._();

final class RecipeListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RecipeModel>>,
          List<RecipeModel>,
          Stream<List<RecipeModel>>
        >
    with
        $FutureModifier<List<RecipeModel>>,
        $StreamProvider<List<RecipeModel>> {
  RecipeListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recipeListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recipeListHash();

  @$internal
  @override
  $StreamProviderElement<List<RecipeModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<RecipeModel>> create(Ref ref) {
    return recipeList(ref);
  }
}

String _$recipeListHash() => r'81f221790bb55adbdd99087b058417b6acb5397d';

@ProviderFor(publicRecipes)
final publicRecipesProvider = PublicRecipesProvider._();

final class PublicRecipesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RecipeModel>>,
          List<RecipeModel>,
          Stream<List<RecipeModel>>
        >
    with
        $FutureModifier<List<RecipeModel>>,
        $StreamProvider<List<RecipeModel>> {
  PublicRecipesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'publicRecipesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$publicRecipesHash();

  @$internal
  @override
  $StreamProviderElement<List<RecipeModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<RecipeModel>> create(Ref ref) {
    return publicRecipes(ref);
  }
}

String _$publicRecipesHash() => r'ce725652da14b83788aeceb10ac9dd60d34b6b84';
