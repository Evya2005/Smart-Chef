import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../providers/scaling_provider.dart';

class ServingScaler extends ConsumerWidget {
  const ServingScaler({super.key, required this.recipeId});

  final String recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(servingCountProvider(recipeId));
    final notifier = ref.read(servingCountProvider(recipeId).notifier);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.outlined(
          onPressed: count > 1 ? () => notifier.decrement() : null,
          icon: const Icon(Icons.remove),
          visualDensity: VisualDensity.compact,
        ),
        const Gap(8),
        Text(
          '$count',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Gap(4),
        Text('מנות', style: Theme.of(context).textTheme.bodySmall),
        const Gap(8),
        IconButton.outlined(
          onPressed: () => notifier.increment(),
          icon: const Icon(Icons.add),
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}
