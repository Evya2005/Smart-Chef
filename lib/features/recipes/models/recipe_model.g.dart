// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecipeModel _$RecipeModelFromJson(Map<String, dynamic> json) => _RecipeModel(
  id: json['id'] as String,
  userId: json['userId'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  notes: json['notes'] as String?,
  tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
  activeTimeMinutes: (json['activeTimeMinutes'] as num).toInt(),
  totalTimeMinutes: (json['totalTimeMinutes'] as num).toInt(),
  defaultServings: (json['defaultServings'] as num).toInt(),
  ingredients: (json['ingredients'] as List<dynamic>)
      .map((e) => IngredientModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  steps: (json['steps'] as List<dynamic>)
      .map((e) => CookStepModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  imageUrl: json['imageUrl'] as String?,
  sourceUrl: json['sourceUrl'] as String?,
  sourceType: json['sourceType'] as String?,
  category: json['category'] as String? ?? 'שונות',
  version: (json['version'] as num?)?.toInt() ?? 1,
  forkedFromId: json['forkedFromId'] as String?,
  isPublic: json['isPublic'] as bool? ?? false,
  isFavorite: json['isFavorite'] as bool? ?? false,
  rating: (json['rating'] as num?)?.toInt() ?? 0,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$RecipeModelToJson(_RecipeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'description': instance.description,
      'notes': instance.notes,
      'tags': instance.tags,
      'activeTimeMinutes': instance.activeTimeMinutes,
      'totalTimeMinutes': instance.totalTimeMinutes,
      'defaultServings': instance.defaultServings,
      'ingredients': instance.ingredients.map((e) => e.toJson()).toList(),
      'steps': instance.steps.map((e) => e.toJson()).toList(),
      'imageUrl': instance.imageUrl,
      'sourceUrl': instance.sourceUrl,
      'sourceType': instance.sourceType,
      'category': instance.category,
      'version': instance.version,
      'forkedFromId': instance.forkedFromId,
      'isPublic': instance.isPublic,
      'isFavorite': instance.isFavorite,
      'rating': instance.rating,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
