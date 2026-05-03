import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../features/auth/repositories/auth_repository.dart';
import '../../../features/recipes/models/recipe_model.dart';
import '../../../features/recipes/providers/recipe_list_provider.dart';
import '../../../features/recipes/repositories/recipe_repository.dart';
import '../models/cooking_session_model.dart';
import '../providers/cooking_session_provider.dart';

/// Entry point for the Planner tab — shows active session banner,
/// a "Start new session" button, and a list of past sessions.
class PlannerHomeScreen extends ConsumerWidget {
  const PlannerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(cookingSessionListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('מתכנן ארוחות'),
        centerTitle: true,
      ),
      body: sessionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('שגיאה: $e')),
        data: (sessions) => _buildBody(context, sessions),
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<CookingSessionModel> sessions) {
    final active = sessions.where((s) => s.completedAt == null).firstOrNull;

    // All sessions newest-first for the history list (active + completed).
    final history = [...sessions]
      ..sort((a, b) {
        final at = DateTime.tryParse(a.startedAt) ?? DateTime(0);
        final bt = DateTime.tryParse(b.startedAt) ?? DateTime(0);
        return bt.compareTo(at);
      });

    return CustomScrollView(
      slivers: [
        // ── Active session banner ──────────────────────────────────────────
        if (active != null)
          SliverToBoxAdapter(
            child: _ActiveSessionCard(session: active),
          ),

        // ── Start new session button ───────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Icon(
                  Icons.restaurant,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Kitchen Conductor',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'בשל מספר מתכונים במקביל עם לוח בקרה חכם',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(153),
                      ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => context.push('/planner/setup'),
                  icon: const Icon(Icons.add),
                  label: const Text('התחל ארוחה חדשה'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Session history (all sessions, newest first) ───────────────────
        if (history.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text(
                'היסטוריית ארוחות',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          SliverList.builder(
            itemCount: history.length,
            itemBuilder: (ctx, i) => _SessionHistoryTile(
              key: ValueKey(history[i].id),
              session: history[i],
              isActive: history[i].completedAt == null,
            ),
          ),
        ],

        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}

class _ActiveSessionCard extends StatelessWidget {
  const _ActiveSessionCard({required this.session});

  final CookingSessionModel session;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final started = DateTime.tryParse(session.startedAt);
    final label = started != null
        ? 'התחיל ב-${'${started.toLocal().hour.toString().padLeft(2, '0')}:${started.toLocal().minute.toString().padLeft(2, '0')}'}'
        : '';

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      color: cs.primaryContainer,
      child: ListTile(
        leading: Icon(Icons.restaurant_menu, color: cs.primary),
        title: Text(
          'ארוחה בהכנה — ${session.recipeIds.length} מתכונים',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: cs.onPrimaryContainer,
          ),
        ),
        subtitle: Text(
          label,
          style: TextStyle(color: cs.onPrimaryContainer.withAlpha(180)),
        ),
        trailing: FilledButton(
          onPressed: () =>
              context.push('/planner/session/${session.id}'),
          child: const Text('המשך'),
        ),
      ),
    );
  }
}

class _SessionHistoryTile extends ConsumerStatefulWidget {
  const _SessionHistoryTile({
    super.key,
    required this.session,
    required this.isActive,
  });

  final CookingSessionModel session;
  final bool isActive;

  @override
  ConsumerState<_SessionHistoryTile> createState() =>
      _SessionHistoryTileState();
}

class _SessionHistoryTileState extends ConsumerState<_SessionHistoryTile> {
  bool _reactivating = false;

  Future<void> _reactivate(BuildContext context) async {
    setState(() => _reactivating = true);
    try {
      // Read directly from repository to avoid the auto-dispose race on the
      // stream provider (same pattern used in cooking_session_provider).
      final uid = ref.read(authRepositoryProvider).currentUser?.uid;
      if (uid == null) return;

      final ownRecipes = await ref
          .read(recipeRepositoryProvider)
          .watchRecipes(uid)
          .first;
      final recipeRepo = ref.read(recipeRepositoryProvider);
      final recipes = <RecipeModel>[];
      for (final id in widget.session.recipeIds) {
        final own = ownRecipes.where((r) => r.id == id).firstOrNull;
        if (own != null) {
          recipes.add(own);
        } else {
          try {
            recipes.add(await recipeRepo.fetchRecipeWithFallback(uid, id));
          } catch (_) {}
        }
      }

      if (recipes.isEmpty || !context.mounted) return;

      final newId = await ref
          .read(cookingSessionProvider.notifier)
          .createSession(recipes: recipes);
      if (newId != null && context.mounted) {
        context.push('/planner/session/$newId');
      }
    } finally {
      if (mounted) setState(() => _reactivating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final recipesAsync = ref.watch(recipeListProvider);
    final allRecipes = recipesAsync.value;          // null while loading
    final started = DateTime.tryParse(widget.session.startedAt);
    final dateLabel = started != null
        ? '${started.toLocal().day.toString().padLeft(2, '0')}/${started.toLocal().month.toString().padLeft(2, '0')}/${started.toLocal().year}  ${started.toLocal().hour.toString().padLeft(2, '0')}:${started.toLocal().minute.toString().padLeft(2, '0')}'
        : '';

    // Prefer cached names (available immediately); fall back to live lookup.
    final cachedNames = widget.session.recipeNames;
    final recipeNames = cachedNames.isNotEmpty
        ? widget.session.recipeIds
            .map((id) => cachedNames[id] ?? id)
            .toList()
        : (allRecipes == null
            ? null
            : widget.session.recipeIds
                .map((id) =>
                    allRecipes.where((r) => r.id == id).firstOrNull?.title ??
                    id)
                .toList());

    // Status badge widget
    final statusBadge = widget.isActive
        ? Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'פעיל',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: cs.primary,
              ),
            ),
          )
        : const Icon(Icons.check_circle, color: Colors.green, size: 16);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        shape: const Border(),
        leading: Icon(
          widget.isActive ? Icons.restaurant_menu : Icons.history,
          color: widget.isActive ? cs.primary : Colors.grey,
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                '${widget.session.recipeIds.length} מתכונים',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            statusBadge,
          ],
        ),
        subtitle: Text(dateLabel,
            style: Theme.of(context).textTheme.bodySmall),
        children: [
          // Recipe list — show spinner while provider is still loading.
          if (recipeNames == null)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(
                  child: CircularProgressIndicator(strokeWidth: 2)),
            )
          else
            ...recipeNames.map(
              (name) => ListTile(
                dense: true,
                minLeadingWidth: 16,
                leading: const Icon(Icons.restaurant_menu,
                    size: 16, color: Colors.grey),
                title: Text(name),
              ),
            ),
          // Action button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: widget.isActive
                ? FilledButton.icon(
                    icon: const Icon(Icons.play_arrow, size: 18),
                    label: const Text('המשך בישול'),
                    onPressed: () => context
                        .push('/planner/session/${widget.session.id}'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 44),
                    ),
                  )
                : (_reactivating
                    ? const Center(child: CircularProgressIndicator())
                    : OutlinedButton.icon(
                        icon: const Icon(Icons.replay, size: 18),
                        label: const Text('הפעל שוב'),
                        onPressed: () => _reactivate(context),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 44),
                        ),
                      )),
          ),
        ],
      ),
    );
  }
}
