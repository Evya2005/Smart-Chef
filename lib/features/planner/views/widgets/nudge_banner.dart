import 'package:flutter/material.dart';

import '../../providers/cooking_session_provider.dart';

/// Animated banner that shows the latest nudge message.
class NudgeBanner extends StatelessWidget {
  const NudgeBanner({
    super.key,
    required this.nudge,
    required this.onDismiss,
    this.onSwitch,
  });

  final NudgeMessage nudge;
  final VoidCallback onDismiss;
  final VoidCallback? onSwitch;

  IconData _iconFor(NudgeType type) => switch (type) {
        NudgeType.timerExpired => Icons.alarm,
        NudgeType.passiveWindow => Icons.transfer_within_a_station,
        NudgeType.allPassive => Icons.table_restaurant,
        NudgeType.recipeComplete => Icons.check_circle_outline,
      };

  Color _colorFor(NudgeType type, ColorScheme cs) => switch (type) {
        NudgeType.timerExpired => cs.error,
        NudgeType.passiveWindow => cs.primary,
        NudgeType.allPassive => cs.tertiary,
        NudgeType.recipeComplete => Colors.green,
      };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = _colorFor(nudge.type, cs);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) =>
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
      child: Material(
        key: ValueKey(nudge.id),
        elevation: 2,
        color: color.withAlpha(25),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Icon(_iconFor(nudge.type), color: color, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  nudge.text,
                  style: TextStyle(color: color, fontWeight: FontWeight.w600),
                ),
              ),
              if (onSwitch != null && nudge.targetRecipeId != null) ...[
                TextButton(
                  onPressed: onSwitch,
                  child: const Text('עבור'),
                ),
                const SizedBox(width: 4),
              ],
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                color: color,
                onPressed: onDismiss,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
