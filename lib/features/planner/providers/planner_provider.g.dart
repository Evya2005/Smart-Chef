// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planner_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(planList)
final planListProvider = PlanListProvider._();

final class PlanListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DailyPlanModel>>,
          List<DailyPlanModel>,
          Stream<List<DailyPlanModel>>
        >
    with
        $FutureModifier<List<DailyPlanModel>>,
        $StreamProvider<List<DailyPlanModel>> {
  PlanListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'planListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$planListHash();

  @$internal
  @override
  $StreamProviderElement<List<DailyPlanModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<DailyPlanModel>> create(Ref ref) {
    return planList(ref);
  }
}

String _$planListHash() => r'bcabf26d0ace83a2c53ce81fc0c4507bc357121d';

@ProviderFor(PlannerNotifier)
final plannerProvider = PlannerNotifierProvider._();

final class PlannerNotifierProvider
    extends $NotifierProvider<PlannerNotifier, AsyncValue<DailyPlanModel?>> {
  PlannerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plannerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plannerNotifierHash();

  @$internal
  @override
  PlannerNotifier create() => PlannerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<DailyPlanModel?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<DailyPlanModel?>>(value),
    );
  }
}

String _$plannerNotifierHash() => r'aa2dd1a1c1cf5f18230dcf37fb320afaa79ea945';

abstract class _$PlannerNotifier
    extends $Notifier<AsyncValue<DailyPlanModel?>> {
  AsyncValue<DailyPlanModel?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<DailyPlanModel?>, AsyncValue<DailyPlanModel?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<DailyPlanModel?>,
                AsyncValue<DailyPlanModel?>
              >,
              AsyncValue<DailyPlanModel?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
