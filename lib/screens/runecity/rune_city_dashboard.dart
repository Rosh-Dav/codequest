import 'package:flutter/material.dart';
import '../../utils/theme.dart';
import '../../widgets/background/code_background.dart';
import '../onboarding/story_mode_selection_screen.dart';

class RuneCityDashboard extends StatelessWidget {
  final String username;
  final String selectedLanguage; // Added to enable back navigation

  const RuneCityDashboard({
    super.key, 
    required this.username,
    this.selectedLanguage = 'JavaScript', // Default fallback
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.ideBackground,
      body: Stack(
        children: [
          const Positioned.fill(
            child: CodeBackground(),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   const Icon(Icons.construction, size: 80, color: AppTheme.syntaxYellow),
                   const SizedBox(height: 24),
                   Text(
                    'Rune City Under Construction',
                    style: AppTheme.headingStyle.copyWith(color: AppTheme.syntaxYellow),
                   ),
                   const SizedBox(height: 16),
                   Text(
                    'Welcome, $username!\nThe Rune City developers are still building this world.',
                    textAlign: TextAlign.center,
                    style: AppTheme.bodyStyle,
                   ),
                   const SizedBox(height: 40),
                   ElevatedButton(
                     onPressed: () {
                       // Go back to story selection with valid state
                       Navigator.of(context).pushReplacement(
                         MaterialPageRoute(
                           builder: (_) => StoryModeSelectionScreen(
                             username: username,
                             selectedLanguage: selectedLanguage,
                           ),
                         ),
                       );
                     },
                     style: ElevatedButton.styleFrom(
                       backgroundColor: AppTheme.syntaxYellow,
                       foregroundColor: Colors.black,
                     ),
                     child: const Text('Back to Story Selection'),
                   ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
