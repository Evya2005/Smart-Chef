import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../features/recipes/models/recipe_model.dart';
import '../../../features/recipes/providers/recipe_list_provider.dart';
import '../../../shared/models/unit_type.dart';
import '../models/cooking_session_model.dart';
import '../planner_constants.dart';
import '../providers/cooking_session_provider.dart';
import '../services/local_scheduler_service.dart';

class SessionSetupScreen extends ConsumerStatefulWidget {
  const SessionSetupScreen({super.key});

  @override
  ConsumerState<SessionSetupScreen> createState() => _SessionSetupScreenState();
}

class _SessionSetupScreenState extends ConsumerState<SessionSetupScreen> {
  static const _scheduler = LocalSchedulerService();

  final Set<String> _selectedIds = {};
  DateTime? _targetTime;
  String _search = '';

  List<RecipeModel> _selectedRecipes(List<RecipeModel> all) =>
      all.where((r) => _selectedIds.contains(r.id)).toList();

  List<ScheduledRecipe> _schedule(List<RecipeModel> all) =>
      _scheduler.computeStartOrder(
        _selectedRecipes(all),
        targetReadyTime: _targetTime,
      );

  List<MiseEnPlaceItemModel> _mise(List<RecipeModel> all) =>
      _scheduler.generateMiseEnPlace(_selectedRecipes(all));

  Future<void> _pickTime() async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: now.hour + 1, minute: 0),
      helpText: 'מתי מגישים?',
    );
    if (picked == null) return;
    final today = DateTime.now();
    setState(() {
      _targetTime = DateTime(
        today.year,
        today.month,
        today.day,
        picked.hour,
        picked.minute,
      );
    });
  }

  Future<void> _startSession(List<RecipeModel> all) async {
    if (_selectedIds.length < 2) return;
    final recipes = _selectedRecipes(all);
    final notifier = ref.read(cookingSessionProvider.notifier);
    final id = await notifier.createSession(
      recipes: recipes,
      targetReadyTime: _targetTime,
    );
    if (!mounted) return;
    if (id != null) {
      context.go('/planner/session/$id');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('שגיאה ביצירת הסשן')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipesAsync = ref.watch(recipeListProvider);
    final publicAsync = ref.watch(publicRecipesProvider);

    // Combine loading states: show spinner if either is loading.
    final isLoading = recipesAsync.isLoading || publicAsync.isLoading;
    final hasError = recipesAsync.hasError || publicAsync.hasError;

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (hasError) {
      return Scaffold(
        appBar: AppBar(title: const Text('ארוחה מרובת מתכונים'), centerTitle: true),
        body: Center(child: Text('שגיאה: ${recipesAsync.error ?? publicAsync.error}')),
      );
    }

    final ownRecipes = recipesAsync.asData?.value ?? [];
    final rawPublic = publicAsync.asData?.value ?? [];

    // Own recipe IDs for filtering out user's own from public section.
    final ownIds = {for (final r in ownRecipes) r.id};
    final publicOthers =
        rawPublic.where((r) => !ownIds.contains(r.id)).toList();

    // Combined list for helper methods (_selectedRecipes, _schedule, _mise).
    final allRecipes = [...ownRecipes, ...publicOthers];

    return Scaffold(
      appBar: AppBar(
        title: const Text('ארוחה מרובת מתכונים'),
        centerTitle: true,
      ),
      body: _buildBody(allRecipes, ownRecipes, publicOthers),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _selectedIds.length >= 2
            ? () => _startSession(allRecipes)
            : null,
        icon: const Icon(Icons.restaurant),
        label: Text(
          _selectedIds.length >= 2
              ? 'התחל לבשל! (${_selectedIds.length})'
              : 'בחר לפחות 2 מתכונים',
        ),
        backgroundColor: _selectedIds.length >= 2 ? null : Colors.grey,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildBody(
    List<RecipeModel> allRecipes,
    List<RecipeModel> ownRecipes,
    List<RecipeModel> publicOthers,
  ) {
    bool matchesSearch(RecipeModel r) =>
        _search.isEmpty ||
        r.title.contains(_search) ||
        r.tags.any((t) => t.contains(_search));

    final filteredOwn = ownRecipes.where(matchesSearch).toList();
    final filteredPublic = publicOthers.where(matchesSearch).toList();

    return CustomScrollView(
      slivers: [
        // ── Search + recipe selection ──────────────────────────────────────
        SliverToBoxAdapter(child: _sectionHeader('בחר מתכונים (2–5)')),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'חפש מתכון...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                isDense: true,
              ),
              onChanged: (v) => setState(() => _search = v),
            ),
          ),
        ),

        // ── Own recipes sub-section ────────────────────────────────────────
        SliverToBoxAdapter(child: _subSectionHeader('המתכונים שלי')),
        if (filteredOwn.isEmpty)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text('אין מתכונים'),
            ),
          )
        else
          SliverList.builder(
            itemCount: filteredOwn.length,
            itemBuilder: (ctx, i) => _recipeCheckbox(filteredOwn[i]),
          ),

        // ── Public recipes sub-section ─────────────────────────────────────
        if (publicOthers.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: _subSectionHeader('מתכונים משותפים', icon: Icons.public),
          ),
          SliverList.builder(
            itemCount: filteredPublic.length,
            itemBuilder: (ctx, i) =>
                _recipeCheckbox(filteredPublic[i], isPublic: true),
          ),
        ],

        // ── Target ready time ──────────────────────────────────────────────
        SliverToBoxAdapter(child: _sectionHeader('שעת הגשה (אופציונלי)')),
        SliverToBoxAdapter(
          child: ListTile(
            leading: const Icon(Icons.access_time),
            title: Text(_targetTime == null
                ? 'לא נקבע'
                : 'הגשה עד ${_targetTime!.hour.toString().padLeft(2, '0')}:${_targetTime!.minute.toString().padLeft(2, '0')}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(onPressed: _pickTime, child: const Text('בחר')),
                if (_targetTime != null)
                  TextButton(
                    onPressed: () => setState(() => _targetTime = null),
                    child: const Text('נקה'),
                  ),
              ],
            ),
          ),
        ),

        // ── Suggested start order ──────────────────────────────────────────
        if (_selectedIds.length >= 2) ...[
          SliverToBoxAdapter(
            child: _sectionHeader('סדר התחלה מוצע'),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'המתכון הארוך ביותר מתחיל ראשון',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          SliverList.builder(
            itemCount: _schedule(allRecipes).length,
            itemBuilder: (ctx, i) {
              final s = _schedule(allRecipes)[i];
              final offset = s.startOffset;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: kPlannerRecipeColors[i % kPlannerRecipeColors.length]
                      .withAlpha(200),
                  child: Text('${i + 1}',
                      style: const TextStyle(color: Colors.white)),
                ),
                title: Text(s.recipe.title),
                subtitle: Text('${s.recipe.totalTimeMinutes} דקות'),
                trailing: offset.inMinutes > 0
                    ? Text(
                        'מתחיל אחרי ${offset.inMinutes} ד\'',
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    : const Text('מתחיל ראשון'),
              );
            },
          ),
        ],

        // ── Mise en place ──────────────────────────────────────────────────
        if (_selectedIds.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: _sectionHeader('הכנה מוקדמת (מיז אן פלאס)'),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'כל הרכיבים שצריך להכין לפני שמדליקים כיריים',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          SliverList.builder(
            itemCount: _mise(allRecipes).length,
            itemBuilder: (ctx, i) {
              final item = _mise(allRecipes)[i];
              final qty = item.quantity % 1 == 0
                  ? item.quantity.toInt().toString()
                  : item.quantity.toStringAsFixed(1);
              final unit =
                  item.unit == UnitType.none ? '' : ' ${item.unit.displayLabel}';
              return ListTile(
                dense: true,
                leading: const Icon(Icons.check_box_outline_blank, size: 20),
                title: Text('$qty$unit ${item.name}'),
                subtitle: item.prepNote != null ? Text(item.prepNote!) : null,
              );
            },
          ),
        ],

        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _recipeCheckbox(RecipeModel r, {bool isPublic = false}) {
    final selected = _selectedIds.contains(r.id);
    final canAdd = _selectedIds.length < 5 || selected;
    return CheckboxListTile.adaptive(
      value: selected,
      onChanged: canAdd
          ? (v) => setState(() {
                if (v == true) {
                  _selectedIds.add(r.id);
                } else {
                  _selectedIds.remove(r.id);
                }
              })
          : null,
      title: Text(r.title),
      subtitle: Text(
        '${r.totalTimeMinutes} דקות'
        '${r.activeTimeMinutes != r.totalTimeMinutes ? ' (${r.activeTimeMinutes} פעיל)' : ''}',
      ),
      secondary: isPublic
          ? const Icon(Icons.public, size: 28)
          : r.imageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(r.imageUrl!,
                      width: 48, height: 48, fit: BoxFit.cover),
                )
              : null,
    );
  }

  Widget _sectionHeader(String title) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
        child: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      );

  Widget _subSectionHeader(String title, {IconData? icon}) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: Row(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 6),
              Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
            ],
          ],
        ),
      );
}
