// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_display_unit_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Holds per-ingredient unit overrides for the current session.
/// Key: (recipeId, ingredientIndex). Value: UnitType.value string, or null = original.

@ProviderFor(IngredientDisplayUnit)
final ingredientDisplayUnitProvider = IngredientDisplayUnitProvider._();

/// Holds per-ingredient unit overrides for the current session.
/// Key: (recipeId, ingredientIndex). Value: UnitType.value string, or null = original.
final class IngredientDisplayUnitProvider
    extends
        $NotifierProvider<IngredientDisplayUnit, Map<(String, int), String?>> {
  /// Holds per-ingredient unit overrides for the current session.
  /// Key: (recipeId, ingredientIndex). Value: UnitType.value string, or null = original.
  IngredientDisplayUnitProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ingredientDisplayUnitProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ingredientDisplayUnitHash();

  @$internal
  @override
  IngredientDisplayUnit create() => IngredientDisplayUnit();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<(String, int), String?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<(String, int), String?>>(value),
    );
  }
}

String _$ingredientDisplayUnitHash() =>
    r'2d753cecffa36d804da6ccca6bd45f8509575d6d';

/// Holds per-ingredient unit overrides for the current session.
/// Key: (recipeId, ingredientIndex). Value: UnitType.value string, or null = original.

abstract class _$IngredientDisplayUnit
    extends $Notifier<Map<(String, int), String?>> {
  Map<(String, int), String?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<Map<(String, int), String?>, Map<(String, int), String?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Map<(String, int), String?>,
                Map<(String, int), String?>
              >,
              Map<(String, int), String?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
