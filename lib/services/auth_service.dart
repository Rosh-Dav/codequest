import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn? _googleSignIn = kIsWeb ? null : GoogleSignIn();

  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    required String username,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await credential.user?.updateDisplayName(username);
    await _ensureUserProfile(
      credential.user!,
      username: username,
      provider: 'password',
    );

    return credential;
  }

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _ensureUserProfile(
      credential.user!,
      provider: 'password',
    );

    return credential;
  }

  Future<UserCredential?> signInWithGoogle() async {
    if (kIsWeb) {
      final provider = GoogleAuthProvider();
      provider.addScope('email');
      final credential = await _auth.signInWithPopup(provider);
      await _ensureUserProfile(
        credential.user!,
        provider: 'google',
      );
      return credential;
    }

    final googleUser = await _googleSignIn!.signIn();
    if (googleUser == null) {
      return null;
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    await _ensureUserProfile(
      userCredential.user!,
      provider: 'google',
    );
    return userCredential;
  }

  Future<void> signOut() async {
    await _googleSignIn?.signOut();
    await _auth.signOut();
  }

  Future<void> _ensureUserProfile(
    User user, {
    String? username,
    required String provider,
  }) async {
    final docRef = _db.collection('users').doc(user.uid);
    try {
      final snapshot = await docRef.get();

      final displayName = username ??
          user.displayName ??
          user.email?.split('@').first ??
          'Coder';

      if (!snapshot.exists) {
        await docRef.set({
          'uid': user.uid,
          'email': user.email,
          'username': displayName,
          'provider': provider,
          'createdAt': FieldValue.serverTimestamp(),
        });
        return;
      }

      await docRef.set({
        'email': user.email,
        'username': displayName,
        'provider': provider,
        'lastLoginAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      // Allow login to proceed when offline; profile will sync later.
      if (e.code == 'unavailable' || e.code == 'network-request-failed') {
        return;
      }
      rethrow;
    }
  }
}
