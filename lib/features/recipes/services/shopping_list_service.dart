import '../../../shared/models/ingredient_model.dart';
import '../../../shared/models/unit_type.dart';
import '../models/recipe_model.dart';
import 'recipe_scaling_service.dart';

class ShoppingListService {
  const ShoppingListService();

  static const _scaler = RecipeScalingService();

  static const _categoryOrder = [
    'Produce',
    'Dairy',
    'Meat',
    'Seafood',
    'Bakery',
    'Pantry',
    'Spices',
    'Other',
  ];

  static const _categoryLabels = {
    'Produce': 'ירקות ופירות',
    'Dairy': 'מוצרי חלב',
    'Meat': 'בשר',
    'Seafood': 'פירות ים ודגים',
    'Bakery': 'מאפייה',
    'Pantry': 'מזווה',
    'Spices': 'תבלינים',
    'Other': 'שונות',
  };

  /// Returns a flat list of formatted ingredient strings for checklist export.
  /// [ingredients] should already be scaled to the desired serving count.
  List<String> generateItemList(List<IngredientModel> ingredients) =>
      ingredients.map(_formatIngredient).toList();

  /// Same merging logic as [generateForPlan] but returns a flat sorted list
  /// for use as Google Keep checklist items.
  List<String> generateItemListForPlan(
    List<({RecipeModel recipe, int servings})> entries,
  ) {
    final merged = <String, IngredientModel>{};
    for (final entry in entries) {
      final scaled = _scaler.scale(
        entry.recipe.ingredients,
        entry.recipe.defaultServings,
        entry.servings,
      );
      for (final ing in scaled) {
        final key = '${ing.name.toLowerCase().trim()}|${ing.unit.value}';
        final existing = merged[key];
        if (existing != null) {
          merged[key] =
              existing.copyWith(quantity: existing.quantity + ing.quantity);
        } else {
          merged[key] = ing;
        }
      }
    }

    final sorted = merged.values.toList()
      ..sort((a, b) {
        final ia = _categoryOrder.indexOf(a.category ?? 'Other');
        final ib = _categoryOrder.indexOf(b.category ?? 'Other');
        return ia != ib ? ia.compareTo(ib) : a.name.compareTo(b.name);
      });

    return sorted.map(_formatIngredient).toList();
  }

  /// Generates a merged shopping list from multiple [recipes], each scaled to
  /// [servings] specified by the plan. Ingredients with the same name + unit
  /// across recipes are combined into a single entry.
  String generateForPlan(
    List<({RecipeModel recipe, int servings})> entries,
    String planTitle,
  ) {
    // Collect all scaled ingredients, merging same (name, unit) pairs.
    final merged = <String, IngredientModel>{};
    for (final entry in entries) {
      final scaled = _scaler.scale(
        entry.recipe.ingredients,
        entry.recipe.defaultServings,
        entry.servings,
      );
      for (final ing in scaled) {
        final key = '${ing.name.toLowerCase().trim()}|${ing.unit.value}';
        final existing = merged[key];
        if (existing != null) {
          merged[key] = existing.copyWith(
            quantity: existing.quantity + ing.quantity,
          );
        } else {
          merged[key] = ing;
        }
      }
    }

    final recipeNames = entries.map((e) => e.recipe.title).join(', ');
    final totalServings = entries.fold(0, (s, e) => s + e.servings);
    final buffer = StringBuffer();
    buffer.writeln('🛒 רשימת קניות — $planTitle');
    buffer.writeln('מתכונים: $recipeNames');
    buffer.writeln('סה״כ מנות: $totalServings');
    buffer.writeln('═' * 30);

    final byCategory = <String, List<IngredientModel>>{};
    for (final ing in merged.values) {
      final cat = ing.category ?? 'Other';
      byCategory.putIfAbsent(cat, () => []).add(ing);
    }

    final orderedKeys = [
      ..._categoryOrder.where(byCategory.containsKey),
      ...byCategory.keys.where((k) => !_categoryOrder.contains(k)),
    ];

    for (final category in orderedKeys) {
      final label = _categoryLabels[category] ?? category;
      buffer.writeln('\n$label:');
      final items = byCategory[category]!
        ..sort((a, b) => a.name.compareTo(b.name));
      for (final ing in items) {
        buffer.writeln('  • ${_formatIngredient(ing)}');
      }
    }

    return buffer.toString().trim();
  }

  String generate(
    List<IngredientModel> ingredients,
    int servings,
    String recipeTitle,
  ) {
    final byCategory = <String, List<IngredientModel>>{};
    for (final ing in ingredients) {
      final cat = ing.category ?? 'Other';
      byCategory.putIfAbsent(cat, () => []).add(ing);
    }

    final buffer = StringBuffer();
    buffer.writeln('רשימת קניות — $recipeTitle ($servings מנות)');
    buffer.writeln('═' * 30);

    final orderedKeys = [
      ..._categoryOrder.where(byCategory.containsKey),
      ...byCategory.keys.where((k) => !_categoryOrder.contains(k)),
    ];

    for (final category in orderedKeys) {
      final label = _categoryLabels[category] ?? category;
      buffer.writeln('\n$label:');
      for (final ing in byCategory[category]!) {
        buffer.writeln('  • ${_formatIngredient(ing)}');
      }
    }

    return buffer.toString().trim();
  }

  String _formatIngredient(IngredientModel ing) {
    final qty = _formatQty(ing.quantity);
    final unit = ing.unit == UnitType.none ? '' : ' ${ing.unit.displayLabel}';
    final prep = ing.prepNote != null ? ' (${ing.prepNote})' : '';
    return '$qty$unit ${ing.name}$prep'.trim();
  }

  String _formatQty(double qty) {
    if (qty == qty.truncateToDouble()) return qty.toInt().toString();
    return qty.toStringAsFixed(1);
  }
}
