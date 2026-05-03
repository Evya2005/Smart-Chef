import 'package:flutter/material.dart';

import '../../../../features/recipes/models/recipe_model.dart';
import '../../../../shared/models/cook_step_model.dart';
import '../../providers/cooking_session_provider.dart';

/// Bottom panel showing the currently active recipe's step in large text.
class FocusPanel extends StatelessWidget {
  const FocusPanel({
    super.key,
    required this.recipe,
    required this.stepIndex,
    required this.color,
    required this.activeTimerForStep,
    required this.otherRecipes,
    required this.onPrevious,
    required this.onNext,
    required this.onStartTimer,
    required this.onSwitchRecipe,
  });

  final RecipeModel recipe;
  final int stepIndex;
  final Color color;
  final ActiveTimerState? activeTimerForStep;
  final List<RecipeModel> otherRecipes;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onStartTimer;
  final void Function(String recipeId) onSwitchRecipe;

  CookStepModel get _step => recipe.steps[stepIndex];
  int get _totalSteps => recipe.steps.length;
  bool get _isLastStep => stepIndex >= _totalSteps - 1;
  bool get _hasTimer =>
      _step.timerSeconds != null && _step.timerSeconds! > 0;

  String _formatTimer(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Recipe name + step indicator
          Container(
            color: color.withAlpha(30),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: color),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    recipe.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  'שלב ${stepIndex + 1} מתוך $_totalSteps',
                  style: TextStyle(
                    fontSize: 12,
                    color: cs.onSurface.withAlpha(153),
                  ),
                ),
              ],
            ),
          ),
          // Step instruction
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Center(
                child: Text(
                  _step.instruction,
                  style: const TextStyle(fontSize: 18, height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          // Timer display
          if (_hasTimer)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: activeTimerForStep != null
                  ? _RunningTimerBar(
                      timer: activeTimerForStep!,
                      color: color,
                    )
                  : OutlinedButton.icon(
                      onPressed: onStartTimer,
                      icon: const Icon(Icons.timer_outlined),
                      label: Text(
                        'התחל טיימר ${_formatTimer(_step.timerSeconds!)}',
                      ),
                      style: OutlinedButton.styleFrom(foregroundColor: color),
                    ),
            ),
          const SizedBox(height: 8),
          // Navigation buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                OutlinedButton.icon(
                  onPressed: stepIndex > 0 ? onPrevious : null,
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  label: const Text('הקודם'),
                ),
                const Spacer(),
                // Switch recipe buttons
                for (final other in otherRecipes.take(2))
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: TextButton(
                      onPressed: () => onSwitchRecipe(other.id),
                      child: Text(
                        other.title.length > 8
                            ? other.title.substring(0, 8)
                            : other.title,
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                  ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: onNext,
                  icon: Icon(
                    _isLastStep
                        ? Icons.check_circle_outline
                        : Icons.arrow_back,
                    size: 18,
                  ),
                  label: Text(_isLastStep ? 'סיום' : 'סיימתי'),
                  style: FilledButton.styleFrom(backgroundColor: color),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _RunningTimerBar extends StatelessWidget {
  const _RunningTimerBar({required this.timer, required this.color});

  final ActiveTimerState timer;
  final Color color;

  String _fmt(int s) {
    final m = s ~/ 60;
    final sec = s % 60;
    return '${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final progress = timer.totalSeconds > 0
        ? timer.secondsRemaining / timer.totalSeconds
        : 0.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.timer, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              _fmt(timer.secondsRemaining),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            color: color,
            backgroundColor: color.withAlpha(40),
          ),
        ),
      ],
    );
  }
}
