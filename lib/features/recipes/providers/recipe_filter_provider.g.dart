// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_filter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RecipeFilterNotifier)
final recipeFilterProvider = RecipeFilterNotifierProvider._();

final class RecipeFilterNotifierProvider
    extends $NotifierProvider<RecipeFilterNotifier, RecipeFilter> {
  RecipeFilterNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recipeFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recipeFilterNotifierHash();

  @$internal
  @override
  RecipeFilterNotifier create() => RecipeFilterNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecipeFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecipeFilter>(value),
    );
  }
}

String _$recipeFilterNotifierHash() =>
    r'c4186f1855179c421b0b5abee4aedd360d106664';

abstract class _$RecipeFilterNotifier extends $Notifier<RecipeFilter> {
  RecipeFilter build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<RecipeFilter, RecipeFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RecipeFilter, RecipeFilter>,
              RecipeFilter,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(filteredRecipes)
final filteredRecipesProvider = FilteredRecipesProvider._();

final class FilteredRecipesProvider
    extends
        $FunctionalProvider<
          List<RecipeModel>?,
          List<RecipeModel>?,
          List<RecipeModel>?
        >
    with $Provider<List<RecipeModel>?> {
  FilteredRecipesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredRecipesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredRecipesHash();

  @$internal
  @override
  $ProviderElement<List<RecipeModel>?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<RecipeModel>? create(Ref ref) {
    return filteredRecipes(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<RecipeModel>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<RecipeModel>?>(value),
    );
  }
}

String _$filteredRecipesHash() => r'0bda367c90588417e53962da1fb9337a9265d64b';
