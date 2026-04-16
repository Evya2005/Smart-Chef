import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/firestore_constants.dart';

part 'user_settings_repository.g.dart';

@riverpod
UserSettingsRepository userSettingsRepository(Ref ref) =>
    UserSettingsRepository();

class UserSettingsRepository {
  UserSettingsRepository() : _firestore = FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _firestore.collection(FirestoreConstants.usersCollection).doc(uid);

  Future<void> saveApiKey(String uid, String key) =>
      _userDoc(uid).set({'geminiApiKey': key}, SetOptions(merge: true));

  Stream<String?> watchApiKey(String uid) => _userDoc(uid)
      .snapshots()
      .map((doc) => doc.data()?['geminiApiKey'] as String?);

  Future<void> clearApiKey(String uid) =>
      _userDoc(uid).update({'geminiApiKey': FieldValue.delete()});
}
