import 'package:flutter/material.dart';

import '../../features/recipes/providers/recipe_filter_provider.dart';

class TagChip extends StatelessWidget {
  const TagChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(tagLabel(label)),
      visualDensity: VisualDensity.compact,
    );
  }
}
