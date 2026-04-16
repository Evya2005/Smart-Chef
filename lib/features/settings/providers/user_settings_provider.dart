import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/providers/auth_provider.dart';
import '../repositories/user_settings_repository.dart';

part 'user_settings_provider.g.dart';

@Riverpod(keepAlive: true)
Stream<String?> geminiApiKey(Ref ref) {
  final authState = ref.watch(authStateProvider);

  // Auth is still loading — keep provider in AsyncLoading so the guard can
  // await correctly instead of seeing an immediately-closed empty stream.
  if (authState.isLoading) {
    final controller = StreamController<String?>();
    ref.onDispose(controller.close);
    return controller.stream;
  }

  final uid = authState.asData?.value?.uid;
  // Not logged in — emit null once so provider settles to AsyncData(null).
  if (uid == null) return Stream.value(null);

  return ref.watch(userSettingsRepositoryProvider).watchApiKey(uid);
}

@riverpod
bool hasGeminiApiKey(Ref ref) =>
    (ref.watch(geminiApiKeyProvider).asData?.value ?? '').isNotEmpty;
