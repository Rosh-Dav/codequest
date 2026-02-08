
import 'package:flutter/material.dart';

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
  final int languageId; // Judge0 language id
  final IconData? icon;
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
    this.languageId = 50, // default C
    this.icon,
    this.isLocked = true,
    required this.x,
    required this.y,
  });
}

enum SceneType {
  none,
  deepSpace,     // Generic galaxy view
  darkSpaceship, // M1: Emergency lights, dark
  engineRoom,    // Legacy/Rune City
  cockpit,       // Legacy/Rune City
  energyCore,    // M2: Unstable glowing core
  commandSystem, // M3: Security/Keywords
  signalRoom,    // M4: Data types/Signals
  displayPanels, // M5: Output/Holograms
  pilotConsole,  // M6: Input/Scanf
  calculationCore,// M7: Operators
  autopilotAI,   // M8: Conditions/Meteor threats
  thrusterRoom,  // M9: Loops
  commandRouter, // M10: Switch Case
  moduleFactory, // M11: Functions
  dataVault,     // M12: Arrays
  memoryLab,     // M13: Pointers
  blueprintLab,  // M14: Structures
  hyperspace,    // Mission completion transition
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
