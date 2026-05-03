import '../../../shared/models/ingredient_model.dart';
import '../../../shared/models/unit_type.dart';
import 'unit_conversion_service.dart';

const _converter = UnitConversionService();

const _thinLiquids = [
  'מים', 'water', 'חלב', 'milk', 'שמן', 'oil',
  'יין', 'wine', 'מיץ', 'juice', 'שמנת', 'cream',
];

const _bakingIngredients = [
  'קמח', 'flour', 'סוכר', 'sugar', 'שמרים', 'yeast',
  'קקאו', 'cocoa', 'אבקת אפייה', 'baking',
];

const _stickyIngredients = [
  'דבש', 'honey', 'סילן', 'silan', 'חמאת בוטנים', 'peanut butter',
  'ריבה', 'jam',
];

const _thickPastes = [
  'רסק עגבניות', 'tomato paste', 'טחינה', 'tahini',
  'דבש', 'honey', 'סילן', 'silan', 'חמאת בוטנים', 'peanut butter',
];

const _wholeProduce = [
  'ביצה', 'egg', 'בצל', 'onion', 'תפוח אדמה', 'potato',
  'עגבנייה', 'tomato', 'גזר', 'carrot', 'שום', 'garlic',
  'לימון', 'lemon', 'תפוח', 'apple',
];

bool _matches(String name, List<String> keywords) {
  final lower = name.toLowerCase();
  return keywords.any((kw) => lower.contains(kw.toLowerCase()));
}

const _volumeUnits = {
  UnitType.milliliters,
  UnitType.liters,
  UnitType.teaspoon,
  UnitType.tablespoon,
  UnitType.cup,
};

class SmartUnitSuggester {
  const SmartUnitSuggester();

  /// Returns a filtered, ordered list of relevant target units for [ingredient].
  /// Falls back to an empty list when no smart rule applies
  /// (caller should then use UnitConversionService.availableTargets instead).
  List<UnitType> relevantTargets(IngredientModel ingredient) {
    final name = ingredient.name;
    final unit = ingredient.unit;
    final qty = ingredient.quantity;

    List<UnitType> candidates;

    if (unit == UnitType.grams && qty < 15 && !_matches(name, _thinLiquids)) {
      candidates = qty < 3 ? [UnitType.pinch] : [UnitType.teaspoon];
    } else if (_matches(name, _bakingIngredients) && _volumeUnits.contains(unit)) {
      candidates = [UnitType.grams];
    } else if (_matches(name, _stickyIngredients) &&
        {UnitType.tablespoon, UnitType.teaspoon, UnitType.cup}.contains(unit)) {
      candidates = [UnitType.grams];
    } else if (_matches(name, _thickPastes) && unit == UnitType.grams) {
      candidates = [UnitType.tablespoon, UnitType.teaspoon];
    } else if (unit == UnitType.milliliters && qty > 1000) {
      candidates = [UnitType.liters, UnitType.cup];
    } else if (unit == UnitType.milliliters && qty > 250) {
      candidates = [UnitType.cup];
    } else if (_matches(name, _thinLiquids) &&
        {UnitType.cup, UnitType.tablespoon, UnitType.teaspoon}.contains(unit)) {
      candidates = [UnitType.milliliters, UnitType.grams];
    } else if (unit == UnitType.piece && _matches(name, _wholeProduce)) {
      candidates = [UnitType.grams];
    } else {
      return [];
    }

    // Filter through canConvert to ensure all candidates are actually computable.
    return candidates
        .where((t) => _converter.canConvert(unit, t, name))
        .toList();
  }
}
