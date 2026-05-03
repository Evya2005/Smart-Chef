import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'planned_recipe_model.dart';
import 'timeline_event_model.dart';

part 'daily_plan_model.freezed.dart';
part 'daily_plan_model.g.dart';

@freezed
abstract class DailyPlanModel with _$DailyPlanModel {
  const factory DailyPlanModel({
    required String id,
    required String userId,
    required String mealTime, // ISO8601
    required List<PlannedRecipeModel> recipes,
    List<TimelineEventModel>? timeline,
    required String createdAt, // ISO8601
    @Default('') String notes,
    @Default('') String customInstructions,
  }) = _DailyPlanModel;

  factory DailyPlanModel.fromJson(Map<String, dynamic> json) =>
      _$DailyPlanModelFromJson(json);
}

extension DailyPlanModelFirestore on DailyPlanModel {
  static DailyPlanModel fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DailyPlanModel.fromJson({
      ...data,
      'id': doc.id,
      'mealTime': (data['mealTime'] is Timestamp)
          ? (data['mealTime'] as Timestamp).toDate().toLocal().toIso8601String()
          : data['mealTime'],
      'createdAt': (data['createdAt'] is Timestamp)
          ? (data['createdAt'] as Timestamp).toDate().toLocal().toIso8601String()
          : data['createdAt'],
    });
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    json['mealTime'] =
        Timestamp.fromDate(DateTime.parse(mealTime));
    json['createdAt'] =
        Timestamp.fromDate(DateTime.parse(createdAt));
    return json;
  }
}
