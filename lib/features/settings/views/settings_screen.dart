import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/ai_guard.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../features/auth/repositories/auth_repository.dart';
import '../providers/user_settings_provider.dart';
import '../repositories/user_settings_repository.dart';
import '../../recipes/providers/recipe_categorizer_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(recipeCategorizerProvider);
    final email = ref.watch(authStateProvider).asData?.value?.email;
    final isAdmin = email == 'evya2005@gmail.com';

    return Scaffold(
      appBar: AppBar(title: const Text('הגדרות')),
      body: ListView(
        children: [
          // ─── Gemini API Key ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              'מפתח Gemini AI',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
          _ApiKeyTile(),
          const Divider(),
          // ─── AI Features ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              'בינה מלאכותית',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.category_outlined),
            title: const Text('סיווג מתכונים'),
            subtitle: const Text(
                'מסווג את כל המתכונים לקטגוריות באמצעות AI'),
            trailing: _CategorizerTrailing(status: status, ref: ref),
          ),
          const Divider(),
          if (isAdmin) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text(
                'ניהול מערכת',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('ניהול קטגוריות'),
              subtitle: const Text(
                  'הוסף, מחק וסדר מחדש את קטגוריות המתכונים'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/settings/categories'),
            ),
            const Divider(),
          ],
        ],
      ),
    );
  }
}

class _ApiKeyTile extends ConsumerStatefulWidget {
  @override
  ConsumerState<_ApiKeyTile> createState() => _ApiKeyTileState();
}

class _ApiKeyTileState extends ConsumerState<_ApiKeyTile> {
  bool _helpExpanded = false;

  @override
  Widget build(BuildContext context) {
    final currentKey = ref.watch(geminiApiKeyProvider).asData?.value;
    final hasKey = ref.watch(hasGeminiApiKeyProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(
            hasKey ? Icons.check_circle : Icons.warning_amber_rounded,
            color: hasKey
                ? Colors.green
                : Theme.of(context).colorScheme.error,
          ),
          title: Text(hasKey ? 'מפתח מוגדר' : 'לא הוגדר מפתח'),
          subtitle: Text(
            hasKey
                ? 'כל תכונות ה-AI פעילות'
                : 'נדרש מפתח לייבוא מתכונים, תכנון ארוחות ועוד',
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasKey)
                TextButton(
                  onPressed: () => _clearKey(context),
                  child: const Text('הסר'),
                ),
              FilledButton.tonal(
                onPressed: () => _showSetKeyDialog(context, currentKey),
                child: Text(hasKey ? 'החלף' : 'הגדר מפתח'),
              ),
            ],
          ),
        ),
        // How to get a key — expandable
        InkWell(
          onTap: () => setState(() => _helpExpanded = !_helpExpanded),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(
                  _helpExpanded
                      ? Icons.expand_less
                      : Icons.expand_more,
                  size: 18,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const Gap(4),
                Text(
                  'כיצד לקבל מפתח API?',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
              ],
            ),
          ),
        ),
        if (_helpExpanded)
          const Padding(
            padding:
                EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HelpStep(
                    number: 1,
                    text: 'גש לאתר aistudio.google.com'),
                _HelpStep(
                    number: 2,
                    text: 'התחבר עם חשבון Google'),
                _HelpStep(
                    number: 3,
                    text:
                        'לחץ על "Get API key" ואז "Create API key"'),
                _HelpStep(
                    number: 4,
                    text: 'העתק את המפתח והדבק כאן'),
              ],
            ),
          ),
      ],
    );
  }

  Future<void> _showSetKeyDialog(
      BuildContext context, String? currentKey) async {
    final uid = ref.read(authRepositoryProvider).currentUser?.uid;
    if (uid == null) return;

    // Use a StatefulWidget dialog so the controller lifecycle is managed properly.
    final newKey = await showDialog<String>(
      context: context,
      builder: (ctx) => _ApiKeyDialog(initialKey: currentKey ?? ''),
    );

    if (newKey != null && newKey.isNotEmpty) {
      await ref
          .read(userSettingsRepositoryProvider)
          .saveApiKey(uid, newKey);
    }
  }

  Future<void> _clearKey(BuildContext context) async {
    final uid =
        ref.read(authRepositoryProvider).currentUser?.uid;
    if (uid == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('הסר מפתח API?'),
        content: const Text('תכונות ה-AI לא יהיו זמינות.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('ביטול'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(ctx).colorScheme.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('הסר'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await ref
          .read(userSettingsRepositoryProvider)
          .clearApiKey(uid);
    }
  }
}

/// Dialog that manages its own TextEditingController to avoid dispose-after-use
/// crashes caused by the dialog's close animation running after the controller
/// is manually disposed in an async caller.
class _ApiKeyDialog extends StatefulWidget {
  const _ApiKeyDialog({required this.initialKey});
  final String initialKey;

  @override
  State<_ApiKeyDialog> createState() => _ApiKeyDialogState();
}

class _ApiKeyDialogState extends State<_ApiKeyDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialKey);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('הגדר מפתח Gemini API'),
      content: TextField(
        controller: _controller,
        obscureText: true,
        decoration: const InputDecoration(
          labelText: 'מפתח API',
          hintText: 'AIza...',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('ביטול'),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.pop(context, _controller.text.trim()),
          child: const Text('שמור'),
        ),
      ],
    );
  }
}

class _HelpStep extends StatelessWidget {
  const _HelpStep({required this.number, required this.text});
  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$number',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          const Gap(8),
          Expanded(
            child: Text(text,
                style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}

class _CategorizerTrailing extends StatelessWidget {
  const _CategorizerTrailing({required this.status, required this.ref});

  final CategorizerStatus status;
  final WidgetRef ref;

  Future<void> _run(BuildContext context) async {
    if (!await requireAiKey(context, ref)) return;
    ref.read(recipeCategorizerProvider.notifier).runNow();
  }

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case CategorizerStatus.running:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const Gap(8),
            Text('מסווג...', style: Theme.of(context).textTheme.bodySmall),
          ],
        );
      case CategorizerStatus.error:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline,
                color: Theme.of(context).colorScheme.error, size: 18),
            const Gap(4),
            TextButton(
                onPressed: () => _run(context), child: const Text('נסה שוב')),
          ],
        );
      case CategorizerStatus.idle:
      case CategorizerStatus.done:
        return FilledButton.tonal(
          onPressed: () => _run(context),
          child: const Text('הפעל'),
        );
    }
  }
}
