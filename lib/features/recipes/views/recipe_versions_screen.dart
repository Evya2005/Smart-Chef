import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../shared/widgets/error_card.dart';
import '../../auth/repositories/auth_repository.dart';
import '../models/recipe_version_model.dart';
import '../providers/recipe_detail_provider.dart';
import '../providers/recipe_versions_provider.dart';
import '../repositories/recipe_repository.dart';

class RecipeVersionsScreen extends ConsumerWidget {
  const RecipeVersionsScreen({super.key, required this.recipeId});

  final String recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final versionsAsync = ref.watch(recipeVersionsProvider(recipeId));

    return Scaffold(
      appBar: AppBar(title: const Text('היסטוריית גרסאות')),
      body: versionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ErrorCard(message: e.toString()),
          ),
        ),
        data: (versions) {
          if (versions.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.history, size: 48, color: Colors.grey),
                  Gap(12),
                  Text('אין גרסאות שמורות עדיין'),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: versions.length,
            itemBuilder: (context, i) =>
                _VersionTile(version: versions[i], recipeId: recipeId),
          );
        },
      ),
    );
  }
}

class _VersionTile extends ConsumerWidget {
  const _VersionTile(
      {required this.version, required this.recipeId});

  final RecipeVersionModel version;
  final String recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fmt = DateFormat('d/M/y HH:mm');

    return ListTile(
      leading: CircleAvatar(
        child: Text('v${version.versionNumber}'),
      ),
      title: Text('גרסה ${version.versionNumber}'),
      subtitle: Text(fmt.format(version.savedAt)),
      trailing: TextButton(
        child: const Text('שחזר'),
        onPressed: () =>
            _confirmRestore(context, ref),
      ),
      onTap: () => _showSnapshotPreview(context),
    );
  }

  Future<void> _confirmRestore(
      BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('לשחזר גרסה?'),
        content: Text(
            'הגרסה הנוכחית תישמר כגרסה חדשה, ואז המתכון ישוחזר לגרסה ${version.versionNumber}.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('ביטול'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('שחזר'),
          ),
        ],
      ),
    );

    if (confirm != true || !context.mounted) return;

    final uid =
        ref.read(authRepositoryProvider).currentUser?.uid;
    if (uid == null) return;

    // Restore: update recipe with snapshot data, bumping version
    final repo = ref.read(recipeRepositoryProvider);
    final current =
        await ref.read(recipeDetailProvider(recipeId).future);
    // Save current state as a version, then restore snapshot
    await repo.updateRecipe(
      version.snapshot.copyWith(
        id: recipeId,
        userId: uid,
        updatedAt: DateTime.now(),
        version: current.version,
      ),
      changeNote: 'שוחזר מגרסה ${version.versionNumber}',
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('המתכון שוחזר לגרסה ${version.versionNumber}')),
      );
      Navigator.pop(context);
    }
  }

  void _showSnapshotPreview(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'גרסה ${version.versionNumber} — ${version.snapshot.title}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Gap(8),
            Text(
                'מצרכים: ${version.snapshot.ingredients.length} | שלבים: ${version.snapshot.steps.length}'),
            if (version.changeNote != null) ...[
              const Gap(4),
              Text('הערה: ${version.changeNote}'),
            ],
          ],
        ),
      ),
    );
  }
}
