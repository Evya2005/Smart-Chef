import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../shared/models/cook_step_model.dart';
import '../../../../core/theme/app_colors.dart';

class StepTile extends StatelessWidget {
  const StepTile({super.key, required this.step});

  final CookStepModel step;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${step.stepNumber}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step.instruction, style: textTheme.bodyMedium),
                if (step.timerSeconds != null) ...[
                  const Gap(4),
                  _TimerBadge(
                    seconds: step.timerSeconds!,
                    label: step.timerLabel,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimerBadge extends StatelessWidget {
  const _TimerBadge({required this.seconds, this.label});

  final int seconds;
  final String? label;

  String _format(int s) {
    final m = s ~/ 60;
    final rem = s % 60;
    if (m > 0 && rem > 0) return '$m min $rem sec';
    if (m > 0) return '$m min';
    return '$s sec';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.secondary.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.secondary),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer, size: 14, color: AppColors.secondary),
          const Gap(4),
          Text(
            label ?? _format(seconds),
            style: const TextStyle(
              color: AppColors.secondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
