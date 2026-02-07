import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/theme.dart';
import '../../widgets/background/code_background.dart';
import '../../widgets/onboarding/selection_card.dart';
import 'mentor_introduction_screen.dart';

class StoryModeSelectionScreen extends StatefulWidget {
  final String username;
  final String selectedLanguage;

  const StoryModeSelectionScreen({
    super.key,
    required this.username,
    required this.selectedLanguage,
  });

  @override
  State<StoryModeSelectionScreen> createState() => _StoryModeSelectionScreenState();
}

class _StoryModeSelectionScreenState extends State<StoryModeSelectionScreen> {
  String? _selectedStoryMode;
  bool _isTransitioning = false;

  void _selectStoryMode(String storyMode) {
    if (_isTransitioning) return;
    setState(() {
      _selectedStoryMode = storyMode;
      _isTransitioning = true;
    });

    // Show confirmation and transition to mentor
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                MentorIntroductionScreen(
              username: widget.username,
              selectedLanguage: widget.selectedLanguage,
              selectedStoryMode: _selectedStoryMode!,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.ideBackground,
      body: Stack(
        children: [
          // Animated Background
          const Positioned.fill(
            child: CodeBackground(),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 60),

                // Title
                Text(
                  'Choose Your Story',
                  style: AppTheme.headingStyle.copyWith(fontSize: 40),
                ).animate().fadeIn().slideY(begin: -0.3, end: 0),

                const SizedBox(height: 16),

                Text(
                  'Select your learning adventure world',
                  style: AppTheme.bodyStyle.copyWith(
                    color: AppTheme.syntaxComment,
                    fontSize: 16,
                  ),
                ).animate(delay: 200.ms).fadeIn(),

                const Spacer(),

                // Story Mode Cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Rune City Quest Card - Yellow theme
                    SelectionCard(
                      title: 'Rune City Quest',
                      description: 'Urban coding adventure with friendly mentorship and exploration',
                      icon: Icons.location_city,
                      accentColor: AppTheme.syntaxYellow,
                      isSelected: _selectedStoryMode == 'Rune City Quest',
                      onTap: () => _selectStoryMode('Rune City Quest'),
                    ).animate(delay: 400.ms).fadeIn().slideX(begin: -0.2, end: 0),

                    const SizedBox(width: 40),

                    // Byte Star Arena Card - Blue theme with rocket
                    SelectionCard(
                      title: 'Byte Star Arena',
                      description: 'Competitive coding challenges with energetic training and rankings',
                      icon: Icons.rocket_launch,
                      accentColor: AppTheme.syntaxBlue,
                      isSelected: _selectedStoryMode == 'Byte Star Arena',
                      onTap: () => _selectStoryMode('Byte Star Arena'),
                    ).animate(delay: 600.ms).fadeIn().slideX(begin: 0.2, end: 0),
                  ],
                ),


                const Spacer(),

                // Impressive Selection Confirmation
                if (_selectedStoryMode != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          (_selectedStoryMode == 'Rune City Quest'
                              ? AppTheme.syntaxYellow
                              : AppTheme.syntaxBlue).withValues(alpha: 0.3),
                          (_selectedStoryMode == 'Rune City Quest'
                              ? AppTheme.syntaxYellow
                              : AppTheme.syntaxBlue).withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _selectedStoryMode == 'Rune City Quest'
                            ? AppTheme.syntaxYellow
                            : AppTheme.syntaxBlue,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (_selectedStoryMode == 'Rune City Quest'
                              ? AppTheme.syntaxYellow
                              : AppTheme.syntaxBlue).withValues(alpha: 0.5),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _selectedStoryMode == 'Rune City Quest'
                                ? AppTheme.syntaxYellow
                                : AppTheme.syntaxBlue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Story Mode Selected',
                              style: AppTheme.codeStyle.copyWith(
                                color: AppTheme.syntaxComment,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _selectedStoryMode!,
                              style: AppTheme.headingStyle.copyWith(
                                color: _selectedStoryMode == 'Rune City Quest'
                                    ? AppTheme.syntaxYellow
                                    : AppTheme.syntaxBlue,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: _selectedStoryMode == 'Rune City Quest'
                              ? AppTheme.syntaxYellow
                              : AppTheme.syntaxBlue,
                          size: 28,
                        ),
                      ],
                    ),
                  ).animate()
                    .fadeIn(duration: 300.ms)
                    .scale(begin: const Offset(0.8, 0.8), curve: Curves.elasticOut)
                    .shimmer(delay: 400.ms, duration: 1.seconds, color: Colors.white24),

                const SizedBox(height: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
