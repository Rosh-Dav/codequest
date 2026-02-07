import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/story_state.dart';

/// Service for managing local storage operations using SharedPreferences
class LocalStorageService {
  static const String _keyUsername = 'username';
  static const String _keySelectedLanguage = 'selectedLanguage';
  static const String _keySelectedStoryMode = 'selectedStoryMode';
  static const String _keyOnboardingCompleted = 'onboardingCompleted';
  static const String _keyStoryState = 'storyState';

  // Singleton pattern
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  SharedPreferences? _prefs;

  /// Initialize SharedPreferences
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Ensure preferences are initialized
  Future<SharedPreferences> get _preferences async {
    if (_prefs == null) {
      await init();
    }
    return _prefs!;
  }

  // ==================== User Preferences ====================

  /// Save username
  Future<bool> saveUsername(String username) async {
    final prefs = await _preferences;
    return prefs.setString(_keyUsername, username);
  }

  /// Get username
  Future<String?> getUsername() async {
    final prefs = await _preferences;
    return prefs.getString(_keyUsername);
  }

  /// Save selected language
  Future<bool> saveSelectedLanguage(String language) async {
    final prefs = await _preferences;
    return prefs.setString(_keySelectedLanguage, language);
  }

  /// Get selected language
  Future<String?> getSelectedLanguage() async {
    final prefs = await _preferences;
    return prefs.getString(_keySelectedLanguage);
  }

  /// Save selected story mode
  Future<bool> saveSelectedStoryMode(String storyMode) async {
    final prefs = await _preferences;
    return prefs.setString(_keySelectedStoryMode, storyMode);
  }

  /// Get selected story mode
  Future<String?> getSelectedStoryMode() async {
    final prefs = await _preferences;
    return prefs.getString(_keySelectedStoryMode);
  }

  /// Save onboarding completed flag
  Future<bool> saveOnboardingCompleted(bool completed) async {
    final prefs = await _preferences;
    return prefs.setBool(_keyOnboardingCompleted, completed);
  }

  /// Get onboarding completed flag
  Future<bool> getOnboardingCompleted() async {
    final prefs = await _preferences;
    return prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  // ==================== Story State ====================

  /// Save story state
  Future<bool> saveStoryState(StoryState state) async {
    final prefs = await _preferences;
    final jsonString = jsonEncode(state.toJson());
    return prefs.setString(_keyStoryState, jsonString);
  }

  /// Get story state
  Future<StoryState?> getStoryState() async {
    final prefs = await _preferences;
    final jsonString = prefs.getString(_keyStoryState);
    
    if (jsonString == null) return null;
    
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return StoryState.fromJson(json);
    } catch (e) {
      // If parsing fails, return null
      return null;
    }
  }

  // ==================== Utility Methods ====================

  /// Clear all stored data (for reset/logout)
  Future<bool> clearAll() async {
    final prefs = await _preferences;
    return prefs.clear();
  }

  /// Clear only story progress (keep user preferences)
  Future<bool> clearStoryProgress() async {
    final prefs = await _preferences;
    return prefs.remove(_keyStoryState);
  }
}
