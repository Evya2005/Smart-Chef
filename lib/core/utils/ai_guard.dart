import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/providers/auth_provider.dart';
import '../../features/settings/providers/user_settings_provider.dart';

/// Returns true if the user has a Gemini API key set.
/// If not, shows a dialog offering to navigate to /settings.
/// Shows a SnackBar error (and returns false) when the key could not be fetched.
Future<bool> requireAiKey(BuildContext context, WidgetRef ref) async {
  // Fast path: key already cached
  if (ref.read(geminiApiKeyProvider).asData?.value?.isNotEmpty == true) return true;

  // Ensure auth has settled so geminiApiKeyProvider uses the real uid.
  // Failure here is non-fatal — we still attempt to read the key below.
  try {
    await ref
        .read(authStateProvider.future)
        .timeout(const Duration(seconds: 10));
  } catch (_) {
    // Auth timed out or errored — fall through and try the key anyway.
  }

  if (!context.mounted) return false;

  // Fast path again after auth settled
  if (ref.read(geminiApiKeyProvider).asData?.value?.isNotEmpty == true) return true;

  // Wait for Firestore to emit the key.
  //
  // We use listenManual instead of .future because geminiApiKeyProvider
  // rebuilds whenever authStateProvider emits (ref.watch inside it).
  // A provider rebuild cancels any pending .future with a disposal error,
  // causing the catch block to see AsyncLoading and show a spurious SnackBar.
  // listenManual stays alive through rebuilds and waits for the next AsyncData.
  final completer = Completer<String?>();
  final sub = ref.listenManual(
    geminiApiKeyProvider,
    (_, next) {
      if (completer.isCompleted) return;
      if (next.asData != null) {
        completer.complete(next.asData!.value);
      } else if (next is AsyncError) {
        completer.completeError(next.error!, next.stackTrace);
      }
      // AsyncLoading → provider is rebuilding; keep waiting silently.
    },
    fireImmediately: true,
  );

  String? key;
  try {
    key = await completer.future.timeout(const Duration(seconds: 15));
  } catch (_) {
    sub.close();
    if (!context.mounted) return false;
    _showFetchError(context);
    return false;
  }
  sub.close();

  if (key != null && key.isNotEmpty) return true;

  // key is null/empty → definitively missing → show dialog
  if (!context.mounted) return false;
  final goTo = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('נדרש מפתח Gemini API'),
      content: const Text(
        'כדי להשתמש בתכונות AI, יש להגדיר מפתח Gemini API בהגדרות.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('ביטול'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('עבור להגדרות'),
        ),
      ],
    ),
  );
  if (goTo == true && context.mounted) context.push('/settings');
  return false;
}

void _showFetchError(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('שגיאה בטעינת הגדרות. אנא בדוק חיבור לאינטרנט ונסה שוב.')),
  );
}
