// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'substitution_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SubstitutionNotifier)
final substitutionProvider = SubstitutionNotifierProvider._();

final class SubstitutionNotifierProvider
    extends $NotifierProvider<SubstitutionNotifier, SubstitutionState> {
  SubstitutionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'substitutionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$substitutionNotifierHash();

  @$internal
  @override
  SubstitutionNotifier create() => SubstitutionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SubstitutionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SubstitutionState>(value),
    );
  }
}

String _$substitutionNotifierHash() =>
    r'f19ac00f5496bc0f614a83fe4713042b5e37f3ea';

abstract class _$SubstitutionNotifier extends $Notifier<SubstitutionState> {
  SubstitutionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SubstitutionState, SubstitutionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SubstitutionState, SubstitutionState>,
              SubstitutionState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
