import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../features/auth/repositories/auth_repository.dart';
import '../../models/recipe_model.dart';
import '../../repositories/recipe_repository.dart';

class RecipeCard extends ConsumerWidget {
  const RecipeCard({
    super.key,
    required this.recipe,
    this.onTap,
    this.isOwnedByCurrentUser = true,
  });

  final RecipeModel recipe;
  final VoidCallback? onTap;
  final bool isOwnedByCurrentUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (recipe.imageUrl != null)
                  Image.network(
                    recipe.imageUrl!,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox(
                      height: 160,
                      child: Center(child: Icon(Icons.broken_image, size: 48)),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              recipe.title,
                              style: textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!isOwnedByCurrentUser && recipe.isPublic)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'משותף',
                                style: textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSecondaryContainer,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const Gap(8),
                      Row(
                        children: [
                          const Icon(Icons.timer_outlined, size: 16),
                          const Gap(4),
                          Text(
                            '${recipe.activeTimeMinutes} ד׳ פעיל',
                            style: textTheme.bodySmall,
                          ),
                          const Gap(16),
                          const Icon(Icons.schedule_outlined, size: 16),
                          const Gap(4),
                          Text(
                            '${recipe.totalTimeMinutes} ד׳ סה״כ',
                            style: textTheme.bodySmall,
                          ),
                        ],
                      ),
                      if (recipe.rating > 0) ...[
                        const Gap(4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            5,
                            (i) => Icon(
                              i < recipe.rating
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 14,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (isOwnedByCurrentUser)
              Positioned(
                top: 8,
                left: 8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _FavoriteButton(recipe: recipe, ref: ref),
                    const Gap(4),
                    Material(
                      color: Colors.black26,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          final uid = ref
                              .read(authRepositoryProvider)
                              .currentUser
                              ?.uid;
                          if (uid != null) {
                            ref
                                .read(recipeRepositoryProvider)
                                .togglePublic(
                                  uid,
                                  recipe.id,
                                  !recipe.isPublic,
                                );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            recipe.isPublic
                                ? Icons.public
                                : Icons.lock_outline,
                            size: 20,
                            color: recipe.isPublic
                                ? Colors.lightGreenAccent
                                : Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.recipe, required this.ref});

  final RecipeModel recipe;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black26,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          final uid =
              ref.read(authRepositoryProvider).currentUser?.uid;
          if (uid != null) {
            ref
                .read(recipeRepositoryProvider)
                .toggleFavorite(uid, recipe.id, !recipe.isFavorite);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(
            recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
            size: 20,
            color: recipe.isFavorite ? Colors.red : Colors.white,
          ),
        ),
      ),
    );
  }
}
