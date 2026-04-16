// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_categorizer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RecipeCategorizer)
final recipeCategorizerProvider = RecipeCategorizerProvider._();

final class RecipeCategorizerProvider
    extends $NotifierProvider<RecipeCategorizer, CategorizerStatus> {
  RecipeCategorizerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recipeCategorizerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recipeCategorizerHash();

  @$internal
  @override
  RecipeCategorizer create() => RecipeCategorizer();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CategorizerStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CategorizerStatus>(value),
    );
  }
}

String _$recipeCategorizerHash() => r'c821fce10a09b699907403952e5a3d2e32647959';

abstract class _$RecipeCategorizer extends $Notifier<CategorizerStatus> {
  CategorizerStatus build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<CategorizerStatus, CategorizerStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CategorizerStatus, CategorizerStatus>,
              CategorizerStatus,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
