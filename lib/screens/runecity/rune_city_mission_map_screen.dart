import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/theme.dart';
import '../../models/bytestar_data.dart';
import '../../widgets/bytestar/nova_hologram.dart';
import '../../widgets/bytestar/tactical_profile_banner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bytestar/mission_engine_screen.dart';
import '../bytestar/profile_screen.dart';
import '../../widgets/navigation/global_sidebar.dart';

class RuneCityMissionMapScreen extends StatefulWidget {
  final String username;

  const RuneCityMissionMapScreen({super.key, required this.username});

  @override
  State<RuneCityMissionMapScreen> createState() => _RuneCityMissionMapScreenState();
}

class _RuneCityMissionMapScreenState extends State<RuneCityMissionMapScreen> {
  final List<Mission> missions = [
    Mission(
      id: 'r1',
      title: 'The First Rune',
      description: 'Store citizen energy and awaken memory.',
      concept: 'Variables',
      introVideoId: 'rune_intro_1',
      openingScene: SceneType.cockpit,
      dialogueLines: [
        'The city memory is fading.',
        'I am Luna, keeper of the runes.',
        'We must bind energy to a name so the city can remember it.',
        'In Python, we call these bindings variables.',
      ],
      teachingModule: const TeachingModule(
        codeSnippet: 'energy = 25\nprint(energy)\nenergy = 40\nprint(energy)',
        steps: [
          TeachingStep(
            explanation: 'Assign a value with "=". This creates a variable.',
            highlightedLines: [1],
            visualAssetId: 'engine_start',
          ),
          TeachingStep(
            explanation: 'Use print() to display the stored value.',
            highlightedLines: [2],
            visualAssetId: 'brackets',
          ),
          TeachingStep(
            explanation: 'Reassigning changes the stored value.',
            highlightedLines: [3],
            visualAssetId: 'check_mark',
          ),
        ],
      ),
      task: const CodingTask(
        instruction: 'Create a variable "energy" with value 10, then print it.',
        initialCode: '# Write your code below\n',
        correctOutput: '10',
        validationRules: [
          ValidationRule(pattern: 'energy', errorMessage: 'Use a variable named "energy".'),
          ValidationRule(pattern: '=', errorMessage: 'Assign a value using "=".'),
          ValidationRule(pattern: '10', errorMessage: 'Set the value to 10.'),
          ValidationRule(pattern: 'print', errorMessage: 'Use print() to display the value.'),
        ],
        hints: ['energy = 10', 'print(energy)'],
      ),
      isLocked: false,
      x: 0.15,
      y: 0.85,
      languageId: 71, // Python 3
      icon: Icons.bolt,
    ),
    Mission(
      id: 'r2',
      title: 'Endless Work',
      description: 'Automate lanterns and fountains.',
      concept: 'Loops',
      introVideoId: 'rune_intro_2',
      openingScene: SceneType.engineRoom,
      dialogueLines: [
        'The city runs many tasks at once.',
        'We cannot repeat the same spell forever.',
        'Loops let us repeat a task with control.',
      ],
      teachingModule: const TeachingModule(
        codeSnippet: 'for i in range(3):\n    print("Lamp lit")',
        steps: [
          TeachingStep(
            explanation: 'for loops repeat a fixed number of times.',
            highlightedLines: [1],
            visualAssetId: 'toolbox',
          ),
          TeachingStep(
            explanation: 'The indented block is what repeats.',
            highlightedLines: [2],
            visualAssetId: 'brackets',
          ),
        ],
      ),
      task: const CodingTask(
        instruction: 'Write a loop that prints "Glow" 3 times.',
        initialCode: '# Write your code below\n',
        correctOutput: 'Glow\nGlow\nGlow',
        validationRules: [
          ValidationRule(pattern: 'for', errorMessage: 'Use a for loop.'),
          ValidationRule(pattern: 'range(3)', errorMessage: 'Repeat exactly 3 times.'),
          ValidationRule(pattern: 'print', errorMessage: 'Print "Glow" inside the loop.'),
        ],
        hints: ['for i in range(3):', 'print("Glow")'],
      ),
      isLocked: true,
      x: 0.28,
      y: 0.72,
      languageId: 71,
      icon: Icons.loop,
    ),
    Mission(
      id: 'r3',
      title: 'Decision Point',
      description: 'Open the gate or raise the alarm.',
      concept: 'Conditions',
      introVideoId: 'rune_intro_3',
      openingScene: SceneType.cockpit,
      dialogueLines: [
        'The gate must react to the right signal.',
        'Conditions let the city decide what to do.',
      ],
      teachingModule: const TeachingModule(
        codeSnippet: 'signal = "open"\nif signal == "open":\n    print("Gate opens")\nelse:\n    print("Alarm")',
        steps: [
          TeachingStep(
            explanation: 'if checks a condition.',
            highlightedLines: [2],
            visualAssetId: 'engine_start',
          ),
          TeachingStep(
            explanation: 'else runs when the condition is false.',
            highlightedLines: [4, 5],
            visualAssetId: 'check_mark',
          ),
        ],
      ),
      task: const CodingTask(
        instruction: 'If energy is greater than 50, print "Open". Otherwise print "Hold".',
        initialCode: 'energy = 60\n# Write your code below\n',
        correctOutput: 'Open',
        validationRules: [
          ValidationRule(pattern: 'if', errorMessage: 'Use an if statement.'),
          ValidationRule(pattern: 'energy', errorMessage: 'Use the energy variable.'),
          ValidationRule(pattern: 'print', errorMessage: 'Print the result.'),
        ],
        hints: ['if energy > 50:', 'print("Open")'],
      ),
      isLocked: true,
      x: 0.44,
      y: 0.6,
      languageId: 71,
      icon: Icons.alt_route,
    ),
    Mission(
      id: 'r4',
      title: 'Helpful Runes',
      description: 'Turn repeated tasks into functions.',
      concept: 'Functions',
      introVideoId: 'rune_intro_4',
      openingScene: SceneType.engineRoom,
      dialogueLines: [
        'We repeat spells too often.',
        'Let us craft a function to reuse power.',
      ],
      teachingModule: const TeachingModule(
        codeSnippet: 'def heal(name):\n    print("Heal", name)\n\nheal("Ari")',
        steps: [
          TeachingStep(
            explanation: 'def creates a function.',
            highlightedLines: [1],
            visualAssetId: 'toolbox',
          ),
          TeachingStep(
            explanation: 'Call the function by name.',
            highlightedLines: [4],
            visualAssetId: 'engine_start',
          ),
        ],
      ),
      task: const CodingTask(
        instruction: 'Write a function called shield that prints "Shield Up". Then call it.',
        initialCode: '# Write your code below\n',
        correctOutput: 'Shield Up',
        validationRules: [
          ValidationRule(pattern: 'def', errorMessage: 'Define a function with def.'),
          ValidationRule(pattern: 'shield', errorMessage: 'Name the function shield.'),
          ValidationRule(pattern: 'print', errorMessage: 'Print "Shield Up".'),
        ],
        hints: ['def shield():', 'print("Shield Up")', 'shield()'],
      ),
      isLocked: true,
      x: 0.6,
      y: 0.5,
      languageId: 71,
      icon: Icons.auto_fix_high,
    ),
    Mission(
      id: 'r5',
      title: 'Many Runes',
      description: 'Store multiple readings in lists.',
      concept: 'Lists',
      introVideoId: 'rune_intro_5',
      openingScene: SceneType.cockpit,
      dialogueLines: [
        'The city reads many values at once.',
        'Lists keep them together in order.',
      ],
      teachingModule: const TeachingModule(
        codeSnippet: 'levels = [10, 20, 30]\nlevels.append(40)\nprint(levels[0])',
        steps: [
          TeachingStep(
            explanation: 'Lists store multiple values.',
            highlightedLines: [1],
            visualAssetId: 'toolbox',
          ),
          TeachingStep(
            explanation: 'append adds a new value.',
            highlightedLines: [2],
            visualAssetId: 'engine_start',
          ),
          TeachingStep(
            explanation: 'Indexing gets a value by position.',
            highlightedLines: [3],
            visualAssetId: 'brackets',
          ),
        ],
      ),
      task: const CodingTask(
        instruction: 'Create a list with 3 numbers and print the first one.',
        initialCode: '# Write your code below\n',
        correctOutput: '1',
        validationRules: [
          ValidationRule(pattern: '[', errorMessage: 'Create a list using [ ].'),
          ValidationRule(pattern: 'print', errorMessage: 'Print the first element.'),
        ],
        hints: ['nums = [1,2,3]', 'print(nums[0])'],
      ),
      isLocked: true,
      x: 0.72,
      y: 0.4,
      languageId: 71,
      icon: Icons.view_list,
    ),
    Mission(
      id: 'r6',
      title: 'List Mastery',
      description: 'Refine lists to cleanse duplicates and find strength.',
      concept: 'Lists',
      introVideoId: 'rune_intro_6',
      openingScene: SceneType.engineRoom,
      dialogueLines: [
        'Rune City stores many readings in lists.',
        'But duplicates weaken the signal.',
        'We will cleanse and sort the list to reveal the second greatest power.',
      ],
      teachingModule: const TeachingModule(
        codeSnippet: 'nums = [3, 5, 3, 9, 9, 2]\nunique = list(set(nums))\nunique.sort()\nprint(unique[-2])',
        steps: [
          TeachingStep(
            explanation: 'Convert to a set to remove duplicates.',
            highlightedLines: [2],
            visualAssetId: 'toolbox',
          ),
          TeachingStep(
            explanation: 'Sort the list to find ordered values.',
            highlightedLines: [3],
            visualAssetId: 'engine_start',
          ),
          TeachingStep(
            explanation: 'The second largest is at index -2 after sorting.',
            highlightedLines: [4],
            visualAssetId: 'brackets',
          ),
        ],
      ),
      task: const CodingTask(
        instruction:
            'Given nums = [4, 2, 4, 6, 9, 6], remove duplicates, find the second largest, and print the updated list.',
        initialCode: 'nums = [4, 2, 4, 6, 9, 6]\n# Write your code below\n',
        correctOutput: '[2, 4, 6, 9]',
        validationRules: [
          ValidationRule(pattern: 'set', errorMessage: 'Use a set to remove duplicates.'),
          ValidationRule(pattern: 'sort', errorMessage: 'Sort the list to find the second largest.'),
          ValidationRule(pattern: 'print', errorMessage: 'Print the updated list.'),
        ],
        hints: ['unique = list(set(nums))', 'unique.sort()', 'print(unique)'],
      ),
      isLocked: true,
      x: 0.8,
      y: 0.32,
      languageId: 71,
      icon: Icons.filter_alt,
    ),
    Mission(
      id: 'r7',
      title: 'Dictionary Explorer',
      description: 'Seek the top scholar and average knowledge.',
      concept: 'Dictionaries',
      introVideoId: 'rune_intro_7',
      openingScene: SceneType.cockpit,
      dialogueLines: [
        'Names and marks are stored in rune ledgers.',
        'We must find the highest mark and the average.',
      ],
      teachingModule: const TeachingModule(
        codeSnippet: 'scores = {"Ari": 90, "Bea": 78}\nbest = max(scores, key=scores.get)\navg = sum(scores.values()) / len(scores)',
        steps: [
          TeachingStep(
            explanation: 'Use max with key to find the top student.',
            highlightedLines: [2],
            visualAssetId: 'check_mark',
          ),
          TeachingStep(
            explanation: 'Sum values and divide by count for average.',
            highlightedLines: [3],
            visualAssetId: 'engine_start',
          ),
        ],
      ),
      task: const CodingTask(
        instruction:
            'Given scores = {"Ari": 80, "Bea": 95, "Kai": 70}, print the top student name and the average marks.',
        initialCode: 'scores = {"Ari": 80, "Bea": 95, "Kai": 70}\n# Write your code below\n',
        correctOutput: 'Bea',
        validationRules: [
          ValidationRule(pattern: 'max', errorMessage: 'Use max() with a key to find the top student.'),
          ValidationRule(pattern: 'values', errorMessage: 'Use values() to compute average.'),
          ValidationRule(pattern: 'print', errorMessage: 'Print the results.'),
        ],
        hints: ['best = max(scores, key=scores.get)', 'avg = sum(scores.values())/len(scores)'],
      ),
      isLocked: true,
      x: 0.68,
      y: 0.24,
      languageId: 71,
      icon: Icons.menu_book,
    ),
    Mission(
      id: 'r8',
      title: 'Function Builder',
      description: 'Forge a function to filter powerful numbers.',
      concept: 'Functions',
      introVideoId: 'rune_intro_8',
      openingScene: SceneType.engineRoom,
      dialogueLines: [
        'A function can filter numbers by rule.',
        'We need numbers divisible by both 3 and 5.',
      ],
      teachingModule: const TeachingModule(
        codeSnippet: 'def filter_nums(nums):\n    return [n for n in nums if n % 3 == 0 and n % 5 == 0]\n\nprint(filter_nums([1, 15, 30, 7]))',
        steps: [
          TeachingStep(
            explanation: 'Define a function with def.',
            highlightedLines: [1],
            visualAssetId: 'toolbox',
          ),
          TeachingStep(
            explanation: 'Use a list comprehension with conditions.',
            highlightedLines: [2],
            visualAssetId: 'brackets',
          ),
        ],
      ),
      task: const CodingTask(
        instruction:
            'Create a function that returns numbers divisible by both 3 and 5 from a list. Print the result for nums = [3, 5, 10, 15, 30, 33].',
        initialCode: 'nums = [3, 5, 10, 15, 30, 33]\n# Write your code below\n',
        correctOutput: '[15, 30]',
        validationRules: [
          ValidationRule(pattern: 'def', errorMessage: 'Define a function using def.'),
          ValidationRule(pattern: '% 3', errorMessage: 'Check divisibility by 3.'),
          ValidationRule(pattern: '% 5', errorMessage: 'Check divisibility by 5.'),
          ValidationRule(pattern: 'print', errorMessage: 'Print the filtered list.'),
        ],
        hints: ['def filter_nums(nums):', 'n % 3 == 0 and n % 5 == 0', 'print(filter_nums(nums))'],
      ),
      isLocked: true,
      x: 0.5,
      y: 0.18,
      languageId: 71,
      icon: Icons.build_circle,
    ),
    Mission(
      id: 'r9',
      title: 'File Handling Quest',
      description: 'Read scrolls to count lines, words, and longest word.',
      concept: 'File Handling',
      introVideoId: 'rune_intro_9',
      openingScene: SceneType.cockpit,
      dialogueLines: [
        'Ancient scrolls store city lore.',
        'We must read the scroll and measure its lines and words.',
      ],
      teachingModule: const TeachingModule(
        codeSnippet: 'with open("scroll.txt") as f:\n    text = f.read()\nlines = text.splitlines()\nwords = text.split()\nlongest = max(words, key=len)',
        steps: [
          TeachingStep(
            explanation: 'Open the file and read the text.',
            highlightedLines: [1, 2],
            visualAssetId: 'engine_start',
          ),
          TeachingStep(
            explanation: 'Split lines and words to count them.',
            highlightedLines: [3, 4],
            visualAssetId: 'brackets',
          ),
          TeachingStep(
            explanation: 'Use max with key=len to find the longest word.',
            highlightedLines: [5],
            visualAssetId: 'check_mark',
          ),
        ],
      ),
      task: const CodingTask(
        instruction:
            'Read "scroll.txt", count lines and words, and print the longest word.',
        initialCode: '# Assume scroll.txt exists in the runtime.\n# Write your code below\n',
        correctOutput: '',
        validationRules: [
          ValidationRule(pattern: 'open', errorMessage: 'Open the file with open().'),
          ValidationRule(pattern: 'splitlines', errorMessage: 'Use splitlines() to count lines.'),
          ValidationRule(pattern: 'split', errorMessage: 'Use split() to count words.'),
          ValidationRule(pattern: 'max', errorMessage: 'Use max() to find the longest word.'),
          ValidationRule(pattern: 'print', errorMessage: 'Print the longest word.'),
        ],
        hints: ['with open("scroll.txt") as f:', 'words = text.split()', 'print(longest)'],
      ),
      isLocked: true,
      x: 0.32,
      y: 0.15,
      languageId: 71,
      icon: Icons.menu_open,
    ),
  ];

  Set<String> unlockedMissionIds = {'r1'};
  Set<String> completedMissionIds = {};

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('runeCityPythonUnlockedMissions');
    final completed = prefs.getStringList('runeCityPythonCompletedMissions');
    if (saved != null) {
      setState(() {
        unlockedMissionIds = saved.toSet();
      });
    }
    if (completed != null) {
      setState(() {
        completedMissionIds = completed.toSet();
      });
    }
  }

  Future<void> _unlockMission(String missionId) async {
    if (!unlockedMissionIds.contains(missionId)) {
      setState(() {
        unlockedMissionIds.add(missionId);
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('runeCityPythonUnlockedMissions', unlockedMissionIds.toList());
    }
  }

  Future<void> _markCompleted(String missionId) async {
    if (!completedMissionIds.contains(missionId)) {
      setState(() {
        completedMissionIds.add(missionId);
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('runeCityPythonCompletedMissions', completedMissionIds.toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = AppTheme.syntaxYellow;
    return Scaffold(
      backgroundColor: AppTheme.ideBackground,
      drawer: GlobalSidebar(username: widget.username),
      body: Stack(
        children: [
          const Positioned.fill(child: _RuneCityBackground()),
          CustomPaint(
            size: Size.infinite,
            painter: _MissionPathPainter(missions, accent),
          ),
          ...missions.map((mission) {
            return Positioned(
              left: MediaQuery.of(context).size.width * mission.x - 30,
              top: MediaQuery.of(context).size.height * mission.y - 30,
              child: _MissionNode(
                mission: mission,
                isLocked: !unlockedMissionIds.contains(mission.id),
                accent: accent,
                onTap: () async {
                  if (unlockedMissionIds.contains(mission.id)) {
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MissionEngineScreen(
                          mission: mission,
                          mentorName: 'LUNA',
                        ),
                      ),
                    );
                    if (result == true) {
                      await _markCompleted(mission.id);
                      if (mission.id == 'r1') _unlockMission('r2');
                      if (mission.id == 'r2') _unlockMission('r3');
                      if (mission.id == 'r3') _unlockMission('r4');
                      if (mission.id == 'r4') _unlockMission('r5');
                      if (mission.id == 'r5') _unlockMission('r6');
                      if (mission.id == 'r6') _unlockMission('r7');
                      if (mission.id == 'r7') _unlockMission('r8');
                      if (mission.id == 'r8') _unlockMission('r9');
                    }
                  }
                },
              ),
            );
          }),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Menu Button
                        Builder(
                          builder: (context) => IconButton(
                            icon: const Icon(Icons.menu, color: AppTheme.syntaxYellow, size: 28),
                            onPressed: () => Scaffold.of(context).openDrawer(),
                          ),
                        ),
                        
                        // Progress Pill
                        _ProgressPill(
                          current: completedMissionIds.length,
                          total: missions.length,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 30,
            child: GestureDetector(
              onTap: () {},
              child: NovaHologram(
                size: 80,
                accentColor: AppTheme.syntaxYellow,
              ),
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
  final Color accent;

  const _MissionNode({
    required this.mission,
    required this.onTap,
    required this.isLocked,
    required this.accent,
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
              color: isLocked ? Colors.grey.withValues(alpha: 0.3) : AppTheme.ideBackground,
              border: Border.all(
                color: isLocked ? Colors.grey : accent,
                width: 2,
              ),
              boxShadow: isLocked
                  ? []
                  : [
                      BoxShadow(
                        color: accent.withValues(alpha: 0.5),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
            ),
            child: Center(
              child: Icon(
                isLocked ? Icons.lock : (mission.icon ?? Icons.code),
                color: isLocked ? Colors.grey : accent,
              ),
            ),
          ).animate(onPlay: (c) => isLocked ? null : c.repeat(reverse: true))
              .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 2.seconds),
          const SizedBox(height: 8),
          Text(
            mission.title,
            style: AppTheme.bodyStyle.copyWith(
              fontSize: 12,
              color: isLocked ? Colors.grey : accent,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressPill extends StatelessWidget {
  final int current;
  final int total;

  const _ProgressPill({
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = total == 0 ? 0.0 : (current / total).clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.idePanel.withValues(alpha: 0.5),
        border: Border.all(color: AppTheme.syntaxYellow),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.auto_awesome, color: AppTheme.syntaxYellow, size: 16),
          const SizedBox(width: 6),
          Text(
            'Progress $current/$total',
            style: AppTheme.bodyStyle.copyWith(
              color: AppTheme.syntaxYellow,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 6,
                backgroundColor: AppTheme.ideBackground,
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.syntaxYellow),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class _MissionPathPainter extends CustomPainter {
  final List<Mission> missions;
  final Color accent;

  _MissionPathPainter(this.missions, this.accent);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = accent.withValues(alpha: 0.3)
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

class _RuneCityBackground extends StatelessWidget {
  const _RuneCityBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF19160E),
                const Color(0xFF1F1A10),
                const Color(0xFF15110B),
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: CustomPaint(
            painter: _RuneGlowPainter(),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.2, -0.6),
                  radius: 1.1,
                  colors: [
                    AppTheme.syntaxYellow.withValues(alpha: 0.22),
                    AppTheme.ideBackground.withValues(alpha: 0.95),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RuneGlowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final glow = Paint()
      ..color = AppTheme.syntaxYellow.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final soft = Paint()
      ..color = AppTheme.syntaxYellow.withValues(alpha: 0.04)
      ..style = PaintingStyle.fill;

    final centers = [
      Offset(size.width * 0.2, size.height * 0.25),
      Offset(size.width * 0.75, size.height * 0.2),
      Offset(size.width * 0.6, size.height * 0.7),
      Offset(size.width * 0.3, size.height * 0.65),
    ];

    final radii = [120.0, 180.0, 140.0, 200.0];

    for (int i = 0; i < centers.length; i++) {
      canvas.drawCircle(centers[i], radii[i], soft);
      canvas.drawCircle(centers[i], radii[i], glow);
      canvas.drawCircle(centers[i], radii[i] * 0.6, glow);
    }

    final linePaint = Paint()
      ..color = AppTheme.syntaxYellow.withValues(alpha: 0.06)
      ..strokeWidth = 2;

    for (int i = 0; i < 6; i++) {
      final y = size.height * (0.15 + i * 0.12);
      canvas.drawLine(Offset(size.width * 0.05, y), Offset(size.width * 0.35, y), linePaint);
    }
    for (int i = 0; i < 5; i++) {
      final y = size.height * (0.2 + i * 0.14);
      canvas.drawLine(Offset(size.width * 0.6, y), Offset(size.width * 0.9, y), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
