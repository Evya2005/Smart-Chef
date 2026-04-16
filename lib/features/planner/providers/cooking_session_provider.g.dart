// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cooking_session_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CookingSessionNotifier)
final cookingSessionProvider = CookingSessionNotifierProvider._();

final class CookingSessionNotifierProvider
    extends $NotifierProvider<CookingSessionNotifier, CookingSessionState> {
  CookingSessionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cookingSessionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cookingSessionNotifierHash();

  @$internal
  @override
  CookingSessionNotifier create() => CookingSessionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CookingSessionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CookingSessionState>(value),
    );
  }
}

String _$cookingSessionNotifierHash() =>
    r'b620a32c69c71e77c34eee14f945bc9b313b7c14';

abstract class _$CookingSessionNotifier extends $Notifier<CookingSessionState> {
  CookingSessionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<CookingSessionState, CookingSessionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CookingSessionState, CookingSessionState>,
              CookingSessionState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(cookingSessionList)
final cookingSessionListProvider = CookingSessionListProvider._();

final class CookingSessionListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CookingSessionModel>>,
          List<CookingSessionModel>,
          Stream<List<CookingSessionModel>>
        >
    with
        $FutureModifier<List<CookingSessionModel>>,
        $StreamProvider<List<CookingSessionModel>> {
  CookingSessionListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cookingSessionListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cookingSessionListHash();

  @$internal
  @override
  $StreamProviderElement<List<CookingSessionModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<CookingSessionModel>> create(Ref ref) {
    return cookingSessionList(ref);
  }
}

String _$cookingSessionListHash() =>
    r'b0827a17e531972d734ecbacce28e6230c4dcf96';
