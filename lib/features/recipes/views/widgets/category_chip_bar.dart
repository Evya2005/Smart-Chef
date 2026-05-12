import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../settings/providers/categories_provider.dart';
import '../../providers/recipe_filter_provider.dart';

class CategoryChipBar extends ConsumerWidget {
  const CategoryChipBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeCategory =
        ref.watch(recipeFilterProvider.select((f) => f.activeCategory));
    final notifier = ref.read(recipeFilterProvider.notifier);

    final presentCategories =
        ref.watch(recipeCategoriesProvider).asData?.value ??
            AppConstants.kRecipeCategories;

    return SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _SCChip(
            label: 'מועדפים',
            leadingIcon: Icons.favorite,
            selected: activeCategory == 'מועדפים',
            onTap: () => notifier.setCategory('מועדפים'),
          ),
          const SizedBox(width: 8),
          _SCChip(
            label: 'מומלצים',
            leadingIcon: Icons.star,
            selected: activeCategory == 'מומלצים',
            onTap: () => notifier.setCategory('מומלצים'),
          ),
          ...presentCategories.map((cat) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _SCChip(
                label: cat,
                selected: activeCategory == cat,
                onTap: () => notifier.setCategory(cat),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _SCChip extends StatelessWidget {
  const _SCChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.leadingIcon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? leadingIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.terracotta : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: selected
              ? null
              : Border.all(color: AppColors.lineStrong),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leadingIcon != null) ...[
              Icon(
                leadingIcon,
                size: 14,
                color: selected ? Colors.white : AppColors.ink2,
              ),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: GoogleFonts.assistant(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                color: selected ? Colors.white : AppColors.ink2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
