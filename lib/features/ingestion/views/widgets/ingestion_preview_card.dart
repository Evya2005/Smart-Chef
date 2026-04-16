import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../features/recipes/models/recipe_model.dart';
import '../../../../features/recipes/providers/recipe_filter_provider.dart';

class IngestionPreviewCard extends StatefulWidget {
  const IngestionPreviewCard({
    super.key,
    required this.recipe,
    required this.onTitleChanged,
    required this.onTagsChanged,
    required this.onConfirm,
    required this.onDiscard,
  });

  final RecipeModel recipe;
  final ValueChanged<String> onTitleChanged;
  final ValueChanged<List<String>> onTagsChanged;
  final VoidCallback onConfirm;
  final VoidCallback onDiscard;

  @override
  State<IngestionPreviewCard> createState() => _IngestionPreviewCardState();
}

class _IngestionPreviewCardState extends State<IngestionPreviewCard> {
  late TextEditingController _titleCtrl;
  late Set<String> _selectedTags;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.recipe.title);
    _selectedTags = widget.recipe.tags.toSet();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.recipe;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'תצוגה מקדימה',
              style: textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Gap(16),
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'שם המתכון'),
              onChanged: widget.onTitleChanged,
            ),
            const Gap(12),
            Text(
              'תגיות',
              style: textTheme.labelLarge,
            ),
            const Gap(6),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: kAllTags.map((tag) {
                final selected = _selectedTags.contains(tag);
                return FilterChip(
                  label: Text(tagLabel(tag)),
                  selected: selected,
                  onSelected: (_) {
                    setState(() {
                      if (selected) {
                        _selectedTags.remove(tag);
                      } else {
                        _selectedTags.add(tag);
                      }
                    });
                    widget.onTagsChanged(_selectedTags.toList());
                  },
                );
              }).toList(),
            ),
            const Gap(16),
            Row(
              children: [
                _StatBadge(
                    icon: Icons.timer_outlined,
                    label: '${r.activeTimeMinutes} ד׳ פעיל'),
                const Gap(12),
                _StatBadge(
                    icon: Icons.schedule_outlined,
                    label: '${r.totalTimeMinutes} ד׳ סה״כ'),
                const Gap(12),
                _StatBadge(
                    icon: Icons.people_outline,
                    label: '${r.defaultServings} מנות'),
              ],
            ),
            const Gap(12),
            Text(
              '${r.ingredients.length} מצרכים · ${r.steps.length} שלבים',
              style: textTheme.bodySmall,
            ),
            const Gap(16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: widget.onDiscard,
                    icon: const Icon(Icons.close),
                    label: const Text('בטל'),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: widget.onConfirm,
                    icon: const Icon(Icons.check),
                    label: const Text('שמור מתכון'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  const _StatBadge({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Theme.of(context).colorScheme.primary),
        const Gap(4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
