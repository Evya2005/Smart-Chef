// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(recipeDetail)
final recipeDetailProvider = RecipeDetailFamily._();

final class RecipeDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<RecipeModel>,
          RecipeModel,
          Stream<RecipeModel>
        >
    with $FutureModifier<RecipeModel>, $StreamProvider<RecipeModel> {
  RecipeDetailProvider._({
    required RecipeDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'recipeDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$recipeDetailHash();

  @override
  String toString() {
    return r'recipeDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<RecipeModel> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<RecipeModel> create(Ref ref) {
    final argument = this.argument as String;
    return recipeDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RecipeDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$recipeDetailHash() => r'af0a872803cf1947a7a95f6694fec4b9fa4269cd';

final class RecipeDetailFamily extends $Family
    with $FunctionalFamilyOverride<Stream<RecipeModel>, String> {
  RecipeDetailFamily._()
    : super(
        retry: null,
        name: r'recipeDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RecipeDetailProvider call(String recipeId) =>
      RecipeDetailProvider._(argument: recipeId, from: this);

  @override
  String toString() => r'recipeDetailProvider';
}
