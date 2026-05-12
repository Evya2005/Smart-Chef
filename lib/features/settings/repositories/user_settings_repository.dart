import 'dart:async';

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

  Future<void> saveApifyApiKey(String uid, String key) =>
      _userDoc(uid).set({'apifyApiKey': key}, SetOptions(merge: true));

  Stream<String?> watchApifyApiKey(String uid) => _userDoc(uid)
      .snapshots()
      .map((doc) => doc.data()?['apifyApiKey'] as String?);

  Future<void> clearApifyApiKey(String uid) =>
      _userDoc(uid).update({'apifyApiKey': FieldValue.delete()});

  Future<String?> fetchOwnerEmail(String userId) async {
    // 1. Check user_profiles — written on each login
    final profileDoc = await _firestore
        .collection(FirestoreConstants.userProfilesCollection)
        .doc(userId)
        .get();
    final profileEmail = profileDoc.data()?['email'] as String?;
    if (profileEmail != null) return profileEmail;

    // 2. Fallback: scan public_recipes for a doc from this user that has ownerEmail
    final snap = await _firestore
        .collection(FirestoreConstants.publicRecipesCollection)
        .where('userId', isEqualTo: userId)
        .limit(20)
        .get();
    for (final doc in snap.docs) {
      final email = doc.data()['ownerEmail'] as String?;
      if (email != null) {
        // Cache it in user_profiles so future lookups skip this query.
        unawaited(_firestore
            .collection(FirestoreConstants.userProfilesCollection)
            .doc(userId)
            .set({'email': email}, SetOptions(merge: true)));
        return email;
      }
    }

    return null;
  }
}
