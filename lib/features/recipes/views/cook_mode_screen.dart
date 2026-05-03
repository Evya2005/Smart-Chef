import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:gap/gap.dart';

import '../../../shared/models/ingredient_model.dart';
import '../../../shared/models/unit_type.dart';
import '../../../shared/widgets/error_card.dart';
import '../models/recipe_model.dart';
import '../providers/cook_mode_provider.dart';
import '../providers/recipe_detail_provider.dart';
import '../providers/scaling_provider.dart';
import '../services/voice_command_service.dart';
import 'widgets/cook_step_cook_tile.dart';

class CookModeScreen extends ConsumerStatefulWidget {
  const CookModeScreen({super.key, required this.recipeId});

  final String recipeId;

  @override
  ConsumerState<CookModeScreen> createState() => _CookModeScreenState();
}

class _CookModeScreenState extends ConsumerState<CookModeScreen> {
  final _tts = FlutterTts();
  final _voice = VoiceCommandService();
  bool _voiceReady = false;

  @override
  void initState() {
    super.initState();
    _setupTts();
    _setupVoice();
  }

  Future<void> _setupTts() async {
    await _tts.setLanguage('he-IL');
    await _tts.setSpeechRate(0.5);
  }

  Future<void> _setupVoice() async {
    final ready = await _voice.initialize();
    if (mounted) setState(() => _voiceReady = ready);
  }

  Future<void> _speak(String text) async {
    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> _toggleListen(CookModeNotifier notifier) async {
    if (ref.read(cookModeProvider).isListening) {
      await _voice.stopListening();
      notifier.setListening(false);
    } else {
      notifier.setListening(true);
      await _voice.startListening((cmd) {
        switch (cmd) {
          case VoiceCommand.next:
            notifier.next();
            _speak(ref.read(cookModeProvider).activeStep.instruction);
          case VoiceCommand.previous:
            notifier.previous();
            _speak(ref.read(cookModeProvider).activeStep.instruction);
          case VoiceCommand.repeat:
            _speak(ref.read(cookModeProvider).activeStep.instruction);
          case VoiceCommand.stop:
            notifier.setListening(false);
            _voice.stopListening();
          case VoiceCommand.timer:
            notifier.startTimer(ref.read(cookModeProvider).activeStepIndex);
          case VoiceCommand.switchRecipe:
            break; // Not applicable in single-recipe cook mode.
          case VoiceCommand.unknown:
            break;
        }
      });
    }
  }

  @override
  void dispose() {
    _tts.stop();
    _voice.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipeAsync = ref.watch(recipeDetailProvider(widget.recipeId));

    return recipeAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) =>
          Scaffold(body: Center(child: ErrorCard(message: e.toString()))),
      data: (recipe) {
        // Initialize cook mode with recipe steps on first load.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (ref.read(cookModeProvider).steps.isEmpty) {
            ref.read(cookModeProvider.notifier).init(recipe.steps);
          }
        });

        return _CookModeBody(
          recipe: recipe,
          voiceReady: _voiceReady,
          onSpeak: _speak,
          onToggleListen: _toggleListen,
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _CookModeBody extends ConsumerWidget {
  const _CookModeBody({
    required this.recipe,
    required this.voiceReady,
    required this.onSpeak,
    required this.onToggleListen,
  });

  final RecipeModel recipe;
  final bool voiceReady;
  final Future<void> Function(String) onSpeak;
  final Future<void> Function(CookModeNotifier) onToggleListen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cookModeProvider);
    final notifier = ref.read(cookModeProvider.notifier);
    final scaledAsync = ref.watch(scaledIngredientsProvider(recipe.id));

    if (state.steps.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(recipe.title)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final scaledIngredients = scaledAsync.value ?? recipe.ingredients;
    final checkedSteps = state.checkedSteps;
    final progress = checkedSteps.length / state.totalSteps;

    // Completed steps float to the top; within each group, original order is kept.
    final sortedIndices = List.generate(state.steps.length, (i) => i)
      ..sort((a, b) {
        final aChecked = checkedSteps.contains(a);
        final bChecked = checkedSteps.contains(b);
        if (aChecked && !bChecked) return -1;
        if (!aChecked && bChecked) return 1;
        return a.compareTo(b);
      });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(recipe.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(value: progress),
        ),
        actions: [
          if (voiceReady)
            IconButton(
              icon: Icon(state.isListening ? Icons.mic : Icons.mic_none),
              color: state.isListening
                  ? Theme.of(context).colorScheme.primary
                  : null,
              onPressed: () => onToggleListen(notifier),
              tooltip: 'פקודות קוליות',
            ),
          IconButton(
            icon: const Icon(Icons.volume_up_outlined),
            onPressed: () => onSpeak(state.activeStep.instruction),
            tooltip: 'קרא בקול',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 40),
        children: [
          _IngredientsFoldout(ingredients: scaledIngredients),
          const Gap(8),
          ...sortedIndices.map(
            (i) => CookStepCookTile(
              key: ValueKey(i),
              step: state.steps[i],
              stepIndex: i,
              scaledIngredients: scaledIngredients,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

/// Foldable card showing the full scaled ingredient list.
/// Collapsed by default so it doesn't clutter the steps view.
class _IngredientsFoldout extends StatelessWidget {
  const _IngredientsFoldout({required this.ingredients});

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
          final note =
              ing.prepNote != null ? '  •  ${ing.prepNote}' : '';
          return ListTile(
            dense: true,
            minLeadingWidth: 12,
            leading: Icon(Icons.circle, size: 6, color: cs.primary),
            title: Text('${_fmt(ing)}$note'),
          );
        }).toList(),
      ),
    );
  }
}
