import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/firestore_constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/utils/logger.dart';
import '../models/recipe_model.dart';
import 'recipe_version_repository.dart';

part 'recipe_repository.g.dart';

@riverpod
RecipeRepository recipeRepository(Ref ref) => RecipeRepository();

class RecipeRepository {
  RecipeRepository() : _firestore = FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  final _uuid = const Uuid();

  CollectionReference<Map<String, dynamic>> _recipesRef(String uid) =>
      _firestore
          .collection(FirestoreConstants.usersCollection)
          .doc(uid)
          .collection(FirestoreConstants.recipesCollection);

  CollectionReference<Map<String, dynamic>> get _publicRef =>
      _firestore.collection(FirestoreConstants.publicRecipesCollection);

  Stream<RecipeModel> watchRecipe(String uid, String recipeId) {
    return _recipesRef(uid).doc(recipeId).snapshots().map(
          (doc) => RecipeModelFirestore.fromFirestore(doc),
        );
  }

  /// Watches the recipe from the user's own collection.
  /// If the doc doesn't exist there, falls back to a one-time read from public_recipes.
  Stream<RecipeModel> watchRecipeWithFallback(
      String uid, String recipeId) async* {
    await for (final doc in _recipesRef(uid).doc(recipeId).snapshots()) {
      if (doc.exists) {
        yield RecipeModelFirestore.fromFirestore(doc);
      } else {
        final publicDoc = await _publicRef.doc(recipeId).get();
        if (publicDoc.exists) {
          yield RecipeModelFirestore.fromFirestore(publicDoc);
        } else {
          throw RecipeException('Recipe $recipeId not found.');
        }
      }
    }
  }

  Stream<List<RecipeModel>> watchRecipes(String uid) {
    return _recipesRef(uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => RecipeModelFirestore.fromFirestore(doc))
              .toList(),
        );
  }

  Stream<List<RecipeModel>> watchPublicRecipes() =>
      _publicRef
          .orderBy('updatedAt', descending: true)
          .snapshots()
          .map((s) =>
              s.docs.map(RecipeModelFirestore.fromFirestore).toList());

  Future<RecipeModel> fetchRecipeWithFallback(
      String uid, String recipeId) async {
    final doc = await _recipesRef(uid).doc(recipeId).get();
    if (doc.exists) return RecipeModelFirestore.fromFirestore(doc);
    final publicDoc = await _publicRef.doc(recipeId).get();
    if (publicDoc.exists) return RecipeModelFirestore.fromFirestore(publicDoc);
    throw RecipeException('Recipe $recipeId not found.');
  }

  Future<RecipeModel> fetchRecipe(String uid, String recipeId) async {
    try {
      final doc = await _recipesRef(uid).doc(recipeId).get();
      if (!doc.exists) {
        throw RecipeException('Recipe $recipeId not found.');
      }
      return RecipeModelFirestore.fromFirestore(doc);
    } catch (e, st) {
      AppLogger.e('fetchRecipe failed', e, st);
      if (e is RecipeException) rethrow;
      throw RecipeException('Failed to load recipe.', e);
    }
  }

  Future<String> saveRecipe(RecipeModel recipe) async {
    try {
      final id = recipe.id.isEmpty ? _uuid.v4() : recipe.id;
      final now = DateTime.now();
      final toSave = recipe.copyWith(
        id: id,
        createdAt: recipe.createdAt,
        updatedAt: now,
      );
      if (toSave.isPublic) {
        final batch = _firestore.batch();
        batch.set(_recipesRef(toSave.userId).doc(id), toSave.toFirestore());
        batch.set(_publicRef.doc(id), toSave.toFirestore());
        await batch.commit();
      } else {
        await _recipesRef(toSave.userId).doc(id).set(toSave.toFirestore());
      }
      AppLogger.i('Saved recipe $id');
      return id;
    } catch (e, st) {
      AppLogger.e('saveRecipe failed', e, st);
      throw RecipeException('Failed to save recipe.', e);
    }
  }

  Future<void> updateRecipe(RecipeModel recipe,
      {String? changeNote}) async {
    try {
      // Auto-save version snapshot before overwriting.
      final versionRepo = RecipeVersionRepository();
      await versionRepo.saveVersion(recipe.userId, recipe, changeNote);

      final updated = recipe.copyWith(
        updatedAt: DateTime.now(),
        version: recipe.version + 1,
      );

      if (updated.isPublic) {
        final batch = _firestore.batch();
        batch.update(
            _recipesRef(recipe.userId).doc(recipe.id), updated.toFirestore());
        batch.set(_publicRef.doc(recipe.id), updated.toFirestore());
        await batch.commit();
      } else {
        await _recipesRef(recipe.userId)
            .doc(recipe.id)
            .update(updated.toFirestore());
      }
      AppLogger.i('Updated recipe ${recipe.id} to v${updated.version}');
    } catch (e, st) {
      AppLogger.e('updateRecipe failed', e, st);
      throw RecipeException('Failed to update recipe.', e);
    }
  }

  /// Toggles the public visibility of a recipe.
  /// When making public: writes the full doc to public_recipes.
  /// When making private: removes it from public_recipes.
  Future<void> togglePublic(
      String uid, String recipeId, bool isPublic) async {
    try {
      if (isPublic) {
        final recipe = await fetchRecipe(uid, recipeId);
        final updated = recipe.copyWith(
            isPublic: true, updatedAt: DateTime.now());
        final batch = _firestore.batch();
        batch.update(_recipesRef(uid).doc(recipeId), {
          'isPublic': true,
          'updatedAt': Timestamp.fromDate(updated.updatedAt),
        });
        batch.set(_publicRef.doc(recipeId), updated.toFirestore());
        await batch.commit();
      } else {
        final batch = _firestore.batch();
        batch.update(
            _recipesRef(uid).doc(recipeId), {'isPublic': false});
        batch.delete(_publicRef.doc(recipeId));
        await batch.commit();
      }
      AppLogger.i('togglePublic $recipeId → $isPublic');
    } catch (e, st) {
      AppLogger.e('togglePublic failed', e, st);
      throw RecipeException('Failed to toggle public.', e);
    }
  }

  /// Creates a fork (copy) of [source] with a new ID and returns the new ID.
  Future<String> forkRecipe(String uid, RecipeModel source) async {
    try {
      final newId = _uuid.v4();
      final now = DateTime.now();
      final forked = source.copyWith(
        id: newId,
        userId: uid,
        title: '${source.title} (עותק)',
        version: 1,
        forkedFromId: source.id,
        isFavorite: false,
        isPublic: false,
        createdAt: now,
        updatedAt: now,
      );
      await _recipesRef(uid).doc(newId).set(forked.toFirestore());
      AppLogger.i('Forked recipe ${source.id} → $newId');
      return newId;
    } catch (e, st) {
      AppLogger.e('forkRecipe failed', e, st);
      throw RecipeException('Failed to fork recipe.', e);
    }
  }

  Future<void> toggleFavorite(
      String uid, String recipeId, bool isFavorite) async {
    await _recipesRef(uid).doc(recipeId).update({'isFavorite': isFavorite});
  }

  Future<void> setRating(String uid, String recipeId, int rating) async {
    await _recipesRef(uid).doc(recipeId).update({'rating': rating});
  }

  /// Updates only the category field. No version snapshot is created (migration use).
  Future<void> updateCategoryField(
      String uid, String recipeId, String? category) async {
    await _recipesRef(uid).doc(recipeId).update({'category': category});
  }

  Future<void> deleteRecipe(String uid, String recipeId) async {
    try {
      final batch = _firestore.batch();
      batch.delete(_recipesRef(uid).doc(recipeId));
      batch.delete(_publicRef.doc(recipeId));
      await batch.commit();
      AppLogger.i('Deleted recipe $recipeId');
    } catch (e, st) {
      AppLogger.e('deleteRecipe failed', e, st);
      throw RecipeException('Failed to delete recipe.', e);
    }
  }
}
