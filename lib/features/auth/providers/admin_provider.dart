import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'auth_provider.dart';

part 'admin_provider.g.dart';

/// Emails unconditionally granted admin privileges.
/// Hardcoded intentionally — no Firestore dependency, cannot be escalated by a DB write.
const _kAdminEmails = {'evya2005@gmail.com'};

/// True when the currently authenticated user is an admin.
/// Recomputes automatically on sign-in / sign-out.
@riverpod
bool isAdmin(Ref ref) {
  final email = ref.watch(authStateProvider).asData?.value?.email;
  if (email == null) return false;
  return _kAdminEmails.contains(email);
}

/// Admin-only toggle. Auto-resets to false when the provider is disposed
/// (i.e., on sign-out, when authStateProvider changes and dependents rebuild).
@riverpod
class GodModeNotifier extends _$GodModeNotifier {
  @override
  bool build() => false;

  void toggle() {
    if (!ref.read(isAdminProvider)) return; // safety guard
    state = !state;
  }
}
