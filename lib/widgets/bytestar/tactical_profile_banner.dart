import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/bytestar_theme.dart';
import '../../utils/theme.dart';
import '../../services/bytestar/reward_service.dart';
import '../../screens/bytestar/profile_screen.dart';

class TacticalProfileBanner extends StatefulWidget {
  final String username;
  final bool isFantasyTheme;
  final VoidCallback? onTap;

  const TacticalProfileBanner({
    super.key,
    required this.username,
    this.isFantasyTheme = false,
    this.onTap,
  });

  @override
  State<TacticalProfileBanner> createState() => _TacticalProfileBannerState();
}

class _TacticalProfileBannerState extends State<TacticalProfileBanner> {
  final RewardService _rewardService = RewardService();
  int _level = 1;
  double _xpProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final level = await _rewardService.getLevel();
    final progress = await _rewardService.getXpProgress();
    if (mounted) {
      setState(() {
        _level = level;
        _xpProgress = progress;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color accentColor = widget.isFantasyTheme ? AppTheme.syntaxYellow : ByteStarTheme.accent;
    final Color panelColor = widget.isFantasyTheme ? AppTheme.idePanel : ByteStarTheme.secondary;

    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => ProfileScreen(username: widget.username)),
          );
        }
        _loadStats();
      },
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: panelColor.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: accentColor.withValues(alpha: 0.4), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.15),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Avatar with animated ring
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: accentColor.withValues(alpha: 0.3), width: 1),
                  ),
                ).animate(onPlay: (c) => c.repeat()).rotate(duration: 4.seconds),
                
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black26,
                    border: Border.all(color: accentColor, width: 1.5),
                  ),
                  child: const Icon(Icons.person, color: Colors.white, size: 20),
                ),
              ],
            ),
            const SizedBox(width: 12),
            
            // Text Info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.username.toUpperCase(),
                  style: (widget.isFantasyTheme ? AppTheme.bodyStyle : ByteStarTheme.code).copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'LVL $_level',
                      style: TextStyle(color: accentColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 80,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: _xpProgress,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(width: 12),
            Icon(Icons.chevron_right, color: accentColor.withValues(alpha: 0.5), size: 16),
          ],
        ),
      ).animate().slideX(begin: -0.2, end: 0).fadeIn(),
    );
  }
}
