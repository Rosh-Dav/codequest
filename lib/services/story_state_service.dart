import 'package:shared_preferences/shared_preferences.dart';
import '../core/level_manager.dart';

class StoryStateService {
  static const String _keyStoryStarted = 'phase1_storyStarted';
  static const String _keyCurrentPhase = 'phase1_currentPhase';
  static const String _keyCurrentMission = 'phase1_currentMission';
  // Tracks the highest unlocked mission
  static const String _keyMaxMission = 'phase1_maxMission'; 
  static const String _keyPhaseTheme = 'phase1_phaseTheme';
  static const String _keyNovaUnlocked = 'phase1_novaUnlocked';
  static const String _keyXP = 'phase1_xp';

  // Singleton
  static final StoryStateService _instance = StoryStateService._internal();
  factory StoryStateService() => _instance;
  StoryStateService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Getters
  bool get storyStarted => _prefs?.getBool(_keyStoryStarted) ?? false;
  int get currentPhase => _prefs?.getInt(_keyCurrentPhase) ?? 0;
  int get currentMission => _prefs?.getInt(_keyCurrentMission) ?? 1;
  int get maxMission => _prefs?.getInt(_keyMaxMission) ?? 1;
  String get phaseTheme => _prefs?.getString(_keyPhaseTheme) ?? '';
  bool get novaUnlocked => _prefs?.getBool(_keyNovaUnlocked) ?? false;
  int get xp => _prefs?.getInt(_keyXP) ?? 0;

  // Setters
  Future<void> startStory() async {
    await init();
    await _prefs?.setBool(_keyStoryStarted, true);
    await _prefs?.setInt(_keyCurrentPhase, 1);
    await _prefs?.setInt(_keyCurrentMission, 1);
    await _prefs?.setInt(_keyMaxMission, 1);
    await _prefs?.setString(_keyPhaseTheme, 'System Awakening');
    await _prefs?.setBool(_keyNovaUnlocked, true);
    await _prefs?.setInt(_keyXP, 0); // Reset XP or keep? Assuming part of story progress.
  }

  Future<void> completeMission(int missionId, int earnedXp) async {
    await init();
    
    // Update XP
    int currentXp = xp;
    await _prefs?.setInt(_keyXP, currentXp + earnedXp);

    // Update Progress in Story Service
    if (missionId >= maxMission) {
      await _prefs?.setInt(_keyMaxMission, missionId + 1);
      await _prefs?.setInt(_keyCurrentMission, missionId + 1);
    }
    
    // Update Level Manager (Unlocks next level)
    await LevelManager().completeLevel(missionId);
  }

  Future<void> resetStory() async {
    await init();
    await _prefs?.remove(_keyStoryStarted);
    await _prefs?.remove(_keyCurrentPhase);
    await _prefs?.remove(_keyCurrentMission);
    await _prefs?.remove(_keyMaxMission);
    await _prefs?.remove(_keyPhaseTheme);
    await _prefs?.remove(_keyNovaUnlocked);
    await _prefs?.remove(_keyXP);
  }
}
