import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    required String username,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user != null) {
      await credential.user!.updateDisplayName(username);
      await _ensureUserProfile(
        credential.user!,
        username: username,
        provider: 'password',
      );
    }

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

    if (credential.user != null) {
      await _ensureUserProfile(
        credential.user!,
        provider: 'password',
      );
    }

    return credential;
  }

  Future<void> signOut() async {
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
      debugPrint('Firestore Error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('General Firestore Error: $e');
      rethrow;
    }
  }
}
