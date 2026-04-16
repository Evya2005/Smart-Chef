import 'package:flutter/material.dart';

import '../../providers/cooking_session_provider.dart';

/// Horizontal scrollable row of active timer chips shown at the top of
/// Mission Control.
class TimerRack extends StatelessWidget {
  const TimerRack({
    super.key,
    required this.timers,
    required this.recipeColors,
    required this.onCancel,
    required this.onTap,
  });

  final List<ActiveTimerState> timers;
  final Map<String, Color> recipeColors;
  final void Function(String timerKey) onCancel;
  final void Function(String recipeId) onTap;

  @override
  Widget build(BuildContext context) {
    if (timers.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 56,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: timers.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (ctx, i) {
          final timer = timers[i];
          return _TimerChip(
            timer: timer,
            color: recipeColors[timer.recipeId] ?? Colors.teal,
            onCancel: () => onCancel(timer.timerKey),
            onTap: () => onTap(timer.recipeId),
          );
        },
      ),
    );
  }
}

class _TimerChip extends StatelessWidget {
  const _TimerChip({
    required this.timer,
    required this.color,
    required this.onCancel,
    required this.onTap,
  });

  final ActiveTimerState timer;
  final Color color;
  final VoidCallback onCancel;
  final VoidCallback onTap;

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final expired = timer.isExpired;
    final bg = expired
        ? Theme.of(context).colorScheme.errorContainer
        : color.withAlpha(30);
    final fg = expired ? Theme.of(context).colorScheme.onErrorContainer : color;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withAlpha(80)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              expired ? Icons.alarm : Icons.timer_outlined,
              size: 14,
              color: fg,
            ),
            const SizedBox(width: 4),
            Text(
              timer.recipeTitle.length > 12
                  ? '${timer.recipeTitle.substring(0, 12)}…'
                  : timer.recipeTitle,
              style: TextStyle(fontSize: 12, color: fg),
            ),
            const SizedBox(width: 6),
            Text(
              expired ? 'הסתיים!' : _formatTime(timer.secondsRemaining),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: fg,
              ),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onCancel,
              child: Icon(Icons.close, size: 14, color: fg),
            ),
          ],
        ),
      ),
    );
  }
}
