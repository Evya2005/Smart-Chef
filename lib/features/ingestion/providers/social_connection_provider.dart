import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'social_connection_provider.g.dart';

// Still used by url_scraper_service.dart detection logic
enum SocialPlatform { facebook, instagram }

class SocialConnectionStatus {
  const SocialConnectionStatus({
    this.facebookAccessToken,
    this.facebookUserName,
    this.isLoading = false,
    this.errorMessage,
  });

  final String? facebookAccessToken;
  final String? facebookUserName;
  final bool isLoading;
  final String? errorMessage;

  bool get isConnected => facebookAccessToken != null;

  SocialConnectionStatus copyWith({
    String? facebookAccessToken,
    bool clearToken = false,
    String? facebookUserName,
    bool clearName = false,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) =>
      SocialConnectionStatus(
        facebookAccessToken:
            clearToken ? null : facebookAccessToken ?? this.facebookAccessToken,
        facebookUserName:
            clearName ? null : facebookUserName ?? this.facebookUserName,
        isLoading: isLoading ?? this.isLoading,
        errorMessage:
            clearError ? null : errorMessage ?? this.errorMessage,
      );
}

@Riverpod(keepAlive: true)
class SocialConnectionNotifier extends _$SocialConnectionNotifier {
  @override
  SocialConnectionStatus build() {
    Future.microtask(_restoreFromCache);
    return const SocialConnectionStatus();
  }

  Future<void> _restoreFromCache() async {
    final token = await FacebookAuth.instance.accessToken;
    if (token == null || state.isConnected) return;
    try {
      final userData = await FacebookAuth.instance.getUserData(fields: 'name');
      final name = (userData['name'] as String?) ?? 'משתמש פייסבוק';
      state = state.copyWith(
        facebookAccessToken: token.tokenString,
        facebookUserName: name,
      );
    } catch (_) {
      // Silently ignore — user can reconnect manually
    }
  }

  Future<void> loginFacebook() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final result = await FacebookAuth.instance
          .login(permissions: ['public_profile']);
      if (result.status == LoginStatus.success) {
        final token = result.accessToken!.tokenString;
        final userData =
            await FacebookAuth.instance.getUserData(fields: 'name');
        final name = (userData['name'] as String?) ?? 'משתמש פייסבוק';
        state = state.copyWith(
          facebookAccessToken: token,
          facebookUserName: name,
          isLoading: false,
        );
      } else if (result.status == LoginStatus.cancelled) {
        state = state.copyWith(isLoading: false);
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: result.message ?? 'שגיאה בהתחברות לפייסבוק.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'שגיאה בהתחברות לפייסבוק: $e',
      );
    }
  }

  Future<void> disconnect() async {
    state = state.copyWith(isLoading: true);
    await FacebookAuth.instance.logOut();
    state = const SocialConnectionStatus();
  }

  void clearError() => state = state.copyWith(clearError: true);
}
