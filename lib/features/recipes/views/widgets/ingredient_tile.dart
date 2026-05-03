import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/ingredient_model.dart';
import '../../../../shared/models/unit_type.dart';
import '../../providers/ingredient_display_unit_provider.dart';
import '../../services/smart_unit_suggester.dart';
import '../../services/unit_conversion_service.dart';

const _converter = UnitConversionService();
const _suggester = SmartUnitSuggester();

class IngredientTile extends ConsumerWidget {
  const IngredientTile({
    super.key,
    required this.ingredient,
    this.recipeId,
    this.index,
    this.showSubstituteButton = false,
    this.onSubstitute,
  });

  final IngredientModel ingredient;

  /// When provided, enables unit conversion interaction.
  final String? recipeId;
  final int? index;
  final bool showSubstituteButton;
  final VoidCallback? onSubstitute;

  String _formatQty(double qty) {
    if (qty == qty.truncateToDouble()) return qty.toInt().toString();
    return qty.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final canInteract = recipeId != null && index != null;

    final overrideName = canInteract
        ? ref
            .watch(ingredientDisplayUnitProvider)[(recipeId!, index!)]
        : null;

    final displayUnit = overrideName != null
        ? UnitType.values.firstWhere(
            (u) => u.value == overrideName,
            orElse: () => ingredient.unit,
          )
        : ingredient.unit;

    final isApprox = overrideName != null &&
        overrideName != ingredient.unit.value;
    double displayQty = ingredient.quantity;
    if (isApprox) {
      displayQty = _converter.convert(
              ingredient.quantity,
              ingredient.unit,
              displayUnit,
              ingredient.name) ??
          ingredient.quantity;
    }

    final unitLabel =
        displayUnit == UnitType.none ? '' : ' ${displayUnit.displayLabel}';
    final quantityStr =
        '${isApprox ? '~' : ''}${_formatQty(displayQty)}$unitLabel';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          GestureDetector(
            onTap: canInteract
                ? () => _showConversionSheet(context, ref)
                : null,
            child: Container(
              width: 80,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              decoration: canInteract
                  ? BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withAlpha(80),
                      ),
                      borderRadius: BorderRadius.circular(6),
                    )
                  : null,
              child: Text(
                quantityStr,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ingredient.inferred
                      ? '${ingredient.name} *'
                      : ingredient.name,
                  style: textTheme.bodyMedium,
                ),
                if (ingredient.prepNote != null)
                  Text(
                    ingredient.prepNote!,
                    style: textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          if (showSubstituteButton && canInteract)
            IconButton(
              icon: const Icon(Icons.swap_horiz_outlined, size: 20),
              tooltip: 'מצא תחליף',
              onPressed: onSubstitute,
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }

  Future<void> _showConversionSheet(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final smartTargets = _suggester.relevantTargets(ingredient);
    var targets = smartTargets.isNotEmpty
        ? smartTargets
        : _converter.availableTargets(ingredient.unit, ingredient.name);

    targets = targets.where((u) {
      if (u == UnitType.kilograms || u == UnitType.liters) {
        final v = _converter.convert(
            ingredient.quantity, ingredient.unit, u, ingredient.name);
        return v != null && v >= 0.5;
      }
      return true;
    }).toList();

    if (targets.isEmpty) return;

    final overrideName =
        ref.read(ingredientDisplayUnitProvider)[(recipeId!, index!)];
    final currentUnit = overrideName != null
        ? UnitType.values.firstWhere((u) => u.value == overrideName,
            orElse: () => ingredient.unit)
        : ingredient.unit;
    final unitLabel =
        ingredient.unit == UnitType.none ? '' : ' ${ingredient.unit.displayLabel}';

    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(ctx)
                          .colorScheme
                          .onSurfaceVariant
                          .withAlpha(60),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  ingredient.name,
                  style: Theme.of(ctx)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  'מקורי: ${_formatQty(ingredient.quantity)}$unitLabel',
                  style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                        color:
                            Theme.of(ctx).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _unitChip(
                      ctx,
                      label: 'מקורי',
                      preview:
                          '${_formatQty(ingredient.quantity)}$unitLabel',
                      selected: currentUnit == ingredient.unit,
                      onTap: () {
                        ref
                            .read(ingredientDisplayUnitProvider.notifier)
                            .setOverride((recipeId!, index!), null);
                        Navigator.pop(ctx);
                      },
                    ),
                    ...targets.map(
                      (u) => _unitChip(
                        ctx,
                        label: u.displayLabel,
                        preview: _previewConversion(u),
                        selected: currentUnit == u,
                        onTap: () {
                          ref
                              .read(
                                  ingredientDisplayUnitProvider.notifier)
                              .setOverride((recipeId!, index!), u.value);
                          Navigator.pop(ctx);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _unitChip(
    BuildContext ctx, {
    required String label,
    required String preview,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final cs = Theme.of(ctx).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? cs.primaryContainer
              : cs.secondaryContainer.withAlpha(80),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? cs.primary : cs.outline.withAlpha(60),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Theme.of(ctx).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: selected ? cs.onPrimaryContainer : cs.onSurface,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              preview,
              style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                    color: selected ? cs.primary : cs.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  String _previewConversion(UnitType to) {
    final result = _converter.convert(
        ingredient.quantity, ingredient.unit, to, ingredient.name);
    if (result == null) return '';
    final fmt = result == result.truncateToDouble()
        ? result.toInt().toString()
        : result.toStringAsFixed(2);
    return '~$fmt ${to.displayLabel}';
  }
}
