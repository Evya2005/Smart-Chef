import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../shared/models/ingredient_model.dart';
import '../../../../shared/models/unit_type.dart';
import '../../models/recipe_model.dart';
import '../../models/substitution_model.dart';
import '../../providers/substitution_provider.dart';

class SubstitutionBottomSheet extends ConsumerStatefulWidget {
  const SubstitutionBottomSheet({
    super.key,
    required this.recipe,
    required this.ingredient,
  });

  final RecipeModel recipe;
  final IngredientModel ingredient;

  static Future<void> show(
    BuildContext context, {
    required RecipeModel recipe,
    required IngredientModel ingredient,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => SubstitutionBottomSheet(
        recipe: recipe,
        ingredient: ingredient,
      ),
    );
  }

  @override
  ConsumerState<SubstitutionBottomSheet> createState() =>
      _SubstitutionBottomSheetState();
}

class _SubstitutionBottomSheetState
    extends ConsumerState<SubstitutionBottomSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(substitutionProvider.notifier).findSubstitutions(
            widget.recipe,
            widget.ingredient,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<SubstitutionState>(substitutionProvider, (_, next) {
      if (next is SubstitutionDone) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'המצרך "${widget.ingredient.name}" הוחלף בהצלחה!'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (next is SubstitutionError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });

    final subState = ref.watch(substitutionProvider);
    final notifier = ref.read(substitutionProvider.notifier);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'תחליפים עבור: ${widget.ingredient.name}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Gap(8),
              if (subState is SubstitutionLoading)
                const Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        Gap(16),
                        Text('מנתח תפקיד קולינרי...'),
                      ],
                    ),
                  ),
                )
              else if (subState is SubstitutionResult) ...[
                Text(
                  'תפקיד: ${subState.role}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant,
                      ),
                ),
                const Gap(12),
                _CategoryFilterChips(
                  activeCategory: subState.activeCategory,
                  onCategoryChanged: notifier.setCategory,
                ),
                const Gap(12),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: subState.filtered.length,
                    itemBuilder: (context, i) {
                      final sub = subState.filtered[i];
                      return _SubstitutionCard(
                        substitution: sub,
                        onApply: () => notifier.applySubstitution(
                          widget.recipe,
                          widget.ingredient,
                          sub,
                        ),
                      );
                    },
                  ),
                ),
              ] else if (subState is SubstitutionApplying)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (subState is SubstitutionError)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Theme.of(context).colorScheme.error,
                          size: 48,
                        ),
                        const Gap(12),
                        Text(subState.message,
                            textAlign: TextAlign.center),
                        const Gap(12),
                        FilledButton(
                          onPressed: () =>
                              notifier.findSubstitutions(
                            widget.recipe,
                            widget.ingredient,
                          ),
                          child: const Text('נסה שוב'),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _CategoryFilterChips extends StatelessWidget {
  const _CategoryFilterChips({
    required this.activeCategory,
    required this.onCategoryChanged,
  });

  final String? activeCategory;
  final ValueChanged<String?> onCategoryChanged;

  static const _categories = ['בריא', 'טבעוני', 'אין לי את זה'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          FilterChip(
            label: const Text('הכל'),
            selected: activeCategory == null,
            onSelected: (_) => onCategoryChanged(null),
          ),
          const Gap(6),
          ..._categories.map(
            (cat) => Padding(
              padding: const EdgeInsets.only(right: 6),
              child: FilterChip(
                label: Text(cat),
                selected: activeCategory == cat,
                onSelected: (_) => onCategoryChanged(
                  activeCategory == cat ? null : cat,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubstitutionCard extends StatefulWidget {
  const _SubstitutionCard({
    required this.substitution,
    required this.onApply,
  });

  final SubstitutionModel substitution;
  final VoidCallback onApply;

  @override
  State<_SubstitutionCard> createState() => _SubstitutionCardState();
}

class _SubstitutionCardState extends State<_SubstitutionCard> {
  bool _expanded = false;

  static const _categoryColors = {
    'בריא': Color(0xFF4CAF50),
    'טבעוני': Color(0xFF8BC34A),
    'אין לי את זה': Color(0xFF2196F3),
  };

  @override
  Widget build(BuildContext context) {
    final sub = widget.substitution;
    final color = _categoryColors[sub.category] ?? Colors.grey;
    final unit = sub.unit == UnitType.none ? '' : ' ${sub.unit.displayLabel}';
    final qty = _formatQty(sub.quantity);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withAlpha(40),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withAlpha(100)),
                  ),
                  child: Text(
                    sub.category,
                    style: TextStyle(
                      fontSize: 11,
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: Text(
                    '$qty$unit ${sub.name}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                FilledButton(
                  onPressed: widget.onApply,
                  child: const Text('החל'),
                ),
              ],
            ),
            if (sub.prepNote != null) ...[
              const Gap(4),
              Text(
                sub.prepNote!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant,
                    ),
              ),
            ],
            if (sub.stepUpdates.isNotEmpty) ...[
              const Gap(8),
              GestureDetector(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Row(
                  children: [
                    Icon(
                      _expanded
                          ? Icons.expand_less
                          : Icons.expand_more,
                      size: 16,
                      color:
                          Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const Gap(4),
                    Text(
                      '${sub.stepUpdates.length} שלבים מתעדכנים',
                      style:
                          Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                    ),
                  ],
                ),
              ),
              if (_expanded) ...[
                const Gap(8),
                ...sub.stepUpdates.map(
                  (u) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'שלב ${u.stepNumber}: ',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Expanded(
                          child: Text(
                            u.instruction,
                            style:
                                Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  String _formatQty(double qty) {
    if (qty == qty.truncateToDouble()) return qty.toInt().toString();
    return qty.toStringAsFixed(1);
  }
}
