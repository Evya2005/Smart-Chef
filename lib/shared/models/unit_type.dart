import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum UnitType {
  grams('grams'),
  kilograms('kilograms'),
  milliliters('milliliters'),
  liters('liters'),
  teaspoon('teaspoon'),
  tablespoon('tablespoon'),
  cup('cup'),
  piece('piece'),
  pinch('pinch'),
  toTaste('to_taste'),
  none('none');

  const UnitType(this.value);
  final String value;

  static UnitType fromString(String s) {
    return UnitType.values.firstWhere(
      (e) => e.value == s,
      orElse: () => UnitType.none,
    );
  }

  String get displayLabel {
    switch (this) {
      case UnitType.grams:
        return 'גר׳';
      case UnitType.kilograms:
        return 'ק״ג';
      case UnitType.milliliters:
        return 'מ״ל';
      case UnitType.liters:
        return 'ל׳';
      case UnitType.teaspoon:
        return 'כפית';
      case UnitType.tablespoon:
        return 'כף';
      case UnitType.cup:
        return 'כוס';
      case UnitType.piece:
        return 'יח׳';
      case UnitType.pinch:
        return 'קמצוץ';
      case UnitType.toTaste:
        return 'לפי הטעם';
      case UnitType.none:
        return '';
    }
  }
}
