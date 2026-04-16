import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/ai_guard.dart';
import '../../auth/repositories/auth_repository.dart';
import '../../recipes/models/recipe_model.dart';
import '../../recipes/providers/recipe_list_provider.dart';
import '../../recipes/views/widgets/shopping_list_bottom_sheet.dart';
import '../models/daily_plan_model.dart';
import '../providers/planner_provider.dart';
import 'widgets/add_recipe_to_plan_sheet.dart';
import 'widgets/timeline_view.dart' show TimelineView, kPlannerTrackColors;

void _showPlanShoppingList(
  BuildContext context,
  WidgetRef ref,
  DailyPlanModel plan,
) {
  final allRecipes = ref.read(recipeListProvider).value ?? [];
  final entries = <({RecipeModel recipe, int servings})>[];
  for (final pr in plan.recipes) {
    final recipe =
        allRecipes.where((r) => r.id == pr.recipeId).firstOrNull;
    if (recipe != null) {
      entries.add((recipe: recipe, servings: pr.servings));
    }
  }
  if (entries.isEmpty) return;
  ShoppingListBottomSheet.showForPlan(
    context,
    entries: entries,
    planTitle: 'ארוחה',
  );
}

class OrchestratorScreen extends ConsumerWidget {
  const OrchestratorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planState = ref.watch(plannerProvider);
    final notifier = ref.read(plannerProvider.notifier);
    final uid = ref.read(authRepositoryProvider).currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('תכנון ארוחה'),
        leading: planState.value != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: notifier.clearPlan,
              )
            : null,
        actions: [
          if (planState.value != null &&
              planState.value!.recipes.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              tooltip: 'רשימת קניות',
              onPressed: () =>
                  _showPlanShoppingList(context, ref, planState.value!),
            ),
          if (planState.value != null) ...[
            IconButton(
              icon: const Icon(Icons.save_outlined),
              tooltip: 'שמור תכנית',
              onPressed: () async {
                await notifier.savePlan(uid);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('התכנית נשמרה')),
                  );
                }
              },
            ),
            if (planState.value!.id.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                tooltip: 'מחק תכנית',
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('מחיקת תכנית'),
                      content: const Text('האם למחוק את התכנית לצמיתות?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('ביטול'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('מחק',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                  if (confirmed == true && context.mounted) {
                    await notifier.deletePlan(uid, planState.value!.id);
                    notifier.clearPlan();
                  }
                },
              ),
          ],
        ],
      ),
      body: planState.when(
        loading: () => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              Gap(16),
              Text('Gemini מחשב לוח זמנים...'),
            ],
          ),
        ),
        error: (e, _) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const Gap(12),
              Text(
                e is Exception ? e.toString() : 'שגיאה בלתי צפויה',
                textAlign: TextAlign.center,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              const Gap(16),
              FilledButton.icon(
                icon: const Icon(Icons.refresh),
                onPressed: notifier.clearPlan,
                label: const Text('חזור'),
              ),
            ],
          ),
        ),
        data: (plan) {
          if (plan == null) {
            return _IdleView(uid: uid, notifier: notifier);
          }

          return Column(
            children: [
              _PlanHeader(plan: plan, notifier: notifier),
              const Divider(height: 1),
              Expanded(
                child: plan.timeline != null
                    ? TimelineView(plan: plan)
                    : _RecipeList(plan: plan, notifier: notifier),
              ),
              if (plan.timeline == null)
                _GenerateButton(plan: plan, notifier: notifier, ref: ref),
            ],
          );
        },
      ),
    );
  }
}

// ─── Idle (no active plan) — shows saved plans + new plan button ──────────────

class _IdleView extends ConsumerWidget {
  const _IdleView({required this.uid, required this.notifier});

  final String uid;
  final PlannerNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedPlansAsync = ref.watch(planListProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        FilledButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('תכנן ארוחה חדשה'),
          onPressed: () => notifier.newPlan(uid),
        ),
        const Gap(24),
        savedPlansAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('שגיאה: $e'),
          data: (plans) {
            if (plans.isEmpty) {
              return Column(
                children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 48,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(80)),
                  const Gap(12),
                  Text('אין תכניות שמורות עדיין',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'תכניות שמורות',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Gap(8),
                ...plans.map(
                  (p) => _SavedPlanTile(
                    plan: p,
                    uid: uid,
                    onTap: () => notifier.loadPlan(p),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _SavedPlanTile extends ConsumerWidget {
  const _SavedPlanTile({
    required this.plan,
    required this.uid,
    required this.onTap,
  });

  final DailyPlanModel plan;
  final String uid;
  final VoidCallback onTap;

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('מחיקת תכנית'),
        content: const Text('האם למחוק את התכנית לצמיתות?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('ביטול'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child:
                const Text('מחק', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await ref.read(plannerProvider.notifier).deletePlan(uid, plan.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealTime = DateTime.parse(plan.mealTime).toLocal();
    final fmt = DateFormat('EEEE, d/M/y H:mm', 'he');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(Icons.restaurant_menu),
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(fmt.format(mealTime),
                        style:
                            Theme.of(context).textTheme.bodyMedium),
                    Text(
                      '${plan.recipes.length} מתכונים'
                      '${plan.timeline != null ? ' • לוח זמנים מוכן' : ''}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (plan.recipes.isNotEmpty) ...[
                      const Gap(8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          for (var i = 0;
                              i < plan.recipes.length;
                              i++)
                            Chip(
                              visualDensity: VisualDensity.compact,
                              labelStyle: Theme.of(context)
                                  .textTheme
                                  .labelSmall,
                              avatar: CircleAvatar(
                                backgroundColor:
                                    kPlannerTrackColors[i %
                                        kPlannerTrackColors
                                            .length],
                                radius: 6,
                              ),
                              backgroundColor:
                                  kPlannerTrackColors[i %
                                          kPlannerTrackColors
                                              .length]
                                      .withAlpha(40),
                              label: Text(
                                  plan.recipes[i].recipeTitle),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: Colors.red),
                    tooltip: 'מחק תכנית',
                    onPressed: () => _confirmDelete(context, ref),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Active plan components ────────────────────────────────────────────────────

class _PlanHeader extends StatelessWidget {
  const _PlanHeader({required this.plan, required this.notifier});

  final DailyPlanModel plan;
  final PlannerNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final mealTime = DateTime.parse(plan.mealTime).toLocal();
    final fmt = DateFormat('EEEE, d/M/y H:mm', 'he');

    return ListTile(
      leading: const Icon(Icons.schedule),
      title: const Text('זמן ארוחה'),
      subtitle: Text(fmt.format(mealTime)),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () async {
          final picked = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(mealTime),
          );
          if (picked != null) {
            notifier.setMealTime(DateTime(
              mealTime.year,
              mealTime.month,
              mealTime.day,
              picked.hour,
              picked.minute,
            ));
          }
        },
      ),
    );
  }
}

class _RecipeList extends ConsumerStatefulWidget {
  const _RecipeList({required this.plan, required this.notifier});

  final DailyPlanModel plan;
  final PlannerNotifier notifier;

  @override
  ConsumerState<_RecipeList> createState() => _RecipeListState();
}

class _RecipeListState extends ConsumerState<_RecipeList> {
  late TextEditingController _notesCtrl;
  late TextEditingController _instructionsCtrl;

  @override
  void initState() {
    super.initState();
    _notesCtrl = TextEditingController(text: widget.plan.notes);
    _instructionsCtrl =
        TextEditingController(text: widget.plan.customInstructions);
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    _instructionsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plan = widget.plan;
    final notifier = widget.notifier;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (plan.recipes.isEmpty)
          const Center(child: Text('לא נוספו מתכונים עדיין'))
        else
          ...plan.recipes.map<Widget>((pr) => ListTile(
                leading: const Icon(Icons.restaurant),
                title: Text(pr.recipeTitle),
                subtitle: Text('${pr.servings} מנות'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => notifier.removeRecipe(pr.recipeId),
                ),
              )),
        const Gap(8),
        OutlinedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('הוסף מתכון'),
          onPressed: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => const AddRecipeToPlanSheet(),
          ),
        ),
        if (plan.recipes.isNotEmpty) ...[
          const Gap(16),
          TextFormField(
            controller: _notesCtrl,
            decoration: const InputDecoration(
              labelText: 'הערות אישיות',
              hintText: 'אלרגיות, העדפות, תזכורות...',
            ),
            maxLines: 3,
            onChanged: notifier.setNotes,
          ),
          const Gap(12),
          TextFormField(
            controller: _instructionsCtrl,
            decoration: const InputDecoration(
              labelText: 'הנחיות ל-Gemini',
              hintText: 'למשל: מתחיל בבישול, יש לי תנור אחד...',
            ),
            maxLines: 3,
            onChanged: notifier.setCustomInstructions,
          ),
        ],
      ],
    );
  }
}

class _GenerateButton extends StatelessWidget {
  const _GenerateButton({
    required this.plan,
    required this.notifier,
    required this.ref,
  });

  final DailyPlanModel plan;
  final PlannerNotifier notifier;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: FilledButton.icon(
        icon: const Icon(Icons.auto_awesome),
        label: const Text('צור לוח זמנים עם Gemini'),
        onPressed: plan.recipes.isEmpty
            ? null
            : () async {
                if (!await requireAiKey(context, ref)) return;
                final recipeIds =
                    plan.recipes.map((pr) => pr.recipeId).toSet();
                final allRecipes =
                    ref.read(recipeListProvider).value ?? [];
                final selected = allRecipes
                    .where((r) => recipeIds.contains(r.id))
                    .toList();
                await notifier.generateTimeline(selected);
              },
      ),
    );
  }
}
