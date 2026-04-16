import '../../../shared/models/ingredient_model.dart';

class RecipeScalingService {
  const RecipeScalingService();

  List<IngredientModel> scale(
    List<IngredientModel> items,
    int fromServings,
    int toServings,
  ) {
    if (fromServings <= 0 || toServings <= 0) return items;
    final multiplier = toServings / fromServings;
    return items
        .map((i) => i.copyWith(quantity: i.quantity * multiplier))
        .toList();
  }
}
