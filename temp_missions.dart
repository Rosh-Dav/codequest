import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/bytestar_theme.dart';
import '../../models/bytestar_data.dart';
import '../../widgets/bytestar/nova_hologram.dart';
import '../../widgets/bytestar/space_backgrounds.dart';
import '../../widgets/bytestar/animated_space_background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mission_engine_screen.dart';

class MissionMapScreen extends StatefulWidget {
  final String username;

  const MissionMapScreen({super.key, required this.username});

  @override
  State<MissionMapScreen> createState() => _MissionMapScreenState();
}

class _MissionMapScreenState extends State<MissionMapScreen> {
  // Dummy missions for now
  final List<Mission> missions = [
    Mission(
      id: 'm1',
      title: 'Wake Up ASTRA-X',
      description: 'Initialize the main communication mainframe.',
      concept: 'Output & Main',
      introVideoId: 'intro_v1', // Placeholder
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
      isLocked: false, // M1 is always open
      x: 0.2,
      y: 0.7,
    ),
    Mission(
      id: 'm2',
      title: 'Power Stabilization',
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
      x: 0.5,
      y: 0.4,
    ),
    Mission(
      id: 'm3',
      title: 'Navigation Systems',
      description: 'Calibrate thruster sequences.',
      concept: 'Loops',
      introVideoId: 'intro_v3',
      openingScene: SceneType.cockpit,
      dialogueLines: [
        'Power is stable. Now for navigation.',
        'We need to fire the thrusters multiple times to align the ship.',
        'Instead of writing the same command 3 times, we use a Loop.',
      ],
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
        instruction: 'Write a loop that runs exactly 3 times to fire the main thrusters.',
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
      x: 0.8,
      y: 0.6,
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
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MissionEngineScreen(mission: mission),
                      ),
                    );
                    
                    if (result == true) {
                      // Mission Complete! Unlock next.
                      if (mission.id == 'm1') _unlockMission('m2');
                      if (mission.id == 'm2') _unlockMission('m3');
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
                        const Icon(Icons.shield, color: ByteStarTheme.accent),
                        const SizedBox(width: 8),
                        Text(
                          'Cadet ${widget.username}',
                          style: ByteStarTheme.body.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    
                    // Ship Integrity
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: ByteStarTheme.secondary.withValues(alpha: 0.5),
                        border: Border.all(color: ByteStarTheme.success),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.battery_charging_full, color: ByteStarTheme.success, size: 16),
                          SizedBox(width: 4),
                          Text('Ship: 100%', style: TextStyle(color: ByteStarTheme.success)),
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
                isLocked ? Icons.lock : (mission.icon ?? Icons.code),
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

class _SpaceBackground extends StatelessWidget {
  const _SpaceBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ByteStarTheme.primary,
      ),
      child: CustomPaint(
        painter: _StarFieldPainter(),
      ),
    );
  }
}

class _StarFieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.3);
    // Draw simple stars
    // In a real app, use random generation or static offsets
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
