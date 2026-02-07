import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/bytestar_theme.dart';
import '../../services/bytestar/reward_service.dart';
import '../../models/bytestar_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final String username;

  const ProfileScreen({super.key, required this.username});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final RewardService _rewardService = RewardService();
  int _xp = 0;
  int _level = 1;
  double _xpProgress = 0.0;
  int _xpNeeded = 500;
  int _missionsCompleted = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final xp = await _rewardService.getXp();
    final level = await _rewardService.getLevel();
    final progress = await _rewardService.getXpProgress();
    final needed = await _rewardService.getXpNeededForNextLevel();
    
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getStringList('completedMissions') ?? [];

    setState(() {
      _xp = xp;
      _level = level;
      _xpProgress = progress;
      _xpNeeded = needed;
      _missionsCompleted = completed.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ByteStarTheme.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('PILOT PROFILE', style: ByteStarTheme.heading.copyWith(fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ByteStarTheme.accent),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Dynamic Background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    ByteStarTheme.primary,
                    ByteStarTheme.primary.withValues(alpha: 0.8),
                    ByteStarTheme.secondary.withValues(alpha: 0.9),
                  ],
                ),
              ),
            ),
          ),
          
          // Animated Grid & Tactical Data Streams
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: CustomPaint(
                painter: _TacticalGridPainter(),
              ),
            ),
          ),

          // Periodically Moving Scanline
          Positioned.fill(
            child: _ScanningLine(),
          ),

          // Static CRT Scanlines Overlay
          const Positioned.fill(
            child: IgnorePointer(
              child: _ScanlineOverlay(),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  // Pilot Header with Holographic Ring & Tech Brackets
                  _buildPilotHeader(),
                  const SizedBox(height: 32),
                  
                  // Level & XP Card with Tactical Frame
                  _buildLevelCard(),
                  const SizedBox(height: 24),
                  
                  // Stats Grid with Cascaded Tech Animations
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.4,
                    children: [
                      _buildStatCard('MISSIONS', '$_missionsCompleted/14', Icons.rocket_launch, 0),
                      _buildStatCard('RANK', _getRankName(_level), Icons.military_tech, 1),
                      _buildStatCard('INTEGRITY', '100%', Icons.shield, 2),
                      _buildStatCard('BADGES', '0', Icons.workspace_premium, 3),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  // Achievements in a Tactical Panel
                  _buildBadgesPreview(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPilotHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Outer Rotating Holographic Ring
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: ByteStarTheme.accent.withValues(alpha: 0.15),
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
            ).animate(onPlay: (controller) => controller.repeat())
              .rotate(duration: 8.seconds, curve: Curves.linear),

            // Inner Pulsing tech ring
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: ByteStarTheme.accent.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
            ).animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(duration: 2.seconds, begin: const Offset(1, 1), end: const Offset(1.05, 1.05)),
              
            // Avatar with Glow & Glitch Animation
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: ByteStarTheme.accent.withValues(alpha: 0.6),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: ByteStarTheme.accent.withValues(alpha: 0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipOval(
                child: Container(
                  color: ByteStarTheme.secondary.withValues(alpha: 0.6),
                  child: const Icon(Icons.person, size: 70, color: Colors.white),
                ),
              ),
            ).animate(onPlay: (controller) => controller.repeat(reverse: true))
              .tint(color: ByteStarTheme.accent.withValues(alpha: 0.1), duration: 200.ms)
              .shake(hz: 2, duration: 100.ms, delay: 3.seconds),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          widget.username.toUpperCase(),
          style: ByteStarTheme.heading.copyWith(
            fontSize: 28, 
            letterSpacing: 8,
            shadows: [
              Shadow(color: ByteStarTheme.accent, blurRadius: 15),
              const Shadow(color: Colors.white, blurRadius: 2),
            ],
          ),
        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3, end: 0),
        
        // Animated Status Tag
        Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: ByteStarTheme.accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: ByteStarTheme.accent.withValues(alpha: 0.4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: ByteStarTheme.success,
                  shape: BoxShape.circle,
                ),
              ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                .boxShadow(end: const BoxShadow(color: ByteStarTheme.success, blurRadius: 8)),
              const SizedBox(width: 8),
              Text(
                'SYSTEMS ACTIVE',
                style: ByteStarTheme.code.copyWith(fontSize: 10, color: ByteStarTheme.accent, letterSpacing: 2),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 500.ms),
      ],
    );
  }

  Widget _buildLevelCard() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: ByteStarTheme.accent.withValues(alpha: 0.15)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('EXPERIENCE LEVEL', style: ByteStarTheme.code.copyWith(color: ByteStarTheme.accent, fontSize: 10, letterSpacing: 2)),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text('$_level', style: ByteStarTheme.heading.copyWith(fontSize: 48, color: ByteStarTheme.accent)),
                          const SizedBox(width: 8),
                          Text('RANK: ${_getRankName(_level)}', style: ByteStarTheme.body.copyWith(fontSize: 12, color: Colors.white54, letterSpacing: 1)),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ByteStarTheme.accent.withValues(alpha: 0.05),
                    ),
                    child: const Icon(Icons.flash_on, color: ByteStarTheme.accent, size: 32),
                  ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                    .shimmer(duration: 1.5.seconds, color: Colors.white30),
                ],
              ),
              const SizedBox(height: 24),
              Stack(
                children: [
                  Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: _xpProgress,
                        backgroundColor: Colors.transparent,
                        valueColor: const AlwaysStoppedAnimation<Color>(ByteStarTheme.accent),
                      ),
                    ),
                  ),
                  // Tech ticks
                  Positioned.fill(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(10, (i) => Container(width: 1, color: Colors.white12)),
                    ),
                  ),
                ],
              ).animate().shimmer(delay: 1.seconds, duration: 2.seconds),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('EXP: $_xp', style: ByteStarTheme.code.copyWith(fontSize: 10, color: Colors.white24)),
                  Text('NEXT: $_xpNeeded XP', style: ByteStarTheme.code.copyWith(fontSize: 10, color: ByteStarTheme.accent, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
        // HUD Brackets
        const Positioned(top: 0, left: 0, child: _TechCorner(isTop: true, isLeft: true)),
        const Positioned(top: 0, right: 0, child: _TechCorner(isTop: true, isLeft: false)),
        const Positioned(bottom: 0, left: 0, child: _TechCorner(isTop: false, isLeft: true)),
        const Positioned(bottom: 0, right: 0, child: _TechCorner(isTop: false, isLeft: false)),
      ],
    ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1, end: 0);
  }

  Widget _buildStatCard(String label, String value, IconData icon, int index) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: ByteStarTheme.accent, size: 16),
              const SizedBox(height: 12),
              Text(label, style: ByteStarTheme.code.copyWith(fontSize: 8, color: Colors.white38, letterSpacing: 1.5)),
              const SizedBox(height: 2),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(value, style: ByteStarTheme.heading.copyWith(fontSize: 18, color: Colors.white, letterSpacing: 1)),
              ),
            ],
          ),
        ),
        // Mini tech accent in corner
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            width: 10,
            height: 1,
            color: ByteStarTheme.accent.withValues(alpha: 0.5),
          ),
        ),
      ],
    ).animate().fadeIn(delay: (600 + (index * 100)).ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildBadgesPreview() {
    return Stack(
      children: [
        Container(
           padding: const EdgeInsets.all(24),
           decoration: BoxDecoration(
             color: Colors.black.withValues(alpha: 0.1),
             borderRadius: BorderRadius.circular(4),
             border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
           ),
           child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('TAC-ACHIEVEMENTS', style: ByteStarTheme.heading.copyWith(fontSize: 14, letterSpacing: 3)),
                  Icon(Icons.more_horiz, color: ByteStarTheme.accent.withValues(alpha: 0.5), size: 16),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 70,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) => Container(
                    width: 70,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.02),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                    ),
                    child: Center(
                      child: Icon(
                        index == 0 ? Icons.verified_user : Icons.lock_outline, 
                        color: index == 0 ? ByteStarTheme.accent : Colors.white10, 
                        size: 24
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Positioned(top: 0, left: 0, child: _TechCorner(isTop: true, isLeft: true)),
        const Positioned(bottom: 0, right: 0, child: _TechCorner(isTop: false, isLeft: false)),
      ],
    ).animate().fadeIn(delay: 1.seconds);
  }

  String _getRankName(int level) {
    if (level < 3) return 'RECRUIT';
    if (level < 6) return 'CADET';
    if (level < 10) return 'PILOT';
    if (level < 15) return 'COMMANDER';
    return 'STAR-LORD';
  }
}

class _TacticalGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ByteStarTheme.accent.withValues(alpha: 0.1)
      ..strokeWidth = 0.5;

    // Grid Lines
    for (double i = 0; i < size.width; i += 50) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 50) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }

    // Secondary fine grid
    paint.color = ByteStarTheme.accent.withValues(alpha: 0.03);
    for (double i = 0; i < size.width; i += 10) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ScanningLine extends StatefulWidget {
  @override
  State<_ScanningLine> createState() => _ScanningLineState();
}

class _ScanningLineState extends State<_ScanningLine> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: 4.seconds)..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: _controller.value * MediaQuery.of(context).size.height,
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      ByteStarTheme.accent.withValues(alpha: 0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ScanlineOverlay extends StatelessWidget {
  const _ScanlineOverlay();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => Container(
        height: 1,
        color: Colors.black.withValues(alpha: 0.05),
        margin: const EdgeInsets.only(bottom: 2),
      ),
    );
  }
}

class _TechCorner extends StatelessWidget {
  final bool isTop;
  final bool isLeft;

  const _TechCorner({required this.isTop, required this.isLeft});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15,
      height: 15,
      padding: const EdgeInsets.all(2),
      child: CustomPaint(
        painter: _BracketPainter(isTop: isTop, isLeft: isLeft),
      ),
    );
  }
}

class _BracketPainter extends CustomPainter {
  final bool isTop;
  final bool isLeft;

  _BracketPainter({required this.isTop, required this.isLeft});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ByteStarTheme.accent.withValues(alpha: 0.5)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    if (isTop && isLeft) {
      path.moveTo(0, size.height);
      path.lineTo(0, 0);
      path.lineTo(size.width, 0);
    } else if (isTop && !isLeft) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
    } else if (!isTop && isLeft) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(size.width, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
