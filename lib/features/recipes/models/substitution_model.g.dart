// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'substitution_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubstitutionModel _$SubstitutionModelFromJson(Map<String, dynamic> json) =>
    _SubstitutionModel(
      category: json['category'] as String,
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: $enumDecode(_$UnitTypeEnumMap, json['unit']),
      prepNote: json['prepNote'] as String?,
      stepUpdates:
          (json['stepUpdates'] as List<dynamic>?)
              ?.map((e) => StepUpdate.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SubstitutionModelToJson(_SubstitutionModel instance) =>
    <String, dynamic>{
      'category': instance.category,
      'name': instance.name,
      'quantity': instance.quantity,
      'unit': _$UnitTypeEnumMap[instance.unit]!,
      'prepNote': instance.prepNote,
      'stepUpdates': instance.stepUpdates.map((e) => e.toJson()).toList(),
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

_StepUpdate _$StepUpdateFromJson(Map<String, dynamic> json) => _StepUpdate(
  stepNumber: (json['stepNumber'] as num).toInt(),
  instruction: json['instruction'] as String,
);

Map<String, dynamic> _$StepUpdateToJson(_StepUpdate instance) =>
    <String, dynamic>{
      'stepNumber': instance.stepNumber,
      'instruction': instance.instruction,
    };
