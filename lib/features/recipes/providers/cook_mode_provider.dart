import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/cook_step_model.dart';

class CookModeState {
  const CookModeState({
    required this.steps,
    this.activeStepIndex = 0,
    this.isListening = false,
    this.timerSeconds,
    this.timerStepIndex,
    Set<int>? checkedSteps,
  }) : checkedSteps = checkedSteps ?? const {};

  final List<CookStepModel> steps;
  final int activeStepIndex;
  final bool isListening;
  final int? timerSeconds;
  final int? timerStepIndex;
  final Set<int> checkedSteps;

  CookStepModel get activeStep => steps[activeStepIndex];
  int get totalSteps => steps.length;
  bool get hasNext => activeStepIndex < steps.length - 1;
  bool get hasPrevious => activeStepIndex > 0;
  int get checkedCount => checkedSteps.length;

  CookModeState copyWith({
    int? activeStepIndex,
    bool? isListening,
    int? timerSeconds,
    bool clearTimer = false,
    int? timerStepIndex,
    bool clearTimerStepIndex = false,
    Set<int>? checkedSteps,
  }) {
    return CookModeState(
      steps: steps,
      activeStepIndex: activeStepIndex ?? this.activeStepIndex,
      isListening: isListening ?? this.isListening,
      timerSeconds: clearTimer ? null : (timerSeconds ?? this.timerSeconds),
      timerStepIndex: clearTimerStepIndex
          ? null
          : (timerStepIndex ?? this.timerStepIndex),
      checkedSteps: checkedSteps != null
          ? Set.unmodifiable(checkedSteps)
          : Set.unmodifiable(this.checkedSteps),
    );
  }
}

class CookModeNotifier extends Notifier<CookModeState> {
  Timer? _countdownTimer;

  @override
  CookModeState build() => const CookModeState(steps: []);

  void init(List<CookStepModel> steps) {
    _countdownTimer?.cancel();
    state = CookModeState(steps: steps);
  }

  void next() {
    if (state.hasNext) {
      _countdownTimer?.cancel();
      state = state.copyWith(
        activeStepIndex: state.activeStepIndex + 1,
        clearTimer: true,
        clearTimerStepIndex: true,
      );
    }
  }

  void previous() {
    if (state.hasPrevious) {
      _countdownTimer?.cancel();
      state = state.copyWith(
        activeStepIndex: state.activeStepIndex - 1,
        clearTimer: true,
        clearTimerStepIndex: true,
      );
    }
  }

  void setListening(bool listening) {
    state = state.copyWith(isListening: listening);
  }

  void startTimer(int stepIndex) {
    final secs = state.steps[stepIndex].timerSeconds;
    if (secs == null || secs <= 0) return;
    _countdownTimer?.cancel();
    state = state.copyWith(timerSeconds: secs, timerStepIndex: stepIndex);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final remaining = (state.timerSeconds ?? 1) - 1;
      if (remaining <= 0) {
        _countdownTimer?.cancel();
        state = state.copyWith(clearTimer: true, clearTimerStepIndex: true);
        return;
      }
      state = state.copyWith(timerSeconds: remaining);
    });
  }

  void cancelTimer() {
    _countdownTimer?.cancel();
    state = state.copyWith(clearTimer: true, clearTimerStepIndex: true);
  }

  void toggleStep(int index) {
    final next = Set<int>.of(state.checkedSteps);
    if (next.contains(index)) {
      next.remove(index);
    } else {
      next.add(index);
    }
    state = state.copyWith(checkedSteps: next);
  }
}

final cookModeProvider =
    NotifierProvider<CookModeNotifier, CookModeState>(CookModeNotifier.new);

/// Tracks whether inline cook mode is active on the detail screen.
class CookModeActiveNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  // ignore: avoid_positional_boolean_parameters
  void setActive(bool value) => state = value;
}

final cookModeActiveProvider =
    NotifierProvider<CookModeActiveNotifier, bool>(
        CookModeActiveNotifier.new);
