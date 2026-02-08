import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/python_bytestar_theme.dart';
import '../../models/bytestar_data.dart'; // For SceneType
import '../../widgets/bytestar/nova_hologram.dart';
import '../../widgets/bytestar/animated_space_background.dart';
import 'python_mission_map_screen.dart';

class OpeningCinematicScreen extends StatefulWidget {
  final String username;

  const OpeningCinematicScreen({super.key, required this.username});

  @override
  State<OpeningCinematicScreen> createState() => _OpeningCinematicScreenState();
}

class _OpeningCinematicScreenState extends State<OpeningCinematicScreen> {
  int _dialogueIndex = 0;
  bool _showButton = false;
  
  final List<String> _openingLines = [
    "System Alert: Core Mainframe Offline.",
    "Rerouting to backup power...",
    "Py-Engine Core detected.",
    "Cadet, this is NOVA. I have located a new engine type.",
    "It is powered by Python logic protocol.",
    "We need to initialize it to restore ship functions.",
  ];

  @override
  void initState() {
    super.initState();
    _playSequence();
  }

  Future<void> _playSequence() async {
    for (int i = 0; i < _openingLines.length; i++) {
      if (!mounted) return;
      await Future.delayed(Duration(seconds: (i == 0 || i == 1) ? 2 : 4));
      setState(() {
        _dialogueIndex = i;
      });
    }
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _showButton = true;
      });
    }
  }

  Future<void> _activateSystem() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('python_story_started', true);
    await prefs.setStringList('python_unlocked_missions', ['py1']);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => PythonMissionMapScreen(username: widget.username),
        transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
        transitionDuration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PythonByteStarTheme.background,
      body: Stack(
        children: [
          // Background - Deep Space
           Positioned.fill(
            child: AnimatedSpaceBackground(
              sceneType: SceneType.deepSpace,
              child: const SizedBox.expand(),
            ),
          ),
          
          // Overlay Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.5,
                  colors: [
                    Colors.transparent,
                    PythonByteStarTheme.background.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),

          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Nova / Core Visual
                const SizedBox(height: 100, child: NovaHologram(size: 150)),
                
                const SizedBox(height: 40),

                // Dialogue Text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Text(
                      _openingLines[_dialogueIndex],
                      key: ValueKey(_dialogueIndex),
                      textAlign: TextAlign.center,
                      style: PythonByteStarTheme.heading.copyWith(
                        fontSize: 20,
                        color: _dialogueIndex < 2 ? PythonByteStarTheme.error : PythonByteStarTheme.primary,
                        shadows: [
                          Shadow(
                            color: _dialogueIndex < 2 ? PythonByteStarTheme.error : PythonByteStarTheme.primary,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 60),

                // Activate Button
                if (_showButton)
                  GestureDetector(
                    onTap: _activateSystem,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: PythonByteStarTheme.success, width: 2),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(color: PythonByteStarTheme.success.withOpacity(0.3), blurRadius: 20, spreadRadius: 2),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.power_settings_new, color: PythonByteStarTheme.success),
                          const SizedBox(width: 12),
                          Text(
                            "ACTIVATE PY-ENGINE",
                            style: PythonByteStarTheme.heading.copyWith(fontSize: 16, color: PythonByteStarTheme.success),
                          ),
                        ],
                      ),
                    ).animate(onPlay: (c) => c.repeat(reverse: true))
                     .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), duration: 1.seconds),
                  ).animate().fadeIn().scale(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
