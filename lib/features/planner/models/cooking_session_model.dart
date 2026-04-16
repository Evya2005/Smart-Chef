import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../shared/models/unit_type.dart';

part 'cooking_session_model.freezed.dart';
part 'cooking_session_model.g.dart';

/// An aggregated prep item across all recipes in a session.
@freezed
abstract class MiseEnPlaceItemModel with _$MiseEnPlaceItemModel {
  const factory MiseEnPlaceItemModel({
    required String id,
    required String name,
    required double quantity,
    required UnitType unit,
    String? prepNote,
    @Default([]) List<String> forRecipeIds,
  }) = _MiseEnPlaceItemModel;

  factory MiseEnPlaceItemModel.fromJson(Map<String, dynamic> json) =>
      _$MiseEnPlaceItemModelFromJson(json);
}

/// Tracks a live multi-recipe cooking session.
@freezed
abstract class CookingSessionModel with _$CookingSessionModel {
  const factory CookingSessionModel({
    required String id,
    required String userId,
    /// Ordered list of recipe IDs (longest-first suggested order).
    required List<String> recipeIds,
    /// Current step index per recipe (recipeId → stepIndex).
    @Default({}) Map<String, int> recipeProgress,
    /// Which recipe is currently in focus.
    String? activeRecipeId,
    /// Optional target ready time (ISO8601).
    String? targetReadyTime,
    /// When the session was started (ISO8601).
    required String startedAt,
    /// Non-null when all recipes are done (ISO8601).
    String? completedAt,
    @Default([]) List<String> completedRecipeIds,
    /// Aggregated mise en place items across all recipes.
    @Default([]) List<MiseEnPlaceItemModel> miseEnPlace,
    /// Which mise en place items have been checked off (itemId → done).
    @Default({}) Map<String, bool> miseEnPlaceChecked,
    /// Snapshot of recipe titles at session-creation time (recipeId → title).
    @Default({}) Map<String, String> recipeNames,
  }) = _CookingSessionModel;

  factory CookingSessionModel.fromJson(Map<String, dynamic> json) =>
      _$CookingSessionModelFromJson(json);
}

extension CookingSessionModelFirestore on CookingSessionModel {
  static CookingSessionModel fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CookingSessionModel.fromJson({
      ...data,
      'id': doc.id,
      'startedAt': data['startedAt'] is Timestamp
          ? (data['startedAt'] as Timestamp).toDate().toLocal().toIso8601String()
          : data['startedAt'],
      'completedAt': data['completedAt'] is Timestamp
          ? (data['completedAt'] as Timestamp)
              .toDate()
              .toLocal()
              .toIso8601String()
          : data['completedAt'],
      'targetReadyTime': data['targetReadyTime'] is Timestamp
          ? (data['targetReadyTime'] as Timestamp)
              .toDate()
              .toLocal()
              .toIso8601String()
          : data['targetReadyTime'],
      // Firestore returns Map values as dynamic; cast to int.
      'recipeProgress':
          (data['recipeProgress'] as Map<String, dynamic>?)
                  ?.map((k, v) => MapEntry(k, (v as num).toInt())) ??
              {},
      'miseEnPlaceChecked':
          (data['miseEnPlaceChecked'] as Map<String, dynamic>?)
                  ?.map((k, v) => MapEntry(k, v as bool)) ??
              {},
      'recipeNames':
          (data['recipeNames'] as Map<String, dynamic>?)
                  ?.map((k, v) => MapEntry(k, v as String)) ??
              {},
    });
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    json['startedAt'] = Timestamp.fromDate(DateTime.parse(startedAt));
    if (completedAt != null) {
      json['completedAt'] = Timestamp.fromDate(DateTime.parse(completedAt!));
    }
    if (targetReadyTime != null) {
      json['targetReadyTime'] =
          Timestamp.fromDate(DateTime.parse(targetReadyTime!));
    }
    return json;
  }
}
