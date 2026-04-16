// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovery_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DiscoveryNotifier)
final discoveryProvider = DiscoveryNotifierProvider._();

final class DiscoveryNotifierProvider
    extends $NotifierProvider<DiscoveryNotifier, DiscoveryState> {
  DiscoveryNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'discoveryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$discoveryNotifierHash();

  @$internal
  @override
  DiscoveryNotifier create() => DiscoveryNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiscoveryState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiscoveryState>(value),
    );
  }
}

String _$discoveryNotifierHash() => r'2956de1a231cb5b4a3d19f9437b8d7daf4136995';

abstract class _$DiscoveryNotifier extends $Notifier<DiscoveryState> {
  DiscoveryState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DiscoveryState, DiscoveryState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DiscoveryState, DiscoveryState>,
              DiscoveryState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
