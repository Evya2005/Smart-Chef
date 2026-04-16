import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/firestore_constants.dart';
import '../../../core/utils/logger.dart';

part 'categories_repository.g.dart';

@riverpod
CategoriesRepository categoriesRepository(Ref ref) =>
    CategoriesRepository();

class CategoriesRepository {
  final _doc = FirebaseFirestore.instance
      .collection(FirestoreConstants.appConfigCollection)
      .doc(FirestoreConstants.categoriesDocument);

  Stream<List<String>> watchCategories() {
    return _doc.snapshots().map((snap) {
      if (!snap.exists) return AppConstants.kRecipeCategories;
      final raw = snap.data()?['list'];
      if (raw is List && raw.isNotEmpty) {
        return List<String>.from(raw);
      }
      return AppConstants.kRecipeCategories;
    });
  }

  Future<void> saveCategories(List<String> categories) async {
    try {
      await _doc.set({'list': categories}, SetOptions(merge: true));
    } catch (e, st) {
      AppLogger.e('CategoriesRepository: saveCategories failed', e, st);
      rethrow;
    }
  }
}
