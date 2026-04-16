import 'package:flutter_test/flutter_test.dart';
import 'package:smart_chef/features/recipes/services/smart_unit_suggester.dart';
import 'package:smart_chef/shared/models/ingredient_model.dart';
import 'package:smart_chef/shared/models/unit_type.dart';

IngredientModel _ing(String name, UnitType unit, double qty) =>
    IngredientModel(name: name, quantity: qty, unit: unit);

void main() {
  const suggester = SmartUnitSuggester();

  group('SmartUnitSuggester.relevantTargets', () {
    test('קמח cup 2 → [grams]', () {
      final result = suggester.relevantTargets(_ing('קמח', UnitType.cup, 2));
      expect(result, [UnitType.grams]);
    });

    test('קינמון grams 5 → [teaspoon]', () {
      final result = suggester.relevantTargets(_ing('קינמון', UnitType.grams, 5));
      expect(result, [UnitType.teaspoon]);
    });

    test('כורכום grams 2 → [pinch]', () {
      final result = suggester.relevantTargets(_ing('כורכום', UnitType.grams, 2));
      expect(result, [UnitType.pinch]);
    });

    test('דבש tablespoon 2 → [grams]', () {
      final result = suggester.relevantTargets(_ing('דבש', UnitType.tablespoon, 2));
      expect(result, [UnitType.grams]);
    });

    test('טחינה grams 20 → [tablespoon, teaspoon]', () {
      final result = suggester.relevantTargets(_ing('טחינה', UnitType.grams, 20));
      expect(result, [UnitType.tablespoon, UnitType.teaspoon]);
    });

    test('מים ml 300 → [cup]', () {
      final result = suggester.relevantTargets(_ing('מים', UnitType.milliliters, 300));
      expect(result, [UnitType.cup]);
    });

    test('מים ml 1500 → [liters, cup]', () {
      final result = suggester.relevantTargets(_ing('מים', UnitType.milliliters, 1500));
      expect(result, [UnitType.liters, UnitType.cup]);
    });

    test('חלב cup 1 → [milliliters, grams]', () {
      final result = suggester.relevantTargets(_ing('חלב', UnitType.cup, 1));
      expect(result, [UnitType.milliliters, UnitType.grams]);
    });

    test('ביצה piece 3 → [grams]', () {
      final result = suggester.relevantTargets(_ing('ביצה', UnitType.piece, 3));
      expect(result, [UnitType.grams]);
    });

    test('מלח grams 100 → [] (fallback)', () {
      final result = suggester.relevantTargets(_ing('מלח', UnitType.grams, 100));
      expect(result, isEmpty);
    });
  });
}
