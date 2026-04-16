import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../shared/models/cook_step_model.dart';
import '../../../shared/models/ingredient_model.dart';

part 'recipe_model.freezed.dart';
part 'recipe_model.g.dart';

@freezed
abstract class RecipeModel with _$RecipeModel {
  const factory RecipeModel({
    required String id,
    required String userId,
    required String title,
    String? description,
    String? notes,
    required List<String> tags,
    required int activeTimeMinutes,
    required int totalTimeMinutes,
    required int defaultServings,
    required List<IngredientModel> ingredients,
    required List<CookStepModel> steps,
    String? imageUrl,
    String? sourceUrl,
    String? sourceType,
    @Default('שונות') String category,
    @Default(1) int version,
    String? forkedFromId,
    @Default(false) bool isPublic,
    @Default(false) bool isFavorite,
    @Default(0) int rating,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RecipeModel;

  factory RecipeModel.fromJson(Map<String, dynamic> json) =>
      _$RecipeModelFromJson(json);
}

/// Firestore serialization helpers — kept separate from the pure model.
extension RecipeModelFirestore on RecipeModel {
  static RecipeModel fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RecipeModel.fromJson({
      ...data,
      'id': doc.id,
      'createdAt': (data['createdAt'] as Timestamp).toDate().toIso8601String(),
      'updatedAt': (data['updatedAt'] as Timestamp).toDate().toIso8601String(),
    });
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id'); // stored as the doc ID, not a field
    json['createdAt'] = Timestamp.fromDate(createdAt);
    json['updatedAt'] = Timestamp.fromDate(updatedAt);
    return json;
  }
}
