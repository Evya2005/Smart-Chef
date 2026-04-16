// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planner_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(plannerRepository)
final plannerRepositoryProvider = PlannerRepositoryProvider._();

final class PlannerRepositoryProvider
    extends
        $FunctionalProvider<
          PlannerRepository,
          PlannerRepository,
          PlannerRepository
        >
    with $Provider<PlannerRepository> {
  PlannerRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plannerRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plannerRepositoryHash();

  @$internal
  @override
  $ProviderElement<PlannerRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PlannerRepository create(Ref ref) {
    return plannerRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlannerRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlannerRepository>(value),
    );
  }
}

String _$plannerRepositoryHash() => r'bacc8faefee7c8b9871aa242a2c217162aa7179a';
