// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_plan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DailyPlanModel _$DailyPlanModelFromJson(Map<String, dynamic> json) =>
    _DailyPlanModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      mealTime: json['mealTime'] as String,
      recipes: (json['recipes'] as List<dynamic>)
          .map((e) => PlannedRecipeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      timeline: (json['timeline'] as List<dynamic>?)
          ?.map((e) => TimelineEventModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] as String,
      notes: json['notes'] as String? ?? '',
      customInstructions: json['customInstructions'] as String? ?? '',
    );

Map<String, dynamic> _$DailyPlanModelToJson(_DailyPlanModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'mealTime': instance.mealTime,
      'recipes': instance.recipes.map((e) => e.toJson()).toList(),
      'timeline': instance.timeline?.map((e) => e.toJson()).toList(),
      'createdAt': instance.createdAt,
      'notes': instance.notes,
      'customInstructions': instance.customInstructions,
    };
