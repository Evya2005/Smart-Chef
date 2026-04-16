import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../features/recipes/models/recipe_model.dart';
import '../../../features/recipes/services/voice_command_service.dart';
import '../../../features/recipes/views/widgets/cook_timer_display.dart';
import '../../../shared/models/cook_step_model.dart';
import '../../../shared/models/ingredient_model.dart';
import '../../../shared/models/unit_type.dart';
import '../models/cooking_session_model.dart';
import '../planner_constants.dart';
import '../providers/cooking_session_provider.dart';
import 'widgets/nudge_banner.dart';
import 'widgets/recipe_track_tile.dart';
import 'widgets/timer_rack.dart';

class MissionControlScreen extends ConsumerStatefulWidget {
  const MissionControlScreen({super.key, required this.sessionId});

  final String sessionId;

  @override
  ConsumerState<MissionControlScreen> createState() =>
      _MissionControlScreenState();
}

class _MissionControlScreenState extends ConsumerState<MissionControlScreen> {
  final _voiceService = VoiceCommandService();
  final _tts = FlutterTts();
  bool _voiceReady = false;
  bool _listening = false;
  bool _loaded = false;
  Timer? _nudgeTimer;

  @override
  void initState() {
    super.initState();
    _initVoice();
    _loadSession();
  }

  Future<void> _initVoice() async {
    final ok = await _voiceService.initialize();
    await _tts.setLanguage('he-IL');
    await _tts.setSpeechRate(0.5);
    if (mounted) setState(() => _voiceReady = ok);
  }

  Future<void> _loadSession() async {
    await ref
        .read(cookingSessionProvider.notifier)
        .loadSession(widget.sessionId);
    if (mounted) setState(() => _loaded = true);
  }

  @override
  void dispose() {
    _nudgeTimer?.cancel();
    _voiceService.dispose();
    _tts.stop();
    super.dispose();
  }

  void _toggleListening() {
    if (_listening) {
      _voiceService.stopListening();
      setState(() => _listening = false);
    } else {
      _voiceService.startListening(_handleVoiceCommand);
      setState(() => _listening = true);
    }
  }

  void _handleVoiceCommand(VoiceCommand cmd) {
    final notifier = ref.read(cookingSessionProvider.notifier);
    final session = ref.read(cookingSessionProvider).session;
    if (session == null) return;

    switch (cmd) {
      case VoiceCommand.next:
        if (session.activeRecipeId != null) {
          notifier.advanceStep(session.activeRecipeId!);
        }
      case VoiceCommand.previous:
        if (session.activeRecipeId != null) {
          notifier.previousStep(session.activeRecipeId!);
        }
      case VoiceCommand.timer:
        if (session.activeRecipeId != null) {
          final stepIdx =
              session.recipeProgress[session.activeRecipeId] ?? 0;
          notifier.startTimer(session.activeRecipeId!, stepIdx);
        }
      case VoiceCommand.switchRecipe:
        notifier.switchToNextRecipe();
        _speakActiveStep();
      case VoiceCommand.repeat:
        _speakActiveStep();
      case VoiceCommand.stop:
        _voiceService.stopListening();
        setState(() => _listening = false);
      case VoiceCommand.unknown:
        break;
    }
  }

  void _speakActiveStep() {
    final state = ref.read(cookingSessionProvider);
    final recipe = state.activeRecipe;
    if (recipe == null) return;
    final idx = state.stepIndexFor(recipe.id);
    if (idx < recipe.steps.length) {
      _tts.speak(recipe.steps[idx].instruction);
    }
  }

  Map<String, Color> _colorMap(List<String> recipeIds) {
    return {
      for (var i = 0; i < recipeIds.length; i++)
        recipeIds[i]: kPlannerRecipeColors[i % kPlannerRecipeColors.length],
    };
  }

  Future<void> _confirmEndSession() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('סיום ארוחה'),
        content: const Text('האם לסיים את הסשן הנוכחי?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('ביטול'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('סיום'),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      await ref.read(cookingSessionProvider.notifier).endSession();
      if (mounted) context.go('/planner');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cookingSessionProvider);

    // Auto-dismiss the floating nudge banner after 4 seconds.
    ref.listen<CookingSessionState>(cookingSessionProvider, (prev, next) {
      final prevId = prev?.nudges.firstOrNull?.id;
      final nextNudge = next.nudges.firstOrNull;
      if (nextNudge != null && nextNudge.id != prevId) {
        _nudgeTimer?.cancel();
        _nudgeTimer = Timer(const Duration(seconds: 4), () {
          if (mounted) {
            ref
                .read(cookingSessionProvider.notifier)
                .dismissNudge(nextNudge.id);
          }
        });
      } else if (next.nudges.isEmpty) {
        _nudgeTimer?.cancel();
      }
    });

    if (!_loaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final session = state.session;
    if (session == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('מטבח מרובה')),
        body: const Center(child: Text('הסשן לא נמצא')),
      );
    }

    if (state.isCompleted) {
      return _CompletionScreen(session: session, recipes: state.recipes);
    }

    final colorMap = _colorMap(session.recipeIds);
    final activeRecipe = state.activeRecipe;
    final nudges = state.nudges;
    final timers = state.timers.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('מטבח מרובה'),
        centerTitle: true,
        actions: [
          if (_voiceReady)
            IconButton(
              icon: Icon(
                _listening ? Icons.mic : Icons.mic_none,
                color: _listening
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              onPressed: _toggleListening,
              tooltip: 'פקודות קוליות',
            ),
          IconButton(
            icon: const Icon(Icons.stop_circle_outlined),
            onPressed: _confirmEndSession,
            tooltip: 'סיום ארוחה',
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Timer rack
              if (timers.isNotEmpty)
                TimerRack(
                  timers: timers,
                  recipeColors: colorMap,
                  onCancel: (key) =>
                      ref.read(cookingSessionProvider.notifier).cancelTimer(key),
                  onTap: (id) =>
                      ref.read(cookingSessionProvider.notifier).setActiveRecipe(id),
                ),

              // Recipe tracks — completed → top, active → bottom, others in between.
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 240),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: session.recipeIds.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (ctx, i) {
                final sortedIds = [...session.recipeIds]
                  ..sort((a, b) {
                    final aCompleted = state.isRecipeCompleted(a);
                    final bCompleted = state.isRecipeCompleted(b);
                    final aActive = a == session.activeRecipeId;
                    final bActive = b == session.activeRecipeId;
                    if (aCompleted && !bCompleted) return -1;
                    if (!aCompleted && bCompleted) return 1;
                    if (!aCompleted && !bCompleted) {
                      if (aActive && !bActive) return 1;
                      if (!aActive && bActive) return -1;
                    }
                    return 0;
                  });
                final id = sortedIds[i];
                final recipe = state.recipes[id];
                if (recipe == null) return const SizedBox.shrink();
                final stepIdx = state.stepIndexFor(id);
                final hasTimer = state.timers.values
                    .any((t) => t.recipeId == id && !t.isExpired);
                return RecipeTrackTile(
                  recipe: recipe,
                  stepIndex: stepIdx,
                  color: colorMap[id]!,
                  isActive: id == session.activeRecipeId,
                  isCompleted: state.isRecipeCompleted(id),
                  hasRunningTimer: hasTimer,
                  onTap: () => ref
                      .read(cookingSessionProvider.notifier)
                      .setActiveRecipe(id),
                );
              },
            ),
          ),

          // All-steps panel fills the remaining space with no extra gap.
          if (activeRecipe != null)
            Expanded(
              child: _buildAllStepsPanel(state, session, activeRecipe, colorMap),
            )
          else
            const Expanded(
              child: Center(child: Text('כל המתכונים הסתיימו!')),
            ),
          ],
        ),

          // Floating nudge banner — slides in from top, sits above content.
          if (nudges.isNotEmpty)
            Positioned(
              top: 0,
              left: 12,
              right: 12,
              child: SafeArea(
                child: Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(12),
                  clipBehavior: Clip.hardEdge,
                  child: NudgeBanner(
                    nudge: nudges.first,
                    onDismiss: () {
                      _nudgeTimer?.cancel();
                      ref
                          .read(cookingSessionProvider.notifier)
                          .dismissNudge(nudges.first.id);
                    },
                    onSwitch: nudges.first.targetRecipeId != null
                        ? () {
                            _nudgeTimer?.cancel();
                            ref
                                .read(cookingSessionProvider.notifier)
                                .setActiveRecipe(nudges.first.targetRecipeId!);
                            ref
                                .read(cookingSessionProvider.notifier)
                                .dismissNudge(nudges.first.id);
                          }
                        : null,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAllStepsPanel(
    CookingSessionState state,
    CookingSessionModel session,
    RecipeModel activeRecipe,
    Map<String, Color> colorMap,
  ) {
    final notifier = ref.read(cookingSessionProvider.notifier);
    final stepIdx = state.stepIndexFor(activeRecipe.id);
    final steps = activeRecipe.steps;
    final color = colorMap[activeRecipe.id]!;

    // Completed steps (index < stepIdx) float to top; within groups, original order preserved.
    final sortedIndices = List.generate(steps.length, (i) => i)
      ..sort((a, b) {
        final aDone = a < stepIdx;
        final bDone = b < stepIdx;
        if (aDone && !bDone) return -1;
        if (!aDone && bDone) return 1;
        return a.compareTo(b);
      });

    // Title + details live in one unified Card — no gap between them.
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withValues(alpha: 0.35), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step counter strip — title is already visible in the track tile above.
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration:
                      BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                const Gap(8),
                Text(
                  'שלב ${stepIdx < steps.length ? stepIdx + 1 : steps.length} מתוך ${steps.length}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: color, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: color.withValues(alpha: 0.2)),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 32),
              children: [
                _MissionIngredientsFoldout(
                    ingredients: activeRecipe.ingredients),
                const Gap(8),
                ...sortedIndices.map(
                  (i) => _SessionStepTile(
                    key: ValueKey('${activeRecipe.id}_$i'),
                    step: steps[i],
                    stepIndex: i,
                    recipeId: activeRecipe.id,
                    currentStepIdx: stepIdx,
                    color: color,
                    onAdvance: () {
                      final timerKey = '${activeRecipe.id}_$stepIdx';
                      if (state.timers.containsKey(timerKey)) {
                        notifier.cancelTimer(timerKey);
                      }
                      notifier.advanceStep(activeRecipe.id);
                    },
                    onPrevious: () => notifier.previousStep(activeRecipe.id),
                    onStartTimer: () =>
                        notifier.startTimer(activeRecipe.id, i),
                    onCancelTimer: () {
                      final timerKey = '${activeRecipe.id}_$i';
                      notifier.cancelTimer(timerKey);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Foldable ingredient list for the active recipe
// ─────────────────────────────────────────────────────────────────────────────

class _MissionIngredientsFoldout extends StatelessWidget {
  const _MissionIngredientsFoldout({required this.ingredients});

  final List<IngredientModel> ingredients;

  String _fmt(IngredientModel ing) {
    final qty = ing.quantity == ing.quantity.roundToDouble()
        ? ing.quantity.toInt().toString()
        : ing.quantity.toStringAsFixed(1);
    final unit =
        ing.unit != UnitType.none ? ' ${ing.unit.displayLabel}' : '';
    return '$qty$unit ${ing.name}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        initiallyExpanded: false,
        shape: const Border(),
        leading: Icon(Icons.kitchen_outlined, color: cs.primary),
        title: Text(
          'חומרים (${ingredients.length})',
          style: theme.textTheme.titleSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        children: ingredients.map((ing) {
          final note = ing.prepNote != null ? '  •  ${ing.prepNote}' : '';
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            child: Row(
              children: [
                Icon(Icons.circle, size: 6, color: cs.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${_fmt(ing)}$note',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Individual step tile for multi-recipe cook mode
// ─────────────────────────────────────────────────────────────────────────────

class _SessionStepTile extends ConsumerStatefulWidget {
  const _SessionStepTile({
    super.key,
    required this.step,
    required this.stepIndex,
    required this.recipeId,
    required this.currentStepIdx,
    required this.color,
    required this.onAdvance,
    required this.onPrevious,
    required this.onStartTimer,
    required this.onCancelTimer,
  });

  final CookStepModel step;
  final int stepIndex;
  final String recipeId;
  final int currentStepIdx;
  final Color color;
  final VoidCallback onAdvance;
  final VoidCallback onPrevious;
  final VoidCallback onStartTimer;
  final VoidCallback onCancelTimer;

  @override
  ConsumerState<_SessionStepTile> createState() => _SessionStepTileState();
}

class _SessionStepTileState extends ConsumerState<_SessionStepTile> {
  bool _expanded = false;

  bool get isDone => widget.stepIndex < widget.currentStepIdx;
  bool get isCurrent => widget.stepIndex == widget.currentStepIdx;

  @override
  void initState() {
    super.initState();
    _expanded = isCurrent && widget.step.timerSeconds != null;
  }

  @override
  void didUpdateWidget(_SessionStepTile old) {
    super.didUpdateWidget(old);
    // Auto-expand when this step becomes current (and has a timer); collapse otherwise.
    if (old.currentStepIdx != widget.currentStepIdx) {
      setState(() => _expanded = isCurrent && widget.step.timerSeconds != null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cookingSessionProvider);
    final timerKey = '${widget.recipeId}_${widget.stepIndex}';
    final activeTimer = state.timers[timerKey];
    final isTimerRunning =
        activeTimer != null && !activeTimer.isExpired;
    final hasTimer = widget.step.timerSeconds != null;
    final canExpand = hasTimer;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color circleColor;
    Color circleTextColor;
    if (isDone) {
      circleColor = colorScheme.outline.withValues(alpha: 0.3);
      circleTextColor = colorScheme.onSurface.withValues(alpha: 0.4);
    } else if (isCurrent) {
      circleColor = widget.color;
      circleTextColor = Colors.white;
    } else {
      circleColor = colorScheme.surfaceContainerHighest;
      circleTextColor = colorScheme.onSurface;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isDone
              ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.4)
              : isCurrent
                  ? widget.color.withValues(alpha: 0.06)
                  : colorScheme.surface,
          border: Border.all(
            color: isCurrent
                ? widget.color.withValues(alpha: 0.5)
                : isDone
                    ? colorScheme.outline.withValues(alpha: 0.2)
                    : colorScheme.outline.withValues(alpha: 0.4),
            width: isCurrent ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: canExpand
                  ? () => setState(() => _expanded = !_expanded)
                  : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step number / done indicator
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: circleColor,
                      child: isDone
                          ? Icon(
                              Icons.check,
                              size: 14,
                              color: colorScheme.onSurface.withValues(alpha: 0.4),
                            )
                          : Text(
                              '${widget.stepIndex + 1}',
                              style: TextStyle(
                                fontSize: 12,
                                color: circleTextColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    const Gap(10),
                    Expanded(
                      child: Text(
                        widget.step.instruction,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          decoration: isDone
                              ? TextDecoration.lineThrough
                              : null,
                          color: isDone
                              ? colorScheme.onSurface.withValues(alpha: 0.4)
                              : null,
                        ),
                      ),
                    ),
                    const Gap(4),
                    if (canExpand)
                      Icon(
                        _expanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                  ],
                ),
              ),
            ),
            if (_expanded) ...[
              Divider(
                indent: 12,
                endIndent: 12,
                height: 1,
                color: colorScheme.outline.withValues(alpha: 0.3),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isTimerRunning) ...[
                      CookTimerDisplay(
                          seconds: activeTimer.secondsRemaining),
                      const Gap(6),
                      TextButton.icon(
                        icon: const Icon(Icons.timer_off_outlined),
                        label: const Text('בטל טיימר'),
                        onPressed: widget.onCancelTimer,
                      ),
                    ] else if (!isDone)
                      OutlinedButton.icon(
                        icon: const Icon(Icons.timer_outlined),
                        label: Text(
                          'הפעל טיימר (${widget.step.timerSeconds! ~/ 60} דקות)',
                        ),
                        onPressed: widget.onStartTimer,
                      ),
                  ],
                ),
              ),
            ],
            // Action buttons — always visible for the current step.
            if (isCurrent) ...[
              Divider(
                indent: 12,
                endIndent: 12,
                height: 1,
                color: colorScheme.outline.withValues(alpha: 0.3),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: Row(
                  children: [
                    if (widget.stepIndex > 0)
                      OutlinedButton.icon(
                        icon: const Icon(Icons.arrow_back, size: 16),
                        label: const Text('קודם'),
                        onPressed: widget.onPrevious,
                      ),
                    const Spacer(),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: widget.color,
                      ),
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('סיימתי'),
                      onPressed: widget.onAdvance,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Completion screen shown when all recipes are done
// ─────────────────────────────────────────────────────────────────────────────

class _CompletionScreen extends ConsumerWidget {
  const _CompletionScreen({
    required this.session,
    required this.recipes,
  });

  final CookingSessionModel session;
  final Map<String, RecipeModel> recipes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.celebration, size: 80, color: Colors.amber),
                const SizedBox(height: 24),
                const Text(
                  'הארוחה הסתיימה!',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  'בישלת ${session.recipeIds.length} מתכונים',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 32),
                ...session.recipeIds.map((id) {
                  final r = recipes[id];
                  return ListTile(
                    leading:
                        const Icon(Icons.check_circle, color: Colors.green),
                    title: Text(r?.title ?? id),
                  );
                }),
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: () {
                    ref.read(cookingSessionProvider.notifier).resetSession();
                    context.go('/planner');
                  },
                  icon: const Icon(Icons.home),
                  label: const Text('חזור לתפריט'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
