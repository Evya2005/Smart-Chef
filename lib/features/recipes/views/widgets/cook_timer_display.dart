import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';

class CookTimerDisplay extends StatelessWidget {
  const CookTimerDisplay({super.key, required this.seconds});

  final int seconds;

  @override
  Widget build(BuildContext context) {
    final min = seconds ~/ 60;
    final sec = seconds % 60;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.terracottaSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.terracotta.withAlpha(60)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.timer_outlined, color: AppColors.terracotta),
          const Gap(10),
          Text(
            '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}',
            style: GoogleFonts.sourceSerif4(
              fontSize: 32,
              fontWeight: FontWeight.w500,
              color: AppColors.terracotta,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}
