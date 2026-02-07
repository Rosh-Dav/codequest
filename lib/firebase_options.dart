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
    apiKey: 'AIzaSyCx81Xh1kktSsRNt3_wmPmKHCDn1N_MIaY',
    authDomain: 'codequest-aa086.firebaseapp.com',
    projectId: 'codequest-aa086',
    storageBucket: 'codequest-aa086.firebasestorage.app',
    messagingSenderId: '1087734660069',
    appId: '1:1087734660069:web:e57ac0ca8b28e9fa888d0c',
    measurementId: 'G-QR96KJL767',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD7c-PsfrFTrFGqeRz7iJt_G18JjOwUc0A',
    appId: '1:1087734660069:android:8f4be13819152e05888d0c',
    messagingSenderId: '1087734660069',
    projectId: 'codequest-aa086',
    storageBucket: 'codequest-aa086.firebasestorage.app',
  );
}
