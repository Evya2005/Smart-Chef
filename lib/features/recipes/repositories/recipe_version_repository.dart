import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/firestore_constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/utils/logger.dart';
import '../models/recipe_model.dart';
import '../models/recipe_version_model.dart';

part 'recipe_version_repository.g.dart';

@riverpod
RecipeVersionRepository recipeVersionRepository(Ref ref) =>
    RecipeVersionRepository();

class RecipeVersionRepository {
  RecipeVersionRepository() : _firestore = FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  final _uuid = const Uuid();

  CollectionReference<Map<String, dynamic>> _versionsRef(
    String uid,
    String recipeId,
  ) =>
      _firestore
          .collection(FirestoreConstants.usersCollection)
          .doc(uid)
          .collection(FirestoreConstants.recipesCollection)
          .doc(recipeId)
          .collection(FirestoreConstants.versionsCollection);

  Stream<List<RecipeVersionModel>> watchVersions(
      String uid, String recipeId) {
    return _versionsRef(uid, recipeId)
        .orderBy('versionNumber', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) =>
                RecipeVersionModelFirestore.fromFirestore(doc))
            .toList());
  }

  Future<void> saveVersion(
    String uid,
    RecipeModel currentRecipe,
    String? changeNote,
  ) async {
    try {
      final id = _uuid.v4();
      final version = RecipeVersionModel(
        id: id,
        versionNumber: currentRecipe.version,
        snapshot: currentRecipe,
        savedAt: DateTime.now(),
        changeNote: changeNote,
      );
      await _versionsRef(uid, currentRecipe.id)
          .doc(id)
          .set(version.toFirestore());
      AppLogger.i(
          'Saved version ${currentRecipe.version} for recipe ${currentRecipe.id}');
    } catch (e, st) {
      AppLogger.e('saveVersion failed', e, st);
      throw VersionException('Failed to save version.', e);
    }
  }
}
