// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planned_recipe_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlannedRecipeModel _$PlannedRecipeModelFromJson(Map<String, dynamic> json) =>
    _PlannedRecipeModel(
      recipeId: json['recipeId'] as String,
      recipeTitle: json['recipeTitle'] as String,
      servings: (json['servings'] as num).toInt(),
      computedStartTime: json['computedStartTime'] as String?,
    );

Map<String, dynamic> _$PlannedRecipeModelToJson(_PlannedRecipeModel instance) =>
    <String, dynamic>{
      'recipeId': instance.recipeId,
      'recipeTitle': instance.recipeTitle,
      'servings': instance.servings,
      'computedStartTime': instance.computedStartTime,
    };
