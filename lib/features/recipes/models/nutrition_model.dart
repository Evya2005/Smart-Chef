import 'package:freezed_annotation/freezed_annotation.dart';

part 'nutrition_model.freezed.dart';
part 'nutrition_model.g.dart';

@freezed
abstract class NutritionModel with _$NutritionModel {
  const factory NutritionModel({
    required double calories,
    required double protein,
    required double fat,
    required double carbs,
    required double fiber,
    required double sugar,
    required double sodium,
    required double saturatedFat,
    @Default(true) bool isEstimated,
  }) = _NutritionModel;

  factory NutritionModel.fromJson(Map<String, dynamic> json) =>
      _$NutritionModelFromJson(json);
}
