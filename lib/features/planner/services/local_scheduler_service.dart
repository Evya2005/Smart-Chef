import 'package:uuid/uuid.dart';

import '../../recipes/models/recipe_model.dart';
import '../models/cooking_session_model.dart';

/// A recipe with its suggested start offset relative to session start.
class ScheduledRecipe {
  const ScheduledRecipe({
    required this.recipe,
    required this.startOffset,
  });

  final RecipeModel recipe;

  /// How long after session start to begin this recipe.
  final Duration startOffset;
}

/// Pure-Dart, zero-network scheduling service.
///
/// Computes a greedy start order (longest recipe first) and generates
/// a unified mise en place list across all recipes.
class LocalSchedulerService {
  const LocalSchedulerService();

  /// Sorts [recipes] longest-total-time first and back-calculates start
  /// offsets so all dishes finish at approximately [targetReadyTime].
  /// If [targetReadyTime] is null all offsets are zero.
  List<ScheduledRecipe> computeStartOrder(
    List<RecipeModel> recipes, {
    DateTime? targetReadyTime,
  }) {
    if (recipes.isEmpty) return [];

    final sorted = [...recipes]
      ..sort((a, b) => b.totalTimeMinutes.compareTo(a.totalTimeMinutes));

    if (targetReadyTime == null) {
      return sorted
          .map((r) => ScheduledRecipe(recipe: r, startOffset: Duration.zero))
          .toList();
    }

    final now = DateTime.now();
    final totalAvailable = targetReadyTime.difference(now).inMinutes;

    // If the target time is in the past or right now, start all recipes immediately.
    if (totalAvailable <= 0) {
      return sorted
          .map((r) => ScheduledRecipe(recipe: r, startOffset: Duration.zero))
          .toList();
    }

    final longestMinutes = sorted.first.totalTimeMinutes;

    return sorted.map((r) {
      final offsetMinutes =
          (longestMinutes - r.totalTimeMinutes).clamp(0, totalAvailable);
      return ScheduledRecipe(
        recipe: r,
        startOffset: Duration(minutes: offsetMinutes),
      );
    }).toList();
  }

  /// Aggregates all ingredients across [recipes] into a unified prep list.
  /// Ingredients with the same name and unit are combined.
  List<MiseEnPlaceItemModel> generateMiseEnPlace(List<RecipeModel> recipes) {
    const uuid = Uuid();
    final Map<String, MiseEnPlaceItemModel> aggregated = {};

    for (final recipe in recipes) {
      for (final ing in recipe.ingredients) {
        final key = '${ing.name.trim().toLowerCase()}|${ing.unit.value}';
        final existing = aggregated[key];
        if (existing != null) {
          aggregated[key] = existing.copyWith(
            quantity: existing.quantity + ing.quantity,
            forRecipeIds: [...existing.forRecipeIds, recipe.id],
          );
        } else {
          aggregated[key] = MiseEnPlaceItemModel(
            id: uuid.v4(),
            name: ing.name,
            quantity: ing.quantity,
            unit: ing.unit,
            prepNote: ing.prepNote,
            forRecipeIds: [recipe.id],
          );
        }
      }
    }

    return aggregated.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }
}
