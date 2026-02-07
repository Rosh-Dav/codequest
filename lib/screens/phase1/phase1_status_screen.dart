import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/phase1_theme.dart';
import '../../widgets/background/code_background.dart';
import '../../services/tts_service.dart';
import '../../widgets/phase1/holographic_nova.dart';
import 'mission_title_screen.dart';

class Phase1StatusScreen extends StatefulWidget {
  const Phase1StatusScreen({super.key});

  @override
  State<Phase1StatusScreen> createState() => _Phase1StatusScreenState();
}

class _Phase1StatusScreenState extends State<Phase1StatusScreen> {
  // Dialogue
  String _novaDialogue = "";
  bool _isTyping = true;

  @override
  void initState() {
    super.initState();
    _startSequence();
  }

  void _startSequence() async {
    await Future.delayed(1.seconds);
    if (!mounted) return;
    
    setState(() {
      _novaDialogue = "Excellent progress. The core is awakening.";
      _isTyping = true;
    });
    TTSService().speak(_novaDialogue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background
          const Positioned.fill(child: CodeBackground()),
          
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title
                  Text(
                    "PHASE 1 COMPLETE",
                    style: Phase1Theme.alertFont.copyWith(color: Phase1Theme.cyanGlow, fontSize: 32),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(duration: 1.seconds).slideY(begin: -0.2, end: 0),
                  
                  const SizedBox(height: 48),
                  
                  // Status Bars
                  _buildStatusRow("PY-ENGINE", 0.35, Colors.orange),
                  const SizedBox(height: 24),
                  _buildStatusRow("SYSTEM STABILITY", 0.85, Colors.green),
                  const SizedBox(height: 24),
                  _buildStatusRow("COMMUNICATIONS", 1.0, Colors.blue),
                  
                  const Spacer(),
                  
                  // Nova
                  SizedBox(
                    height: 150,
                    child: HolographicNova(
                      dialogue: _novaDialogue,
                      isTyping: _isTyping,
                      onTypingFinished: () => setState(() => _isTyping = false),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: Colors.white24),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text("RETURN TO MAP", style: Phase1Theme.sciFiFont.copyWith(color: Colors.white70, fontSize: 14)),
                        ).animate().fadeIn(delay: 4.seconds),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                             Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const MissionTitleScreen(
                                    missionId: 6,
                                    title: "MATH CORE",
                                    nextRoute: '/story/python/mission6',
                                  ),
                                ),
                              );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Phase1Theme.cyanGlow.withValues(alpha: 0.2),
                            side: BorderSide(color: Phase1Theme.cyanGlow),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text("NEXT MISSION", style: Phase1Theme.sciFiFont.copyWith(color: Phase1Theme.cyanGlow, fontSize: 16)),
                        ).animate().fadeIn(delay: 4.seconds),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Phase1Theme.codeFont.copyWith(color: Colors.white, fontSize: 14)),
            Text("${(progress * 100).toInt()}%", style: Phase1Theme.codeFont.copyWith(color: color, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.white10,
          color: color,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ).animate().scaleX(begin: 0, alignment: Alignment.centerLeft, duration: 2.seconds, curve: Curves.easeOut),
      ],
    );
  }
}
