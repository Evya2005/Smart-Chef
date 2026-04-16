import 'package:freezed_annotation/freezed_annotation.dart';

part 'timeline_event_model.freezed.dart';
part 'timeline_event_model.g.dart';

@freezed
abstract class TimelineEventModel with _$TimelineEventModel {
  const factory TimelineEventModel({
    required String recipeId,
    required String recipeTitle,
    required int stepNumber,
    required String instruction,
    required String startTime, // ISO8601
    required String endTime, // ISO8601
    int? timerSeconds,
  }) = _TimelineEventModel;

  factory TimelineEventModel.fromJson(Map<String, dynamic> json) =>
      _$TimelineEventModelFromJson(json);
}
