import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cook_history_model.freezed.dart';
part 'cook_history_model.g.dart';

@freezed
abstract class CookHistoryModel with _$CookHistoryModel {
  const factory CookHistoryModel({
    required String id,
    required String recipeId,
    required String userId,
    required int servingsCooked,
    required DateTime cookedAt,
    String? notes,
    @Default(0) int rating, // 0 = unrated, 1–5
  }) = _CookHistoryModel;

  factory CookHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$CookHistoryModelFromJson(json);
}

extension CookHistoryModelFirestore on CookHistoryModel {
  static CookHistoryModel fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CookHistoryModel.fromJson({
      ...data,
      'id': doc.id,
      'cookedAt': (data['cookedAt'] as Timestamp).toDate().toIso8601String(),
    });
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    json['cookedAt'] = Timestamp.fromDate(cookedAt);
    return json;
  }
}
