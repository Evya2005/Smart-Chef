// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_IngredientModel _$IngredientModelFromJson(Map<String, dynamic> json) =>
    _IngredientModel(
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: $enumDecode(_$UnitTypeEnumMap, json['unit']),
      prepNote: json['prepNote'] as String?,
      category: json['category'] as String?,
      inferred: json['inferred'] as bool? ?? false,
    );

Map<String, dynamic> _$IngredientModelToJson(_IngredientModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'quantity': instance.quantity,
      'unit': _$UnitTypeEnumMap[instance.unit]!,
      'prepNote': instance.prepNote,
      'category': instance.category,
      'inferred': instance.inferred,
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
