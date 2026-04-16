import 'package:flutter_test/flutter_test.dart';
import 'package:smart_chef/features/recipes/services/recipe_scaling_service.dart';
import 'package:smart_chef/shared/models/ingredient_model.dart';
import 'package:smart_chef/shared/models/unit_type.dart';

void main() {
  const service = RecipeScalingService();

  IngredientModel makeIngredient(double qty) => IngredientModel(
        name: 'Flour',
        quantity: qty,
        unit: UnitType.grams,
      );

  group('RecipeScalingService', () {
    test('doubles quantities when scaling from 2 to 4 servings', () {
      final items = [makeIngredient(100), makeIngredient(200)];
      final scaled = service.scale(items, 2, 4);
      expect(scaled[0].quantity, 200);
      expect(scaled[1].quantity, 400);
    });

    test('halves quantities when scaling from 4 to 2 servings', () {
      final items = [makeIngredient(400)];
      final scaled = service.scale(items, 4, 2);
      expect(scaled[0].quantity, 200);
    });

    test('returns same quantities when from == to', () {
      final items = [makeIngredient(150)];
      final scaled = service.scale(items, 3, 3);
      expect(scaled[0].quantity, 150);
    });

    test('returns original list if fromServings is 0', () {
      final items = [makeIngredient(100)];
      final scaled = service.scale(items, 0, 4);
      expect(scaled, same(items));
    });

    test('returns original list if toServings is 0', () {
      final items = [makeIngredient(100)];
      final scaled = service.scale(items, 2, 0);
      expect(scaled, same(items));
    });

    test('handles non-integer multiplier correctly', () {
      final items = [makeIngredient(100)];
      final scaled = service.scale(items, 4, 6); // × 1.5
      expect(scaled[0].quantity, closeTo(150, 0.001));
    });

    test('does not mutate original list', () {
      final items = [makeIngredient(100)];
      service.scale(items, 2, 4);
      expect(items[0].quantity, 100);
    });
  });
}
