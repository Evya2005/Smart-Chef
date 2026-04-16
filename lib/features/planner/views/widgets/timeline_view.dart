import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../shared/models/ingredient_model.dart';
import '../../../recipes/models/recipe_model.dart';
import '../../../recipes/providers/recipe_list_provider.dart';
import '../../models/daily_plan_model.dart';
import '../../models/timeline_event_model.dart';

const kPlannerTrackColors = [
  Color(0xFF4CAF50),
  Color(0xFF2196F3),
  Color(0xFFFF9800),
  Color(0xFF9C27B0),
  Color(0xFFE91E63),
];

class TimelineView extends ConsumerStatefulWidget {
  const TimelineView({super.key, required this.plan});

  final DailyPlanModel plan;

  @override
  ConsumerState<TimelineView> createState() => _TimelineViewState();
}

class _TimelineViewState extends ConsumerState<TimelineView> {
  Timer? _timer;
  String? _activeTimerKey;
  int _remainingSeconds = 0;
  final Set<String> _doneKeys = {};

  String _eventKey(TimelineEventModel e) =>
      '${e.recipeId}_${e.stepNumber}';

  void _toggleDone(TimelineEventModel e) {
    setState(() {
      final k = _eventKey(e);
      if (_doneKeys.contains(k)) {
        _doneKeys.remove(k);
      } else {
        _doneKeys.add(k);
        if (_activeTimerKey == k) {
          _timer?.cancel();
          _activeTimerKey = null;
        }
      }
    });
  }

  void _startTimer(TimelineEventModel event) {
    _timer?.cancel();
    setState(() {
      _activeTimerKey = _eventKey(event);
      _remainingSeconds = event.timerSeconds!;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds <= 0) {
        _timer?.cancel();
        if (mounted) setState(() => _activeTimerKey = null);
        return;
      }
      if (mounted) setState(() => _remainingSeconds--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timeline = List<TimelineEventModel>.from(
        widget.plan.timeline ?? [])
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    if (timeline.isEmpty) {
      return const Center(child: Text('אין לוח זמנים'));
    }

    // Build recipe lookup map for ingredient display.
    final allRecipes = ref.watch(recipeListProvider).value ?? <RecipeModel>[];
    final recipeMap = {for (final r in allRecipes) r.id: r};

    // Build recipe → color index map.
    final recipeIds =
        timeline.map((e) => e.recipeId).toSet().toList();
    final colorMap = {
      for (var i = 0; i < recipeIds.length; i++)
        recipeIds[i]: kPlannerTrackColors[i % kPlannerTrackColors.length]
    };

    // Build recipe → servings ratio map (planned ÷ default).
    final servingsRatioMap = <String, double>{};
    for (final pr in widget.plan.recipes) {
      final defaultServings =
          recipeMap[pr.recipeId]?.defaultServings ?? 1;
      servingsRatioMap[pr.recipeId] =
          pr.servings / defaultServings.clamp(1, double.infinity);
    }

    final done = _doneKeys.length;
    final total = timeline.length;

    return Column(
      children: [
        if (_activeTimerKey != null)
          _TimerBanner(
            seconds: _remainingSeconds,
            onStop: () {
              _timer?.cancel();
              setState(() => _activeTimerKey = null);
            },
          ),
        // Progress bar.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Text('$done / $total שלבים',
                  style: Theme.of(context).textTheme.labelMedium),
              const Gap(8),
              Expanded(
                child: LinearProgressIndicator(
                  value: total == 0 ? 0 : done / total,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: timeline.length,
            itemBuilder: (context, i) {
              final event = timeline[i];
              final key = _eventKey(event);
              final isDone = _doneKeys.contains(key);
              final isTimerActive = _activeTimerKey == key;
              final color = colorMap[event.recipeId] ?? Colors.grey;

              final ingredients =
                  recipeMap[event.recipeId]?.ingredients ??
                      <IngredientModel>[];
              final servingsRatio =
                  servingsRatioMap[event.recipeId] ?? 1.0;

              return _TimelineEventTile(
                event: event,
                color: color,
                isDone: isDone,
                isTimerActive: isTimerActive,
                timerSeconds:
                    isTimerActive ? _remainingSeconds : null,
                onToggleDone: () => _toggleDone(event),
                onStartTimer: event.timerSeconds != null
                    ? () => _startTimer(event)
                    : null,
                isLast: i == timeline.length - 1,
                ingredients: ingredients,
                servingsRatio: servingsRatio,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TimelineEventTile extends StatefulWidget {
  const _TimelineEventTile({
    required this.event,
    required this.color,
    required this.isDone,
    required this.isTimerActive,
    required this.timerSeconds,
    required this.onToggleDone,
    required this.onStartTimer,
    required this.isLast,
    required this.ingredients,
    required this.servingsRatio,
  });

  final TimelineEventModel event;
  final Color color;
  final bool isDone;
  final bool isTimerActive;
  final int? timerSeconds;
  final VoidCallback onToggleDone;
  final VoidCallback? onStartTimer;
  final bool isLast;
  final List<IngredientModel> ingredients;
  final double servingsRatio;

  @override
  State<_TimelineEventTile> createState() => _TimelineEventTileState();
}

class _TimelineEventTileState extends State<_TimelineEventTile> {
  bool _expanded = false;

  String _fmtTime(String iso) {
    final dt = DateTime.parse(iso).toLocal();
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  String _fmtAmount(IngredientModel ing) {
    final scaled = ing.quantity * widget.servingsRatio;
    final qty = scaled % 1 == 0
        ? scaled.toInt().toString()
        : scaled.toStringAsFixed(1);
    final unit = ing.unit.displayLabel;
    return unit.isEmpty ? qty : '$qty $unit';
  }

  /// Returns the instruction text with ingredient amounts inserted inline.
  /// Sorts by name length descending so "cumin seeds" is matched before "cumin".
  String _annotatedInstruction() {
    if (widget.ingredients.isEmpty) return widget.event.instruction;
    final sorted = [...widget.ingredients]
      ..sort((a, b) => b.name.length.compareTo(a.name.length));
    final nameToIng = {
      for (final ing in sorted) ing.name.toLowerCase(): ing,
    };
    final pattern = RegExp(
      sorted.map((i) => RegExp.escape(i.name)).join('|'),
      caseSensitive: false,
    );
    return widget.event.instruction.replaceAllMapped(pattern, (m) {
      final ing = nameToIng[m[0]!.toLowerCase()];
      if (ing == null) return m[0]!;
      return '(${_fmtAmount(ing)}) ${m[0]!}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final event = widget.event;
    final color = widget.color;
    final isDone = widget.isDone;
    final isTimerActive = widget.isTimerActive;
    final timerSeconds = widget.timerSeconds;
    final isLast = widget.isLast;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left: time column.
          SizedBox(
            width: 48,
            child: Column(
              children: [
                Text(
                  _fmtTime(event.startTime),
                  style: textTheme.labelSmall
                      ?.copyWith(color: color, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  _fmtTime(event.endTime),
                  style: textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          // Centre: vertical line + dot.
          Column(
            children: [
              Container(
                width: 2,
                height: 8,
                color: color.withAlpha(isDone ? 60 : 180),
              ),
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone ? Colors.green : color,
                  border: Border.all(
                    color: isDone ? Colors.green : color,
                    width: 2,
                  ),
                ),
                child: isDone
                    ? const Icon(Icons.check, size: 10, color: Colors.white)
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: color.withAlpha(isDone ? 40 : 120),
                  ),
                ),
            ],
          ),
          const Gap(10),
          // Right: content card.
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AnimatedOpacity(
                opacity: isDone ? 0.5 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Card(
                  margin: EdgeInsets.zero,
                  clipBehavior: Clip.antiAlias,
                  color: isTimerActive
                      ? Colors.amber.withAlpha(40)
                      : null,
                  child: InkWell(
                    onTap: widget.ingredients.isNotEmpty
                        ? () => setState(() => _expanded = !_expanded)
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: color.withAlpha(30),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    event.recipeTitle,
                                    style: textTheme.labelSmall
                                        ?.copyWith(color: color),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              const Gap(6),
                              Text(
                                'שלב ${event.stepNumber}',
                                style: textTheme.labelSmall?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                              const Spacer(),
                              if (widget.ingredients.isNotEmpty)
                                AnimatedRotation(
                                  turns: _expanded ? 0.5 : 0,
                                  duration:
                                      const Duration(milliseconds: 200),
                                  child: Icon(Icons.expand_more,
                                      size: 18,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant),
                                ),
                              const Gap(6),
                              // Done toggle.
                              GestureDetector(
                                onTap: widget.onToggleDone,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isDone
                                        ? Colors.green
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: isDone
                                          ? Colors.green
                                          : Theme.of(context)
                                              .colorScheme
                                              .outline,
                                      width: 2,
                                    ),
                                  ),
                                  child: isDone
                                      ? const Icon(Icons.check,
                                          size: 16, color: Colors.white)
                                      : null,
                                ),
                              ),
                            ],
                          ),
                          const Gap(6),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Text(
                              _expanded
                                  ? _annotatedInstruction()
                                  : event.instruction,
                              key: ValueKey(_expanded),
                              style: textTheme.bodyMedium?.copyWith(
                                decoration: isDone
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                          if (isTimerActive && timerSeconds != null) ...[
                            const Gap(8),
                            _InlineTimer(seconds: timerSeconds),
                          ] else if (widget.onStartTimer != null &&
                              event.timerSeconds != null) ...[
                            const Gap(8),
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 32),
                                tapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                              icon: const Icon(Icons.timer_outlined,
                                  size: 16),
                              label: Text(
                                  '${event.timerSeconds! ~/ 60} דקות'),
                              onPressed: widget.onStartTimer,
                            ),
                          ],
                          // inline inside the instruction text when tapped.
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Gap(12),
        ],
      ),
    );
  }
}

class _InlineTimer extends StatelessWidget {
  const _InlineTimer({required this.seconds});

  final int seconds;

  @override
  Widget build(BuildContext context) {
    final min = seconds ~/ 60;
    final sec = seconds % 60;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.timer, size: 16, color: Colors.orange),
        const Gap(4),
        Text(
          '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}',
          style: const TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _TimerBanner extends StatelessWidget {
  const _TimerBanner({required this.seconds, required this.onStop});

  final int seconds;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    final min = seconds ~/ 60;
    final sec = seconds % 60;
    return Container(
      color: Colors.amber,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.timer, color: Colors.black87),
          const Gap(8),
          Text(
            '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}',
            style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          const Spacer(),
          TextButton(
            onPressed: onStop,
            child: const Text('עצור',
                style: TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}
