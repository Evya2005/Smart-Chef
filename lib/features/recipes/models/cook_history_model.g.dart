// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cook_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CookHistoryModel _$CookHistoryModelFromJson(Map<String, dynamic> json) =>
    _CookHistoryModel(
      id: json['id'] as String,
      recipeId: json['recipeId'] as String,
      userId: json['userId'] as String,
      servingsCooked: (json['servingsCooked'] as num).toInt(),
      cookedAt: DateTime.parse(json['cookedAt'] as String),
      notes: json['notes'] as String?,
      rating: (json['rating'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$CookHistoryModelToJson(_CookHistoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'recipeId': instance.recipeId,
      'userId': instance.userId,
      'servingsCooked': instance.servingsCooked,
      'cookedAt': instance.cookedAt.toIso8601String(),
      'notes': instance.notes,
      'rating': instance.rating,
    };
