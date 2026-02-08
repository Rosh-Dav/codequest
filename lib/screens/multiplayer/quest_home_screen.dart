import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/theme.dart';
import 'create_room_screen.dart';
import 'join_room_screen.dart';

class QuestHomeScreen extends StatefulWidget {
  const QuestHomeScreen({super.key});

  @override
  State<QuestHomeScreen> createState() => _QuestHomeScreenState();
}

class _QuestHomeScreenState extends State<QuestHomeScreen> {
  String _selectedDifficulty = 'medium';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.darkBackground,
              AppTheme.darkBackground.withValues(alpha: 0.8),
              AppTheme.neonPurple.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppTheme.neonBlue),
                  onPressed: () => Navigator.pop(context),
                ).animate().fadeIn().slideX(begin: -0.2),

                const SizedBox(height: 20),

                // Title
                Text(
                  'QUEST MODE',
                  style: AppTheme.headingStyle.copyWith(
                    fontSize: 48,
                    letterSpacing: 4,
                  ),
                ).animate().fadeIn().slideY(begin: -0.3),

                const SizedBox(height: 8),

                Text(
                  'Real-time multiplayer quiz competition',
                  style: AppTheme.bodyStyle.copyWith(
                    color: AppTheme.syntaxComment,
                    fontSize: 16,
                  ),
                ).animate(delay: 200.ms).fadeIn(),

                const SizedBox(height: 40),

                // Difficulty Selection
                Text(
                  'SELECT DIFFICULTY',
                  style: AppTheme.bodyStyle.copyWith(
                    color: AppTheme.neonPurple,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontSize: 14,
                  ),
                ).animate(delay: 400.ms).fadeIn(),

                const SizedBox(height: 16),

                // Difficulty Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildDifficultyCard(
                        'EASY',
                        'Beginner friendly',
                        AppTheme.syntaxGreen,
                        'easy',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDifficultyCard(
                        'MEDIUM',
                        'Balanced challenge',
                        AppTheme.syntaxYellow,
                        'medium',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDifficultyCard(
                        'HARD',
                        'Expert level',
                        AppTheme.syntaxRed,
                        'hard',
                      ),
                    ),
                  ],
                ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.2),

                const Spacer(),

                // Game Info
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.idePanel.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.neonBlue.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: AppTheme.neonBlue, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'GAME RULES',
                            style: AppTheme.bodyStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.neonBlue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow('👥', '2-6 players per room'),
                      _buildInfoRow('❓', '10 questions per game'),
                      _buildInfoRow('⏱️', '15 seconds per question'),
                      _buildInfoRow('🏆', 'Highest score wins'),
                    ],
                  ),
                ).animate(delay: 800.ms).fadeIn().slideY(begin: 0.2),

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        'CREATE ROOM',
                        Icons.add_circle_outline,
                        AppTheme.neonBlue,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateRoomScreen(
                                difficulty: _selectedDifficulty,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildActionButton(
                        'JOIN ROOM',
                        Icons.login,
                        AppTheme.neonPurple,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const JoinRoomScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ).animate(delay: 1000.ms).fadeIn().slideY(begin: 0.3),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyCard(
    String title,
    String subtitle,
    Color color,
    String value,
  ) {
    final isSelected = _selectedDifficulty == value;

    return GestureDetector(
      onTap: () => setState(() => _selectedDifficulty = value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.2)
              : AppTheme.idePanel.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : color.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: AppTheme.bodyStyle.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected ? color : Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTheme.bodyStyle.copyWith(
                fontSize: 11,
                color: Colors.white60,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 12),
          Text(
            text,
            style: AppTheme.bodyStyle.copyWith(
              fontSize: 13,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.2),
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: color, width: 2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTheme.bodyStyle.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
