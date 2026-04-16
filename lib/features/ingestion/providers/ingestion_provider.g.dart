// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingestion_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(IngestionNotifier)
final ingestionProvider = IngestionNotifierProvider._();

final class IngestionNotifierProvider
    extends $NotifierProvider<IngestionNotifier, IngestionState> {
  IngestionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ingestionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ingestionNotifierHash();

  @$internal
  @override
  IngestionNotifier create() => IngestionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IngestionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IngestionState>(value),
    );
  }
}

String _$ingestionNotifierHash() => r'b8326e34b5ff1f67684c117ee25097f9e02a7616';

abstract class _$IngestionNotifier extends $Notifier<IngestionState> {
  IngestionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<IngestionState, IngestionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<IngestionState, IngestionState>,
              IngestionState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
