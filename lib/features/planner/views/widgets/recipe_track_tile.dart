import 'package:flutter/material.dart';

import '../../../../features/recipes/models/recipe_model.dart';

/// A compact row showing a recipe's progress in Mission Control.
class RecipeTrackTile extends StatelessWidget {
  const RecipeTrackTile({
    super.key,
    required this.recipe,
    required this.stepIndex,
    required this.color,
    required this.isActive,
    required this.isCompleted,
    required this.hasRunningTimer,
    required this.onTap,
  });

  final RecipeModel recipe;
  final int stepIndex;
  final Color color;
  final bool isActive;
  final bool isCompleted;
  final bool hasRunningTimer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final totalSteps = recipe.steps.length;
    final progress =
        totalSteps > 0 ? (stepIndex / totalSteps).clamp(0.0, 1.0) : 0.0;

    return InkWell(
      onTap: isCompleted ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? color.withAlpha(20)
              : cs.surface,
          border: Border(
            right: BorderSide(
              color: isActive ? color : Colors.transparent,
              width: 4,
            ),
          ),
        ),
        child: Row(
          children: [
            // Color indicator dot
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? Colors.grey : color,
              ),
            ),
            const SizedBox(width: 12),
            // Recipe name + progress
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          recipe.title,
                          style: TextStyle(
                            fontWeight: isActive
                                ? FontWeight.bold
                                : FontWeight.normal,
                            decoration: isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: isCompleted ? cs.onSurface.withAlpha(128) : null,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (isCompleted)
                        const Icon(Icons.check_circle, size: 16, color: Colors.green)
                      else if (hasRunningTimer)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.timer, size: 14, color: color),
                            const SizedBox(width: 2),
                            Text(
                              'ממתין',
                              style: TextStyle(fontSize: 11, color: color),
                            ),
                          ],
                        )
                      else
                        Text(
                          'שלב ${stepIndex + 1}/$totalSteps',
                          style: TextStyle(
                            fontSize: 11,
                            color: cs.onSurface.withAlpha(153),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: isCompleted ? 1.0 : progress,
                      minHeight: 6,
                      color: isCompleted ? Colors.green : color,
                      backgroundColor: color.withAlpha(40),
                    ),
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
