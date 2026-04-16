// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_intent_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ShareIntentNotifier)
final shareIntentProvider = ShareIntentNotifierProvider._();

final class ShareIntentNotifierProvider
    extends $NotifierProvider<ShareIntentNotifier, SharedPayload?> {
  ShareIntentNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shareIntentProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shareIntentNotifierHash();

  @$internal
  @override
  ShareIntentNotifier create() => ShareIntentNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPayload? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPayload?>(value),
    );
  }
}

String _$shareIntentNotifierHash() =>
    r'38de5730266240b2683e42421a35372725c0d52e';

abstract class _$ShareIntentNotifier extends $Notifier<SharedPayload?> {
  SharedPayload? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SharedPayload?, SharedPayload?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SharedPayload?, SharedPayload?>,
              SharedPayload?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
