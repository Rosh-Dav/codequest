import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/level_manager.dart';
import '../../utils/phase1_theme.dart';
import '../../widgets/phase1/level_card.dart';
import '../../services/tts_service.dart';

class LevelMapScreen extends StatefulWidget {
  const LevelMapScreen({super.key});

  @override
  State<LevelMapScreen> createState() => _LevelMapScreenState();
}

class _LevelMapScreenState extends State<LevelMapScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh state
    LevelManager().init().then((_) => setState(() {}));
    
    // Play intro music/ambience if implemented
    // Speak status
    Future.delayed(500.ms, () {
      TTSService().speak("Mission Hub Active. Select a mission to proceed.");
    });
  }

  void _onLevelTap(int index) {
    final level = LevelManager().levels[index];
    if (level.isUnlocked) {
      // Play sound
      TTSService().speak("Initiating ${level.title}");
      
      // Navigate
      // Note: We push the route. When it returns, we refresh.
      Navigator.of(context).pushNamed(level.route).then((_) {
        // Refresh on return (in case next level unlocked)
        setState(() {}); // LevelManager singleton updates, but we need to rebuild UI
      });
    } else {
      // Locked
      TTSService().speak("Access Denied. Complete previous missions first.");
      
      // Shake animation (handled by widget state or simple snackbar for now)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("LOCKED: Complete Level ${level.id - 1} first.", style: Phase1Theme.codeFont),
          backgroundColor: Phase1Theme.errorRed,
          duration: 1.seconds,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background - Neon Grid
          Positioned.fill(
            child: GridPaper(
              color: Phase1Theme.deepSpaceBlue.withValues(alpha: 0.1),
              interval: 50,
              divisions: 1,
              subdivisions: 1,
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("PHASE 1", style: Phase1Theme.sciFiFont.copyWith(color: Colors.grey, fontSize: 14)),
                          Text("SYSTEM AWAKENING", style: Phase1Theme.alertFont.copyWith(color: Phase1Theme.cyanGlow, fontSize: 20)),
                        ],
                      ),
                      // Progress Ring or Value
                      AnimatedBuilder(
                        animation: LevelManager(),
                        builder: (context, child) {
                          final progress = LevelManager().progress;
                          return Column(
                            children: [
                              Text("${(progress * 100).toInt()}%", style: Phase1Theme.codeFont.copyWith(color: Phase1Theme.purplish, fontSize: 18)),
                              SizedBox(
                                width: 100,
                                child: LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor: Colors.white10,
                                  color: Phase1Theme.purplish,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                
                // Map Grid
                Expanded(
                  child: AnimatedBuilder(
                    animation: LevelManager(),
                    builder: (context, child) {
                      final levels = LevelManager().levels;
                      return GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 2 columns
                          childAspectRatio: 1.5,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: levels.length,
                        itemBuilder: (context, index) {
                          return LevelCard(
                            level: levels[index],
                            onTap: () => _onLevelTap(index),
                          ).animate().scale(delay: (index * 100).ms, duration: 400.ms);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
