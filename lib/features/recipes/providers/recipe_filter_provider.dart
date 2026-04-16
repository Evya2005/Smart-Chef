import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/recipe_model.dart';
import 'recipe_list_provider.dart';

part 'recipe_filter_provider.g.dart';

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
  });

  final String query;
  final Set<String> activeTags;
  final Set<String> ingredientFilters;
  final int? maxTotalMinutes;
  final bool favoritesOnly;
  final int? minRating;
  final String? activeCategory;

  int get activeFilterCount =>
      activeTags.length +
      ingredientFilters.length +
      (maxTotalMinutes != null ? 1 : 0) +
      (favoritesOnly ? 1 : 0) +
      (minRating != null ? 1 : 0);

  static const _sentinel = Object();

  RecipeFilter copyWith({
    String? query,
    Set<String>? activeTags,
    Set<String>? ingredientFilters,
    Object? maxTotalMinutes = _sentinel,
    bool? favoritesOnly,
    Object? minRating = _sentinel,
    Object? activeCategory = _sentinel,
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

  void clearAll() => state = const RecipeFilter();
}

@riverpod
List<RecipeModel>? filteredRecipes(Ref ref) {
  final ownAsync = ref.watch(recipeListProvider);
  final publicAsync = ref.watch(publicRecipesProvider);
  final filter = ref.watch(recipeFilterProvider);

  final own = ownAsync.value;
  if (own == null && !ownAsync.hasError) return null;

  final combined = <RecipeModel>[
    ...(own ?? []),
    ...(publicAsync.asData?.value ?? []),
  ];

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
    return true;
  }).toList();
}
