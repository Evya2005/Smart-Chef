// THIS FILE IS GENERATED — DO NOT EDIT MANUALLY.
// Run: flutterfire configure
// See: https://firebase.flutter.dev/docs/cli

// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// IMPORTANT: Replace these placeholder values by running:
///   flutterfire configure
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web. '
        'Reconfigure your app using flutterfire configure.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAgHAwG3IsNPL3O0jNR2xm79qm3XxcsGJA',
    appId: '1:367461305373:android:56f56502dbcb1e97470af4',
    messagingSenderId: '367461305373',
    projectId: 'smart-chef-28189',
    storageBucket: 'smart-chef-28189.firebasestorage.app',
  );

  // ─── REPLACE THESE VALUES AFTER RUNNING `flutterfire configure` ───────────

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC61iODU5n3wIJl_2wEDmq3Bzhn-f8ATRc',
    appId: '1:367461305373:ios:ad1f85fe0327b7cd470af4',
    messagingSenderId: '367461305373',
    projectId: 'smart-chef-28189',
    storageBucket: 'smart-chef-28189.firebasestorage.app',
    iosBundleId: 'com.smartchef.smartChef',
  );

  // ──────────────────────────────────────────────────────────────────────────
}