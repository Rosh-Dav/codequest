import 'package:flutter/material.dart';
import '../../models/bytestar_data.dart'; // Reuse SceneType and helper enums if possible

// Enums for Scene Types specific to Python if needed, but reusing global for now
// We might need to map the new scenes (Communication Deck, Power Chamber, etc.) 
// to existing SceneTypes or add new ones. 
// For this plan, I will assume we can reuse or map them, 
// or I will add them to the main bytestar_data file if required. 
// Given the prompt's specific visual descriptions, I'll use closest matches or generic 'custom'.

class PythonMission {
  final String id;
  final String title;
  final String concept;
  final String sceneName; // For UI display
  final SceneType sceneType; // For background animation
  final List<String> introDialogue;
  final PythonTeachingModule? teachingModule;
  final PythonCodingTask task;
  final double x;
  final double y;
  final bool isLocked;
  final String successMessage;

  const PythonMission({
    required this.id,
    required this.title,
    required this.concept,
    required this.sceneName,
    required this.sceneType,
    required this.introDialogue,
    this.teachingModule,
    required this.task,
    required this.x,
    required this.y,
    this.isLocked = true,
    required this.successMessage,
  });
}

class PythonTeachingModule {
  final String codeSnippet;
  final List<PythonTeachingStep> steps;

  const PythonTeachingModule({
    required this.codeSnippet,
    required this.steps,
  });
}

class PythonTeachingStep {
  final String explanation;
  final List<int> highlightedLines; // 0-indexed line numbers
  final String? focusElement; // For specific word highlighting

  const PythonTeachingStep({
    required this.explanation,
    this.highlightedLines = const [],
    this.focusElement,
  });
}

class PythonCodingTask {
  final String instruction;
  final String initialCode;
  final String expectedInput; // For validator reference
  final List<String> hints;
  final List<PythonValidationRule> validationRules;

  const PythonCodingTask({
    required this.instruction,
    required this.initialCode,
    required this.expectedInput,
    required this.hints,
    required this.validationRules,
  });
}

class PythonValidationRule {
  final String pattern;
  final String errorMessage;
  final bool isNegative; // If true, pattern MUST NOT be present

  const PythonValidationRule({
    required this.pattern,
    required this.errorMessage,
    this.isNegative = false,
  });
}

// ---------------------------------------------------------------------------
// MISSION DATA
// ---------------------------------------------------------------------------

final List<PythonMission> pythonMissions = [
  // MILLION 1: FIRST SIGNAL
  PythonMission(
    id: 'py1',
    title: 'FIRST SIGNAL',
    concept: 'print()',
    sceneName: 'Communication Deck',
    sceneType: SceneType.commandSystem, 
    introDialogue: [
      'The ship cannot send messages.',
      'Without output, we are blind.',
      'Let’s send our first signal.',
    ],
    teachingModule: const PythonTeachingModule(
      codeSnippet: 'print("System Online")',
      steps: [
        PythonTeachingStep(
          explanation: 'print sends text to the screen.',
          focusElement: 'print',
        ),
        PythonTeachingStep(
          explanation: 'Anything inside quotes appears.',
          focusElement: '"System Online"',
        ),
      ],
    ),
    task: const PythonCodingTask(
      instruction: 'Enter EXACTLY: print("System Online")',
      initialCode: '# Write your code here\n',
      expectedInput: 'print("System Online")',
      hints: [
        'You need to display text.',
        'Use print().',
        'Write: print("System Online")',
      ],
      validationRules: [
        PythonValidationRule(pattern: 'print(', errorMessage: 'Must start with: print('),
        PythonValidationRule(pattern: '"', errorMessage: 'Must contain double quotes'),
        PythonValidationRule(pattern: 'System Online', errorMessage: 'Must contain: System Online'),
        PythonValidationRule(pattern: ')', errorMessage: 'Must end with )'),
        PythonValidationRule(pattern: 'print("System Online")', errorMessage: 'Output format incorrect. Check spacing and case.', isNegative: false),
      ],
    ),
    x: 0.1,
    y: 0.8,
    isLocked: false,
    successMessage: 'Signal received. Communication restored. Well done, Engineer.',
  ),

  // MISSION 2: ENERGY LABELING
  PythonMission(
    id: 'py2',
    title: 'ENERGY LABELING',
    concept: 'Variables',
    sceneName: 'Power Chamber',
    sceneType: SceneType.engineRoom,
    introDialogue: [
      'Energy has no identity.',
      'We must label it.',
    ],
    teachingModule: const PythonTeachingModule(
      codeSnippet: 'power = 80',
      steps: [
        PythonTeachingStep(
          explanation: 'power is the variable name. It represents stored energy.',
          focusElement: 'power',
        ),
        PythonTeachingStep(
          explanation: '= assigns a value.',
          focusElement: '=',
        ),
        PythonTeachingStep(
          explanation: '80 is the stored value.',
          focusElement: '80',
        ),
      ],
    ),
    task: const PythonCodingTask(
      instruction: 'Create: fuel = 60',
      initialCode: '# Assign variable here\n',
      expectedInput: 'fuel = 60',
      hints: [
        'Give energy a name.',
        'Use = to connect name and value.',
        'Write: fuel = 60',
      ],
      validationRules: [
        PythonValidationRule(pattern: 'fuel', errorMessage: 'Variable name must be fuel.'),
        PythonValidationRule(pattern: '=', errorMessage: 'Use only one = sign.'),
        PythonValidationRule(pattern: '60', errorMessage: 'Value must be 60.'),
        PythonValidationRule(pattern: '"', errorMessage: 'Numbers should not be inside quotes.', isNegative: true),
        PythonValidationRule(pattern: '==', errorMessage: 'Use = for assignment, not ==.', isNegative: true),
      ],
    ),
    x: 0.2,
    y: 0.6,
    isLocked: true,
    successMessage: 'Excellent. The fuel system now has identity. We can control it.',
  ),

  // MISSION 3: SIGNAL FORMATS
  PythonMission(
    id: 'py3',
    title: 'SIGNAL FORMATS',
    concept: 'Data Types',
    sceneName: 'Decoder Room',
    sceneType: SceneType.signalRoom,
    introDialogue: [
      'Not all data is the same.',
      'Each type needs proper format.',
      'We can also scan data to see its exact type.',
    ],
    teachingModule: const PythonTeachingModule(
      codeSnippet: 'count = 10\ntemp = 36.5\nname = "Astra"\nready = True\n\ntype(count)',
      steps: [
        PythonTeachingStep(explanation: 'Numbers without decimals are integers (int).'),
        PythonTeachingStep(explanation: 'Numbers with decimals are floats (float).'),
        PythonTeachingStep(explanation: 'Text inside quotes is a string (str).'),
        PythonTeachingStep(explanation: 'True and False represent system status (bool).'),
        PythonTeachingStep(explanation: 'type() scans data to tell us its kind.'),
      ],
    ),
    task: const PythonCodingTask(
      instruction: 'Create one int, float, string, bool. Check each with type().',
      initialCode: '# Define variables and check types\n',
      expectedInput: 'level = 5\nheat = 42.7\nship = "Nova"\nactive = True\ntype(level)\ntype(heat)\ntype(ship)\ntype(active)',
      hints: [
        'Numbers without . are int.',
        'Use quotes for text.',
        'True/False for status.',
        'Use type() to check data.',
      ],
      validationRules: [
        PythonValidationRule(pattern: 'type(', errorMessage: 'You forgot to use type() scanner.'),
        // Complex validation will be logic-based in engine, but these are patterns
        PythonValidationRule(pattern: '"', errorMessage: 'Text must be inside quotes.'),
        PythonValidationRule(pattern: 'True', errorMessage: 'Boolean must be True or False (capitalized).'),
      ],
    ),
    x: 0.3,
    y: 0.4,
    isLocked: true,
    successMessage: 'Perfect. The system now understands every signal. Data is flowing correctly.',
  ),

  // MISSION 4: COMMAND RECEIVER
  PythonMission(
    id: 'py4',
    title: 'COMMAND RECEIVER',
    concept: 'input()',
    sceneName: 'Cockpit Controls',
    sceneType: SceneType.pilotConsole,
    introDialogue: [
      'We can’t receive commands.',
      'The cockpit is disconnected.',
      'Let’s activate the listener.',
    ],
    teachingModule: const PythonTeachingModule(
      codeSnippet: 'cmd = input()',
      steps: [
        PythonTeachingStep(explanation: 'Proteins communicate. input() waits for user typing.'),
        PythonTeachingStep(explanation: 'The result is stored in the variable on the left.'),
      ],
    ),
    task: const PythonCodingTask(
      instruction: 'Create: name = input()',
      initialCode: '# Receive input\n',
      expectedInput: 'name = input()',
      hints: [
        'Use input()',
        'Store in variable',
        'name = input()',
      ],
      validationRules: [
        PythonValidationRule(pattern: 'name', errorMessage: 'Store the result in name.'),
        PythonValidationRule(pattern: 'input()', errorMessage: 'input() needs parentheses.'),
        PythonValidationRule(pattern: '=', errorMessage: 'Assign the input to variable.'),
      ],
    ),
    x: 0.3,
    y: 0.7,
    isLocked: true,
    successMessage: 'Command received. Cockpit online.',
  ),

  // MISSION 5: DATA CONVERTER
  PythonMission(
    id: 'py5',
    title: 'DATA CONVERTER',
    concept: 'Type Casting',
    sceneName: 'Converter Core',
    sceneType: SceneType.calculationCore, 
    introDialogue: [
      'Input is always text.',
      'We must convert it.',
    ],
    teachingModule: const PythonTeachingModule(
      codeSnippet: 'age = int(input())',
      steps: [
        PythonTeachingStep(explanation: 'input() gives text.'),
        PythonTeachingStep(explanation: 'int() converts it to a number.'),
      ],
    ),
    task: const PythonCodingTask(
      instruction: 'Create: speed = int(input())',
      initialCode: '# Convert input\n',
      expectedInput: 'speed = int(input())',
      hints: [
        'input gives text',
        'Wrap with int()',
        'int(input())',
      ],
      validationRules: [
        PythonValidationRule(pattern: 'speed', errorMessage: 'Variable name is speed.'),
        PythonValidationRule(pattern: 'int(', errorMessage: 'Wrap input() inside int().'),
        PythonValidationRule(pattern: 'input()', errorMessage: 'Don\'t forget input().'),
      ],
    ),
    x: 0.4,
    y: 0.8,
    isLocked: true,
    successMessage: 'Speed system online. Conversion successful.',
  ),

  // MISSION 6: MATH CORE
  PythonMission(
    id: 'py6',
    title: 'MATH CORE',
    concept: 'Operators',
    sceneName: 'Calculation Chamber',
    sceneType: SceneType.calculationCore,
    introDialogue: [
      'The system cannot calculate correctly.',
      'Without operators, logic collapses.',
      'Operators connect values and actions.',
    ],
    teachingModule: const PythonTeachingModule(
      codeSnippet: 'print(a + b)\nprint(a * b)',
      steps: [
        PythonTeachingStep(explanation: 'Standard math operators: + - * /'),
      ],
    ),
    task: const PythonCodingTask(
      instruction: 'Create: eff = fuel / time',
      initialCode: 'fuel = 100\ntime = 2\n# Calculate efficiency\n',
      expectedInput: 'eff = fuel / time',
      hints: [
        'Use / for division',
        'Store result',
        'fuel / time',
      ],
      validationRules: [
        PythonValidationRule(pattern: 'eff', errorMessage: 'Store result in eff.'),
        PythonValidationRule(pattern: '/', errorMessage: 'Use / for division.'),
      ],
    ),
    x: 0.5,
    y: 0.6,
    isLocked: true,
    successMessage: 'Calculation stable. Efficiency maximized.',
  ),

  // MISSION 7: ENGINEER NOTES
  PythonMission(
    id: 'py7',
    title: 'ENGINEER NOTES',
    concept: 'Comments',
    sceneName: 'Maintenance Log Room',
    sceneType: SceneType.memoryLab,
    introDialogue: [
      'Humans forget.',
      'Comments help us remember.',
      'Good code explains itself.',
    ],
    teachingModule: const PythonTeachingModule(
      codeSnippet: '# This controls fuel system\nfuel = 60',
      steps: [
        PythonTeachingStep(explanation: 'Anything after # is ignored by Python.'),
        PythonTeachingStep(explanation: 'It is only for humans.'),
      ],
    ),
    task: const PythonCodingTask(
      instruction: 'Add comment: # Set ship speed before the code.',
      initialCode: 'speed = 80\n',
      expectedInput: '# Set ship speed\nspeed = 80',
      hints: [
        'Use #',
        'Write before line',
        'Explain purpose',
      ],
      validationRules: [
        PythonValidationRule(pattern: '#', errorMessage: 'Comments must start with #.'),
      ],
    ),
    x: 0.5,
    y: 0.3,
    isLocked: true,
    successMessage: 'Log system clear. Documentation restored.',
  ),

  // MISSION 8: ALIGNMENT SYSTEM
  PythonMission(
    id: 'py8',
    title: 'ALIGNMENT SYSTEM',
    concept: 'Indentation',
    sceneName: 'Structure Core',
    sceneType: SceneType.blueprintLab,
    introDialogue: [
      'Python reads spaces.',
      'Structure depends on alignment.',
      'One wrong space can break the system.',
    ],
    teachingModule: const PythonTeachingModule(
      codeSnippet: 'if x > 5:\n    print("High")',
      steps: [
        PythonTeachingStep(explanation: 'The code inside the block must be indented (pushed right).'),
      ],
    ),
    task: const PythonCodingTask(
      instruction: 'Fix indentation: if speed > 50: print("Fast")',
      initialCode: 'if speed > 50:\nprint("Fast")',
      expectedInput: 'if speed > 50:\n    print("Fast")',
      hints: [
        'Indent print line',
        'Use 4 spaces or tab',
      ],
      validationRules: [], // Checked by structure logic
    ),
    x: 0.6,
    y: 0.5,
    isLocked: true,
    successMessage: 'Structure stable. Blocks aligned.',
  ),

  // MISSION 9: DECISION UNIT
  PythonMission(
    id: 'py9',
    title: 'DECISION UNIT',
    concept: 'if / elif / else',
    sceneName: 'Auto-Pilot Chamber',
    sceneType: SceneType.autopilotAI,
    introDialogue: [
      'The system cannot choose.',
      'We must give it rules.',
    ],
    teachingModule: const PythonTeachingModule(
      codeSnippet: 'if fuel > 50:\n    print("Safe")\nelif fuel > 20:\n    print("Low")\nelse:\n    print("Critical")',
      steps: [
        PythonTeachingStep(explanation: 'if checks first.'),
        PythonTeachingStep(explanation: 'elif checks if previous failed.'),
        PythonTeachingStep(explanation: 'else catches everything else.'),
      ],
    ),
    task: const PythonCodingTask(
      instruction: 'Write full if/elif/else logic for fuel levels.',
      initialCode: 'fuel = 30\n# Write logic here\n',
      expectedInput: '', // Complex
      hints: [
        'if, then elif, then else',
        'Mind indentation',
      ],
      validationRules: [
        PythonValidationRule(pattern: 'if ', errorMessage: 'Start with if.'),
        PythonValidationRule(pattern: 'elif ', errorMessage: 'Use elif for secondary check.'),
        PythonValidationRule(pattern: 'else:', errorMessage: 'End with else:.'),
      ],
    ),
    x: 0.7,
    y: 0.7,
    isLocked: true,
    successMessage: 'Navigation optimal. Decisions logic active.',
  ),

  // MISSION 10: AUTO-REPEATER
  PythonMission(
    id: 'py10',
    title: 'AUTO-REPEATER',
    concept: 'for Loop',
    sceneName: 'Calibration Bay',
    sceneType: SceneType.moduleFactory,
    introDialogue: [
      'Humans repeat.',
      'Programs automate.',
    ],
    teachingModule: const PythonTeachingModule(
      codeSnippet: 'for i in range(5):\n    print("Adjusting...")',
      steps: [
        PythonTeachingStep(explanation: 'for loop repeats code a specific number of times.'),
      ],
    ),
    task: const PythonCodingTask(
      instruction: 'Loop 3 times printing "Calibrate".',
      initialCode: '# loop here\n',
      expectedInput: 'for i in range(3):\n    print("Calibrate")',
      hints: [
        'for i in range(3):',
        'Indent the print',
      ],
      validationRules: [
        PythonValidationRule(pattern: 'range(3)', errorMessage: 'Use range(3).'),
        PythonValidationRule(pattern: 'for ', errorMessage: 'Start with for.'),
      ],
    ),
    x: 0.8,
    y: 0.5,
    isLocked: true,
    successMessage: 'Automation active. Repeater online.',
  ),

  // MISSION 11: CONTINUOUS MONITOR
  PythonMission(
    id: 'py11',
    title: 'CONTINUOUS MONITOR',
    concept: 'while Loop',
    sceneName: 'Life Support Room',
    sceneType: SceneType.engineRoom, // Reusing engine room vibe
    introDialogue: [
      'Some systems must run forever.',
      'Until a condition changes.',
    ],
    teachingModule: const PythonTeachingModule(
      codeSnippet: 'while oxygen > 0:\n    oxygen -= 1\n    print(oxygen)',
      steps: [
        PythonTeachingStep(explanation: 'while loops run as long as the condition is True.'),
      ],
    ),
    task: const PythonCodingTask(
      instruction: 'While fuel > 0, decrease fuel by 1.',
      initialCode: 'fuel = 10\n# write while loop\n',
      expectedInput: 'while fuel > 0:\n    fuel -= 1',
      hints: [
        'while fuel > 0:',
        'fuel -= 1',
      ],
      validationRules: [
        PythonValidationRule(pattern: 'while ', errorMessage: 'Use while.'),
        PythonValidationRule(pattern: '-=', errorMessage: 'Decrease value (-= 1).'),
      ],
    ),
    x: 0.9,
    y: 0.3,
    isLocked: true,
    successMessage: 'Monitoring active. Life support stable.',
  ),
];
