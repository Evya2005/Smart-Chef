import '../../../shared/models/unit_type.dart';

/// Ingredient density in g/ml for ~40 common ingredients.
const _densityTable = <String, double>{
  'קמח': 0.53,
  'flour': 0.53,
  'סוכר': 0.85,
  'sugar': 0.85,
  'חמאה': 0.91,
  'butter': 0.91,
  'אורז': 0.75,
  'rice': 0.75,
  'שמן': 0.92,
  'oil': 0.92,
  'מלח': 1.22,
  'salt': 1.22,
  'דבש': 1.40,
  'honey': 1.40,
  'שוקולד': 0.60,
  'chocolate': 0.60,
  'קינמון': 0.56,
  'cinnamon': 0.56,
  'כורכום': 0.77,
  'turmeric': 0.77,
  'קקאו': 0.50,
  'cocoa': 0.50,
  'אבקת סוכר': 0.56,
  'powdered sugar': 0.56,
  'קמח תירס': 0.56,
  'cornstarch': 0.62,
  'שקדים': 0.60,
  'almonds': 0.60,
  'פיסטוק': 0.58,
  'pistachios': 0.58,
  'שיבולת שועל': 0.37,
  'oats': 0.37,
  'גבינה': 0.50,
  'cheese': 0.50,
  'חלב': 1.03,
  'milk': 1.03,
  'שמנת': 1.01,
  'cream': 1.01,
  'יוגורט': 1.05,
  'yogurt': 1.05,
  'מים': 1.00,
  'water': 1.00,
  'פנקייק מיקס': 0.55,
  'baking powder': 0.72,
  'אבקת אפייה': 0.72,
  'סודה לשתייה': 0.72,
  'baking soda': 0.72,
  'שמרים': 0.72,
  'yeast': 0.72,
  'סילן': 1.35,
  'silan': 1.35,
  'חמאת בוטנים': 0.95,
  'peanut butter': 0.95,
  'טחינה': 1.05,
  'tahini': 1.05,
};

const _typicalWeightGrams = <String, double>{
  'ביצה': 55,
  'egg': 55,
  'בצל': 150,
  'onion': 150,
  'תפוח אדמה': 200,
  'potato': 200,
  'עגבנייה': 150,
  'tomato': 150,
  'גזר': 80,
  'carrot': 80,
  'שום': 4,
  'garlic': 4,
  'לימון': 100,
  'lemon': 100,
  'תפוח': 180,
  'apple': 180,
};

// Volume unit to ml (pinch ≈ 1/16 teaspoon)
const _toMl = <UnitType, double>{
  UnitType.milliliters: 1,
  UnitType.liters: 1000,
  UnitType.teaspoon: 4.92892,
  UnitType.tablespoon: 14.7868,
  UnitType.cup: 236.588,
  UnitType.pinch: 0.30806,
};

// Weight unit to grams
const _toGrams = <UnitType, double>{
  UnitType.grams: 1,
  UnitType.kilograms: 1000,
};

class UnitConversionService {
  const UnitConversionService();

  bool isVolumeUnit(UnitType u) => _toMl.containsKey(u);
  bool isWeightUnit(UnitType u) => _toGrams.containsKey(u);

  /// Returns true if we can convert between [from] and [to] for [ingredientName].
  bool canConvert(UnitType from, UnitType to, String ingredientName) {
    if (from == to) return false;
    if (from == UnitType.piece && to == UnitType.grams) {
      return _typicalWeight(ingredientName) != null;
    }
    if (isVolumeUnit(from) && isVolumeUnit(to)) return true;
    if (isWeightUnit(from) && isWeightUnit(to)) return true;
    final density = _density(ingredientName);
    if (density == null) return false;
    return (isVolumeUnit(from) && isWeightUnit(to)) ||
        (isWeightUnit(from) && isVolumeUnit(to));
  }

  /// Returns the list of [UnitType]s that [from] can be converted to.
  List<UnitType> availableTargets(UnitType from, String ingredientName) {
    return UnitType.values
        .where((t) => canConvert(from, t, ingredientName))
        .toList();
  }

  /// Converts [qty] from [from] unit to [to] unit for [ingredientName].
  /// Returns null if conversion is not possible.
  double? convert(
      double qty, UnitType from, UnitType to, String ingredientName) {
    if (from == to) return qty;
    if (from == UnitType.piece && to == UnitType.grams) {
      final w = _typicalWeight(ingredientName);
      if (w != null) return qty * w;
    }
    if (isVolumeUnit(from) && isVolumeUnit(to)) {
      final ml = qty * _toMl[from]!;
      return ml / _toMl[to]!;
    }
    if (isWeightUnit(from) && isWeightUnit(to)) {
      final g = qty * _toGrams[from]!;
      return g / _toGrams[to]!;
    }
    final density = _density(ingredientName);
    if (density == null) return null;

    if (isVolumeUnit(from) && isWeightUnit(to)) {
      // ml → g using density
      final ml = qty * _toMl[from]!;
      final grams = ml * density;
      return grams / _toGrams[to]!;
    }
    if (isWeightUnit(from) && isVolumeUnit(to)) {
      // g → ml using density
      final grams = qty * _toGrams[from]!;
      final ml = grams / density;
      return ml / _toMl[to]!;
    }
    return null;
  }

  double? _density(String ingredientName) {
    final lower = ingredientName.toLowerCase();
    for (final entry in _densityTable.entries) {
      if (lower.contains(entry.key.toLowerCase())) return entry.value;
    }
    return null;
  }

  double? _typicalWeight(String ingredientName) {
    final lower = ingredientName.toLowerCase();
    for (final entry in _typicalWeightGrams.entries) {
      if (lower.contains(entry.key.toLowerCase())) return entry.value;
    }
    return null;
  }
}
