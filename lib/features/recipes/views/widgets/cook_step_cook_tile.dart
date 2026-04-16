import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../shared/models/cook_step_model.dart';
import '../../../../shared/models/ingredient_model.dart';
import '../../../../shared/models/unit_type.dart';
import '../../providers/cook_mode_provider.dart';
import 'cook_timer_display.dart';

class CookStepCookTile extends ConsumerStatefulWidget {
  const CookStepCookTile({
    super.key,
    required this.step,
    required this.stepIndex,
    required this.scaledIngredients,
  });

  final CookStepModel step;
  final int stepIndex;
  final List<IngredientModel> scaledIngredients;

  @override
  ConsumerState<CookStepCookTile> createState() => _CookStepCookTileState();
}

class _CookStepCookTileState extends ConsumerState<CookStepCookTile> {
  bool _expanded = false;

  List<IngredientModel> get _matchedIngredients {
    final lower = widget.step.instruction.toLowerCase();
    return widget.scaledIngredients
        .where((i) => lower.contains(i.name.toLowerCase()))
        .toList();
  }

  String _fmtIngredient(IngredientModel ing) {
    final qty = ing.quantity == ing.quantity.roundToDouble()
        ? ing.quantity.toInt().toString()
        : ing.quantity.toStringAsFixed(1);
    final unit =
        ing.unit != UnitType.none ? ' ${ing.unit.displayLabel}' : '';
    return '$qty$unit ${ing.name}';
  }

  @override
  Widget build(BuildContext context) {
    final cookState = ref.watch(cookModeProvider);
    final notifier = ref.read(cookModeProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isChecked = cookState.checkedSteps.contains(widget.stepIndex);
    final matched = _matchedIngredients;
    final hasTimer = widget.step.timerSeconds != null;
    final hasIngredients = matched.isNotEmpty;
    final expandable = hasIngredients || hasTimer;

    final isTimerRunning = cookState.timerStepIndex == widget.stepIndex &&
        cookState.timerSeconds != null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isChecked
              ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
              : colorScheme.surface,
          border: Border.all(
            color: isChecked
                ? colorScheme.outline.withValues(alpha: 0.3)
                : colorScheme.outline.withValues(alpha: 0.5),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: expandable
                  ? () => setState(() => _expanded = !_expanded)
                  : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: isChecked
                          ? colorScheme.outline.withValues(alpha: 0.3)
                          : colorScheme.primary,
                      child: Text(
                        '${widget.stepIndex + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isChecked
                              ? colorScheme.onSurface.withValues(alpha: 0.4)
                              : colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      child: Text(
                        widget.step.instruction,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          decoration: isChecked
                              ? TextDecoration.lineThrough
                              : null,
                          color: isChecked
                              ? colorScheme.onSurface.withValues(alpha: 0.4)
                              : null,
                        ),
                      ),
                    ),
                    if (expandable) ...[
                      Icon(
                        _expanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ],
                    const Gap(4),
                    Checkbox(
                      value: isChecked,
                      visualDensity: VisualDensity.compact,
                      onChanged: (_) {
                        // If marking this step done while its timer is running,
                        // cancel the timer immediately.
                        if (!isChecked && isTimerRunning) {
                          notifier.cancelTimer();
                        }
                        notifier.toggleStep(widget.stepIndex);
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (_expanded) ...[
              Divider(
                indent: 12,
                endIndent: 12,
                height: 1,
                color: colorScheme.outline.withValues(alpha: 0.3),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasIngredients) ...[
                      Text(
                        'מצרכים לשלב זה:',
                        style: theme.textTheme.labelMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Gap(6),
                      ...matched.map(
                        (ing) => Padding(
                          padding:
                              const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              const Icon(Icons.circle, size: 5),
                              const Gap(8),
                              Text(_fmtIngredient(ing)),
                            ],
                          ),
                        ),
                      ),
                      if (hasTimer) const Gap(12),
                    ],
                    if (hasTimer) ...[
                      if (isTimerRunning) ...[
                        CookTimerDisplay(seconds: cookState.timerSeconds!),
                        const Gap(6),
                        TextButton.icon(
                          icon: const Icon(Icons.timer_off_outlined),
                          label: const Text('בטל טיימר'),
                          onPressed: notifier.cancelTimer,
                        ),
                      ] else
                        OutlinedButton.icon(
                          icon: const Icon(Icons.timer_outlined),
                          label: Text(
                            'הפעל טיימר (${widget.step.timerSeconds! ~/ 60} דקות)',
                          ),
                          onPressed: () =>
                              notifier.startTimer(widget.stepIndex),
                        ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
