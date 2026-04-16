import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'recipe_model.dart';

part 'recipe_version_model.freezed.dart';
part 'recipe_version_model.g.dart';

@freezed
abstract class RecipeVersionModel with _$RecipeVersionModel {
  const factory RecipeVersionModel({
    required String id,
    required int versionNumber,
    required RecipeModel snapshot,
    required DateTime savedAt,
    String? changeNote,
  }) = _RecipeVersionModel;

  factory RecipeVersionModel.fromJson(Map<String, dynamic> json) =>
      _$RecipeVersionModelFromJson(json);
}

extension RecipeVersionModelFirestore on RecipeVersionModel {
  static RecipeVersionModel fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RecipeVersionModel.fromJson({
      ...data,
      'id': doc.id,
      'savedAt': (data['savedAt'] as Timestamp).toDate().toIso8601String(),
    });
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    json['savedAt'] = Timestamp.fromDate(savedAt);
    return json;
  }
}
