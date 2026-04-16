import 'package:freezed_annotation/freezed_annotation.dart';

part 'cook_step_model.freezed.dart';
part 'cook_step_model.g.dart';

@freezed
abstract class CookStepModel with _$CookStepModel {
  const factory CookStepModel({
    required int stepNumber,
    required String instruction,
    int? timerSeconds,
    String? timerLabel,
  }) = _CookStepModel;

  factory CookStepModel.fromJson(Map<String, dynamic> json) =>
      _$CookStepModelFromJson(json);
}
