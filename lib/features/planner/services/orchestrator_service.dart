import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/utils/logger.dart';
import '../../recipes/models/recipe_model.dart';
import '../models/daily_plan_model.dart';
import '../models/timeline_event_model.dart';

class OrchestratorService {
  const OrchestratorService({required this.apiKey});

  final String apiKey;

  GenerativeModel get _model {
    if (apiKey.isEmpty) {
      throw const PlannerException(
          'לא הוגדר מפתח Gemini API. אנא הגדר מפתח בהגדרות.');
    }
    return GenerativeModel(model: AppConstants.geminiModel, apiKey: apiKey);
  }

  static const _maxRetries = 3;

  /// Generates a cooking timeline for [recipes] targeting [mealTime].
  /// Retries up to [_maxRetries] times on transient server errors (5xx).
  /// Returns an updated [DailyPlanModel] with [timeline] populated.
  Future<DailyPlanModel> generateTimeline(
    DailyPlanModel plan,
    List<RecipeModel> recipes,
  ) async {
    final mealTime = DateTime.parse(plan.mealTime).toLocal();
    final prompt = _buildPrompt(recipes, mealTime, plan.customInstructions);
    final content = [
      Content.multi([TextPart(_systemPrompt), TextPart(prompt)]),
    ];

    Object? lastError;
    for (var attempt = 1; attempt <= _maxRetries; attempt++) {
      try {
        final response = await _model.generateContent(content);
        final rawJson = response.text ?? '';
        try {
          return _parseTimeline(rawJson, plan, mealTime, recipes);
        } on FormatException catch (e) {
          AppLogger.w('Orchestrator JSON parse failed: $e');
          throw PlannerException('Gemini returned invalid timeline JSON.', e);
        }
      } on _AtomicViolationException catch (e) {
        lastError = e;
        if (attempt < _maxRetries) {
          AppLogger.w(
              'Orchestrator: atomic block violation, retrying (attempt $attempt)...');
          await Future<void>.delayed(Duration(seconds: attempt * 5));
          continue;
        }
        throw PlannerException(
            'Gemini לא הצליח לייצר ציר זמן תקין. אנא נסה שוב.', e);
      } on PlannerException {
        rethrow; // parse errors — don't retry
      } catch (e, st) {
        lastError = e;
        // Overload: server is already retrying internally — fail fast.
        if (_isOverloaded(e)) {
          AppLogger.w('Orchestrator: Gemini overloaded, failing fast');
          throw PlannerException(
            'שרת Gemini עמוס כרגע. אנא נסה שוב בעוד מספר דקות.',
            e,
          );
        }
        if (attempt < _maxRetries && _isTransient(e)) {
          final delay = Duration(seconds: attempt * 5);
          AppLogger.w(
              'Orchestrator attempt $attempt failed, retrying in ${delay.inSeconds}s... ($e)');
          await Future<void>.delayed(delay);
        } else {
          AppLogger.e(
              'Orchestrator Gemini call failed after $attempt attempt(s)', e, st);
          throw PlannerException('Gemini API call failed.', e);
        }
      }
    }
    throw PlannerException(
        'Gemini API call failed after $_maxRetries attempts.', lastError);
  }

  /// Server is already exhausting internal retries — pointless to retry ourselves.
  static bool _isOverloaded(Object e) {
    final msg = e.toString();
    return msg.contains('high demand') ||
        msg.contains('Overloaded') ||
        msg.contains('Preempted') ||
        msg.contains('too many retries') ||
        msg.contains('RESOURCE_EXHAUSTED');
  }

  /// Returns true for quick transient errors worth retrying (network blips, cold starts).
  static bool _isTransient(Object e) {
    final msg = e.toString();
    return msg.contains('502') ||
        msg.contains('503') ||
        msg.contains('500') ||
        msg.contains('UNAVAILABLE') ||
        msg.contains('SocketException') ||
        msg.contains('TimeoutException');
  }

  static const _systemPrompt = '''
You are a cooking timeline optimizer. Schedule recipe steps so all dishes finish at meal time.
Add prep steps (chopping, measuring, marinating, etc.) before cooking steps where needed.
Return ONLY a JSON array — no markdown, no explanation.

[{"recipeId":"string","stepNumber":integer,"instruction":"string","minutesBeforeMeal":integer,"durationMinutes":integer,"isAtomicWithNext":boolean}]

Definitions:
- Passive Time: a step where the cook is NOT physically attending — boiling, baking, roasting,
  simmering unattended, resting, marinating. You MAY interleave steps from another recipe during
  a passive step.
- Active Attention: a step requiring continuous physical presence — high-heat frying, constant
  stirring, deglazing, immediate add-and-stir sequences, or any step that must start within
  0–2 minutes of the previous same-recipe step. Active Attention steps form Atomic Blocks.
- Atomic Block: a consecutive run of same-recipe steps where no passive gap exists between them.

Rules:
1. minutesBeforeMeal = minutes before meal time this step STARTS (positive integer ≥ 1).
2. Last step of every recipe: minutesBeforeMeal == durationMinutes (finishes exactly at meal time).
3. Same-recipe steps are sequential: minutesBeforeMeal[i] == minutesBeforeMeal[i+1] + durationMinutes[i].
4. Prep steps use negative stepNumbers (-1, -2, … more negative = earlier). All must finish before
   step 1. Use the recipe language. Estimate realistic durations.
5. Cooking steps (stepNumber ≥ 1): use the original step text as instruction.
6. Fill Passive Time gaps with steps from other recipes. Schedule make-ahead items (marinades,
   doughs) as early as possible.
7. Context switching: ONLY place a step from Recipe B between two same-recipe steps of Recipe A
   when there is a Passive Time step in between. NEVER switch mid-Atomic-Block.
8. isAtomicWithNext: set true when this step and the next same-recipe step form an Atomic Block
   (no passive gap, physically continuous). Set false when a passive wait ends the block or the
   recipe is complete. Every step must have this field.
9. NEVER place a step from another recipe immediately after a step whose isAtomicWithNext is true
   without first completing the Atomic Block.
''';

  String _buildPrompt(
    List<RecipeModel> recipes,
    DateTime mealTime,
    String customInstructions,
  ) {
    final buffer = StringBuffer();
    buffer.writeln(
        'Target meal time: ${mealTime.toUtc().toIso8601String()}');
    buffer.writeln('Recipes:');

    for (final recipe in recipes) {
      buffer.writeln(
          '\n--- Recipe: ${recipe.title} (recipeId MUST be exactly: "${recipe.id}") ---');
      buffer.writeln(
          'Total time: ${recipe.totalTimeMinutes} minutes, Active: ${recipe.activeTimeMinutes} minutes');
      for (final step in recipe.steps) {
        final timer = step.timerSeconds != null
            ? ' [timer: ${step.timerSeconds! ~/ 60} min]'
            : '';
        buffer.writeln(
            'Step ${step.stepNumber}: ${step.instruction}$timer');
      }
    }

    if (customInstructions.isNotEmpty) {
      buffer.writeln(
          '\nAdditional instructions from the cook:\n$customInstructions');
    }

    return buffer.toString();
  }

  DailyPlanModel _parseTimeline(
    String rawJson,
    DailyPlanModel plan,
    DateTime mealTime,
    List<RecipeModel> recipes,
  ) {
    final cleaned = rawJson
        .replaceAll(RegExp(r'^```[a-z]*\s*', multiLine: true), '')
        .replaceAll(RegExp(r'```\s*$', multiLine: true), '')
        .trim();

    final List<dynamic> items = jsonDecode(cleaned) as List<dynamic>;
    final recipeMap = {for (final r in recipes) r.id: r};
    // Fallback: match by title slug (e.g. "honey-garlic-salmon" → recipe with that title)
    final slugMap = {
      for (final r in recipes)
        r.title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-'): r,
    };

    final events = <TimelineEventModel>[];
    for (final item in items) {
      final map = item as Map<String, dynamic>;
      final recipeId = map['recipeId'] as String;
      final stepNumber = (map['stepNumber'] as num).toInt();
      final minutesBefore = (map['minutesBeforeMeal'] as num).toInt();
      final durationMin = (map['durationMinutes'] as num).toInt();
      final jsonInstruction = map['instruction'] as String?;

      final recipe = recipeMap[recipeId] ?? slugMap[recipeId];
      if (recipe == null) {
        AppLogger.w('Orchestrator: unknown recipeId "$recipeId" — skipping step');
        continue;
      }

      // For cooking steps (stepNumber >= 1), look up the recipe step for
      // timerSeconds and as a fallback instruction.
      final recipeStep = stepNumber >= 1
          ? recipe.steps.where((s) => s.stepNumber == stepNumber).firstOrNull
          : null;

      final instruction = (jsonInstruction != null && jsonInstruction.isNotEmpty)
          ? jsonInstruction
          : (recipeStep?.instruction ?? '');

      final startTime = mealTime.subtract(Duration(minutes: minutesBefore));
      final endTime = startTime.add(Duration(minutes: durationMin));

      events.add(TimelineEventModel(
        recipeId: recipeId,
        recipeTitle: recipe.title,
        stepNumber: stepNumber,
        instruction: instruction,
        startTime: startTime.toIso8601String(),
        endTime: endTime.toIso8601String(),
        timerSeconds: recipeStep?.timerSeconds,
      ));
    }

    // Validate: no recipe interleaving inside an Atomic Block
    for (int i = 0; i < items.length - 1; i++) {
      final item = items[i] as Map<String, dynamic>;
      final isAtomic = (item['isAtomicWithNext'] as bool?) ?? false;
      if (!isAtomic) continue;
      final nextItem = items[i + 1] as Map<String, dynamic>;
      if ((item['recipeId'] as String) != (nextItem['recipeId'] as String)) {
        throw const _AtomicViolationException();
      }
    }

    // Compute start times per recipe (earliest step start time)
    final updatedRecipes = plan.recipes.map((pr) {
      final recipeEvents =
          events.where((e) => e.recipeId == pr.recipeId).toList();
      if (recipeEvents.isEmpty) return pr;
      recipeEvents
          .sort((a, b) => a.startTime.compareTo(b.startTime));
      return pr.copyWith(
          computedStartTime: recipeEvents.first.startTime);
    }).toList();

    return plan.copyWith(
      recipes: updatedRecipes,
      timeline: events,
    );
  }
}

class _AtomicViolationException implements Exception {
  const _AtomicViolationException();
}
