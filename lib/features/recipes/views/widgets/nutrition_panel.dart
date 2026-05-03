import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../models/nutrition_model.dart';
import '../../providers/recipe_detail_provider.dart';
import '../../providers/scaling_provider.dart';

class NutritionPanel extends ConsumerStatefulWidget {
  const NutritionPanel({super.key, required this.recipeId});

  final String recipeId;

  @override
  ConsumerState<NutritionPanel> createState() => _NutritionPanelState();
}

class _NutritionPanelState extends ConsumerState<NutritionPanel> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final recipeAsync = ref.watch(recipeDetailProvider(widget.recipeId));
    final recipe = recipeAsync.value;
    if (recipe == null || recipe.nutrition == null) return const SizedBox.shrink();

    final nutrition = recipe.nutrition!;
    final servingCount = ref.watch(servingCountProvider(widget.recipeId));
    final scale = recipe.defaultServings > 0
        ? servingCount / recipe.defaultServings
        : 1.0;

    return _NutritionCard(
      nutrition: nutrition,
      scale: scale,
      servingCount: servingCount,
      expanded: _expanded,
      onToggleExpand: () => setState(() => _expanded = !_expanded),
    );
  }
}

class _NutritionCard extends StatelessWidget {
  const _NutritionCard({
    required this.nutrition,
    required this.scale,
    required this.servingCount,
    required this.expanded,
    required this.onToggleExpand,
  });

  final NutritionModel nutrition;
  final double scale;
  final int servingCount;
  final bool expanded;
  final VoidCallback onToggleExpand;

  double _scaled(double val) => val * scale;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final proteinG = _scaled(nutrition.protein);
    final fatG = _scaled(nutrition.fat);
    final carbsG = _scaled(nutrition.carbs);
    final total = proteinG + fatG + carbsG;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.monitor_heart_outlined,
                    size: 20, color: colorScheme.primary),
                const Gap(8),
                Expanded(
                  child: Text(
                    servingCount == 1 ? 'ערכים תזונתיים למנה אחת' : 'ערכים תזונתיים ל-$servingCount מנות',
                    style: textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                if (nutrition.isEstimated)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'הערכה',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
              ],
            ),
            const Gap(12),
            // Macro bar
            if (total > 0) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                  height: 10,
                  child: Row(
                    children: [
                      Flexible(
                        flex: (proteinG * 100).round(),
                        child: ColoredBox(color: Colors.blue.shade400),
                      ),
                      Flexible(
                        flex: (fatG * 100).round(),
                        child: ColoredBox(color: Colors.orange.shade400),
                      ),
                      Flexible(
                        flex: (carbsG * 100).round(),
                        child: ColoredBox(color: Colors.green.shade400),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(12),
            ],
            // Primary rows
            _NutrientRow(
              label: 'קלוריות',
              value: _scaled(nutrition.calories),
              unit: 'קק"ל',
              bold: true,
            ),
            _NutrientRow(
              label: 'חלבון',
              value: proteinG,
              unit: 'ג׳',
              barColor: Colors.blue.shade400,
              fraction: total > 0 ? proteinG / total : 0,
            ),
            _NutrientRow(
              label: 'שומן',
              value: fatG,
              unit: 'ג׳',
              barColor: Colors.orange.shade400,
              fraction: total > 0 ? fatG / total : 0,
            ),
            _NutrientRow(
              label: 'פחמימות',
              value: carbsG,
              unit: 'ג׳',
              barColor: Colors.green.shade400,
              fraction: total > 0 ? carbsG / total : 0,
            ),
            // Expandable secondary rows
            if (expanded) ...[
              const Divider(height: 16),
              _NutrientRow(
                label: 'סיבים תזונתיים',
                value: _scaled(nutrition.fiber),
                unit: 'ג׳',
              ),
              _NutrientRow(
                label: 'סוכרים',
                value: _scaled(nutrition.sugar),
                unit: 'ג׳',
              ),
              _NutrientRow(
                label: 'נתרן',
                value: _scaled(nutrition.sodium),
                unit: 'מ"ג',
              ),
              _NutrientRow(
                label: 'שומן רווי',
                value: _scaled(nutrition.saturatedFat),
                unit: 'ג׳',
              ),
            ],
            const Gap(4),
            // Expand toggle
            GestureDetector(
              onTap: onToggleExpand,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    expanded ? Icons.expand_less : Icons.expand_more,
                    size: 18,
                    color: colorScheme.secondary,
                  ),
                  const Gap(4),
                  Text(
                    expanded ? 'פחות' : 'עוד פרטים',
                    style: textTheme.bodySmall
                        ?.copyWith(color: colorScheme.secondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NutrientRow extends StatelessWidget {
  const _NutrientRow({
    required this.label,
    required this.value,
    required this.unit,
    this.bold = false,
    this.barColor,
    this.fraction,
  });

  final String label;
  final double value;
  final String unit;
  final bool bold;
  final Color? barColor;
  final double? fraction;

  @override
  Widget build(BuildContext context) {
    final style = bold
        ? Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(fontWeight: FontWeight.bold)
        : Theme.of(context).textTheme.bodyMedium;

    if (barColor != null && fraction != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            SizedBox(
              width: 72,
              child: Text(label, style: style),
            ),
            const Gap(8),
            Expanded(
              child: LinearProgressIndicator(
                value: fraction,
                color: barColor,
                backgroundColor: barColor!.withValues(alpha: 0.15),
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const Gap(8),
            SizedBox(
              width: 56,
              child: Text(
                '${value.toStringAsFixed(1)} $unit',
                style: style,
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(
            '${value.toStringAsFixed(1)} $unit',
            style: style,
          ),
        ],
      ),
    );
  }
}

