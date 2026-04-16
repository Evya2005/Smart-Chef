import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../providers/recipe_filter_provider.dart';

const _timeOptions = [
  (label: 'הכל', value: null),
  (label: "15'", value: 15),
  (label: "30'", value: 30),
  (label: "60'", value: 60),
  (label: "2ש׳", value: 120),
];

class FilterDrawer extends StatefulWidget {
  const FilterDrawer({
    super.key,
    required this.filter,
    required this.notifier,
    required this.scaffoldKey,
  });

  final RecipeFilter filter;
  final RecipeFilterNotifier notifier;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  State<FilterDrawer> createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  late final TextEditingController _ingredientCtrl;

  @override
  void initState() {
    super.initState();
    _ingredientCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _ingredientCtrl.dispose();
    super.dispose();
  }

  void _submitIngredient() {
    final text = _ingredientCtrl.text.trim();
    if (text.isEmpty) return;
    widget.notifier.addIngredient(text);
    _ingredientCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final filter = widget.filter;
    final notifier = widget.notifier;

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
              child: Row(
                children: [
                  Text(
                    'סינון מתקדם',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: 'סגור',
                    onPressed: () => widget.scaffoldKey.currentState!.closeEndDrawer(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Favorites + rating chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      FilterChip(
                        avatar: Icon(
                          filter.favoritesOnly
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 16,
                          color: filter.favoritesOnly ? Colors.red : null,
                        ),
                        label: const Text('מועדפים'),
                        selected: filter.favoritesOnly,
                        onSelected: (_) => notifier.toggleFavoritesOnly(),
                      ),
                      ...[1, 2, 3, 4].map((n) {
                        final isSelected = filter.minRating == n;
                        return ChoiceChip(
                          label: Text('★$n+'),
                          selected: isSelected,
                          onSelected: (_) =>
                              notifier.setMinRating(isSelected ? null : n),
                        );
                      }),
                    ],
                  ),
                  const Gap(16),
                  // Ingredient filter
                  Text(
                    'סנן לפי מרכיב',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const Gap(8),
                  TextField(
                    controller: _ingredientCtrl,
                    decoration: InputDecoration(
                      hintText: 'שם מרכיב...',
                      isDense: true,
                      prefixIcon: const Icon(Icons.add, size: 18),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                    onSubmitted: (_) => _submitIngredient(),
                    textInputAction: TextInputAction.done,
                  ),
                  if (filter.ingredientFilters.isNotEmpty) ...[
                    const Gap(8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: filter.ingredientFilters
                          .map(
                            (term) => InputChip(
                              label: Text(term),
                              onDeleted: () => notifier.removeIngredient(term),
                              visualDensity: VisualDensity.compact,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                  const Gap(16),
                  // Time filter
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, size: 18),
                      const Gap(6),
                      Text(
                        'זמן מרבי',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  ),
                  const Gap(8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: _timeOptions.map((opt) {
                      final isSelected = filter.maxTotalMinutes == opt.value;
                      return ChoiceChip(
                        label: Text(opt.label),
                        selected: isSelected,
                        onSelected: (_) => notifier.setMaxTime(opt.value),
                      );
                    }).toList(),
                  ),
                  const Gap(16),
                  // Dietary tags
                  Text(
                    'תגיות תזונה',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const Gap(8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: kAllTags.map((tag) {
                      final isActive = filter.activeTags.contains(tag);
                      return FilterChip(
                        label: Text(tagLabel(tag)),
                        selected: isActive,
                        onSelected: (_) => notifier.toggleTag(tag),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            // Clear all button
            if (filter.activeFilterCount > 0) ...[
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextButton.icon(
                  icon: const Icon(Icons.clear_all),
                  label: const Text('נקה סינונים'),
                  onPressed: notifier.clearAll,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
