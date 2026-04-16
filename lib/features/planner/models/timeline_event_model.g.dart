// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TimelineEventModel _$TimelineEventModelFromJson(Map<String, dynamic> json) =>
    _TimelineEventModel(
      recipeId: json['recipeId'] as String,
      recipeTitle: json['recipeTitle'] as String,
      stepNumber: (json['stepNumber'] as num).toInt(),
      instruction: json['instruction'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      timerSeconds: (json['timerSeconds'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TimelineEventModelToJson(_TimelineEventModel instance) =>
    <String, dynamic>{
      'recipeId': instance.recipeId,
      'recipeTitle': instance.recipeTitle,
      'stepNumber': instance.stepNumber,
      'instruction': instance.instruction,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'timerSeconds': instance.timerSeconds,
    };
