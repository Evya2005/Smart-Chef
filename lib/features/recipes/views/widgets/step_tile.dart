import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/models/cook_step_model.dart';
import '../../../../core/theme/app_colors.dart';

class StepTile extends StatelessWidget {
  const StepTile({super.key, required this.step});

  final CookStepModel step;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step number circle — sage palette
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.sageSoft,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${step.stepNumber}',
              style: GoogleFonts.sourceSerif4(
                color: AppColors.sage,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.instruction,
                  style: GoogleFonts.assistant(
                    fontSize: 14,
                    color: AppColors.ink,
                    height: 1.55,
                  ),
                ),
                if (step.timerSeconds != null) ...[
                  const Gap(6),
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
    if (m > 0 && rem > 0) return '$m דק׳ $rem שנ׳';
    if (m > 0) return '$m דק׳';
    return '$s שנ׳';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.terracottaSoft,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.terracotta.withAlpha(60)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer_outlined,
              size: 14, color: AppColors.terracotta),
          const Gap(5),
          Text(
            label ?? _format(seconds),
            style: GoogleFonts.assistant(
              color: AppColors.terracotta,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
