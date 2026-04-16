import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/firestore_constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/utils/logger.dart';
import '../models/cooking_session_model.dart';

part 'cooking_session_repository.g.dart';

@riverpod
CookingSessionRepository cookingSessionRepository(Ref ref) =>
    CookingSessionRepository();

class CookingSessionRepository {
  CookingSessionRepository() : _firestore = FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  final _uuid = const Uuid();

  CollectionReference<Map<String, dynamic>> _sessionsRef(String uid) =>
      _firestore
          .collection(FirestoreConstants.usersCollection)
          .doc(uid)
          .collection(FirestoreConstants.cookingSessionsCollection);

  Stream<List<CookingSessionModel>> watchSessions(String uid) {
    return _sessionsRef(uid)
        .orderBy('startedAt', descending: true)
        .limit(20)
        .snapshots()
        .map((snap) => snap.docs
            .map(CookingSessionModelFirestore.fromFirestore)
            .toList());
  }

  Future<CookingSessionModel?> fetchActiveSession(String uid) async {
    try {
      final snap = await _sessionsRef(uid)
          .orderBy('startedAt', descending: true)
          .limit(10)
          .get();
      return snap.docs
          .map(CookingSessionModelFirestore.fromFirestore)
          .where((s) => s.completedAt == null)
          .firstOrNull;
    } catch (e, st) {
      AppLogger.e('fetchActiveSession failed', e, st);
      return null;
    }
  }

  Future<String> saveSession(CookingSessionModel session) async {
    try {
      final id = session.id.isEmpty ? _uuid.v4() : session.id;
      final toSave = session.copyWith(id: id);
      await _sessionsRef(toSave.userId)
          .doc(id)
          .set(toSave.toFirestore(), SetOptions(merge: true));
      AppLogger.i('Saved cooking session $id');
      return id;
    } catch (e, st) {
      AppLogger.e('saveSession failed', e, st);
      throw PlannerException('Failed to save session.', e);
    }
  }

  Future<void> updateProgress(CookingSessionModel session) async {
    if (session.id.isEmpty) return;
    try {
      final update = <String, dynamic>{
        'recipeProgress': session.recipeProgress,
        'activeRecipeId': session.activeRecipeId,
        'completedRecipeIds': session.completedRecipeIds,
        'miseEnPlaceChecked': session.miseEnPlaceChecked,
        if (session.completedAt != null)
          'completedAt':
              Timestamp.fromDate(DateTime.parse(session.completedAt!)),
      };
      await _sessionsRef(session.userId).doc(session.id).update(update);
    } catch (e, st) {
      AppLogger.e('updateProgress failed', e, st);
      // Non-fatal: UI state is still correct.
    }
  }

  Future<void> deleteSession(String uid, String sessionId) async {
    try {
      await _sessionsRef(uid).doc(sessionId).delete();
    } catch (e, st) {
      AppLogger.e('deleteSession failed', e, st);
      throw PlannerException('Failed to delete session.', e);
    }
  }
}
