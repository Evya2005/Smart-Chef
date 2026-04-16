// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cooking_session_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(cookingSessionRepository)
final cookingSessionRepositoryProvider = CookingSessionRepositoryProvider._();

final class CookingSessionRepositoryProvider
    extends
        $FunctionalProvider<
          CookingSessionRepository,
          CookingSessionRepository,
          CookingSessionRepository
        >
    with $Provider<CookingSessionRepository> {
  CookingSessionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cookingSessionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cookingSessionRepositoryHash();

  @$internal
  @override
  $ProviderElement<CookingSessionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CookingSessionRepository create(Ref ref) {
    return cookingSessionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CookingSessionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CookingSessionRepository>(value),
    );
  }
}

String _$cookingSessionRepositoryHash() =>
    r'12ac4f9ac7ba17aea3676ffd67422245958c51b5';
