// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_version_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(recipeVersionRepository)
final recipeVersionRepositoryProvider = RecipeVersionRepositoryProvider._();

final class RecipeVersionRepositoryProvider
    extends
        $FunctionalProvider<
          RecipeVersionRepository,
          RecipeVersionRepository,
          RecipeVersionRepository
        >
    with $Provider<RecipeVersionRepository> {
  RecipeVersionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recipeVersionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recipeVersionRepositoryHash();

  @$internal
  @override
  $ProviderElement<RecipeVersionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RecipeVersionRepository create(Ref ref) {
    return recipeVersionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecipeVersionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecipeVersionRepository>(value),
    );
  }
}

String _$recipeVersionRepositoryHash() =>
    r'fb08703f3bcdcfcbb444630dce02e258e7f28be2';
