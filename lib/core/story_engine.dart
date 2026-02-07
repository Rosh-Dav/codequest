import '../models/story_state.dart';
import '../services/local_storage_service.dart';

class StoryEngine {
  final LocalStorageService _storage = LocalStorageService();
  
  // Singleton pattern
  static final StoryEngine _instance = StoryEngine._internal();
  factory StoryEngine() => _instance;
  StoryEngine._internal();

  /// Initialize the Python ByteStar Arena story
  Future<void> initializePythonStory() async {
    final state = StoryState(
      storyStarted: true,
      currentPhase: 1,
      currentMission: 1,
      completedMissions: [],
    );
    await _storage.saveStoryState(state);
  }

  /// Get current mission data based on state
  /// Returns map with mission details
  Future<Map<String, dynamic>?> getCurrentMissionData() async {
    final state = await _storage.getStoryState();
    if (state == null) return null;

    final missionId = '${state.currentPhase}-${state.currentMission}';
    
    // Returns mission data structure
    switch (missionId) {
      case '1-1':
        return {
          'phase': 1,
          'mission': 1,
          'title': 'First Signal',
          'description': 'The ship cannot send messages. Without output, we are blind. Let\'s send our first signal.',
          'objectives': ['Use print()', 'Put text in quotes', 'Write: print("System Online")'],
          'template': '',
          'solution_pattern': r'^\s*print\s*\(\s*["\u0027]System Online["\u0027]\s*\)\s*$', // Regex for print("System Online")
          'success_message': 'COMMUNICATION RESTORED. SIGNAL RECEIVED.',
          'type': 'output',
        };
      case '1-2':
        return {
          'phase': 1,
          'mission': 2,
          'title': 'Energy Labeling',
          'description': 'Energy has no identity. We must label it.',
          'objectives': ['Give energy a name', 'Use =', 'fuel = 60'],
          'template': '',
          'solution_pattern': r'^\s*[a-zA-Z_][a-zA-Z0-9_]*\s*=\s*\d+(\.\d+)?\s*$', // Valid variable assignment
          'success_message': 'ENERGY STABILIZED. POWER LEVELS NOMINAL.',
          'type': 'variable',
        };
        case '1-3':
        return {
          'phase': 1,
          'mission': 3,
          'title': 'Signal Formats',
          'description': 'Not all data is the same. Each type needs proper format.',
          'objectives': ['Assign an integer', 'Assign a float', 'Assign a string', 'Assign a boolean'],
          'template': '# Define variables below\n',
          'success_message': 'DECODER SYNCHRONIZED. DATA FLOW NORMAL.',
          'type': 'datatypes',
        };
      default:
        return null;
    }
  }

  /// Validate mission submission
  bool validateMission(String code, Map<String, dynamic> missionData) {
    if (code.trim().isEmpty) return false;

    final type = missionData['type'] as String;
    
    if (type == 'output' || type == 'variable') {
      final pattern = missionData['solution_pattern'] as String;
      final regex = RegExp(pattern);
      return regex.hasMatch(code);
    } else if (type == 'datatypes') {
      // Custom validation for Mission 3 (Data Types)
      // Check for int, float, str, bool
      bool hasInt = RegExp(r'=\s*\d+\s*$').hasMatch(code) || RegExp(r'=\s*\d+\s*\n').hasMatch(code);
      bool hasFloat = RegExp(r'=\s*\d+\.\d+').hasMatch(code);
      bool hasStr = RegExp(r'=\s*["\u0027].*["\u0027]').hasMatch(code);
      bool hasBool = RegExp(r'=\s*(True|False)').hasMatch(code);
      
      return hasInt && hasFloat && hasStr && hasBool;
    }
    
    return false;
  }

  /// Mark current mission as complete and advance
  Future<void> completeCurrentMission() async {
    final state = await _storage.getStoryState();
    if (state == null) return;

    final currentMissionId = '${state.currentPhase}-${state.currentMission}';
    final newCompleted = List<String>.from(state.completedMissions);
    if (!newCompleted.contains(currentMissionId)) {
      newCompleted.add(currentMissionId);
    }

    // Logic to advance to next mission
    int nextMission = state.currentMission + 1;
    
    // For this implementation limited to Mission 3
    if (nextMission > 3) {
      // End of implemented content
    }

    final newState = state.copyWith(
      currentMission: nextMission,
      completedMissions: newCompleted,
    );
    
    await _storage.saveStoryState(newState);
  }
}
