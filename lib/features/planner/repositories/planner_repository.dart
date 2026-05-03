import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/firestore_constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/utils/logger.dart';
import '../models/daily_plan_model.dart';

part 'planner_repository.g.dart';

@riverpod
PlannerRepository plannerRepository(Ref ref) => PlannerRepository();

class PlannerRepository {
  PlannerRepository() : _firestore = FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  final _uuid = const Uuid();

  CollectionReference<Map<String, dynamic>> _plansRef(String uid) =>
      _firestore
          .collection(FirestoreConstants.usersCollection)
          .doc(uid)
          .collection(FirestoreConstants.dailyPlansCollection);

  Stream<List<DailyPlanModel>> watchPlans(String uid) {
    return _plansRef(uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => DailyPlanModelFirestore.fromFirestore(doc))
            .toList());
  }

  Future<DailyPlanModel> fetchPlan(String uid, String planId) async {
    final doc = await _plansRef(uid).doc(planId).get();
    if (!doc.exists) throw const PlannerException('Plan not found.');
    return DailyPlanModelFirestore.fromFirestore(doc);
  }

  Future<String> savePlan(DailyPlanModel plan) async {
    try {
      final id = plan.id.isEmpty ? _uuid.v4() : plan.id;
      final toSave = plan.copyWith(id: id);
      await _plansRef(toSave.userId).doc(id).set(toSave.toFirestore());
      AppLogger.i('Saved plan $id');
      return id;
    } catch (e, st) {
      AppLogger.e('savePlan failed', e, st);
      throw PlannerException('Failed to save plan.', e);
    }
  }

  Future<void> deletePlan(String uid, String planId) async {
    try {
      await _plansRef(uid).doc(planId).delete();
    } catch (e, st) {
      AppLogger.e('deletePlan failed', e, st);
      throw PlannerException('Failed to delete plan.', e);
    }
  }
}
