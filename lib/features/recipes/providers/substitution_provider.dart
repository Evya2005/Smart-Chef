import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/models/ingredient_model.dart';
import '../models/recipe_model.dart';
import '../models/substitution_model.dart';
import '../repositories/recipe_repository.dart';
import '../services/substitution_service.dart';
import '../../auth/repositories/auth_repository.dart';
import '../../settings/providers/user_settings_provider.dart';

part 'substitution_provider.g.dart';

// ─── State ────────────────────────────────────────────────────────────────────

sealed class SubstitutionState {
  const SubstitutionState();
}

class SubstitutionIdle extends SubstitutionState {
  const SubstitutionIdle();
}

class SubstitutionLoading extends SubstitutionState {
  const SubstitutionLoading();
}

class SubstitutionResult extends SubstitutionState {
  const SubstitutionResult({
    required this.role,
    required this.substitutions,
    this.activeCategory,
  });

  final String role;
  final List<SubstitutionModel> substitutions;
  final String? activeCategory;

  List<SubstitutionModel> get filtered => activeCategory == null
      ? substitutions
      : substitutions
          .where((s) => s.category == activeCategory)
          .toList();
}

class SubstitutionApplying extends SubstitutionState {
  const SubstitutionApplying();
}

class SubstitutionDone extends SubstitutionState {
  const SubstitutionDone();
}

class SubstitutionError extends SubstitutionState {
  const SubstitutionError(this.message);
  final String message;
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

@riverpod
class SubstitutionNotifier extends _$SubstitutionNotifier {
  @override
  SubstitutionState build() => const SubstitutionIdle();

  SubstitutionService get _service {
    final apiKey = ref.read(geminiApiKeyProvider).asData?.value ?? '';
    return SubstitutionService(apiKey: apiKey);
  }

  Future<void> findSubstitutions(
    RecipeModel recipe,
    IngredientModel ingredient,
  ) async {
    state = const SubstitutionLoading();
    try {
      final result =
          await _service.findSubstitutions(recipe, ingredient);
      state = SubstitutionResult(
        role: result.role,
        substitutions: result.substitutions,
      );
    } catch (e) {
      state = SubstitutionError(e.toString());
    }
  }

  void setCategory(String? category) {
    final current = state;
    if (current is SubstitutionResult) {
      state = SubstitutionResult(
        role: current.role,
        substitutions: current.substitutions,
        activeCategory: category,
      );
    }
  }

  Future<void> applySubstitution(
    RecipeModel recipe,
    IngredientModel original,
    SubstitutionModel substitution,
  ) async {
    state = const SubstitutionApplying();
    try {
      // Replace ingredient
      final updatedIngredients = recipe.ingredients.map((ing) {
        if (ing.name == original.name &&
            ing.quantity == original.quantity &&
            ing.unit == original.unit) {
          return IngredientModel(
            name: substitution.name,
            quantity: substitution.quantity,
            unit: substitution.unit,
            prepNote: substitution.prepNote,
            category: ing.category,
            inferred: ing.inferred,
          );
        }
        return ing;
      }).toList();

      // Apply step updates
      final updatedSteps = recipe.steps.map((step) {
        final update = substitution.stepUpdates
            .where((u) => u.stepNumber == step.stepNumber)
            .firstOrNull;
        if (update != null) {
          return step.copyWith(instruction: update.instruction);
        }
        return step;
      }).toList();

      final updatedRecipe = recipe.copyWith(
        ingredients: updatedIngredients,
        steps: updatedSteps,
      );

      final uid =
          ref.read(authRepositoryProvider).currentUser?.uid;
      if (uid == null) throw Exception('המשתמש אינו מחובר.');

      await ref.read(recipeRepositoryProvider).updateRecipe(
            updatedRecipe,
            changeNote: 'החלפת מצרך: ${original.name} → ${substitution.name}',
          );

      state = const SubstitutionDone();
    } catch (e) {
      state = SubstitutionError(e.toString());
    }
  }

  void reset() => state = const SubstitutionIdle();
}
