import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/theme.dart';
import '../widgets/background/code_background.dart';
import '../core/story_engine.dart';

/// Mission Screen for ByteStar Arena
/// Displays Phase 1, Mission 1: printf() - Your First Output
class MissionScreen extends StatefulWidget {
  const MissionScreen({super.key});

  @override
  State<MissionScreen> createState() => _MissionScreenState();
}

class _MissionScreenState extends State<MissionScreen> {
  final StoryEngine _storyEngine = StoryEngine();
  Map<String, dynamic>? _missionData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMission();
  }

  Future<void> _loadMission() async {
    final mission = await _storyEngine.getCurrentMissionData();
    setState(() {
      _missionData = mission;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _missionData == null) {
      return Scaffold(
        backgroundColor: AppTheme.ideBackground,
        body: const Center(
          child: CircularProgressIndicator(
            color: AppTheme.syntaxBlue,
          ),
        ),
      );
    }

    final phase = _missionData!['phase'] as int;
    final mission = _missionData!['mission'] as int;
    final title = _missionData!['title'] as String;
    final description = _missionData!['description'] as String;
    final objectives = _missionData!['objectives'] as List<dynamic>;

    return Scaffold(
      backgroundColor: AppTheme.ideBackground,
      body: Stack(
        children: [
          // Background
          const Positioned.fill(
            child: CodeBackground(),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.syntaxBlue.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppTheme.syntaxBlue,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'Phase $phase • Mission $mission',
                          style: AppTheme.codeStyle.copyWith(
                            color: AppTheme.syntaxBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn().slideY(begin: -0.3, end: 0),

                  const SizedBox(height: 40),

                  // Mission Title
                  Text(
                    title,
                    style: AppTheme.headingStyle.copyWith(
                      fontSize: 36,
                      color: AppTheme.syntaxGreen,
                    ),
                  ).animate(delay: 200.ms).fadeIn().slideX(begin: -0.2, end: 0),

                  const SizedBox(height: 16),

                  // Mission Description
                  Text(
                    description,
                    style: AppTheme.bodyStyle.copyWith(
                      fontSize: 18,
                      color: AppTheme.syntaxComment,
                      height: 1.6,
                    ),
                  ).animate(delay: 400.ms).fadeIn(),

                  const SizedBox(height: 40),

                  // Objectives Section
                  Text(
                    'Mission Objectives',
                    style: AppTheme.headingStyle.copyWith(
                      fontSize: 24,
                      color: AppTheme.syntaxYellow,
                    ),
                  ).animate(delay: 600.ms).fadeIn(),

                  const SizedBox(height: 16),

                  // Objectives List
                  ...objectives.asMap().entries.map((entry) {
                    final index = entry.key;
                    final objective = entry.value as String;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppTheme.syntaxGreen,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: AppTheme.codeStyle.copyWith(
                                  color: AppTheme.syntaxGreen,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              objective,
                              style: AppTheme.bodyStyle.copyWith(
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate(delay: (800 + index * 100).ms).fadeIn().slideX(begin: -0.1, end: 0);
                  }),

                  const SizedBox(height: 60),

                  // Code Challenge Section (Placeholder)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppTheme.idePanel,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.syntaxBlue.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.code,
                              color: AppTheme.syntaxBlue,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Code Challenge',
                              style: AppTheme.headingStyle.copyWith(
                                fontSize: 20,
                                color: AppTheme.syntaxBlue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.ideBackground,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '// Code challenge content coming soon...\n'
                            '#include <stdio.h>\n\n'
                            'int main() {\n'
                            '    printf("Hello, CodeQuest!");\n'
                            '    return 0;\n'
                            '}',
                            style: AppTheme.codeStyle.copyWith(
                              fontSize: 14,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate(delay: 1200.ms).fadeIn().slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 40),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Implement mission completion
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Mission content coming soon!'),
                              backgroundColor: AppTheme.syntaxBlue,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.syntaxGreen,
                          foregroundColor: AppTheme.ideBackground,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Start Mission',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 12),
                            Icon(Icons.arrow_forward, size: 24),
                          ],
                        ),
                      ),
                    ],
                  ).animate(delay: 1400.ms).fadeIn().scale(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
