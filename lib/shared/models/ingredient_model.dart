import 'package:freezed_annotation/freezed_annotation.dart';
import 'unit_type.dart';

part 'ingredient_model.freezed.dart';
part 'ingredient_model.g.dart';

@freezed
abstract class IngredientModel with _$IngredientModel {
  const factory IngredientModel({
    required String name,
    required double quantity,
    required UnitType unit,
    String? prepNote,
    String? category,
    @Default(false) bool inferred,
  }) = _IngredientModel;

  factory IngredientModel.fromJson(Map<String, dynamic> json) =>
      _$IngredientModelFromJson(json);
}
