import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ingredient_display_unit_provider.g.dart';

/// Holds per-ingredient unit overrides for the current session.
/// Key: (recipeId, ingredientIndex). Value: UnitType.value string, or null = original.
@riverpod
class IngredientDisplayUnit extends _$IngredientDisplayUnit {
  @override
  Map<(String, int), String?> build() => {};

  void setOverride((String, int) key, String? unitValue) {
    state = {...state, key: unitValue};
  }

  String? get(String recipeId, int index) => state[(recipeId, index)];
}
