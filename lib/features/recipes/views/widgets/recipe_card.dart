import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../features/auth/repositories/auth_repository.dart';
import '../../../../features/settings/providers/user_settings_provider.dart';
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Heart + lock/globe column (start = right in RTL) ────
            if (isOwnedByCurrentUser) ...[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _StatusButton(
                    active: recipe.isFavorite,
                    activeColor: AppColors.terracottaSoft,
                    child: Icon(
                      recipe.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 16,
                      color: recipe.isFavorite
                          ? AppColors.terracotta
                          : AppColors.ink3,
                    ),
                    onTap: () {
                      final uid = ref
                          .read(authRepositoryProvider)
                          .currentUser
                          ?.uid;
                      if (uid != null) {
                        ref.read(recipeRepositoryProvider).toggleFavorite(
                            uid, recipe.id, !recipe.isFavorite);
                      }
                    },
                  ),
                  const Gap(6),
                  _StatusButton(
                    active: recipe.isPublic,
                    activeColor: AppColors.terracottaSoft,
                    child: Icon(
                      recipe.isPublic
                          ? Icons.public
                          : Icons.lock_outline,
                      size: 16,
                      color: recipe.isPublic
                          ? AppColors.terracotta
                          : AppColors.ink3,
                    ),
                    onTap: () {
                      final uid = ref
                          .read(authRepositoryProvider)
                          .currentUser
                          ?.uid;
                      if (uid != null) {
                        ref.read(recipeRepositoryProvider).togglePublic(
                            uid, recipe.id, !recipe.isPublic);
                      }
                    },
                  ),
                ],
              ),
              const Gap(12),
            ],
            // ── Thumbnail ────────────────────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 78,
                height: 78,
                child: recipe.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: recipe.imageUrl!,
                        fit: BoxFit.cover,
                        errorWidget: (_, _, _) => _ThumbPlaceholder(),
                      )
                    : _ThumbPlaceholder(),
              ),
            ),
            const Gap(12),
            // ── Text area ─────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    recipe.title,
                    style: GoogleFonts.sourceSerif4(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.ink,
                      height: 1.25,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (recipe.rating > 0) ...[
                    const Gap(6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < recipe.rating ? Icons.star : Icons.star_border,
                          size: 11,
                          color: i < recipe.rating
                              ? AppColors.starGold
                              : AppColors.ink3,
                        ),
                      ),
                    ),
                  ],
                  const Gap(6),
                  Row(
                    children: [
                      Icon(Icons.timer_outlined,
                          size: 11, color: AppColors.ink2),
                      const Gap(3),
                      Flexible(
                        child: Text(
                          '${recipe.activeTimeMinutes} ד׳ פעיל · ${recipe.totalTimeMinutes} ד׳ סה״כ',
                          style: GoogleFonts.assistant(
                            fontSize: 11,
                            color: AppColors.ink2,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (!isOwnedByCurrentUser && recipe.isPublic) ...[
                    const Gap(4),
                    _OwnerLabel(recipe: recipe),
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

/// Shows "מאת: <username>" for a shared recipe.
/// Falls back to fetching from user_profiles if ownerEmail is not stored on the recipe.
class _OwnerLabel extends ConsumerWidget {
  const _OwnerLabel({required this.recipe});
  final RecipeModel recipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = recipe.ownerEmail ??
        ref.watch(ownerEmailProvider(recipe.userId)).asData?.value;
    final label = email != null ? 'מאת: ${email.split('@')[0]}' : 'משותף';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.sageSoft,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.assistant(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppColors.sage,
        ),
      ),
    );
  }
}

class _StatusButton extends StatelessWidget {
  const _StatusButton({
    required this.active,
    required this.activeColor,
    required this.child,
    required this.onTap,
  });

  final bool active;
  final Color activeColor;
  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: active ? activeColor : AppColors.sand,
          shape: BoxShape.circle,
        ),
        child: Center(child: child),
      ),
    );
  }
}

class _ThumbPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.sand,
      child: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 52,
          height: 52,
          color: AppColors.terracotta.withOpacity(0.60),
          colorBlendMode: BlendMode.srcIn,
        ),
      ),
    );
  }
}
