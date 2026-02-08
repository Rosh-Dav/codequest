import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/theme.dart';
import '../../models/multiplayer/room.dart';
import '../../models/multiplayer/game_state.dart';

class ResultsScreen extends StatelessWidget {
  final Room room;
  final GameState gameState;
  final String currentUserId;

  const ResultsScreen({
    super.key,
    required this.room,
    required this.gameState,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final sortedPlayers = _getSortedPlayers();
    final winner = sortedPlayers.first;
    final currentPlayerRank = sortedPlayers.indexWhere(
      (p) => p.id == currentUserId,
    ) + 1;

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.darkBackground,
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
                // Title
                Center(
                  child: Text(
                    'GAME OVER',
                    style: AppTheme.headingStyle.copyWith(
                      fontSize: 48,
                      letterSpacing: 4,
                    ),
                  ).animate().fadeIn().slideY(begin: -0.3),
                ),

                const SizedBox(height: 40),

                // Winner Announcement
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.neonBlue.withValues(alpha: 0.2),
                        AppTheme.neonPurple.withValues(alpha: 0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.neonBlue,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.emoji_events,
                        color: AppTheme.syntaxYellow,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'WINNER',
                        style: AppTheme.bodyStyle.copyWith(
                          fontSize: 14,
                          color: AppTheme.syntaxYellow,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        winner.name,
                        style: AppTheme.headingStyle.copyWith(
                          fontSize: 32,
                          color: AppTheme.syntaxYellow,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${gameState.playerScores[winner.id] ?? 0} points',
                        style: AppTheme.bodyStyle.copyWith(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ).animate(delay: 200.ms).fadeIn().scale(),

                const SizedBox(height: 32),

                // Your Rank
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.idePanel.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.neonPurple.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'YOUR RANK',
                        style: AppTheme.bodyStyle.copyWith(
                          color: AppTheme.neonPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '#$currentPlayerRank',
                        style: AppTheme.headingStyle.copyWith(
                          fontSize: 24,
                          color: AppTheme.neonPurple,
                        ),
                      ),
                    ],
                  ),
                ).animate(delay: 400.ms).fadeIn().slideX(begin: -0.2),

                const SizedBox(height: 24),

                // Leaderboard
                Text(
                  'LEADERBOARD',
                  style: AppTheme.bodyStyle.copyWith(
                    color: AppTheme.neonBlue,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontSize: 12,
                  ),
                ).animate(delay: 600.ms).fadeIn(),

                const SizedBox(height: 16),

                // Player Rankings
                Expanded(
                  child: ListView.builder(
                    itemCount: sortedPlayers.length,
                    itemBuilder: (context, index) {
                      final player = sortedPlayers[index];
                      final score = gameState.playerScores[player.id] ?? 0;
                      final isCurrentUser = player.id == currentUserId;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isCurrentUser
                              ? AppTheme.neonPurple.withValues(alpha: 0.2)
                              : AppTheme.idePanel.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isCurrentUser
                                ? AppTheme.neonPurple
                                : Colors.white10,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Rank
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: _getRankColor(index).withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _getRankColor(index),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '#${index + 1}',
                                  style: AppTheme.bodyStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: _getRankColor(index),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Name
                            Expanded(
                              child: Text(
                                player.name,
                                style: AppTheme.bodyStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            // Score
                            Text(
                              '$score pts',
                              style: AppTheme.bodyStyle.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _getRankColor(index),
                              ),
                            ),
                          ],
                        ),
                      ).animate(delay: Duration(milliseconds: 800 + (index * 100)))
                          .fadeIn()
                          .slideX(begin: 0.2);
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.neonPurple,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: AppTheme.neonPurple, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'EXIT',
                          style: AppTheme.bodyStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ).animate(delay: 1200.ms).fadeIn().slideY(begin: 0.3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Player> _getSortedPlayers() {
    final players = List<Player>.from(room.players);
    players.sort((a, b) {
      final scoreA = gameState.playerScores[a.id] ?? 0;
      final scoreB = gameState.playerScores[b.id] ?? 0;
      return scoreB.compareTo(scoreA);
    });
    return players;
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 0:
        return AppTheme.syntaxYellow; // Gold
      case 1:
        return Colors.grey; // Silver
      case 2:
        return Colors.brown; // Bronze
      default:
        return AppTheme.neonBlue;
    }
  }
}
