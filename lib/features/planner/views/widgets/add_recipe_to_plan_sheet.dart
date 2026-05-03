import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../recipes/models/recipe_model.dart';
import '../../../recipes/providers/recipe_list_provider.dart';
import '../../providers/planner_provider.dart';

class AddRecipeToPlanSheet extends ConsumerStatefulWidget {
  const AddRecipeToPlanSheet({super.key});

  @override
  ConsumerState<AddRecipeToPlanSheet> createState() =>
      _AddRecipeToPlanSheetState();
}

class _AddRecipeToPlanSheetState
    extends ConsumerState<AddRecipeToPlanSheet> {
  RecipeModel? _selected;
  int _servings = 4;

  @override
  Widget build(BuildContext context) {
    final recipesAsync = ref.watch(recipeListProvider);

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('הוסף מתכון לתכנית',
              style: Theme.of(context).textTheme.titleLarge),
          const Gap(16),
          recipesAsync.when(
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('שגיאה: $e'),
            data: (recipes) => InputDecorator(
              decoration: const InputDecoration(
                labelText: 'בחר מתכון',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              child: DropdownButton<RecipeModel>(
                value: _selected,
                isExpanded: true,
                underline: const SizedBox.shrink(),
                hint: const Text('בחר מתכון'),
                items: recipes
                    .map((r) => DropdownMenuItem(
                          value: r,
                          child: Text(r.title,
                              overflow: TextOverflow.ellipsis),
                        ))
                    .toList(),
                onChanged: (r) => setState(() {
                  _selected = r;
                  if (r != null) _servings = r.defaultServings;
                }),
              ),
            ),
          ),
          const Gap(12),
          Row(
            children: [
              const Text('מנות:'),
              const Gap(8),
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: _servings > 1
                    ? () => setState(() => _servings--)
                    : null,
              ),
              Text('$_servings',
                  style: Theme.of(context).textTheme.titleMedium),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => setState(() => _servings++),
              ),
            ],
          ),
          const Gap(16),
          FilledButton(
            onPressed: _selected == null
                ? null
                : () {
                    ref
                        .read(plannerProvider.notifier)
                        .addRecipe(_selected!, _servings);
                    Navigator.pop(context);
                  },
            child: const Text('הוסף'),
          ),
        ],
      ),
    );
  }
}
