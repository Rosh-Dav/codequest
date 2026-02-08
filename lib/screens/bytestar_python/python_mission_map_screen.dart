import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/python_bytestar_theme.dart';
import '../../utils/bytestar_theme.dart';
import '../../models/bytestar_python_data.dart';
import '../../models/bytestar_data.dart'; // For SceneType
import '../../widgets/bytestar/nova_hologram.dart';
import '../../widgets/bytestar/animated_space_background.dart';
import '../../widgets/bytestar/tactical_profile_banner.dart';
import '../bytestar/profile_screen.dart';
import '../../widgets/navigation/global_sidebar.dart';
import 'python_mission_engine_screen.dart';

class PythonMissionMapScreen extends StatefulWidget {
  final String username;

  const PythonMissionMapScreen({super.key, required this.username});

  @override
  State<PythonMissionMapScreen> createState() => _PythonMissionMapScreenState();
}

class _PythonMissionMapScreenState extends State<PythonMissionMapScreen> {
  Set<String> unlockedMissionIds = {'py1'}; // Default unlocked

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('python_unlocked_missions');
    
    if (saved != null) {
      setState(() {
         unlockedMissionIds = saved.toSet();
      });
    } else {
      // First time initialization if not present
      prefs.setStringList('python_unlocked_missions', ['py1']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PythonByteStarTheme.background,
      drawer: GlobalSidebar(username: widget.username),
      body: Stack(
        children: [
          // 1. Background (Deep Space)
          Positioned.fill(
            child: AnimatedSpaceBackground(
              sceneType: SceneType.deepSpace,
              child: const SizedBox.expand(),
            ),
          ),

          // Custom Drawer Trigger (Top Left)
          Positioned(
            top: 40,
            left: 20,
            child: Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.menu, color: ByteStarTheme.accent, size: 30),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),

          // 2. Path Painter
          CustomPaint(
            size: Size.infinite,
            painter: _PythonMissionPathPainter(pythonMissions, unlockedMissionIds),
          ),

          // 3. Mission Nodes
          ...pythonMissions.map((mission) {
            final nextMissionId = 'py${int.parse(mission.id.substring(2)) + 1}';
            final isCompleted = unlockedMissionIds.contains(nextMissionId);

            return Positioned(
              left: MediaQuery.of(context).size.width * mission.x - 30,
              top: MediaQuery.of(context).size.height * mission.y - 30,
              child: _PythonMissionNode(
                mission: mission,
                isLocked: !unlockedMissionIds.contains(mission.id),
                isCompleted: isCompleted, 
                onTap: () async {
                  if (unlockedMissionIds.contains(mission.id)) {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PythonMissionEngineScreen(
                          mission: mission,
                          username: widget.username,
                        ),
                      ),
                    );
                    _loadProgress();
                  }
                },
              ),
            );
          }),

          // 4. HUD
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button with themed icon
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: PythonByteStarTheme.primary),
                        onPressed: () => Navigator.of(context).pop(), 
                      ),
                      
                      // Mission Progress Pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: PythonByteStarTheme.glassPanel,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: PythonByteStarTheme.accent.withOpacity(0.5)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.flag, size: 16, color: PythonByteStarTheme.accent),
                            const SizedBox(width: 8),
                            Text(
                              "UNLOCKED: ${unlockedMissionIds.length} / ${pythonMissions.length}",
                              style: PythonByteStarTheme.body.copyWith(
                                color: PythonByteStarTheme.accent,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // 5. Nova Assistant
          const Positioned(
            bottom: 30,
            right: 30,
            child: NovaHologram(size: 80),
          ),
        ],
      ),
    );
  }
}

class _PythonMissionNode extends StatelessWidget {
  final PythonMission mission;
  final bool isLocked;
  final bool isCompleted;
  final VoidCallback onTap;

  const _PythonMissionNode({
    required this.mission,
    required this.isLocked,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // If mission is unlocked but NOT completed, it's active (primary color).
    // If it's completed, it's success color.
    // Logic for completion: if NEXT mission is unlocked, this one is done.
    // Or if unlockedMissionIds contains this mission AND this mission is < max unlocked?
    // Passed in as isCompleted.
    
    final color = isLocked ? Colors.grey : (isCompleted ? PythonByteStarTheme.success : PythonByteStarTheme.primary);
    
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
              color: isLocked ? Colors.grey.withOpacity(0.2) : Colors.black,
              border: Border.all(color: color, width: 2),
              boxShadow: isLocked ? [] : [
                BoxShadow(color: color.withOpacity(0.5), blurRadius: 15, spreadRadius: 2),
              ],
            ),
            child: Center(
              child: Icon(
                isLocked ? Icons.lock : (isCompleted ? Icons.check : Icons.code),
                color: color,
              ),
            ),
          ).animate(onPlay: (c) => isLocked ? null : c.repeat(reverse: true))
           .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 2.seconds),
          
          const SizedBox(height: 8),
          
          Text(
            mission.title,
            style: PythonByteStarTheme.body.copyWith(fontSize: 10, color: color),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _PythonMissionPathPainter extends CustomPainter {
  final List<PythonMission> missions;
  final Set<String> unlockedIds;

  _PythonMissionPathPainter(this.missions, this.unlockedIds);

  @override
  void paint(Canvas canvas, Size size) {
    if (missions.isEmpty) return;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    // Start at first mission
    final start = Offset(size.width * missions[0].x, size.height * missions[0].y);
    path.moveTo(start.dx, start.dy);

    for (int i = 0; i < missions.length - 1; i++) {
       final current = missions[i];
       final next = missions[i+1];
       
       final p1 = Offset(size.width * current.x, size.height * current.y);
       final p2 = Offset(size.width * next.x, size.height * next.y);
       
       // Draw line
       final isUnlocked = unlockedIds.contains(next.id);
       paint.color = isUnlocked ? PythonByteStarTheme.primary : Colors.grey.withOpacity(0.3);
       
       // Simple straight line
       canvas.drawLine(p1, p2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
