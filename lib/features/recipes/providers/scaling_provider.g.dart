// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scaling_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ServingCount)
final servingCountProvider = ServingCountFamily._();

final class ServingCountProvider extends $NotifierProvider<ServingCount, int> {
  ServingCountProvider._({
    required ServingCountFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'servingCountProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$servingCountHash();

  @override
  String toString() {
    return r'servingCountProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ServingCount create() => ServingCount();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ServingCountProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$servingCountHash() => r'672b01b369328d1abacc7e99e1642d9301f24567';

final class ServingCountFamily extends $Family
    with $ClassFamilyOverride<ServingCount, int, int, int, String> {
  ServingCountFamily._()
    : super(
        retry: null,
        name: r'servingCountProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ServingCountProvider call(String recipeId) =>
      ServingCountProvider._(argument: recipeId, from: this);

  @override
  String toString() => r'servingCountProvider';
}

abstract class _$ServingCount extends $Notifier<int> {
  late final _$args = ref.$arg as String;
  String get recipeId => _$args;

  int build(String recipeId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(scaledIngredients)
final scaledIngredientsProvider = ScaledIngredientsFamily._();

final class ScaledIngredientsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<IngredientModel>>,
          List<IngredientModel>,
          FutureOr<List<IngredientModel>>
        >
    with
        $FutureModifier<List<IngredientModel>>,
        $FutureProvider<List<IngredientModel>> {
  ScaledIngredientsProvider._({
    required ScaledIngredientsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'scaledIngredientsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$scaledIngredientsHash();

  @override
  String toString() {
    return r'scaledIngredientsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<IngredientModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<IngredientModel>> create(Ref ref) {
    final argument = this.argument as String;
    return scaledIngredients(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ScaledIngredientsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$scaledIngredientsHash() => r'524956e6c658896fd0c07d1c68dcafcaf5102bd0';

final class ScaledIngredientsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<IngredientModel>>, String> {
  ScaledIngredientsFamily._()
    : super(
        retry: null,
        name: r'scaledIngredientsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ScaledIngredientsProvider call(String recipeId) =>
      ScaledIngredientsProvider._(argument: recipeId, from: this);

  @override
  String toString() => r'scaledIngredientsProvider';
}
