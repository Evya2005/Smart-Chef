import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/utils/ai_guard.dart';
import '../../../shared/widgets/error_card.dart';
import '../../../shared/widgets/tag_chip.dart';
import '../../../features/auth/repositories/auth_repository.dart';
import '../providers/cook_mode_provider.dart';
import '../providers/recipe_detail_provider.dart';
import '../providers/scaling_provider.dart';
import '../repositories/recipe_repository.dart';
import '../services/recipe_card_service.dart';
import 'widgets/cook_step_cook_tile.dart';
import 'widgets/ingredient_tile.dart';
import 'widgets/serving_scaler.dart';
import 'widgets/step_tile.dart';
import 'widgets/shopping_list_bottom_sheet.dart';
import 'widgets/substitution_bottom_sheet.dart';

class RecipeDetailScreen extends ConsumerStatefulWidget {
  const RecipeDetailScreen({super.key, required this.recipeId});

  final String recipeId;

  @override
  ConsumerState<RecipeDetailScreen> createState() =>
      _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends ConsumerState<RecipeDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool? _prevIsCooking;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String get recipeId => widget.recipeId;

  @override
  Widget build(BuildContext context) {
    final recipeAsync = ref.watch(recipeDetailProvider(recipeId));
    final scaledAsync = ref.watch(scaledIngredientsProvider(recipeId));
    final servingCount = ref.watch(servingCountProvider(recipeId));
    final currentUid =
        ref.read(authRepositoryProvider).currentUser?.uid;

    return recipeAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ErrorCard(message: e.toString()),
          ),
        ),
      ),
      data: (recipe) {
        final isOwner = recipe.userId == currentUid;
        final isCooking = ref.watch(cookModeActiveProvider);
        final cookState = ref.watch(cookModeProvider);
        final notifier = ref.read(cookModeProvider.notifier);
        final cookModeActiveNotifier =
            ref.read(cookModeActiveProvider.notifier);
        final ingredients = scaledAsync.value ?? recipe.ingredients;
        final colorScheme = Theme.of(context).colorScheme;

        final progressValue = recipe.steps.isEmpty
            ? 0.0
            : cookState.checkedCount / recipe.steps.length;

        // Scroll to top whenever cook mode is toggled
        if (_prevIsCooking != null && _prevIsCooking != isCooking) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.jumpTo(0);
            }
          });
        }
        _prevIsCooking = isCooking;

        void exitCookMode() {
          notifier.init([]);
          cookModeActiveNotifier.setActive(false);
        }

        return Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: isCooking
                ? FilledButton.icon(
                    onPressed: exitCookMode,
                    icon: const Icon(Icons.stop_circle_outlined),
                    label: const Text('סיים בישול'),
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.error,
                    ),
                  )
                : FilledButton.icon(
                    onPressed: () {
                      notifier.init(recipe.steps);
                      cookModeActiveNotifier.setActive(true);
                    },
                    icon: const Icon(Icons.restaurant_menu),
                    label: const Text('התחל בישול'),
                  ),
          ),
          body: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight:
                    (!isCooking && recipe.imageUrl != null) ? 240 : 0,
                pinned: true,
                leading: isCooking
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: exitCookMode,
                      )
                    : null,
                title: (isCooking || recipe.imageUrl == null)
                    ? Text(recipe.title)
                    : null,
                actions: isCooking
                    ? null
                    : isOwner
                        ? [
                            IconButton(
                              icon: Icon(recipe.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border),
                              color: recipe.isFavorite ? Colors.red : null,
                              tooltip: recipe.isFavorite
                                  ? 'הסר ממועדפים'
                                  : 'הוסף למועדפים',
                              onPressed: () {
                                final uid = ref
                                    .read(authRepositoryProvider)
                                    .currentUser
                                    ?.uid;
                                if (uid != null) {
                                  ref
                                      .read(recipeRepositoryProvider)
                                      .toggleFavorite(
                                          uid, recipeId, !recipe.isFavorite);
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(recipe.isPublic
                                  ? Icons.public
                                  : Icons.lock_outline),
                              color: recipe.isPublic
                                  ? colorScheme.primary
                                  : null,
                              tooltip: recipe.isPublic
                                  ? 'הפוך לפרטי'
                                  : 'שתף עם כולם',
                              onPressed: () async {
                                final uid = ref
                                    .read(authRepositoryProvider)
                                    .currentUser
                                    ?.uid;
                                if (uid != null) {
                                  await ref
                                      .read(recipeRepositoryProvider)
                                      .togglePublic(
                                          uid, recipeId, !recipe.isPublic);
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined),
                              tooltip: 'עריכה',
                              onPressed: () =>
                                  context.push('/recipes/$recipeId/edit'),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) async {
                                if (value == 'share') {
                                  final authorName = FirebaseAuth
                                      .instance.currentUser?.displayName;
                                  const svc = RecipeCardService();
                                  final card = svc.generateCard(
                                    recipe,
                                    authorName: authorName,
                                  );
                                  await Share.share(
                                    card,
                                    subject: recipe.title,
                                  );
                                } else if (value == 'versions') {
                                  context.push(
                                      '/recipes/$recipeId/versions');
                                } else if (value == 'fork') {
                                  final uid = ref
                                      .read(authRepositoryProvider)
                                      .currentUser
                                      ?.uid;
                                  if (uid != null) {
                                    final newId = await ref
                                        .read(recipeRepositoryProvider)
                                        .forkRecipe(uid, recipe);
                                    if (context.mounted) {
                                      context.push('/recipes/$newId');
                                    }
                                  }
                                } else if (value == 'delete') {
                                  final confirm =
                                      await _confirmDelete(context);
                                  if (confirm == true && context.mounted) {
                                    final uid = ref
                                        .read(authRepositoryProvider)
                                        .currentUser
                                        ?.uid;
                                    if (uid != null) {
                                      await ref
                                          .read(recipeRepositoryProvider)
                                          .deleteRecipe(uid, recipeId);
                                    }
                                    if (context.mounted) context.pop();
                                  }
                                }
                              },
                              itemBuilder: (_) => [
                                const PopupMenuItem(
                                  value: 'versions',
                                  child: Row(
                                    children: [
                                      Icon(Icons.history),
                                      Gap(8),
                                      Text('היסטוריית גרסאות'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'fork',
                                  child: Row(
                                    children: [
                                      Icon(Icons.fork_right),
                                      Gap(8),
                                      Text('צור עותק'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'share',
                                  child: Row(
                                    children: [
                                      Icon(Icons.share_outlined),
                                      Gap(8),
                                      Text('שתף מתכון'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete_outline,
                                          color: Colors.red),
                                      Gap(8),
                                      Text('מחיקה',
                                          style: TextStyle(
                                              color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ]
                        : [
                            // Viewer controls — fork only
                            IconButton(
                              icon: const Icon(Icons.fork_right),
                              tooltip: 'צור עותק',
                              onPressed: () async {
                                final uid = ref
                                    .read(authRepositoryProvider)
                                    .currentUser
                                    ?.uid;
                                if (uid != null) {
                                  final newId = await ref
                                      .read(recipeRepositoryProvider)
                                      .forkRecipe(uid, recipe);
                                  if (context.mounted) {
                                    context.push('/recipes/$newId');
                                  }
                                }
                              },
                            ),
                          ],
                bottom: isCooking
                    ? PreferredSize(
                        preferredSize: const Size.fromHeight(4),
                        child: LinearProgressIndicator(
                            value: progressValue),
                      )
                    : null,
                flexibleSpace: (!isCooking && recipe.imageUrl != null)
                    ? FlexibleSpaceBar(
                        title: Text(
                          recipe.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                  blurRadius: 4, color: Colors.black87),
                            ],
                          ),
                        ),
                        titlePadding: const EdgeInsetsDirectional.only(
                            start: 16, end: 72, bottom: 14),
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              recipe.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const SizedBox.shrink(),
                            ),
                            const DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black54,
                                  ],
                                  stops: [0.5, 1.0],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : null,
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    if (!isCooking) ...[
                      if (!isOwner)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.public,
                                  size: 16,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer),
                              const Gap(8),
                              Text(
                                'מתכון משותף — צור עותק כדי לערוך',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      if (recipe.description != null) ...[
                        Text(
                          recipe.description!,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const Gap(12),
                      ],
                      if (recipe.tags.isNotEmpty)
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: recipe.tags
                              .map((t) => TagChip(label: t))
                              .toList(),
                        ),
                      const Gap(16),
                      Row(
                        children: [
                          _InfoChip(
                            icon: Icons.timer_outlined,
                            label: '${recipe.activeTimeMinutes} ד׳ פעיל',
                          ),
                          const Gap(12),
                          _InfoChip(
                            icon: Icons.schedule_outlined,
                            label:
                                '${recipe.totalTimeMinutes} ד׳ סה״כ',
                          ),
                        ],
                      ),
                      if (isOwner) ...[
                        const Gap(12),
                        Row(
                          children: [
                            Text(
                              'דירוג:',
                              style:
                                  Theme.of(context).textTheme.bodyMedium,
                            ),
                            const Gap(8),
                            ...List.generate(5, (index) {
                              final starNum = index + 1;
                              return GestureDetector(
                                onTap: () {
                                  final uid = ref
                                      .read(authRepositoryProvider)
                                      .currentUser
                                      ?.uid;
                                  if (uid != null) {
                                    ref
                                        .read(recipeRepositoryProvider)
                                        .setRating(
                                            uid, recipeId, starNum);
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 2),
                                  child: Icon(
                                    starNum <= recipe.rating
                                        ? Icons.star
                                        : Icons.star_border,
                                    size: 28,
                                    color: Colors.amber,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ],
                      const Gap(24),
                      Row(
                        children: [
                          Text(
                            'מנות',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          ServingScaler(recipeId: recipeId),
                        ],
                      ),
                      const Gap(16),
                    ],
                    Row(
                      children: [
                        Text(
                          'מצרכים',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          icon: const Icon(
                              Icons.shopping_cart_outlined),
                          label: const Text('רשימת קניות'),
                          onPressed: () =>
                              ShoppingListBottomSheet.show(
                            context,
                            ingredients: ingredients,
                            servings: servingCount,
                            recipeTitle: recipe.title,
                          ),
                        ),
                      ],
                    ),
                    const Gap(8),
                    ...ingredients.asMap().entries.map(
                          (e) => IngredientTile(
                            ingredient: e.value,
                            recipeId: recipeId,
                            index: e.key,
                            showSubstituteButton: !isCooking,
                            onSubstitute: () async {
                              if (!await requireAiKey(context, ref)) return;
                              if (!context.mounted) return;
                              SubstitutionBottomSheet.show(
                                context,
                                recipe: recipe,
                                ingredient: e.value,
                              );
                            },
                          ),
                        ),
                    const Gap(8),
                    if (ingredients.any((i) => i.inferred))
                      Text(
                        '* מצרך שזוהה על ידי AI (לא ברשימה המקורית)',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontStyle: FontStyle.italic),
                      ),
                    const Gap(24),
                    if (!isCooking && recipe.notes != null) ...[
                      Text('הערות',
                          style:
                              Theme.of(context).textTheme.titleMedium),
                      const Gap(4),
                      Text(recipe.notes!,
                          style:
                              Theme.of(context).textTheme.bodyMedium),
                      const Gap(24),
                    ],
                    Text(
                      isCooking ? 'שלבי הכנה' : 'הוראות הכנה',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Gap(8),
                    if (isCooking)
                      ...recipe.steps.asMap().entries.map(
                            (e) => CookStepCookTile(
                              step: e.value,
                              stepIndex: e.key,
                              scaledIngredients: ingredients,
                            ),
                          )
                    else
                      ...recipe.steps.map((s) => StepTile(step: s)),
                    const Gap(32),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('למחוק את המתכון?'),
        content: const Text('לא ניתן לבטל פעולה זו.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('ביטול'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('מחיקה'),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
        const Gap(4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
