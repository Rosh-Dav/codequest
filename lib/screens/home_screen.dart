import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/theme.dart';
import '../widgets/background/code_background.dart';
import '../services/local_storage_service.dart';

/// Home Screen - Placeholder for non-ByteStar Arena combinations
/// Shows welcome message and selected preferences
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocalStorageService _storage = LocalStorageService();
  String _welcomeMessage = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWelcomeMessage();
  }

  Future<void> _loadWelcomeMessage() async {
    await _storage.init();
    final username = await _storage.getUsername() ?? 'Coder';
    final language = await _storage.getSelectedLanguage() ?? 'Unknown';
    final storyMode = await _storage.getSelectedStoryMode() ?? 'Unknown';
    
    setState(() {
      _welcomeMessage = 'Welcome back, $username!\nYou are learning $language in $storyMode mode.';
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            child: Center(
              child: _isLoading
                  ? const CircularProgressIndicator(
                      color: AppTheme.syntaxBlue,
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Welcome Icon
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppTheme.syntaxPurple.withValues(alpha: 0.6),
                                AppTheme.syntaxBlue.withValues(alpha: 0.3),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: const Icon(
                            Icons.home,
                            size: 60,
                            color: Colors.white,
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 800.ms)
                            .scale(begin: const Offset(0.5, 0.5)),

                        const SizedBox(height: 40),

                        // Welcome Message
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            _welcomeMessage,
                            style: AppTheme.headingStyle.copyWith(
                              fontSize: 24,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.2, end: 0),

                        const SizedBox(height: 60),

                        // Coming Soon Message
                        Container(
                          padding: const EdgeInsets.all(24),
                          margin: const EdgeInsets.symmetric(horizontal: 32),
                          decoration: BoxDecoration(
                            color: AppTheme.idePanel.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppTheme.syntaxYellow.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.construction,
                                color: AppTheme.syntaxYellow,
                                size: 48,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Story Coming Soon',
                                style: AppTheme.headingStyle.copyWith(
                                  fontSize: 20,
                                  color: AppTheme.syntaxYellow,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'This story mode is under development. '
                                'Stay tuned for exciting coding adventures!',
                                style: AppTheme.bodyStyle.copyWith(
                                  color: AppTheme.syntaxComment,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.2, end: 0),

                        const SizedBox(height: 40),

                        // Placeholder Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Profile feature coming soon!'),
                                    backgroundColor: AppTheme.syntaxBlue,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.person),
                              label: const Text('Profile'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.syntaxBlue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Settings feature coming soon!'),
                                    backgroundColor: AppTheme.syntaxPurple,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.settings),
                              label: const Text('Settings'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.syntaxPurple,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ],
                        ).animate(delay: 900.ms).fadeIn().scale(),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
