import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/bytestar_theme.dart';
import '../../models/bytestar_data.dart';
import '../../widgets/bytestar/nova_hologram.dart';
import '../../widgets/bytestar/animated_space_background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mission_engine_screen.dart';
import 'python_mission_screen.dart';

class MissionMapScreen extends StatefulWidget {
  final String username;
  final String selectedLanguage;

  const MissionMapScreen({
    super.key,
    required this.username,
    this.selectedLanguage = 'C',
  });

  @override
  State<MissionMapScreen> createState() => _MissionMapScreenState();
}

class _MissionMapScreenState extends State<MissionMapScreen> {
  // Full 14-Mission Map
  final List<Mission> missions = [
    Mission(
      id: 'm1',
      title: 'Wake Up ASTRA-X',
      description: 'Initialize the main communication mainframe.',
      concept: 'Output & Main',
      introVideoId: 'intro_v1',
      openingScene: SceneType.darkSpaceship,
      dialogueLines: [
        'System Initialization failure...',
        'Cadet, I am NOVA, the ship\'s AI.',
        'My core mainframe is offline. I need you to run the startup script.',
        'In C programming, every program starts with a specific function.',
      ],
      teachingModule: const TeachingModule(
        codeSnippet: '#include <stdio.h>\n\nint main() {\n    printf("Systems Online");\n    return 0;\n}',
        steps: [
           TeachingStep(
             explanation: 'This "main" function is the entry point. It is where everything begins.',
             highlightedLines: [3],
             visualAssetId: 'engine_start',
           ),
           TeachingStep(
             explanation: 'The "printf" command prints text to the screen. It stands for "print formatted".',
             highlightedLines: [4],
             visualAssetId: 'brackets',
           ),
           TeachingStep(
             explanation: 'We return 0 to tell the computer the program finished successfully.',
             highlightedLines: [5],
             visualAssetId: 'check_mark',
           ),
        ],
      ),
      task: const CodingTask(
        instruction: 'Write a program that prints "Hello ASTRA" to the console.',
        initialCode: '#include <stdio.h>\n\nint main() {\n    // Write your code here\n    \n    return 0;\n}',
        correctOutput: 'Hello ASTRA',
        validationRules: [
           ValidationRule(pattern: 'printf', errorMessage: 'You need to use "printf" to print to the screen.'),
           ValidationRule(pattern: 'Hello ASTRA', errorMessage: 'Make sure you print exactly "Hello ASTRA".'),
           ValidationRule(pattern: ';', errorMessage: 'Every command in C must end with a semicolon ;'),
           ValidationRule(pattern: '"', errorMessage: 'Text must be inside double quotes "like this".'),
        ],
        hints: ['Use printf("Hello ASTRA");'],
      ),
      isLocked: false,
      x: 0.1,
      y: 0.8,
    ),
    Mission(
      id: 'm2',
      title: 'Stabilize Power Core',
      description: 'Stabilize the energy core variables.',
      concept: 'Variables',
      introVideoId: 'intro_v2',
      openingScene: SceneType.engineRoom,
      dialogueLines: [
        'Excellent work on the startup sequence!',
        'However, the core energy levels are unstable.',
        'We need to store the power value in a memory container.',
        'In programming, we call these containers "Variables".',
      ],
      teachingModule: const TeachingModule(
        codeSnippet: 'int power_level = 100;\nfloat temperature = 98.6;\nchar system_status = \'A\';',
        steps: [
          TeachingStep(
            explanation: 'Variables are like box containers. "int" means this box can only hold whole numbers.',
            highlightedLines: [1],
            visualAssetId: 'toolbox',
          ),
          TeachingStep(
            explanation: 'We give the box a name, "power_level", so we can find it later.',
            highlightedLines: [1],
            visualAssetId: 'brackets',
          ),
          TeachingStep(
            explanation: 'The equals sign "=" puts the value 100 inside the box.',
            highlightedLines: [1],
            visualAssetId: 'engine_start',
          ),
        ],
      ),
      task: const CodingTask(
        instruction: 'Create an integer variable named "power" and assign it the value 100.',
        initialCode: '// TODO: Declare variable here\n',
        correctOutput: '', 
        validationRules: [
           ValidationRule(pattern: 'int', errorMessage: 'You need an integer container. Start with "int".'),
           ValidationRule(pattern: 'power', errorMessage: 'The variable must be named "power".'),
           ValidationRule(pattern: '=', errorMessage: 'Use "=" to assign a value.'),
           ValidationRule(pattern: '100', errorMessage: 'The power level must be exactly 100.'),
           ValidationRule(pattern: ';', errorMessage: 'Don\'t forget the semicolon ; at the end!'),
        ],
        hints: ['Type: int power = 100;'],
      ),
      isLocked: true,
      x: 0.2,
      y: 0.6,
    ),
    Mission(
      id: 'm3',
      title: 'Protected Command System',
      description: 'System locked. Keywords required.',
      concept: 'Keywords',
      introVideoId: 'intro_v3',
      openingScene: SceneType.commandSystem,
      dialogueLines: [
        'Access denied. The command system is protected.',
        'We need to identify the correct keywords to bypass the lock.',
        'C has reserved words that cannot be used as variable names.',
      ],
      task: const CodingTask(
        instruction: 'Identify valid variable names (not keywords). Declare an int named "code".',
        initialCode: '// TODO: Declare a valid variable\n',
        correctOutput: '',
        validationRules: [
           ValidationRule(pattern: 'int code', errorMessage: 'Declare "int code".'),
           ValidationRule(pattern: 'int if', errorMessage: '"if" is a keyword. You cannot use it as a name!', isMustContain: false),
           ValidationRule(pattern: 'int return', errorMessage: '"return" is a keyword!', isMustContain: false),
        ],
        hints: ['int code = 1;'],
      ),
      isLocked: true,
      x: 0.3,
      y: 0.4,
    ),
    Mission(
      id: 'm4',
      title: 'Signal Decoder System',
      description: 'Decode incoming data streams.',
      concept: 'Data Types',
      introVideoId: 'intro_v4',
      openingScene: SceneType.signalRoom,
      dialogueLines: ['Incoming signals. We need to sort them by type.'],
      task: const CodingTask(
        instruction: 'Declare a float named "frequency" with value 105.5.',
        initialCode: '// TODO: Declare float\n',
        correctOutput: '',
        validationRules: [
           ValidationRule(pattern: 'float frequency', errorMessage: 'Use "float frequency".'),
           ValidationRule(pattern: '105.5', errorMessage: 'Set value to 105.5.'),
        ],
        hints: ['float frequency = 105.5;'],
      ),
      isLocked: true,
      x: 0.3,
      y: 0.7,
    ),
    Mission(
      id: 'm5',
      title: 'Activate Display Panels',
      description: 'Online the holographic displays.',
      concept: 'Output System',
      introVideoId: 'intro_v5',
      openingScene: SceneType.displayPanels,
      dialogueLines: ['Displays outline. We need visual confirmation.'],
      task: const CodingTask(
        instruction: 'Print "System Ready" to the console.',
        initialCode: '// TODO: Print output\n',
        correctOutput: 'System Ready',
        validationRules: [
           ValidationRule(pattern: 'printf', errorMessage: 'Use printf.'),
           ValidationRule(pattern: 'System Ready', errorMessage: 'Print exactly "System Ready".'),
        ],
        hints: ['printf("System Ready");'],
      ),
      isLocked: true,
      x: 0.4,
      y: 0.8,
    ),
    Mission(
      id: 'm6',
      title: 'Restore Command Console',
      description: 'Enable manual input override.',
      concept: 'Input System',
      introVideoId: 'intro_v6',
      openingScene: SceneType.pilotConsole,
      dialogueLines: ['Manual override required. Input needed.'],
      task: const CodingTask(
        instruction: 'Use scanf to read an integer into variable "id".',
        initialCode: 'int id;\n// TODO: Read input\n',
        correctOutput: '',
        validationRules: [
           ValidationRule(pattern: 'scanf', errorMessage: 'Use scanf for input.'),
           ValidationRule(pattern: '%d', errorMessage: 'Use %d for integer format.'),
           ValidationRule(pattern: '&id', errorMessage: 'Don\'t forget the & before variable name.'),
        ],
        hints: ['scanf("%d", &id);'],
      ),
      isLocked: true,
      x: 0.5,
      y: 0.6,
    ),
    Mission(
      id: 'm7',
      title: 'Calculation Engine Repair',
      description: 'Recalibrate engine thrust vectors.',
      concept: 'Operators',
      introVideoId: 'intro_v7',
      openingScene: SceneType.calculationCore,
      dialogueLines: ['Thrust vectors misaligned. Recalculate.'],
      task: const CodingTask(
        instruction: 'Calculate thrust: int result = 50 * 2;',
        initialCode: '// TODO: Calculate\n',
        correctOutput: '',
        validationRules: [
           ValidationRule(pattern: '50 * 2', errorMessage: 'Multiply 50 and 2.'),
        ],
        hints: ['int result = 50 * 2;'],
      ),
      isLocked: true,
      x: 0.5,
      y: 0.3,
    ),
    Mission(
      id: 'm8',
      title: 'Decision AI System',
      description: 'Enable automated threat response.',
      concept: 'Conditions',
      introVideoId: 'intro_v8',
      openingScene: SceneType.autopilotAI,
      dialogueLines: ['Threat detected. Protocol needed.'],
      task: const CodingTask(
        instruction: 'If threat > 5, print "Generic Alert".',
        initialCode: 'int threat = 10;\n// TODO: If statement\n',
        correctOutput: 'Generic Alert',
        validationRules: [
           ValidationRule(pattern: 'if', errorMessage: 'Use if statement.'),
           ValidationRule(pattern: 'threat > 5', errorMessage: 'Check if threat > 5.'),
        ],
        hints: ['if(threat > 5) printf("Generic Alert");'],
      ),
      isLocked: true,
      x: 0.6,
      y: 0.5,
    ),
    Mission(
      id: 'm9',
      title: 'Auto Navigation System',
      description: 'Plot continuous course trajectory.',
      concept: 'Loops',
      introVideoId: 'intro_v9',
      openingScene: SceneType.thrusterRoom,
      dialogueLines: ['Course plotting...' , 'We need a loop to plot points.'],
      teachingModule: const TeachingModule(
        codeSnippet: 'for (int i = 0; i < 5; i++) {\n    fire_thruster();\n}',
        steps: [
          TeachingStep(
            explanation: 'This "for" loop will repeat the action inside options.',
            highlightedLines: [1],
            visualAssetId: 'toolbox',
          ),
          TeachingStep(
            explanation: 'int i = 0; starts our counter at zero.',
            highlightedLines: [1],
            visualAssetId: 'brackets',
          ),
          TeachingStep(
            explanation: 'i < 5; means "keep running as long as i is less than 5".',
            highlightedLines: [1],
            visualAssetId: 'engine_start',
          ),
          TeachingStep(
            explanation: 'i++ increases the counter by 1 after every loop.',
            highlightedLines: [1],
            visualAssetId: 'check_mark',
          ),
        ],
      ),
      task: const CodingTask(
        instruction: 'Write a loop that runs exactly 3 times to plot coordinates.',
        initialCode: '// TODO: Write a for loop\n',
        correctOutput: '',
        validationRules: [
           ValidationRule(pattern: 'for', errorMessage: 'Start with the "for" keyword.'),
           ValidationRule(pattern: 'int i', errorMessage: 'Initialize a counter variable, like "int i = 0".'),
           ValidationRule(pattern: '< 3', errorMessage: 'The loop needs to run 3 times. Check your condition (i < 3).'),
           ValidationRule(pattern: 'i++', errorMessage: 'Remember to increment your counter with i++.'),
        ],
        hints: ['for(int i=0; i<3; i++) { ... }'],
      ),
      isLocked: true,
      x: 0.7,
      y: 0.7,
    ),
    Mission(
      id: 'm10',
      title: 'Command Router',
      description: 'Route signals to correct subsystems.',
      concept: 'Switch Case',
      introVideoId: 'intro_v10',
      openingScene: SceneType.commandRouter,
      dialogueLines: ['Signals mixed. Sort them.'],
      task: const CodingTask(
        instruction: 'Use switch statement to check "channel". Case 1: print "Alpha".',
        initialCode: 'int channel = 1;\n// TODO: Switch statement\n',
        correctOutput: 'Alpha',
        validationRules: [
           ValidationRule(pattern: 'switch', errorMessage: 'Use switch.'),
           ValidationRule(pattern: 'case 1:', errorMessage: 'Define case 1.'),
        ],
        hints: ['switch(channel) { case 1: ... }'],
      ),
      isLocked: true,
      x: 0.8,
      y: 0.5,
    ),
    Mission(
      id: 'm11',
      title: 'Module Factory',
      description: 'Create reusable code modules.',
      concept: 'Functions',
      introVideoId: 'intro_v11',
      openingScene: SceneType.moduleFactory,
      dialogueLines: ['Code redundancy high. Modules required.'],
      task: const CodingTask(
        instruction: 'Define a function "void scan()" that prints "Scanning...". Call it.',
        initialCode: '// TODO: Define function\n\nint main() {\n  // Call here\n}',
        correctOutput: 'Scanning...',
        validationRules: [
           ValidationRule(pattern: 'void scan()', errorMessage: 'Define void scan().'),
           ValidationRule(pattern: 'scan();', errorMessage: 'Call scan() in main.'),
        ],
        hints: ['void scan() { printf("Scanning..."); }'],
      ),
      isLocked: true,
      x: 0.9,
      y: 0.3,
    ),
    Mission(
      id: 'm12',
      title: 'Data Vault',
      description: 'Store massive data sequences.',
      concept: 'Arrays',
      introVideoId: 'intro_v12',
      openingScene: SceneType.dataVault,
      dialogueLines: ['Data overflow. Arrays needed.'],
      task: const CodingTask(
         instruction: 'Create an int array "codes" with size 5.',
         initialCode: '// TODO: Array\n',
         correctOutput: '',
         validationRules: [
            ValidationRule(pattern: 'int codes[5]', errorMessage: 'Declare int codes[5].'),
         ],
         hints: ['int codes[5];'],
      ),
      isLocked: true,
      x: 0.8,
      y: 0.1,
    ),
    Mission(
      id: 'm13',
      title: 'Memory Lab',
      description: 'Direct memory access protocols.',
      concept: 'Pointers',
      introVideoId: 'intro_v13',
      openingScene: SceneType.memoryLab,
      dialogueLines: ['Direct access required. Use pointers.'],
      task: const CodingTask(
         instruction: 'Declare a pointer "ptr" that points to variable "target".',
         initialCode: 'int target = 10;\n// TODO: Pointer\n',
         correctOutput: '',
         validationRules: [
            ValidationRule(pattern: 'int *ptr', errorMessage: 'Declare int *ptr.'),
            ValidationRule(pattern: '&target', errorMessage: 'Assign address of target (&target).'),
         ],
         hints: ['int *ptr = &target;'],
      ),
      isLocked: true,
      x: 0.6,
      y: 0.1,
    ),
    Mission(
      id: 'm14',
      title: 'Blueprint Lab',
      description: 'Define complex data structures.',
      concept: 'Structures',
      introVideoId: 'intro_v14',
      openingScene: SceneType.blueprintLab,
      dialogueLines: ['Complex data entities detected. Structs required.'],
      task: const CodingTask(
         instruction: 'Define a struct named "Ship" with an int "id".',
         initialCode: '// TODO: Struct\n',
         correctOutput: '',
         validationRules: [
            ValidationRule(pattern: 'struct Ship', errorMessage: 'Define struct Ship.'),
            ValidationRule(pattern: 'int id;', errorMessage: 'Include int id inside.'),
         ],
         hints: ['struct Ship { int id; };'],
      ),
      isLocked: true,
      x: 0.4,
      y: 0.2,
    ),
  ];

  Set<String> unlockedMissionIds = {'m1'}; // Default unlocked

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('unlockedMissions');
    if (saved != null) {
      setState(() {
         unlockedMissionIds = saved.toSet();
      });
    }
  }

  Future<void> _unlockMission(String missionId) async {
    if (!unlockedMissionIds.contains(missionId)) {
      setState(() {
        unlockedMissionIds.add(missionId);
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('unlockedMissions', unlockedMissionIds.toList());
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ByteStarTheme.primary,
      body: Stack(
        children: [
          // Background - Deep Space Grid (Dynamic)
           Positioned.fill(
            child: AnimatedSpaceBackground(
              sceneType: SceneType.deepSpace,
              child: const SizedBox.expand(),
            ),
          ),

          // Mission Paths (Connecting lines)
          CustomPaint(
            size: Size.infinite,
            painter: _MissionPathPainter(missions),
          ),

          // Mission Nodes
          ...missions.map((mission) {
            return Positioned(
              left: MediaQuery.of(context).size.width * mission.x - 30, // center offset
              top: MediaQuery.of(context).size.height * mission.y - 30,
              child: _MissionNode(
                mission: mission,
                isLocked: !unlockedMissionIds.contains(mission.id),
                onTap: () async {
                  if (unlockedMissionIds.contains(mission.id)) {
                    if (widget.selectedLanguage == 'Python') {
                       await Navigator.of(context).push(
                         MaterialPageRoute(
                           builder: (_) => const PythonMissionScreen(),
                         ),
                       );
                       // Python logic manages its own state via StoryEngine
                    } else {
                        final result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => MissionEngineScreen(mission: mission),
                          ),
                        );
                        
                        if (result == true) {
                          // Generic unlock logic for m1 -> m14
                          final currentIdNum = int.tryParse(mission.id.replaceAll('m', '')) ?? 0;
                          if (currentIdNum > 0 && currentIdNum < 14) {
                             final nextId = 'm${currentIdNum + 1}';
                             _unlockMission(nextId);
                          }
                        }
                    }
                  }
                },
              ),
            );
          }),

          // HUD - Top Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // User Info
                    Row(
                      children: [
                         // Back Button added for improved navigation
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: ByteStarTheme.accent),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const Icon(Icons.shield, color: ByteStarTheme.accent),
                        const SizedBox(width: 8),
                        Text(
                          'Cadet ${widget.username}',
                          style: ByteStarTheme.body.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    
                    // Mission Progress Indicator
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: ByteStarTheme.secondary.withValues(alpha: 0.3),
                        border: Border.all(color: ByteStarTheme.accent.withValues(alpha: 0.5)),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: ByteStarTheme.accent.withValues(alpha: 0.1),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.flag, color: ByteStarTheme.accent, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'Mission: ${unlockedMissionIds.length} / ${missions.length}',
                            style: const TextStyle(
                               color: ByteStarTheme.accent,
                               fontWeight: FontWeight.bold,
                               fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // NOVA AI Assistant - Bottom Right
          Positioned(
            bottom: 30,
            right: 30,
            child: GestureDetector(
              onTap: () {
                 // TODO: Show help/dialogue
              },
              child: const NovaHologram(size: 80),
            ).animate().slideY(begin: 1, end: 0, duration: 800.ms, curve: Curves.easeOutBack),
          ),
        ],
      ),
    );
  }
}

class _MissionNode extends StatelessWidget {
  final Mission mission;
  final VoidCallback onTap;
  final bool isLocked;

  const _MissionNode({
    required this.mission, 
    required this.onTap,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isLocked ? Colors.grey.withValues(alpha: 0.3) : ByteStarTheme.primary,
              border: Border.all(
                color: isLocked ? Colors.grey : ByteStarTheme.accent,
                width: 2,
              ),
              boxShadow: isLocked ? [] : [
                BoxShadow(
                  color: ByteStarTheme.accent.withValues(alpha: 0.5),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                isLocked ? Icons.lock : Icons.code,
                color: isLocked ? Colors.grey : ByteStarTheme.accent,
              ),
            ),
          ).animate(onPlay: (c) => isLocked ? null : c.repeat(reverse: true))
           .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 2.seconds),
          
          const SizedBox(height: 8),
          
          Text(
            mission.title,
            style: ByteStarTheme.body.copyWith(
              fontSize: 12,
              color: isLocked ? Colors.grey : ByteStarTheme.accent,
            ),
          ),
        ],
      ),
    );
  }
}

class _StarFieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.3);
    // Draw simple stars
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.2), 1, paint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.1), 2, paint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.3), 1.5, paint);
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.8), 2, paint);
    // Grid lines
    final gridPaint = Paint()
      ..color = ByteStarTheme.accent.withValues(alpha: 0.05)
      ..strokeWidth = 1;
      
    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MissionPathPainter extends CustomPainter {
  final List<Mission> missions;

  _MissionPathPainter(this.missions);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ByteStarTheme.accent.withValues(alpha: 0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    if (missions.isNotEmpty) {
      final start = Offset(size.width * missions[0].x, size.height * missions[0].y);
      path.moveTo(start.dx, start.dy);
      
      for (int i = 1; i < missions.length; i++) {
        final p = Offset(size.width * missions[i].x, size.height * missions[i].y);
        path.lineTo(p.dx, p.dy);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
