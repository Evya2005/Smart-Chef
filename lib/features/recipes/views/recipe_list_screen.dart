import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/theme/app_colors.dart';
import '../../../features/auth/providers/admin_provider.dart';
import '../../../features/auth/repositories/auth_repository.dart';
import '../../../features/settings/providers/user_settings_provider.dart';
import '../../../shared/widgets/error_card.dart';
import '../models/recipe_model.dart';
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
    final adminAsync = ref.watch(allRecipesAdminProvider);
    final currentUid = ref.watch(authRepositoryProvider).currentUser?.uid;
    final isGodMode = ref.watch(isAdminProvider) && ref.watch(godModeProvider);

    // In god mode use the admin stream's async state for loading/error dispatch.
    final primaryAsync = isGodMode ? adminAsync : recipesAsync;

    ref.listen(
      recipeFilterProvider.select((f) => f.activeCategory),
      (_, _) => _scrollToTop(),
    );

    final filtered = ref.watch(filteredRecipesProvider);
    final filter = ref.watch(recipeFilterProvider);
    final notifier = ref.read(recipeFilterProvider.notifier);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.cream,
      endDrawer:
          FilterDrawer(filter: filter, notifier: notifier, scaffoldKey: _scaffoldKey),
      // ── App bar ───────────────────────────────────────────────────────
      appBar: _buildAppBar(filter, notifier),
      body: Column(
        children: [
          // ── God Mode banner ────────────────────────────────────────
          if (isGodMode)
            Material(
              color: Colors.deepOrange.shade100,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  children: [
                    const Icon(Icons.admin_panel_settings, size: 16),
                    const Gap(8),
                    const Expanded(
                      child: Text(
                        'God Mode פעיל — מציג מתכונים של כל המשתמשים',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // ── Search bar ─────────────────────────────────────────────
          _SearchBar(
            query: filter.query,
            onChanged: notifier.setQuery,
            onClear: () => notifier.setQuery(''),
          ),
          // ── Category chips ─────────────────────────────────────────
          const CategoryChipBar(),
          const Divider(height: 1),
          // ── Recipe list ────────────────────────────────────────────
          Expanded(
            child: primaryAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: ErrorCard(message: e.toString()),
                ),
              ),
              data: (_) {
                // While filteredRecipesProvider is still resolving, show spinner.
                if (filtered == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                final totalCount = isGodMode
                    ? (adminAsync.value?.length ?? 0)
                    : (recipesAsync.value?.length ?? 0) +
                          (publicAsync.asData?.value.length ?? 0);
                final filteredList = filtered;

                if (totalCount == 0) {
                  return _EmptyState(onAddTap: () => context.push('/ingest'));
                }

                if (filteredList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off,
                            size: 48, color: AppColors.ink3),
                        const Gap(12),
                        Text(
                          'לא נמצאו מתכונים תואמים',
                          style: GoogleFonts.assistant(
                              color: AppColors.ink2, fontSize: 15),
                        ),
                        TextButton(
                          onPressed: notifier.clearAll,
                          child: const Text('נקה חיפוש'),
                        ),
                      ],
                    ),
                  );
                }

                // Separate featured (first) from the rest
                final featured = filteredList.first;
                final rest = filteredList.skip(1).toList();

                return CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    // Featured card
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: _FeaturedCard(
                          recipe: featured,
                          isOwned: featured.userId == currentUid,
                          onTap: () {
                            final owner = (isGodMode && featured.userId != currentUid)
                                ? '?owner=${featured.userId}'
                                : '';
                            context.push('/recipes/${featured.id}$owner');
                          },
                        ),
                      ),
                    ),
                    // "כל המתכונים" heading
                    if (rest.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'כל המתכונים',
                                  style: GoogleFonts.sourceSerif4(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.ink,
                                  ),
                                ),
                              ),
                              Text(
                                '${filteredList.length} מתכונים',
                                style: GoogleFonts.assistant(
                                  fontSize: 13,
                                  color: AppColors.ink3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                        sliver: SliverList.separated(
                          itemCount: rest.length,
                          separatorBuilder: (_, _) => const Gap(10),
                          itemBuilder: (context, i) {
                            final recipe = rest[i];
                            final owner = (isGodMode && recipe.userId != currentUid)
                                ? '?owner=${recipe.userId}'
                                : '';
                            return RecipeCard(
                              recipe: recipe,
                              isOwnedByCurrentUser:
                                  recipe.userId == currentUid,
                              onTap: () =>
                                  context.push('/recipes/${recipe.id}$owner'),
                            );
                          },
                        ),
                      ),
                    ] else
                      // Only one recipe total → nothing under featured
                      const SliverToBoxAdapter(child: Gap(120)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/ingest'),
        icon: const Icon(Icons.add),
        label: const Text('הוסף מתכון'),
        backgroundColor: AppColors.terracotta,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  PreferredSizeWidget _buildAppBar(
    RecipeFilter filter,
    RecipeFilterNotifier notifier,
  ) {
    final filterCount = filter.activeFilterCount;
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Image.asset(
          'assets/images/logo.png',
          color: AppColors.terracotta.withOpacity(0.65),
          colorBlendMode: BlendMode.srcIn,
        ),
      ),
      title: Text(
        'שף חכם',
        style: GoogleFonts.sourceSerif4(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: AppColors.ink,
          letterSpacing: -0.3,
        ),
      ),
      centerTitle: true,
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.ink,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: AppColors.line,
        ),
      ),
      actions: [
        // In RTL these appear on the LEFT side of the screen
        IconButton(
          icon: const Icon(Icons.logout, size: 20),
          color: AppColors.ink2,
          tooltip: 'יציאה',
          onPressed: () => ref.read(authRepositoryProvider).signOut(),
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined, size: 20),
          color: AppColors.ink2,
          tooltip: 'הגדרות',
          onPressed: () => context.push('/settings'),
        ),
        Badge(
          isLabelVisible: filterCount > 0,
          label: Text('$filterCount'),
          backgroundColor: AppColors.terracotta,
          child: IconButton(
            icon: const Icon(Icons.tune, size: 20),
            color: AppColors.ink2,
            tooltip: 'סינון מתקדם',
            onPressed: () =>
                _scaffoldKey.currentState!.openEndDrawer(),
          ),
        ),
        const Gap(4),
      ],
    );
  }
}

// ─── Search bar ───────────────────────────────────────────────────────────────

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
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.query);
    _focusNode = FocusNode();
    // Prevent the search bar from stealing focus on initial build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.unfocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: SearchBar(
        controller: _controller,
        focusNode: _focusNode,
        autoFocus: false,
        textInputAction: TextInputAction.search,
        hintText: 'חפש מתכון או מרכיב...',
        leading: const Icon(Icons.search, color: AppColors.ink3, size: 18),
        trailing: widget.query.isNotEmpty
            ? [
                IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  color: AppColors.ink2,
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

// ─── Featured card ────────────────────────────────────────────────────────────

class _FeaturedCard extends ConsumerWidget {
  const _FeaturedCard({
    required this.recipe,
    required this.isOwned,
    required this.onTap,
  });

  final RecipeModel recipe;
  final bool isOwned;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image / placeholder
            SizedBox(
              height: 180,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (recipe.imageUrl != null)
                    CachedNetworkImage(
                      imageUrl: recipe.imageUrl!,
                      fit: BoxFit.cover,
                      errorWidget: (_, _, _) => _ImagePlaceholder(),
                    )
                  else
                    _ImagePlaceholder(),
                  // Heart + lock/globe overlay (RTL: left = content-end)
                  if (isOwned)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _OverlayBadge(
                            child: Icon(
                              recipe.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 16,
                              color: recipe.isFavorite
                                  ? AppColors.terracotta
                                  : AppColors.ink2,
                            ),
                          ),
                          const Gap(8),
                          _OverlayBadge(
                            child: Icon(
                              recipe.isPublic
                                  ? Icons.public
                                  : Icons.lock_outline,
                              size: 16,
                              color: recipe.isPublic
                                  ? AppColors.terracotta
                                  : AppColors.ink3,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            // Info area
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: GoogleFonts.sourceSerif4(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(8),
                  Row(
                    children: [
                      _TimeChip(
                          icon: Icons.timer_outlined,
                          label: '${recipe.activeTimeMinutes} ד׳ פעיל'),
                      const Gap(8),
                      Text('·',
                          style: TextStyle(color: AppColors.ink3)),
                      const Gap(8),
                      _TimeChip(
                          icon: Icons.schedule_outlined,
                          label:
                              '${recipe.totalTimeMinutes} ד׳ סה״כ'),
                    ],
                  ),
                  if (!isOwned) ...[
                    const Gap(8),
                    _FeaturedOwnerLabel(recipe: recipe),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedOwnerLabel extends ConsumerWidget {
  const _FeaturedOwnerLabel({required this.recipe});
  final RecipeModel recipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = recipe.ownerEmail ??
        ref.watch(ownerEmailProvider(recipe.userId)).asData?.value;
    final label = email != null ? 'מאת: ${email.split('@')[0]}' : 'משותף';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.sageSoft,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: GoogleFonts.assistant(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.sage,
        ),
      ),
    );
  }
}

class _OverlayBadge extends StatelessWidget {
  const _OverlayBadge({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(220),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.line),
      ),
      child: Center(child: child),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.sand,
      child: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 90,
          height: 90,
          color: AppColors.terracotta.withOpacity(0.60),
          colorBlendMode: BlendMode.srcIn,
        ),
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  const _TimeChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.ink2),
        const Gap(4),
        Text(
          label,
          style: GoogleFonts.assistant(
            fontSize: 13,
            color: AppColors.ink2,
          ),
        ),
      ],
    );
  }
}

// ─── Empty state ──────────────────────────────────────────────────────────────

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
              color: AppColors.ink3,
            ),
            const Gap(24),
            Text(
              'ספר הבישול שלך ריק',
              style: GoogleFonts.sourceSerif4(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: AppColors.ink,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(8),
            Text(
              'הוסף את המתכון הראשון שלך מתמונה, PDF, קישור או טקסט חופשי.',
              style: GoogleFonts.assistant(
                fontSize: 15,
                color: AppColors.ink2,
                height: 1.55,
              ),
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
