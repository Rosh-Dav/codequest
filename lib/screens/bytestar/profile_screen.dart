import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/bytestar_theme.dart';
import '../../utils/theme.dart';
import '../../services/profile_stats_aggregator.dart';
import '../../services/local_storage_service.dart';

class ProfileScreen extends StatefulWidget {
  final String? username;
  final bool isFantasyTheme;

  const ProfileScreen({
    super.key,
    this.username,
    this.isFantasyTheme = false,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileStatsAggregator _aggregator = ProfileStatsAggregator();
  ProfileStats? _stats;
  bool _isLoading = true;
  String? _username;

  @override
  void initState() {
    super.initState();
    _loadAllStats();
  }

  Future<void> _loadAllStats() async {
    final stats = await _aggregator.aggregate();
    
    String? localUsername;
    if (widget.username == null) {
      localUsername = await LocalStorageService().getUsername();
    }

    if (mounted) {
      setState(() {
        _stats = stats;
        _username = localUsername;
        _isLoading = false;
      });
    }
  }

  Color get _accentColor => widget.isFantasyTheme ? AppTheme.syntaxYellow : ByteStarTheme.accent;
  Color get _primaryBg => widget.isFantasyTheme ? AppTheme.ideBackground : ByteStarTheme.primary;
  Color get _secondaryBg => widget.isFantasyTheme ? AppTheme.idePanel : ByteStarTheme.secondary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _primaryBg,
      body: Stack(
        children: [
          // Background effects
          if (widget.isFantasyTheme)
            _buildMysticBackground()
          else
            _buildSciFiBackground(),

          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                pinned: true,
                expandedHeight: 260,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: _accentColor),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildPilotHeader(),
                ),
              ),
              if (_isLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildMainStats(),
                        const SizedBox(height: 24),
                        _buildLevelCard(),
                        const SizedBox(height: 24),
                        _buildStoryProgress(),
                        const SizedBox(height: 24),
                        _buildLanguageStats(),
                        const SizedBox(height: 24),
                        _buildActivityGrid(),
                        const SizedBox(height: 40),
                        const SizedBox(height: 12),
                        _buildActionButton(
                          widget.isFantasyTheme ? 'LEAVE GUILD' : 'LOGOUT', 
                          Icons.logout, 
                          () {
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          },
                          isDestructive: true
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          
          // CRT Overlay for Sci-Fi
          if (!widget.isFantasyTheme)
            IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.1),
                      Colors.black.withValues(alpha: 0.0),
                      Colors.black.withValues(alpha: 0.1),
                    ],
                    stops: const [0, 0.5, 1],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSciFiBackground() {
    return Positioned.fill(
      child: Stack(
        children: [
          // Grid lines
          CustomPaint(
            size: Size.infinite,
            painter: _GridPainter(ByteStarTheme.accent.withValues(alpha: 0.05)),
          ),
          // Pulsing glow
          Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    ByteStarTheme.accent.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
             .scale(duration: 3.seconds, begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2)),
          ),
        ],
      ),
    );
  }

  Widget _buildMysticBackground() {
    return Positioned.fill(
      child: Stack(
        children: [
          // Fantasy Ambient Glow
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.5),
                radius: 1.2,
                colors: [
                  AppTheme.syntaxYellow.withValues(alpha: 0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // Floating particles
          ...List.generate(15, (i) {
            return _FloatingParticle(
              color: AppTheme.syntaxYellow.withValues(alpha: 0.2),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMainStats() {
    return Row(
      children: [
        Expanded(child: _buildStatCard('MISSIONS', '${_stats?.missionsCompleted ?? 0}', Icons.task_alt)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard('XP TOTAL', '${_stats?.totalXp ?? 0}', Icons.bolt)),
      ],
    );
  }

  Widget _buildLevelCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _secondaryBg.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _accentColor.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(color: _accentColor.withValues(alpha: 0.05), blurRadius: 20, spreadRadius: 2),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.isFantasyTheme ? 'ASCENSION' : 'RANK PROGRESS', 
                style: ByteStarTheme.code.copyWith(color: _accentColor, fontSize: 12, fontWeight: FontWeight.bold)
              ),
              Text('LVL ${_stats?.level ?? 1}', style: ByteStarTheme.code.copyWith(color: _accentColor, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _stats?.levelProgress ?? 0.0,
              minHeight: 8,
              backgroundColor: Colors.black26,
              valueColor: AlwaysStoppedAnimation<Color>(_accentColor),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${((_stats?.levelProgress ?? 0.0) * 500).toInt()} / 500 XP TO NEXT LEVEL',
            style: ByteStarTheme.code.copyWith(color: Colors.white54, fontSize: 10, letterSpacing: 1),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: _secondaryBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _accentColor.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          Icon(icon, color: _accentColor, size: 28).animate(onPlay: (c) => c.repeat(reverse: true)).shimmer(duration: 3.seconds),
          const SizedBox(height: 12),
          Text(value, style: ByteStarTheme.heading.copyWith(fontSize: 24, color: Colors.white)),
          const SizedBox(height: 4),
          Text(
            label, 
            style: ByteStarTheme.code.copyWith(fontSize: 10, color: _accentColor.withValues(alpha: 0.6), fontWeight: FontWeight.bold)
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.9, 0.9));
  }

  Widget _buildActivityGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.isFantasyTheme ? 'DIVINE RELICS' : 'ACHIEVEMENTS', 
          style: ByteStarTheme.code.copyWith(color: _accentColor, fontSize: 12, fontWeight: FontWeight.bold)
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: List.generate(4, (i) => _buildBadgePlaceholder(i)),
        ),
      ],
    );
  }

  Widget _buildBadgePlaceholder(int index) {
    if (_stats == null) return const SizedBox.shrink();
    
    // Use real badges if available, else placeholders
    if (index < _stats!.badges.length) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: _accentColor.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(12),
          color: _accentColor.withValues(alpha: 0.05),
        ),
        child: const Icon(Icons.workspace_premium, color: AppTheme.syntaxYellow),
      ).animate().fadeIn(delay: (400 + index * 100).ms);
    }

    final icons = [Icons.stars, Icons.workspace_premium, Icons.military_tech, Icons.verified];
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: _accentColor.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(12),
        color: Colors.black12,
      ),
      child: Icon(icons[index % icons.length], color: _accentColor.withValues(alpha: 0.2)),
    ).animate().fadeIn(delay: (400 + index * 100).ms);
  }

  Widget _buildStoryProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'STORY ARCHIVE',
          style: ByteStarTheme.code.copyWith(color: _accentColor, fontSize: 12, fontWeight: FontWeight.bold)
        ),
        const SizedBox(height: 16),
        ...(_stats?.missionsPerStory.entries.map((entry) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _secondaryBg.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _accentColor.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                Icon(
                  entry.key == 'ByteStar Arena' ? Icons.rocket_launch : Icons.fort,
                  color: _accentColor,
                  size: 20,
                ),
                const SizedBox(width: 16),
                Text(
                  entry.key,
                  style: ByteStarTheme.body.copyWith(fontSize: 14, color: Colors.white),
                ),
                const Spacer(),
                Text(
                  '${entry.value} MISSIONS',
                  style: ByteStarTheme.code.copyWith(fontSize: 10, color: _accentColor),
                ),
              ],
            ),
          );
        }).toList() ?? []),
      ],
    ).animate().fadeIn(delay: 500.ms);
  }

  Widget _buildLanguageStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TECHNICAL MASTERY',
          style: ByteStarTheme.code.copyWith(color: _accentColor, fontSize: 12, fontWeight: FontWeight.bold)
        ),
        const SizedBox(height: 16),
        ...(_stats?.languageExperience.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: ByteStarTheme.body.copyWith(fontSize: 13, color: Colors.white70),
                    ),
                    Text(
                      '${(entry.value * 100).toInt()}%',
                      style: ByteStarTheme.code.copyWith(fontSize: 11, color: _accentColor),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: entry.value,
                    minHeight: 4,
                    backgroundColor: Colors.black26,
                    valueColor: AlwaysStoppedAnimation<Color>(_accentColor.withValues(alpha: 0.7)),
                  ),
                ),
              ],
            ),
          );
        }).toList() ?? []),
      ],
    ).animate().fadeIn(delay: 600.ms);
  }

  Widget _buildPilotHeader() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 32),
          Stack(
            alignment: Alignment.center,
            children: [
              // Outer Rotating Ring
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _accentColor.withValues(alpha: 0.15),
                    width: 2,
                  ),
                ),
              ).animate(onPlay: (c) => c.repeat()).rotate(duration: 10.seconds),

              // Inner Avatar
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _accentColor, width: 2),
                  boxShadow: [
                    BoxShadow(color: _accentColor.withValues(alpha: 0.2), blurRadius: 20, spreadRadius: 2),
                  ],
                ),
                child: ClipOval(
                  child: Container(
                    color: Colors.black45,
                    child: const Icon(Icons.person, size: 70, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            (_username ?? widget.username ?? 'PILOT').toUpperCase(),
            style: ByteStarTheme.heading.copyWith(fontSize: 22, letterSpacing: 2, color: Colors.white),
          ).animate().shimmer(delay: 1.seconds, duration: 2.seconds),
          const SizedBox(height: 4),
          Text(
            _getRankName(_stats?.level ?? 1),
            style: ByteStarTheme.code.copyWith(
              fontSize: 12, 
              color: _accentColor, 
              letterSpacing: 4,
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }

  String _getRankName(int level) {
    if (widget.isFantasyTheme) {
      if (level < 5) return 'NOVICE';
      if (level < 10) return 'APPRENTICE';
      if (level < 15) return 'MAGE';
      return 'ARCHMAGE';
    }
    if (level < 5) return 'CADET';
    if (level < 10) return 'PILOT';
    if (level < 15) return 'COMMANDER';
    return 'ELITE';
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap, {bool isDestructive = false}) {
    final color = isDestructive ? Colors.redAccent : _accentColor;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 16),
            Text(
              label, 
              style: ByteStarTheme.code.copyWith(
                color: isDestructive ? Colors.redAccent : Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.bold
              )
            ),
            const Spacer(),
            Icon(Icons.chevron_right, color: color.withValues(alpha: 0.5), size: 18),
          ],
        ),
      ),
    );
  }
}

class _FloatingParticle extends StatelessWidget {
  final Color color;
  const _FloatingParticle({required this.color});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 100, // Randomized in actual stateful if needed, but keeping it simple for now
      top: 100,
      child: Container(
        width: 4,
        height: 4,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ).animate(onPlay: (c) => c.repeat())
       .moveY(begin: 0, end: -100, duration: 4.seconds, curve: Curves.easeInOut)
       .fadeOut(),
    );
  }
}

class _GridPainter extends CustomPainter {
  final Color color;
  _GridPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 1;
    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double j = 0; j < size.height; j += 40) {
      canvas.drawLine(Offset(0, j), Offset(size.width, j), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
