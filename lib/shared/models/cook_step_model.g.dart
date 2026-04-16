// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cook_step_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CookStepModel _$CookStepModelFromJson(Map<String, dynamic> json) =>
    _CookStepModel(
      stepNumber: (json['stepNumber'] as num).toInt(),
      instruction: json['instruction'] as String,
      timerSeconds: (json['timerSeconds'] as num?)?.toInt(),
      timerLabel: json['timerLabel'] as String?,
    );

Map<String, dynamic> _$CookStepModelToJson(_CookStepModel instance) =>
    <String, dynamic>{
      'stepNumber': instance.stepNumber,
      'instruction': instance.instruction,
      'timerSeconds': instance.timerSeconds,
      'timerLabel': instance.timerLabel,
    };
