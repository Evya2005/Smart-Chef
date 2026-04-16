// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_version_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecipeVersionModel _$RecipeVersionModelFromJson(Map<String, dynamic> json) =>
    _RecipeVersionModel(
      id: json['id'] as String,
      versionNumber: (json['versionNumber'] as num).toInt(),
      snapshot: RecipeModel.fromJson(json['snapshot'] as Map<String, dynamic>),
      savedAt: DateTime.parse(json['savedAt'] as String),
      changeNote: json['changeNote'] as String?,
    );

Map<String, dynamic> _$RecipeVersionModelToJson(_RecipeVersionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'versionNumber': instance.versionNumber,
      'snapshot': instance.snapshot.toJson(),
      'savedAt': instance.savedAt.toIso8601String(),
      'changeNote': instance.changeNote,
    };
