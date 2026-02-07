
class Mission {
  final String id;
  final String title;
  final String description;
  final String concept;
  final String introVideoId; // Placeholder ID for video asset
  final SceneType openingScene; // New: Defines the visual mood
  final List<String> dialogueLines;
  final TeachingModule? teachingModule; // New: Interactive line-by-line lesson
  final CodingTask task;
  final bool isLocked;
  final double x; // Map X coordinate (0.0 to 1.0)
  final double y; // Map Y coordinate (0.0 to 1.0)

  const Mission({
    required this.id,
    required this.title,
    required this.description,
    required this.concept,
    required this.introVideoId,
    this.openingScene = SceneType.none,
    required this.dialogueLines,
    this.teachingModule,
    required this.task,
    this.isLocked = true,
    required this.x,
    required this.y,
  });
}

enum SceneType {
  none,
  darkSpaceship, // M1: Emergency lights, dark
  engineRoom,    // M2: Blue flickers
  cockpit,       // M3-M6 etc
}

class TeachingModule {
  final String codeSnippet;
  final List<TeachingStep> steps;

  const TeachingModule({
    required this.codeSnippet,
    required this.steps,
  });
}

class TeachingStep {
  final String explanation; // NOVA speaks this
  final List<int> highlightedLines; // 1-based line numbers
  final String visualAssetId; // Icon/Animation trigger

  const TeachingStep({
    required this.explanation,
    required this.highlightedLines,
    required this.visualAssetId,
  });
}

class CodingTask {
  final String instruction;
  final String initialCode;
  final String correctOutput;
  final List<ValidationRule> validationRules; // New: Specific error checks
  final List<String> hints;

  const CodingTask({
    required this.instruction,
    required this.initialCode,
    required this.correctOutput,
    this.validationRules = const [],
    required this.hints,
  });
}

class ValidationRule {
  final String pattern; // Retry pattern
  final String errorMessage; // NOVA response
  final bool isMustContain; // true = must exist, false = must not exist

  const ValidationRule({
    required this.pattern,
    required this.errorMessage,
    this.isMustContain = true,
  });
}

class ByteStarProgress {
  final String currentMissionId;
  final int xp;
  final double shipIntegrity;
  final List<String> unlockedBadges;

  const ByteStarProgress({
    required this.currentMissionId,
    required this.xp,
    required this.shipIntegrity,
    required this.unlockedBadges,
  });
}
