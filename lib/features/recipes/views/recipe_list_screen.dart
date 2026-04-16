import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';

import '../../../features/auth/repositories/auth_repository.dart';
import '../../../shared/widgets/error_card.dart';
import '../providers/recipe_filter_provider.dart';
import '../providers/recipe_list_provider.dart';
import 'widgets/category_chip_bar.dart';
import 'widgets/filter_drawer.dart';
import 'widgets/recipe_card.dart';

class RecipeListScreen extends ConsumerStatefulWidget {
  const RecipeListScreen({super.key});

  @override
  ConsumerState<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends ConsumerState<RecipeListScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scrollController = ScrollController();
  bool _fabExpanded = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipesAsync = ref.watch(recipeListProvider);
    final publicAsync = ref.watch(publicRecipesProvider);
    final currentUid =
        ref.watch(authRepositoryProvider).currentUser?.uid;

    ref.listen(
      recipeFilterProvider.select((f) => f.activeCategory),
      (_, __) => _scrollToTop(),
    );

    final filtered = ref.watch(filteredRecipesProvider);
    final filter = ref.watch(recipeFilterProvider);
    final notifier = ref.read(recipeFilterProvider.notifier);

    return Scaffold(
      key: _scaffoldKey,
      endDrawer:
          FilterDrawer(filter: filter, notifier: notifier, scaffoldKey: _scaffoldKey),
      appBar: AppBar(
        title: const Text('שף חכם'),
        actions: [
          Badge(
            isLabelVisible: filter.activeFilterCount > 0,
            label: Text('${filter.activeFilterCount}'),
            child: IconButton(
              icon: const Icon(Icons.tune),
              tooltip: 'סינון מתקדם',
              onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'הגדרות',
            onPressed: () => context.push('/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'יציאה',
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
          ),
        ],
      ),
      body: Column(
        children: [
          _SearchBar(
            query: filter.query,
            onChanged: notifier.setQuery,
            onClear: () => notifier.setQuery(''),
          ),
          const CategoryChipBar(),
          const Divider(height: 1),
          Expanded(
            child: recipesAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: ErrorCard(message: e.toString()),
                ),
              ),
              data: (_) {
                final totalCount = (recipesAsync.value?.length ?? 0) +
                    (publicAsync.asData?.value.length ?? 0);
                final filteredList = filtered ?? [];

                if (totalCount == 0) {
                  return _EmptyState(onAddTap: () => context.push('/ingest'));
                }

                if (filteredList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.search_off, size: 48),
                        const Gap(12),
                        const Text('לא נמצאו מתכונים תואמים'),
                        TextButton(
                          onPressed: notifier.clearAll,
                          child: const Text('נקה חיפוש'),
                        ),
                      ],
                    ),
                  );
                }

                return CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      sliver: SliverList.separated(
                        itemCount: filteredList.length,
                        separatorBuilder: (_, __) => const Gap(12),
                        itemBuilder: (context, i) {
                          final recipe = filteredList[i];
                          return RecipeCard(
                            recipe: recipe,
                            isOwnedByCurrentUser: recipe.userId == currentUid,
                            onTap: () =>
                                context.push('/recipes/${recipe.id}'),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _fabExpanded
          ? _SpeedDialFab(
              onCollapse: () => setState(() => _fabExpanded = false),
              onIngest: () {
                setState(() => _fabExpanded = false);
                context.push('/ingest');
              },
              onDiscover: () {
                setState(() => _fabExpanded = false);
                context.push('/discover');
              },
            )
          : FloatingActionButton.extended(
              onPressed: () => setState(() => _fabExpanded = true),
              icon: const Icon(Icons.add),
              label: const Text('הוסף מתכון'),
            ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  const _SearchBar({
    required this.query,
    required this.onChanged,
    required this.onClear,
  });

  final String query;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.query);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: SearchBar(
        controller: _controller,
        autoFocus: false,
        textInputAction: TextInputAction.search,
        hintText: 'שם מתכון או מרכיב...',
        leading: const Icon(Icons.search),
        trailing: widget.query.isNotEmpty
            ? [
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    widget.onClear();
                  },
                ),
              ]
            : null,
        onChanged: widget.onChanged,
      ),
    );
  }
}

class _SpeedDialFab extends StatelessWidget {
  const _SpeedDialFab({
    required this.onCollapse,
    required this.onIngest,
    required this.onDiscover,
  });

  final VoidCallback onCollapse;
  final VoidCallback onIngest;
  final VoidCallback onDiscover;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FloatingActionButton.small(
          heroTag: 'fab_discover',
          onPressed: onDiscover,
          tooltip: 'סל גילוי',
          child: const Icon(Icons.shopping_basket_outlined),
        ),
        const Gap(8),
        FloatingActionButton.extended(
          heroTag: 'fab_ingest',
          onPressed: onIngest,
          icon: const Icon(Icons.upload_outlined),
          label: const Text('ייבא מתכון'),
        ),
        const Gap(8),
        FloatingActionButton(
          heroTag: 'fab_close',
          onPressed: onCollapse,
          child: const Icon(Icons.close),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAddTap});
  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.primary.withAlpha(100),
            ),
            const Gap(24),
            Text(
              'ספר הבישול שלך ריק',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const Gap(8),
            Text(
              'הוסף את המתכון הראשון שלך מתמונה, PDF, קישור או טקסט חופשי.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const Gap(32),
            FilledButton.icon(
              onPressed: onAddTap,
              icon: const Icon(Icons.add),
              label: const Text('הוסף מתכון ראשון'),
            ),
          ],
        ),
      ),
    );
  }
}
