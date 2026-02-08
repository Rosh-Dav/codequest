import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/theme.dart';
import '../../models/bytestar_data.dart';
import '../../models/rune_city_c_data.dart';
import '../../widgets/bytestar/nova_hologram.dart';
import '../../widgets/bytestar/tactical_profile_banner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bytestar/mission_engine_screen.dart';
import '../bytestar/profile_screen.dart';

class RuneCityCMissionMapScreen extends StatefulWidget {
  final String username;

  const RuneCityCMissionMapScreen({super.key, required this.username});

  @override
  State<RuneCityCMissionMapScreen> createState() => _RuneCityCMissionMapScreenState();
}

class _RuneCityCMissionMapScreenState extends State<RuneCityCMissionMapScreen> {
  late List<Mission> missions;
  Set<String> unlockedMissionIds = {'rc1'};
  Set<String> completedMissionIds = {};

  @override
  void initState() {
    super.initState();
    missions = runeCityCMissions;
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('runeCityCUnlockedMissions');
    final completed = prefs.getStringList('runeCityCCompletedMissions');
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
      await prefs.setStringList('runeCityCUnlockedMissions', unlockedMissionIds.toList());
    }
  }

  Future<void> _markCompleted(String missionId) async {
    if (!completedMissionIds.contains(missionId)) {
      setState(() {
        completedMissionIds.add(missionId);
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('runeCityCCompletedMissions', completedMissionIds.toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = AppTheme.syntaxYellow;
    return Scaffold(
      backgroundColor: AppTheme.ideBackground,
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
                      // Unlock logic based on RC ids
                      int currentIdx = missions.indexWhere((m) => m.id == mission.id);
                      if (currentIdx != -1 && currentIdx < missions.length - 1) {
                        _unlockMission(missions[currentIdx + 1].id);
                      }
                      _loadProgress(); // Refresh
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
                        // Back Button
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: AppTheme.syntaxYellow),
                          onPressed: () => Navigator.of(context).pop(), 
                        ),
                        
                        // Progress Pill
                        _ProgressPill(
                          current: completedMissionIds.length,
                          total: missions.length,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Tactical Profile Banner (Fantasy Theme)
                    TacticalProfileBanner(
                      username: widget.username,
                      isFantasyTheme: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProfileScreen(
                              username: widget.username,
                              isFantasyTheme: true,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 30,
            child: NovaHologram(
              size: 80,
              accentColor: AppTheme.syntaxYellow,
            ).animate().slideY(begin: 1, end: 0, duration: 800.ms, curve: Curves.easeOutBack),
          ),
        ],
      ),
    );
  }
}

// Reusing helper widgets from RuneCityMissionMapScreen
// (I will need to either copy them or make them public, but for now I'll include them here to avoid conflict)

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
              color: isLocked ? Colors.grey.withOpacity(0.3) : AppTheme.ideBackground,
              border: Border.all(
                color: isLocked ? Colors.grey : accent,
                width: 2,
              ),
              boxShadow: isLocked
                  ? []
                  : [
                      BoxShadow(
                        color: accent.withOpacity(0.5),
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
        color: AppTheme.idePanel.withOpacity(0.5),
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
      ..color = accent.withOpacity(0.3)
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
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF19160E),
                Color(0xFF1F1A10),
                Color(0xFF15110B),
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
                    AppTheme.syntaxYellow.withValues(alpha: 0.15),
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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
