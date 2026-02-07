import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        throw UnsupportedError('DefaultFirebaseOptions are not configured for this platform.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAqGrexj9DXnaA9bzo8TKFEtaU-fFpsa8k',
    authDomain: 'codequest-game-v1.firebaseapp.com',
    projectId: 'codequest-game-v1',
    storageBucket: 'codequest-game-v1.firebasestorage.app',
    messagingSenderId: '17271084874',
    appId: '1:17271084874:web:576cb9a4a99af31a7853b3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCAIn9fTPDUT67-ly8Dwfr5vUE-djbyWlw',
    appId: '1:17271084874:android:e565eae27303dd487853b3',
    messagingSenderId: '17271084874',
    projectId: 'codequest-game-v1',
    storageBucket: 'codequest-game-v1.firebasestorage.app',
  );
}
