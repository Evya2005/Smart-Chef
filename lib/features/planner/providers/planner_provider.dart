import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../auth/repositories/auth_repository.dart';
import '../../recipes/models/recipe_model.dart';
import '../../settings/providers/user_settings_provider.dart';
import '../models/daily_plan_model.dart';
import '../models/planned_recipe_model.dart';
import '../repositories/planner_repository.dart';
import '../services/orchestrator_service.dart';

part 'planner_provider.g.dart';

@riverpod
Stream<List<DailyPlanModel>> planList(Ref ref) {
  final user = ref.watch(authRepositoryProvider).currentUser;
  if (user == null) return const Stream.empty();
  return ref.watch(plannerRepositoryProvider).watchPlans(user.uid);
}

@riverpod
class PlannerNotifier extends _$PlannerNotifier {
  final _uuid = const Uuid();

  OrchestratorService get _orchestrator {
    final apiKey = ref.read(geminiApiKeyProvider).asData?.value ?? '';
    return OrchestratorService(apiKey: apiKey);
  }

  @override
  AsyncValue<DailyPlanModel?> build() {
    ref.keepAlive(); // Keep state when navigating away and back.
    return const AsyncData(null);
  }

  void newPlan(String userId) {
    final now = DateTime.now();
    final mealTime = now.add(const Duration(hours: 2));
    state = AsyncData(DailyPlanModel(
      id: '',
      userId: userId,
      mealTime: mealTime.toIso8601String(),
      recipes: const [],
      createdAt: now.toIso8601String(),
    ));
  }

  void setMealTime(DateTime newMealTime) {
    final plan = state.value;
    if (plan == null) return;

    // If a timeline exists, shift every event by the same delta.
    final oldMealTime = DateTime.parse(plan.mealTime).toLocal();
    final delta = newMealTime.difference(oldMealTime);

    final shiftedTimeline = plan.timeline?.map((e) {
      final start = DateTime.parse(e.startTime).add(delta);
      final end = DateTime.parse(e.endTime).add(delta);
      return e.copyWith(
        startTime: start.toIso8601String(),
        endTime: end.toIso8601String(),
      );
    }).toList();

    final shiftedRecipes = plan.recipes.map((r) {
      if (r.computedStartTime == null) return r;
      final shifted =
          DateTime.parse(r.computedStartTime!).add(delta);
      return r.copyWith(computedStartTime: shifted.toIso8601String());
    }).toList();

    state = AsyncData(plan.copyWith(
      mealTime: newMealTime.toIso8601String(),
      timeline: shiftedTimeline,
      recipes: shiftedRecipes,
    ));
  }

  void addRecipe(RecipeModel recipe, int servings) {
    final plan = state.value;
    if (plan == null) return;
    final pr = PlannedRecipeModel(
      recipeId: recipe.id,
      recipeTitle: recipe.title,
      servings: servings,
    );
    state = AsyncData(plan.copyWith(recipes: [...plan.recipes, pr]));
  }

  void removeRecipe(String recipeId) {
    final plan = state.value;
    if (plan == null) return;
    state = AsyncData(plan.copyWith(
      recipes: plan.recipes.where((r) => r.recipeId != recipeId).toList(),
    ));
  }

  void setNotes(String v) {
    final plan = state.value;
    if (plan == null) return;
    state = AsyncData(plan.copyWith(notes: v));
  }

  void setCustomInstructions(String v) {
    final plan = state.value;
    if (plan == null) return;
    state = AsyncData(plan.copyWith(customInstructions: v));
  }

  Future<void> generateTimeline(List<RecipeModel> recipes) async {
    final plan = state.value;
    if (plan == null) return;
    final uid = ref.read(authRepositoryProvider).currentUser?.uid ?? '';
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => _orchestrator.generateTimeline(plan, recipes));
    if (state.hasValue && state.value != null) {
      await savePlan(uid);
    }
  }

  Future<String?> savePlan(String uid) async {
    final plan = state.value;
    if (plan == null) return null;
    final repo = ref.read(plannerRepositoryProvider);
    final savedPlan = plan.copyWith(
      id: plan.id.isEmpty ? _uuid.v4() : plan.id,
    );
    await repo.savePlan(savedPlan);
    // Update state so the plan keeps its ID on subsequent saves.
    state = AsyncData(savedPlan);
    return savedPlan.id;
  }

  void loadPlan(DailyPlanModel plan) {
    state = AsyncData(plan);
  }

  void clearPlan() {
    state = const AsyncData(null);
  }

  Future<void> deletePlan(String uid, String planId) async {
    await ref.read(plannerRepositoryProvider).deletePlan(uid, planId);
  }
}
