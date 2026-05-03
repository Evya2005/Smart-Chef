import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../shared/models/unit_type.dart';

part 'substitution_model.freezed.dart';
part 'substitution_model.g.dart';

@freezed
abstract class SubstitutionModel with _$SubstitutionModel {
  const factory SubstitutionModel({
    required String category,
    required String name,
    required double quantity,
    required UnitType unit,
    String? prepNote,
    @Default([]) List<StepUpdate> stepUpdates,
  }) = _SubstitutionModel;

  factory SubstitutionModel.fromJson(Map<String, dynamic> json) =>
      _$SubstitutionModelFromJson(json);
}

@freezed
abstract class StepUpdate with _$StepUpdate {
  const factory StepUpdate({
    required int stepNumber,
    required String instruction,
  }) = _StepUpdate;

  factory StepUpdate.fromJson(Map<String, dynamic> json) =>
      _$StepUpdateFromJson(json);
}
