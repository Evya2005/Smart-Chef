// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cooking_session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MiseEnPlaceItemModel _$MiseEnPlaceItemModelFromJson(
  Map<String, dynamic> json,
) => _MiseEnPlaceItemModel(
  id: json['id'] as String,
  name: json['name'] as String,
  quantity: (json['quantity'] as num).toDouble(),
  unit: $enumDecode(_$UnitTypeEnumMap, json['unit']),
  prepNote: json['prepNote'] as String?,
  forRecipeIds:
      (json['forRecipeIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$MiseEnPlaceItemModelToJson(
  _MiseEnPlaceItemModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'quantity': instance.quantity,
  'unit': _$UnitTypeEnumMap[instance.unit]!,
  'prepNote': instance.prepNote,
  'forRecipeIds': instance.forRecipeIds,
};

const _$UnitTypeEnumMap = {
  UnitType.grams: 'grams',
  UnitType.kilograms: 'kilograms',
  UnitType.milliliters: 'milliliters',
  UnitType.liters: 'liters',
  UnitType.teaspoon: 'teaspoon',
  UnitType.tablespoon: 'tablespoon',
  UnitType.cup: 'cup',
  UnitType.piece: 'piece',
  UnitType.pinch: 'pinch',
  UnitType.toTaste: 'to_taste',
  UnitType.none: 'none',
};

_CookingSessionModel _$CookingSessionModelFromJson(Map<String, dynamic> json) =>
    _CookingSessionModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      recipeIds: (json['recipeIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      recipeProgress:
          (json['recipeProgress'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      activeRecipeId: json['activeRecipeId'] as String?,
      targetReadyTime: json['targetReadyTime'] as String?,
      startedAt: json['startedAt'] as String,
      completedAt: json['completedAt'] as String?,
      completedRecipeIds:
          (json['completedRecipeIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      miseEnPlace:
          (json['miseEnPlace'] as List<dynamic>?)
              ?.map(
                (e) => MiseEnPlaceItemModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      miseEnPlaceChecked:
          (json['miseEnPlaceChecked'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          const {},
      recipeNames:
          (json['recipeNames'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
    );

Map<String, dynamic> _$CookingSessionModelToJson(
  _CookingSessionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'recipeIds': instance.recipeIds,
  'recipeProgress': instance.recipeProgress,
  'activeRecipeId': instance.activeRecipeId,
  'targetReadyTime': instance.targetReadyTime,
  'startedAt': instance.startedAt,
  'completedAt': instance.completedAt,
  'completedRecipeIds': instance.completedRecipeIds,
  'miseEnPlace': instance.miseEnPlace.map((e) => e.toJson()).toList(),
  'miseEnPlaceChecked': instance.miseEnPlaceChecked,
  'recipeNames': instance.recipeNames,
};
