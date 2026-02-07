import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/phase1_theme.dart';
import '../../widgets/background/code_background.dart';
import '../../services/story_state_service.dart';
import '../../services/tts_service.dart';
import '../../widgets/phase1/holographic_nova.dart';
import '../../widgets/phase1/system_overlay.dart';


class SystemAwakeningScreen extends StatefulWidget {
  const SystemAwakeningScreen({super.key});

  @override
  State<SystemAwakeningScreen> createState() => _SystemAwakeningScreenState();
}

class _SystemAwakeningScreenState extends State<SystemAwakeningScreen> with TickerProviderStateMixin {
  // Sequence Control
  int _sequenceStep = 0; // 0: Space/Ship, 1: Overlay, 2: Dialogue, 3: Button
  int _dialogueIndex = 0;

  // State
  bool _isOverlayComplete = false;
  bool _isDialogueComplete = false;
  bool _isLoadingMission = false;

  // Dialogue Data
  final List<String> _dialogueLines = [
    "Engineer… while restoring primary systems…",
    "I discovered a secondary control engine.",
    "It runs on Python logic.",
    "Currently… it is empty.",
    "We will rebuild it together.",
  ];

  @override
  void initState() {
    super.initState();
    _startSequence();
  }

  void _startSequence() async {
    // Stage 0: Deep Space Flyover -> Ship Core (Simulated by delay)
    // Core animation runs automatically via FlutterAnimate
    await Future.delayed(const Duration(seconds: 4)); // Flyover duration
    if (!mounted) return;
    setState(() => _sequenceStep = 1); // Trigger Overlay
  }

  void _onOverlayComplete() {
    setState(() {
      _isOverlayComplete = true;
      _sequenceStep = 2; // Trigger Dialogue
    });
    // Speak first line
    TTSService().speak(_dialogueLines[_dialogueIndex]);
  }

  void _onDialogueTyped() {
    // Auto-advance dialogue after a pause
    final duration = _dialogueIndex == 3 ? 2000 : 1000; // Longer pause for "Currently... it is empty"
    
    Future.delayed(Duration(milliseconds: duration), () {
      if (!mounted) return;
      if (_dialogueIndex < _dialogueLines.length - 1) {
        setState(() => _dialogueIndex++);
        TTSService().speak(_dialogueLines[_dialogueIndex]); // Speak next line
      } else {
        setState(() {
          _isDialogueComplete = true;
          _sequenceStep = 3; // Trigger Button
        });
      }
    });
  }

  void _activatePyEngine() async {
    // Activation Logic
    setState(() => _isLoadingMission = true);
    
    // Save State
    await StoryStateService().startStory();
    
    // Fake Loading Delay & Fade
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Navigate to Level Map
    Navigator.of(context).pushReplacementNamed('/story/level_map');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Base for deep space
      body: Stack(
        children: [
          // 1. Background Layer (Deep Space + Neon Grid)
          const Positioned.fill(child: CodeBackground()), // Reusing existing space bg
          
          // Neon Grid Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.2,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.8),
                  ],
                ),
              ),
              child: CustomPaint(
                painter: GridPainter(),
              ),
            ),
          ),

          // 2. Core Visuals (Center)
           Center(
             child: AnimatedOpacity(
               duration: 2.seconds,
               opacity: _sequenceStep >= 0 ? 1.0 : 0.0,
               child: Container(
                 width: 200,
                 height: 200,
                 decoration: BoxDecoration(
                   shape: BoxShape.circle,
                   gradient: RadialGradient(
                     colors: [
                       Phase1Theme.cyanGlow.withValues(alpha: 0.2),
                       Colors.transparent,
                     ],
                   ),
                   boxShadow: [
                     BoxShadow(
                       color: Phase1Theme.cyanGlow.withValues(alpha: _sequenceStep >= 3 ? 0.8 : 0.3), // Glow brighter on activation
                       blurRadius: _sequenceStep >= 3 ? 100 : 50,
                       spreadRadius: _sequenceStep >= 3 ? 20 : 5,
                     )
                   ],
                 ),
                 child: Icon(
                   Icons.all_inclusive, // Abstract core symbol
                   size: 100,
                   color: Phase1Theme.cyanGlow.withValues(alpha: 0.9),
                 ).animate(onPlay: (c) => c.repeat(reverse: true))
                  .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), duration: 2.seconds),
               ),
             ),
           ),

          // 3. System Overlay (Top Center)
          if (_sequenceStep >= 1 && !_isOverlayComplete)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.2,
              left: 0,
              right: 0,
              child: Center(
                child: SystemOverlay(
                  onComplete: () {
                    // Slight delay before NOVA appears
                    Future.delayed(1.seconds, _onOverlayComplete);
                  },
                ),
              ),
            ),

          // 4. NOVA Panel (Bottom Left/Center)
          if (_sequenceStep >= 2)
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: HolographicNova(
                dialogue: _isLoadingMission ? "INITIALIZING SEQUENCE..." : _dialogueLines[_dialogueIndex],
                isTyping: !_isDialogueComplete && !_isLoadingMission,
                onTypingFinished: _onDialogueTyped,
              ).animate().fadeIn().slideY(begin: 0.1, end: 0),
            ),

          // 5. Activate Button (Bottom Center)
          if (_sequenceStep >= 3 && !_isLoadingMission)
            Positioned(
              bottom: 180, // Above NOVA panel
              left: 0,
              right: 0,
              child: Center(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: _activatePyEngine,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Phase1Theme.cyanGlow,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Phase1Theme.cyanGlow.withValues(alpha: 0.5),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Text(
                        "ACTIVATE PY-ENGINE",
                        style: Phase1Theme.alertFont.copyWith(
                          color: Phase1Theme.cyanGlow,
                          fontSize: 18,
                        ),
                      ),
                    ).animate(onPlay: (c) => c.repeat(reverse: true))
                     .custom(
                       duration: 2.seconds,
                       builder: (context, value, child) => BoxShadow(
                         color: Phase1Theme.cyanGlow.withValues(alpha: 0.5 * value),
                         blurRadius: 20 * value,
                       ).wrap(child),
                     ), // Pulse effect
                  ),
                ),
              ).animate().fadeIn().scale(),
            ),

          // 6. Loading Overlay (Top layer)
          if (_isLoadingMission)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.9),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(color: Phase1Theme.cyanGlow),
                      const SizedBox(height: 20),
                      Text("Loading Mission Hub...", style: Phase1Theme.sciFiFont),
                    ],
                  ),
                ),
              ).animate().fadeIn(duration: 1.seconds),
            ),
        ],
      ),
    );
  }
}

// Simple Grid Painter for Cyber/Tron effect
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Phase1Theme.purpleGlow.withValues(alpha: 0.1)
      ..strokeWidth = 1;

    const spacing = 40.0;
    
    // Vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    
    // Horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Extension helper for wrapping BoxShadow in custom animation
extension BoxShadowExt on BoxShadow {
  Widget wrap(Widget child) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [this],
        borderRadius: BorderRadius.circular(30),
      ),
      child: child,
    );
  }
}
