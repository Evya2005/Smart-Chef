import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
        color: Colors.amber,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.timer, color: Colors.black87),
          const Gap(8),
          Text(
            '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
