import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/providers/admin_provider.dart';
import '../models/recipe_model.dart';
import 'recipe_list_provider.dart';

part 'recipe_filter_provider.g.dart';

// ─── Nutrition Presets ────────────────────────────────────────────────────────

enum NutritionPreset { lowCalorie, highProtein, lowCarb, lowFat, highFiber }

const _kNutritionPresetLabels = {
  NutritionPreset.lowCalorie: 'קלוריות נמוכות',
  NutritionPreset.highProtein: 'עשיר בחלבון',
  NutritionPreset.lowCarb: 'דל פחמימות',
  NutritionPreset.lowFat: 'דל שומן',
  NutritionPreset.highFiber: 'עשיר בסיבים',
};

String nutritionPresetLabel(NutritionPreset p) =>
    _kNutritionPresetLabels[p] ?? p.name;

bool _matchesNutritionPreset(
    NutritionPreset preset, double calories, double protein, double carbs,
    double fat, double fiber) {
  switch (preset) {
    case NutritionPreset.lowCalorie:
      return calories < 300;
    case NutritionPreset.highProtein:
      return protein > 20;
    case NutritionPreset.lowCarb:
      return carbs < 20;
    case NutritionPreset.lowFat:
      return fat < 10;
    case NutritionPreset.highFiber:
      return fiber > 5;
  }
}

/// The 14 supported recipe tags (matches Gemini prompt).
const kAllTags = [
  'vegan',
  'vegetarian',
  'gluten-free',
  'dairy-free',
  'spicy',
  'quick',
  'breakfast',
  'lunch',
  'dinner',
  'dessert',
  'snack',
  'bake',
  'grill',
  'fry',
];

const _kTagLabels = {
  'vegan': 'טבעוני',
  'vegetarian': 'צמחוני',
  'gluten-free': 'ללא גלוטן',
  'dairy-free': 'ללא חלב',
  'spicy': 'חריף',
  'quick': 'מהיר',
  'breakfast': 'ארוחת בוקר',
  'lunch': 'ארוחת צהריים',
  'dinner': 'ארוחת ערב',
  'dessert': 'קינוח',
  'snack': 'חטיף',
  'bake': 'אפייה',
  'grill': 'גריל',
  'fry': 'טיגון',
};

String tagLabel(String tag) => _kTagLabels[tag] ?? tag;

class RecipeFilter {
  const RecipeFilter({
    this.query = '',
    this.activeTags = const {},
    this.ingredientFilters = const {},
    this.maxTotalMinutes,
    this.favoritesOnly = false,
    this.minRating,
    this.activeCategory,
    this.nutritionPresets = const {},
    this.showPublicRecipes = true,
  });

  final String query;
  final Set<String> activeTags;
  final Set<String> ingredientFilters;
  final int? maxTotalMinutes;
  final bool favoritesOnly;
  final int? minRating;
  final String? activeCategory;
  final Set<NutritionPreset> nutritionPresets;
  final bool showPublicRecipes;

  int get activeFilterCount =>
      activeTags.length +
      ingredientFilters.length +
      (maxTotalMinutes != null ? 1 : 0) +
      (favoritesOnly ? 1 : 0) +
      (minRating != null ? 1 : 0) +
      nutritionPresets.length +
      (!showPublicRecipes ? 1 : 0);

  static const _sentinel = Object();

  RecipeFilter copyWith({
    String? query,
    Set<String>? activeTags,
    Set<String>? ingredientFilters,
    Object? maxTotalMinutes = _sentinel,
    bool? favoritesOnly,
    Object? minRating = _sentinel,
    Object? activeCategory = _sentinel,
    Set<NutritionPreset>? nutritionPresets,
    bool? showPublicRecipes,
  }) {
    return RecipeFilter(
      query: query ?? this.query,
      activeTags: activeTags ?? this.activeTags,
      ingredientFilters: ingredientFilters ?? this.ingredientFilters,
      maxTotalMinutes: identical(maxTotalMinutes, _sentinel)
          ? this.maxTotalMinutes
          : maxTotalMinutes as int?,
      favoritesOnly: favoritesOnly ?? this.favoritesOnly,
      minRating: identical(minRating, _sentinel)
          ? this.minRating
          : minRating as int?,
      activeCategory: identical(activeCategory, _sentinel)
          ? this.activeCategory
          : activeCategory as String?,
      nutritionPresets: nutritionPresets ?? this.nutritionPresets,
      showPublicRecipes: showPublicRecipes ?? this.showPublicRecipes,
    );
  }
}

@riverpod
class RecipeFilterNotifier extends _$RecipeFilterNotifier {
  @override
  RecipeFilter build() => const RecipeFilter();

  void setQuery(String query) => state = state.copyWith(query: query.trim());

  void toggleTag(String tag) {
    final tags = Set<String>.from(state.activeTags);
    if (tags.contains(tag)) {
      tags.remove(tag);
    } else {
      tags.add(tag);
    }
    state = state.copyWith(activeTags: tags);
  }

  void setMaxTime(int? minutes) =>
      state = state.copyWith(maxTotalMinutes: minutes);

  void addIngredient(String name) {
    final term = name.trim().toLowerCase();
    if (term.isEmpty) return;
    state = state.copyWith(
      ingredientFilters: {...state.ingredientFilters, term},
    );
  }

  void removeIngredient(String name) {
    final updated = Set<String>.from(state.ingredientFilters)..remove(name);
    state = state.copyWith(ingredientFilters: updated);
  }

  void toggleFavoritesOnly() =>
      state = state.copyWith(favoritesOnly: !state.favoritesOnly);

  void setMinRating(int? stars) => state = state.copyWith(minRating: stars);

  void setCategory(String? category) {
    state = state.copyWith(
      activeCategory: state.activeCategory == category ? null : category,
    );
  }

  void toggleNutritionPreset(NutritionPreset preset) {
    final presets = Set<NutritionPreset>.from(state.nutritionPresets);
    if (presets.contains(preset)) {
      presets.remove(preset);
    } else {
      presets.add(preset);
    }
    state = state.copyWith(nutritionPresets: presets);
  }

  void toggleShowPublicRecipes() =>
      state = state.copyWith(showPublicRecipes: !state.showPublicRecipes);

  void clearAll() => state = const RecipeFilter();
}

@riverpod
List<RecipeModel>? filteredRecipes(Ref ref) {
  final isGodMode = ref.watch(isAdminProvider) && ref.watch(godModeProvider);
  final filter = ref.watch(recipeFilterProvider);

  final List<RecipeModel> combined;

  if (isGodMode) {
    final allAsync = ref.watch(allRecipesAdminProvider);
    final all = allAsync.value;
    if (all == null && !allAsync.hasError) return null;
    combined = [...(all ?? [])]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  } else {
    final ownAsync = ref.watch(recipeListProvider);
    final own = ownAsync.value;
    if (own == null && !ownAsync.hasError) return null;
    final publicRecipes = filter.showPublicRecipes
        ? (ref.watch(publicRecipesProvider).asData?.value ?? <RecipeModel>[])
        : <RecipeModel>[];
    combined = <RecipeModel>[
      ...(own ?? []),
      ...publicRecipes,
    ]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  return combined.where((recipe) {
    final q = filter.query.toLowerCase();
    if (q.isNotEmpty) {
      final inTitle = recipe.title.toLowerCase().contains(q);
      final inIngredients =
          recipe.ingredients.any((i) => i.name.toLowerCase().contains(q));
      if (!inTitle && !inIngredients) return false;
    }
    if (filter.activeTags.isNotEmpty &&
        !filter.activeTags.every(recipe.tags.contains)) {
      return false;
    }
    if (filter.ingredientFilters.isNotEmpty) {
      final allPresent = filter.ingredientFilters.every((term) =>
          recipe.ingredients.any(
            (ing) => ing.name.toLowerCase().contains(term),
          ));
      if (!allPresent) return false;
    }
    if (filter.maxTotalMinutes != null &&
        recipe.totalTimeMinutes > filter.maxTotalMinutes!) {
      return false;
    }
    if (filter.favoritesOnly && !recipe.isFavorite) return false;
    if (filter.minRating != null && recipe.rating < filter.minRating!) {
      return false;
    }
    final cat = filter.activeCategory;
    if (cat != null) {
      if (cat == 'מועדפים') {
        if (!recipe.isFavorite) return false;
      } else if (cat == 'מומלצים') {
        if (recipe.rating < 4) return false;
      } else {
        if (recipe.category != cat) return false;
      }
    }
    if (filter.nutritionPresets.isNotEmpty) {
      final n = recipe.nutrition;
      if (n == null) return false;
      for (final preset in filter.nutritionPresets) {
        if (!_matchesNutritionPreset(
            preset, n.calories, n.protein, n.carbs, n.fat, n.fiber)) {
          return false;
        }
      }
    }
    return true;
  }).toList();
}
