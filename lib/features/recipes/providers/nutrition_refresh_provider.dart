import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/repositories/auth_repository.dart';
import '../../settings/providers/user_settings_provider.dart';
import '../providers/recipe_list_provider.dart';
import '../repositories/recipe_repository.dart';
import '../services/nutrition_refresh_service.dart';

part 'nutrition_refresh_provider.g.dart';

enum NutritionRefreshStatus { idle, running, done, error }

@riverpod
class NutritionRefresh extends _$NutritionRefresh {
  @override
  NutritionRefreshStatus build() => NutritionRefreshStatus.idle;

  Future<void> runNow() async {
    state = NutritionRefreshStatus.idle;
    await runIfNeeded();
  }

  Future<void> runIfNeeded() async {
    if (state != NutritionRefreshStatus.idle) return;
    final recipes = ref.read(recipeListProvider).value;
    if (recipes == null) return;
    final withoutNutrition =
        recipes.where((r) => r.nutrition == null).toList();
    if (withoutNutrition.isEmpty) {
      state = NutritionRefreshStatus.done;
      return;
    }
    state = NutritionRefreshStatus.running;
    final uid = ref.read(authRepositoryProvider).currentUser?.uid;
    if (uid == null) {
      state = NutritionRefreshStatus.error;
      return;
    }
    final apiKey = ref.read(geminiApiKeyProvider).asData?.value ?? '';
    final repo = ref.read(recipeRepositoryProvider);
    final service = NutritionRefreshService(apiKey: apiKey);
    try {
      for (var i = 0; i < withoutNutrition.length; i += 3) {
        final batch = withoutNutrition.skip(i).take(3).toList();
        await Future.wait(batch.map((r) async {
          final nutrition = await service.fetchNutrition(r);
          if (nutrition != null) {
            await repo.updateNutritionField(uid, r.id, nutrition);
          }
        }));
      }
      state = NutritionRefreshStatus.done;
    } catch (_) {
      state = NutritionRefreshStatus.error;
    }
  }
}
