// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_versions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(recipeVersions)
final recipeVersionsProvider = RecipeVersionsFamily._();

final class RecipeVersionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RecipeVersionModel>>,
          List<RecipeVersionModel>,
          Stream<List<RecipeVersionModel>>
        >
    with
        $FutureModifier<List<RecipeVersionModel>>,
        $StreamProvider<List<RecipeVersionModel>> {
  RecipeVersionsProvider._({
    required RecipeVersionsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'recipeVersionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$recipeVersionsHash();

  @override
  String toString() {
    return r'recipeVersionsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<RecipeVersionModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<RecipeVersionModel>> create(Ref ref) {
    final argument = this.argument as String;
    return recipeVersions(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RecipeVersionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$recipeVersionsHash() => r'30c2e2fe7adb02aaf3c4e7ff28a2af80d3094af0';

final class RecipeVersionsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<RecipeVersionModel>>, String> {
  RecipeVersionsFamily._()
    : super(
        retry: null,
        name: r'recipeVersionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RecipeVersionsProvider call(String recipeId) =>
      RecipeVersionsProvider._(argument: recipeId, from: this);

  @override
  String toString() => r'recipeVersionsProvider';
}
