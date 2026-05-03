import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/utils/logger.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) => AuthRepository();

class AuthRepository {
  AuthRepository() : _auth = FirebaseAuth.instance;

  final FirebaseAuth _auth;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<User> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      AppLogger.i('Signed in: ${credential.user?.email}');
      return credential.user!;
    } on FirebaseAuthException catch (e, st) {
      AppLogger.e('FirebaseAuthException', e, st);
      throw AuthException(_mapFirebaseError(e), e);
    } catch (e, st) {
      AppLogger.e('Unexpected auth error', e, st);
      if (e is AuthException) rethrow;
      throw AuthException('כניסה נכשלה. נסה שוב.', e);
    }
  }

  Future<User> registerWithEmail(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      AppLogger.i('Registered: ${credential.user?.email}');
      return credential.user!;
    } on FirebaseAuthException catch (e, st) {
      AppLogger.e('FirebaseAuthException', e, st);
      throw AuthException(_mapFirebaseError(e), e);
    } catch (e, st) {
      AppLogger.e('Unexpected register error', e, st);
      if (e is AuthException) rethrow;
      throw AuthException('הרשמה נכשלה. נסה שוב.', e);
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      AppLogger.i('Password reset sent to $email');
    } on FirebaseAuthException catch (e, st) {
      AppLogger.e('FirebaseAuthException', e, st);
      throw AuthException(_mapFirebaseError(e), e);
    }
  }

  Future<User> signInWithFacebook() async {
    try {
      final result = await FacebookAuth.instance.login();
      if (result.status != LoginStatus.success) {
        throw AuthException('כניסה עם Facebook בוטלה.');
      }
      final credential = FacebookAuthProvider.credential(
        result.accessToken!.tokenString,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      AppLogger.i('Signed in via Facebook: ${userCredential.user?.email}');
      return userCredential.user!;
    } on FirebaseAuthException catch (e, st) {
      AppLogger.e('Facebook FirebaseAuthException', e, st);
      throw AuthException(_mapFirebaseError(e), e);
    } catch (e, st) {
      AppLogger.e('Facebook auth error', e, st);
      if (e is AuthException) rethrow;
      throw AuthException('כניסה עם Facebook נכשלה. נסה שוב.', e);
    }
  }

  Future<void> signOut() async {
    await FacebookAuth.instance.logOut();
    await _auth.signOut();
    AppLogger.i('User signed out.');
  }

  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'אימייל או סיסמה שגויים.';
      case 'email-already-in-use':
        return 'כתובת האימייל כבר רשומה במערכת.';
      case 'weak-password':
        return 'הסיסמה חלשה מדי — נדרשות לפחות 6 תווים.';
      case 'invalid-email':
        return 'כתובת האימייל אינה תקינה.';
      case 'too-many-requests':
        return 'יותר מדי ניסיונות. נסה שוב מאוחר יותר.';
      default:
        return e.message ?? 'אירעה שגיאה. נסה שוב.';
    }
  }
}
