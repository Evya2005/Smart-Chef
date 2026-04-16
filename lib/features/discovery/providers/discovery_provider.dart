import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/repositories/auth_repository.dart';
import '../../recipes/models/recipe_model.dart';
import '../../recipes/repositories/recipe_repository.dart';
import '../services/discovery_service.dart';

part 'discovery_provider.g.dart';

// ─── State ────────────────────────────────────────────────────────────────────

sealed class DiscoveryState {
  const DiscoveryState();
}

class DiscoveryIdle extends DiscoveryState {
  const DiscoveryIdle();
}

class DiscoveryBuilding extends DiscoveryState {
  const DiscoveryBuilding({required this.ingredients});
  final List<String> ingredients;
}

class DiscoveryGenerating extends DiscoveryState {
  const DiscoveryGenerating();
}

class DiscoveryPreview extends DiscoveryState {
  const DiscoveryPreview(this.recipe);
  final RecipeModel recipe;
}

class DiscoverySaving extends DiscoveryState {
  const DiscoverySaving();
}

class DiscoveryDone extends DiscoveryState {
  const DiscoveryDone(this.recipeId);
  final String recipeId;
}

class DiscoveryError extends DiscoveryState {
  const DiscoveryError(this.message);
  final String message;
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

@riverpod
class DiscoveryNotifier extends _$DiscoveryNotifier {
  @override
  DiscoveryState build() => const DiscoveryIdle();

  static const _service = DiscoveryService();
  static const _maxIngredients = 5;

  void startBuilding() {
    state = const DiscoveryBuilding(ingredients: []);
  }

  void addIngredient(String name) {
    final current = state;
    if (current is! DiscoveryBuilding) return;
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    if (current.ingredients.length >= _maxIngredients) return;
    state = DiscoveryBuilding(
      ingredients: [...current.ingredients, trimmed],
    );
  }

  void removeIngredient(int index) {
    final current = state;
    if (current is! DiscoveryBuilding) return;
    final updated = [...current.ingredients]..removeAt(index);
    state = DiscoveryBuilding(ingredients: updated);
  }

  Future<void> generate() async {
    final current = state;
    if (current is! DiscoveryBuilding) return;
    if (current.ingredients.length < 3) return;

    state = const DiscoveryGenerating();
    try {
      final recipe = await _service.generateFromBasket(current.ingredients);
      state = DiscoveryPreview(recipe);
    } catch (e) {
      state = DiscoveryError(e.toString());
    }
  }

  void updatePreview(RecipeModel updated) {
    if (state is DiscoveryPreview) {
      state = DiscoveryPreview(updated);
    }
  }

  Future<void> confirmSave() async {
    final current = state;
    if (current is! DiscoveryPreview) return;

    state = const DiscoverySaving();
    try {
      final uid = ref.read(authRepositoryProvider).currentUser?.uid;
      if (uid == null) throw Exception('המשתמש אינו מחובר.');

      final recipe = current.recipe.copyWith(userId: uid);
      final id =
          await ref.read(recipeRepositoryProvider).saveRecipe(recipe);
      state = DiscoveryDone(id);
    } catch (e) {
      state = DiscoveryError(e.toString());
    }
  }

  void reset() => state = const DiscoveryIdle();
}
