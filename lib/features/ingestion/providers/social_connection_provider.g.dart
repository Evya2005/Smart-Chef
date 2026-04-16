// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_connection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SocialConnectionNotifier)
final socialConnectionProvider = SocialConnectionNotifierProvider._();

final class SocialConnectionNotifierProvider
    extends
        $NotifierProvider<SocialConnectionNotifier, SocialConnectionStatus> {
  SocialConnectionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'socialConnectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$socialConnectionNotifierHash();

  @$internal
  @override
  SocialConnectionNotifier create() => SocialConnectionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SocialConnectionStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SocialConnectionStatus>(value),
    );
  }
}

String _$socialConnectionNotifierHash() =>
    r'b76bff5695f0f5f994afd13fb622e2b8581ec9b4';

abstract class _$SocialConnectionNotifier
    extends $Notifier<SocialConnectionStatus> {
  SocialConnectionStatus build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<SocialConnectionStatus, SocialConnectionStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SocialConnectionStatus, SocialConnectionStatus>,
              SocialConnectionStatus,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
