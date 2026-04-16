import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../auth/repositories/auth_repository.dart';
import '../../recipes/models/recipe_model.dart';
import '../../recipes/repositories/recipe_repository.dart';
import '../models/cooking_session_model.dart';
import '../repositories/cooking_session_repository.dart';
import '../services/local_scheduler_service.dart';

part 'cooking_session_provider.g.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Ephemeral value types (not persisted to Firestore)
// ─────────────────────────────────────────────────────────────────────────────

enum NudgeType { timerExpired, passiveWindow, allPassive, recipeComplete }

class NudgeMessage {
  const NudgeMessage({
    required this.id,
    required this.text,
    this.targetRecipeId,
    required this.type,
  });

  final String id;
  final String text;
  final String? targetRecipeId;
  final NudgeType type;
}

class ActiveTimerState {
  const ActiveTimerState({
    required this.recipeId,
    required this.recipeTitle,
    required this.stepIndex,
    required this.stepLabel,
    required this.totalSeconds,
    required this.secondsRemaining,
    this.isExpired = false,
  });

  final String recipeId;
  final String recipeTitle;
  final int stepIndex;
  final String stepLabel;
  final int totalSeconds;
  final int secondsRemaining;
  final bool isExpired;

  String get timerKey => '${recipeId}_$stepIndex';

  ActiveTimerState copyWith({int? secondsRemaining, bool? isExpired}) =>
      ActiveTimerState(
        recipeId: recipeId,
        recipeTitle: recipeTitle,
        stepIndex: stepIndex,
        stepLabel: stepLabel,
        totalSeconds: totalSeconds,
        secondsRemaining: secondsRemaining ?? this.secondsRemaining,
        isExpired: isExpired ?? this.isExpired,
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Session state
// ─────────────────────────────────────────────────────────────────────────────

class CookingSessionState {
  const CookingSessionState({
    this.session,
    this.recipes = const {},
    this.timers = const {},
    this.nudges = const [],
    this.isSaving = false,
    this.error,
  });

  final CookingSessionModel? session;
  final Map<String, RecipeModel> recipes;
  final Map<String, ActiveTimerState> timers;
  final List<NudgeMessage> nudges;
  final bool isSaving;
  final String? error;

  bool get hasSession => session != null;
  bool get isCompleted => session?.completedAt != null;

  RecipeModel? get activeRecipe =>
      session?.activeRecipeId != null ? recipes[session!.activeRecipeId] : null;

  int stepIndexFor(String recipeId) => session?.recipeProgress[recipeId] ?? 0;

  bool isRecipeCompleted(String recipeId) =>
      session?.completedRecipeIds.contains(recipeId) ?? false;

  CookingSessionState copyWith({
    CookingSessionModel? session,
    Map<String, RecipeModel>? recipes,
    Map<String, ActiveTimerState>? timers,
    List<NudgeMessage>? nudges,
    bool? isSaving,
    String? error,
    bool clearError = false,
    bool clearSession = false,
  }) =>
      CookingSessionState(
        session: clearSession ? null : (session ?? this.session),
        recipes: recipes ?? this.recipes,
        timers: timers ?? this.timers,
        nudges: nudges ?? this.nudges,
        isSaving: isSaving ?? this.isSaving,
        error: clearError ? null : (error ?? this.error),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Notifier
// ─────────────────────────────────────────────────────────────────────────────

@riverpod
class CookingSessionNotifier extends _$CookingSessionNotifier {
  static const _scheduler = LocalSchedulerService();
  static const _uuid = Uuid();

  final Map<String, Timer> _dartTimers = {};

  @override
  CookingSessionState build() {
    ref.keepAlive();
    ref.onDispose(() {
      for (final t in _dartTimers.values) {
        t.cancel();
      }
    });
    return const CookingSessionState();
  }

  // ── Session lifecycle ──────────────────────────────────────────────────────

  /// Create and persist a new cooking session, then return its ID.
  Future<String?> createSession({
    required List<RecipeModel> recipes,
    DateTime? targetReadyTime,
  }) async {
    final uid = ref.read(authRepositoryProvider).currentUser?.uid;
    if (uid == null || recipes.isEmpty) return null;

    final miseEnPlace = _scheduler.generateMiseEnPlace(recipes);
    final startOrder =
        _scheduler.computeStartOrder(recipes, targetReadyTime: targetReadyTime);
    final orderedIds = startOrder.map((s) => s.recipe.id).toList();

    final session = CookingSessionModel(
      id: '',
      userId: uid,
      recipeIds: orderedIds,
      recipeNames: {for (final r in recipes) r.id: r.title},
      activeRecipeId: orderedIds.first,
      targetReadyTime: targetReadyTime?.toIso8601String(),
      startedAt: DateTime.now().toIso8601String(),
      miseEnPlace: miseEnPlace,
    );

    state = state.copyWith(
      session: session,
      recipes: {for (final r in recipes) r.id: r},
      timers: const {},
      nudges: const [],
    );

    try {
      final id =
          await ref.read(cookingSessionRepositoryProvider).saveSession(session);
      state = state.copyWith(session: session.copyWith(id: id));
      return id;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  /// Load an existing session by ID from Firestore.
  Future<void> loadSession(String sessionId) async {
    final uid = ref.read(authRepositoryProvider).currentUser?.uid;
    if (uid == null) return;

    // Cancel existing timers.
    for (final t in _dartTimers.values) {
      t.cancel();
    }
    _dartTimers.clear();

    final repo = ref.read(cookingSessionRepositoryProvider);
    final sessions = await repo.watchSessions(uid).first;
    final session = sessions.where((s) => s.id == sessionId).firstOrNull;
    if (session == null) return;

    final allRecipes = await ref
        .read(recipeRepositoryProvider)
        .watchRecipes(uid)
        .first;
    final recipeMap = <String, RecipeModel>{
      for (final r in allRecipes)
        if (session.recipeIds.contains(r.id)) r.id: r,
    };
    final missingIds =
        session.recipeIds.where((id) => !recipeMap.containsKey(id));
    for (final id in missingIds) {
      try {
        final r = await ref
            .read(recipeRepositoryProvider)
            .fetchRecipeWithFallback(uid, id);
        recipeMap[r.id] = r;
      } catch (_) {}
    }

    state = state.copyWith(
      session: session,
      recipes: recipeMap,
      timers: const {},
      nudges: const [],
    );
  }

  /// Load the active (incomplete) session if one exists in Firestore.
  Future<void> loadActiveSession() async {
    final uid = ref.read(authRepositoryProvider).currentUser?.uid;
    if (uid == null) return;
    if (state.hasSession && !state.isCompleted) return; // already loaded

    final session =
        await ref.read(cookingSessionRepositoryProvider).fetchActiveSession(uid);
    if (session == null) return;

    final allRecipes = await ref
        .read(recipeRepositoryProvider)
        .watchRecipes(uid)
        .first;
    final recipeMap = <String, RecipeModel>{
      for (final r in allRecipes)
        if (session.recipeIds.contains(r.id)) r.id: r,
    };
    final missingIds =
        session.recipeIds.where((id) => !recipeMap.containsKey(id));
    for (final id in missingIds) {
      try {
        final r = await ref
            .read(recipeRepositoryProvider)
            .fetchRecipeWithFallback(uid, id);
        recipeMap[r.id] = r;
      } catch (_) {}
    }

    state = state.copyWith(session: session, recipes: recipeMap);
  }

  // ── Focus / navigation ─────────────────────────────────────────────────────

  void setActiveRecipe(String recipeId) {
    final session = state.session;
    if (session == null || state.isRecipeCompleted(recipeId)) return;
    state = state.copyWith(
        session: session.copyWith(activeRecipeId: recipeId));
    _persistProgress();
  }

  void switchToNextRecipe() {
    final session = state.session;
    if (session == null) return;
    final incomplete = session.recipeIds
        .where((id) => !session.completedRecipeIds.contains(id))
        .toList();
    if (incomplete.length < 2) return;
    final currentIdx = incomplete.indexOf(session.activeRecipeId ?? '');
    final nextIdx = (currentIdx + 1) % incomplete.length;
    setActiveRecipe(incomplete[nextIdx]);
  }

  // ── Step progression ───────────────────────────────────────────────────────

  Future<void> advanceStep(String recipeId) async {
    final session = state.session;
    if (session == null) return;
    final recipe = state.recipes[recipeId];
    if (recipe == null) return;

    final currentIndex = session.recipeProgress[recipeId] ?? 0;

    if (currentIndex >= recipe.steps.length - 1) {
      await _completeRecipe(recipeId);
      return;
    }

    final newIndex = currentIndex + 1;
    final newProgress = {...session.recipeProgress, recipeId: newIndex};
    state = state.copyWith(session: session.copyWith(recipeProgress: newProgress));
    _persistProgress();

    // If the new step is passive (has a timer), suggest switching.
    final newStep = recipe.steps[newIndex];
    if (newStep.timerSeconds != null && newStep.timerSeconds! > 0) {
      _addPassiveWindowNudge(recipeId, newStep.timerSeconds!);
    }
  }

  Future<void> previousStep(String recipeId) async {
    final session = state.session;
    if (session == null) return;
    final currentIndex = session.recipeProgress[recipeId] ?? 0;
    if (currentIndex <= 0) return;

    final newProgress = {
      ...session.recipeProgress,
      recipeId: currentIndex - 1,
    };
    state = state.copyWith(
        session: session.copyWith(recipeProgress: newProgress));
    _persistProgress();
  }

  // ── Timers ─────────────────────────────────────────────────────────────────

  void startTimer(String recipeId, int stepIndex) {
    final session = state.session;
    if (session == null) return;
    final recipe = state.recipes[recipeId];
    if (recipe == null || stepIndex >= recipe.steps.length) return;

    final step = recipe.steps[stepIndex];
    final secs = step.timerSeconds;
    if (secs == null || secs <= 0) return;

    final key = '${recipeId}_$stepIndex';
    _dartTimers[key]?.cancel();

    final timerState = ActiveTimerState(
      recipeId: recipeId,
      recipeTitle: recipe.title,
      stepIndex: stepIndex,
      stepLabel: step.timerLabel ?? 'שלב ${stepIndex + 1}',
      totalSeconds: secs,
      secondsRemaining: secs,
    );

    state = state.copyWith(
      timers: {...state.timers, key: timerState},
    );

    _dartTimers[key] = Timer.periodic(const Duration(seconds: 1), (_) {
      final current = state.timers[key];
      if (current == null) return;

      final remaining = current.secondsRemaining - 1;
      if (remaining <= 0) {
        _dartTimers[key]?.cancel();
        _dartTimers.remove(key);
        final expired = current.copyWith(secondsRemaining: 0, isExpired: true);
        state = state.copyWith(timers: {...state.timers, key: expired});
        _addTimerExpiredNudge(recipeId, recipe.title, timerState.stepLabel);
        return;
      }
      state = state.copyWith(
        timers: {...state.timers, key: current.copyWith(secondsRemaining: remaining)},
      );
    });

    _checkAllPassive();
  }

  void cancelTimer(String timerKey) {
    _dartTimers[timerKey]?.cancel();
    _dartTimers.remove(timerKey);
    final newTimers = Map<String, ActiveTimerState>.from(state.timers)
      ..remove(timerKey);
    state = state.copyWith(timers: newTimers);
  }

  // ── Mise en place ──────────────────────────────────────────────────────────

  Future<void> toggleMiseEnPlace(String itemId, {required bool value}) async {
    final session = state.session;
    if (session == null) return;
    final newChecked = {...session.miseEnPlaceChecked, itemId: value};
    state = state.copyWith(
        session: session.copyWith(miseEnPlaceChecked: newChecked));
    _persistProgress();
  }

  // ── Session / recipe completion ────────────────────────────────────────────

  Future<void> _completeRecipe(String recipeId) async {
    final session = state.session;
    if (session == null) return;
    final recipe = state.recipes[recipeId];

    // Cancel timers for this recipe.
    final keysToCancel = _dartTimers.keys
        .where((k) => k.startsWith('${recipeId}_'))
        .toList();
    for (final k in keysToCancel) {
      _dartTimers[k]?.cancel();
      _dartTimers.remove(k);
    }
    final newTimers = Map<String, ActiveTimerState>.from(state.timers)
      ..removeWhere((k, _) => k.startsWith('${recipeId}_'));

    final completed = [...session.completedRecipeIds, recipeId];
    final remaining = session.recipeIds
        .where((id) => !completed.contains(id))
        .toList();
    final nextActive =
        remaining.isNotEmpty ? remaining.first : session.activeRecipeId;

    state = state.copyWith(
      session: session.copyWith(
        completedRecipeIds: completed,
        activeRecipeId: nextActive,
      ),
      timers: newTimers,
    );

    if (recipe != null) {
      _addNudge(NudgeMessage(
        id: _uuid.v4(),
        text: '${recipe.title} הסתיים! כל הכבוד!',
        type: NudgeType.recipeComplete,
      ));
    }

    if (completed.length >= session.recipeIds.length) {
      await endSession();
    } else {
      _persistProgress();
    }
  }

  Future<void> endSession() async {
    final session = state.session;
    if (session == null) return;

    for (final t in _dartTimers.values) {
      t.cancel();
    }
    _dartTimers.clear();

    state = state.copyWith(
      session: session.copyWith(completedAt: DateTime.now().toIso8601String()),
      timers: const {},
    );
    _persistProgress();
  }

  void resetSession() {
    for (final t in _dartTimers.values) {
      t.cancel();
    }
    _dartTimers.clear();
    state = const CookingSessionState();
  }

  // ── Nudges ─────────────────────────────────────────────────────────────────

  void dismissNudge(String nudgeId) {
    state = state.copyWith(
      nudges: state.nudges.where((n) => n.id != nudgeId).toList(),
    );
  }

  void _addNudge(NudgeMessage nudge) {
    // Keep at most 3 nudges visible at once.
    final current = state.nudges.take(2).toList();
    state = state.copyWith(nudges: [nudge, ...current]);
  }

  void _addTimerExpiredNudge(
      String recipeId, String recipeTitle, String stepLabel) {
    _addNudge(NudgeMessage(
      id: _uuid.v4(),
      text: 'טיימר "$recipeTitle: $stepLabel" הסתיים!',
      targetRecipeId: recipeId,
      type: NudgeType.timerExpired,
    ));
  }

  void _addPassiveWindowNudge(String recipeId, int passiveSeconds) {
    final session = state.session;
    if (session == null) return;

    final other = session.recipeIds
        .where((id) =>
            id != recipeId && !session.completedRecipeIds.contains(id))
        .firstOrNull;
    if (other == null) return;

    final otherTitle = state.recipes[other]?.title ?? '';
    final minutes = (passiveSeconds / 60).ceil();
    _addNudge(NudgeMessage(
      id: _uuid.v4(),
      text: '$minutes דקות פנויות — עבור ל$otherTitle',
      targetRecipeId: other,
      type: NudgeType.passiveWindow,
    ));
  }

  void _checkAllPassive() {
    final session = state.session;
    if (session == null) return;

    final activeIds = session.recipeIds
        .where((id) => !session.completedRecipeIds.contains(id))
        .toList();
    if (activeIds.length < 2) return;

    final allPassive = activeIds.every(
      (id) =>
          state.timers.values.any((t) => t.recipeId == id && !t.isExpired),
    );
    if (allPassive) {
      _addNudge(const NudgeMessage(
        id: 'all_passive',
        text: 'כל הטיימרים רצים — הגיע הזמן להכין שולחן!',
        type: NudgeType.allPassive,
      ));
    }
  }

  // ── Persistence ────────────────────────────────────────────────────────────

  void _persistProgress() {
    final session = state.session;
    if (session == null || session.id.isEmpty) return;
    ref.read(cookingSessionRepositoryProvider).updateProgress(session);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Derived providers
// ─────────────────────────────────────────────────────────────────────────────

@riverpod
Stream<List<CookingSessionModel>> cookingSessionList(Ref ref) {
  final uid = ref.watch(authRepositoryProvider).currentUser?.uid;
  if (uid == null) return const Stream.empty();
  return ref
      .watch(cookingSessionRepositoryProvider)
      .watchSessions(uid);
}
