import 'package:freezed_annotation/freezed_annotation.dart';

part 'planned_recipe_model.freezed.dart';
part 'planned_recipe_model.g.dart';

@freezed
abstract class PlannedRecipeModel with _$PlannedRecipeModel {
  const factory PlannedRecipeModel({
    required String recipeId,
    required String recipeTitle,
    required int servings,
    String? computedStartTime, // ISO8601 string
  }) = _PlannedRecipeModel;

  factory PlannedRecipeModel.fromJson(Map<String, dynamic> json) =>
      _$PlannedRecipeModelFromJson(json);
}
