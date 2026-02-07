import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/theme.dart';
import '../../widgets/background/code_background.dart';
import '../../widgets/onboarding/selection_card.dart';
import 'story_mode_selection_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final String username;

  const LanguageSelectionScreen({
    super.key,
    required this.username,
  });

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String? _selectedLanguage;
  bool _isTransitioning = false;

  void _selectLanguage(String language) {
    setState(() {
      _selectedLanguage = language;
      _isTransitioning = true;
    });

    // Show confirmation and transition
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                StoryModeSelectionScreen(
              username: widget.username,
              selectedLanguage: _selectedLanguage!,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 600),
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
                  'Choose Your Language',
                  style: AppTheme.headingStyle.copyWith(fontSize: 40),
                ).animate().fadeIn().slideY(begin: -0.3, end: 0),

                const SizedBox(height: 16),

                Text(
                  'Select the programming language you want to master',
                  style: AppTheme.bodyStyle.copyWith(
                    color: AppTheme.syntaxComment,
                    fontSize: 16,
                  ),
                ).animate(delay: 200.ms).fadeIn(),

                const Spacer(),

                // Language Cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Python Card with logo asset
                    SelectionCard(
                      title: 'Python',
                      description: 'Beginner-friendly, versatile, and powerful for data science & AI',
                      customLogo: Image.asset(
                        'assets/images/python_custom.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                      accentColor: AppTheme.syntaxBlue,
                      isSelected: _selectedLanguage == 'Python',
                      onTap: () => _selectLanguage('Python'),
                    ).animate(delay: 400.ms).fadeIn().slideX(begin: -0.2, end: 0),

                    const SizedBox(width: 40),

                    // C Programming Card with logo asset
                    SelectionCard(
                      title: 'C',
                      description: 'System-level programming, performance-focused, foundational language',
                      customLogo: Image.asset(
                        'assets/images/c_custom.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                      accentColor: AppTheme.syntaxGreen,
                      isSelected: _selectedLanguage == 'C',
                      onTap: () => _selectLanguage('C'),
                    ).animate(delay: 600.ms).fadeIn().slideX(begin: 0.2, end: 0),
                  ],
                ),


                const Spacer(),

                // Impressive Selection Confirmation
                if (_selectedLanguage != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          (_selectedLanguage == 'Python'
                              ? AppTheme.syntaxBlue
                              : AppTheme.syntaxGreen).withValues(alpha: 0.3),
                          (_selectedLanguage == 'Python'
                              ? AppTheme.syntaxBlue
                              : AppTheme.syntaxGreen).withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _selectedLanguage == 'Python'
                            ? AppTheme.syntaxBlue
                            : AppTheme.syntaxGreen,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (_selectedLanguage == 'Python'
                              ? AppTheme.syntaxBlue
                              : AppTheme.syntaxGreen).withValues(alpha: 0.5),
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
                            color: _selectedLanguage == 'Python'
                                ? AppTheme.syntaxBlue
                                : AppTheme.syntaxGreen,
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
                              'Language Selected',
                              style: AppTheme.codeStyle.copyWith(
                                color: AppTheme.syntaxComment,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _selectedLanguage!,
                              style: AppTheme.headingStyle.copyWith(
                                color: _selectedLanguage == 'Python'
                                    ? AppTheme.syntaxBlue
                                    : AppTheme.syntaxGreen,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: _selectedLanguage == 'Python'
                              ? AppTheme.syntaxBlue
                              : AppTheme.syntaxGreen,
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
