import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../settings/providers/categories_provider.dart';
import '../../providers/recipe_filter_provider.dart';

class CategoryChipBar extends ConsumerWidget {
  const CategoryChipBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeCategory =
        ref.watch(recipeFilterProvider.select((f) => f.activeCategory));
    final notifier = ref.read(recipeFilterProvider.notifier);

    final presentCategories = ref.watch(recipeCategoriesProvider).asData?.value
        ?? AppConstants.kRecipeCategories;

    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          _Chip(
            label: 'מועדפים',
            icon: activeCategory == 'מועדפים'
                ? Icons.favorite
                : Icons.favorite_border,
            iconColor:
                activeCategory == 'מועדפים' ? Colors.red : null,
            selected: activeCategory == 'מועדפים',
            selectedColor: colorScheme.primaryContainer,
            onTap: () => notifier.setCategory('מועדפים'),
          ),
          const SizedBox(width: 8),
          _Chip(
            label: 'מומלצים',
            icon: activeCategory == 'מומלצים'
                ? Icons.star
                : Icons.star_border,
            iconColor:
                activeCategory == 'מומלצים' ? Colors.amber : null,
            selected: activeCategory == 'מומלצים',
            selectedColor: colorScheme.primaryContainer,
            onTap: () => notifier.setCategory('מומלצים'),
          ),
          ...presentCategories.map((cat) {
            final selected = activeCategory == cat;
            return Padding(
              padding: const EdgeInsets.only(left: 8),
              child: _Chip(
                label: cat,
                selected: selected,
                selectedColor: colorScheme.primaryContainer,
                onTap: () => notifier.setCategory(cat),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.selectedColor,
    required this.onTap,
    this.icon,
    this.iconColor,
  });

  final String label;
  final bool selected;
  final Color selectedColor;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      avatar: icon != null
          ? Icon(icon, size: 16, color: iconColor)
          : null,
      label: Text(label),
      selected: selected,
      selectedColor: selectedColor,
      onSelected: (_) => onTap(),
    );
  }
}
