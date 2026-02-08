import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/story_state.dart';

class SyncService {
  FirebaseFirestore get _db => FirebaseFirestore.instance;
  FirebaseAuth get _auth => FirebaseAuth.instance;

  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  User? get currentUser {
    try {
      return _auth.currentUser;
    } catch (_) {
      return null;
    }
  }

  /// Syncs the entire story state to Firestore
  Future<void> syncStoryState(StoryState state) async {
    final user = currentUser;
    if (user == null) return;

    try {
      await _db.collection('users').doc(user.uid).set({
        'storyState': state.toJson(),
        'lastSyncAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error syncing story state: $e');
    }
  }

  /// Syncs individual progress updates
  Future<void> syncProgress(String missionId, bool isCompleted) async {
    final user = currentUser;
    if (user == null) return;

    try {
      await _db.collection('users').doc(user.uid).collection('progress').doc(missionId).set({
        'isCompleted': isCompleted,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error syncing progress: $e');
    }
  }

  /// Syncs user settings/preferences
  Future<void> syncPreferences({
    String? username,
    String? selectedLanguage,
    String? selectedStoryMode,
  }) async {
    final user = currentUser;
    if (user == null) return;

    final Map<String, dynamic> data = {
      'lastSyncAt': FieldValue.serverTimestamp(),
    };
    
    if (username != null) data['username'] = username;
    if (selectedLanguage != null) data['selectedLanguage'] = selectedLanguage;
    if (selectedStoryMode != null) data['selectedStoryMode'] = selectedStoryMode;

    try {
      await _db.collection('users').doc(user.uid).set(data, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error syncing preferences: $e');
    }
  }
}
