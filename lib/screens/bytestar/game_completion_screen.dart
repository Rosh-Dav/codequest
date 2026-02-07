import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../widgets/bytestar/animated_space_background.dart';
import '../../utils/bytestar_theme.dart';
import '../../models/bytestar_data.dart';
import '../../services/bytestar/reward_service.dart';

class GameCompletionScreen extends StatefulWidget {
  const GameCompletionScreen({super.key});

  @override
  State<GameCompletionScreen> createState() => _GameCompletionScreenState();
}

class _GameCompletionScreenState extends State<GameCompletionScreen> {
  int _totalXp = 0;
  List<String> _badges = [];

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final rewardService = RewardService();
    final xp = await rewardService.getXp();
    final badges = await rewardService.getBadges();
    if (mounted) {
      setState(() {
        _totalXp = xp;
        _badges = badges;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ByteStarTheme.primary,
      body: Stack(
        children: [
          // Background - Hyperspace Effect
          Positioned.fill(
            child: AnimatedSpaceBackground(
              sceneType: SceneType.hyperspace, // We need to add this if not exists, or use deepSpace with high speed
              child: SizedBox.expand(),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Trophy / Ship Icon
                const Icon(Icons.rocket_launch, size: 100, color: ByteStarTheme.accent)
                    .animate(onPlay: (c) => c.repeat())
                    .shimmer(duration: 2.seconds, color: Colors.white),

                const SizedBox(height: 32),

                // Title
                Text(
                  'SYSTEMS ONLINE',
                  style: ByteStarTheme.heading.copyWith(fontSize: 32, letterSpacing: 4),
                ).animate().fadeIn().scale(),

                const SizedBox(height: 16),
                
                Text(
                  'The ByteStar is fully operational.',
                  style: ByteStarTheme.body.copyWith(fontSize: 18),
                ).animate().fadeIn(delay: 500.ms),

                const SizedBox(height: 48),

                // Stats Card
                Container(
                  padding: const EdgeInsets.all(24),
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  decoration: BoxDecoration(
                    color: ByteStarTheme.cardBg.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: ByteStarTheme.accent),
                  ),
                  child: Column(
                    children: [
                      Text('MISSION REPORT', style: ByteStarTheme.heading.copyWith(fontSize: 20)),
                      const Divider(color: ByteStarTheme.accent),
                      const SizedBox(height: 16),
                      _buildStatRow('Total XP', '$_totalXp'),
                      _buildStatRow('Badges Earned', '${_badges.length} / ${BadgeData.allBadges.length}'),
                      _buildStatRow('Ship Integrity', '100%'),
                    ],
                  ),
                ).animate().slideY(begin: 0.5, end: 0, delay: 1.seconds).fadeIn(),

                const SizedBox(height: 48),

                // CTA
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst); // Go to Dashboard/Home
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ByteStarTheme.success,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: const Text('LAUNCH INTO DEEP SPACE'),
                ).animate().fadeIn(delay: 2.seconds).shimmer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: ByteStarTheme.body.copyWith(color: Colors.grey)),
          Text(value, style: ByteStarTheme.code.copyWith(fontSize: 18, color: ByteStarTheme.accent)),
        ],
      ),
    );
  }
}
