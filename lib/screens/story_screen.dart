import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../utils/theme.dart';
import '../../widgets/background/code_background.dart';
import '../../widgets/ai/nova_mentor_widget.dart';
import '../../core/story_engine.dart';
import 'python_mission_screen.dart';

/// Opening cinematic screen for Python ByteStar Arena
/// Theme: Deep space + neon grids
/// Colors: Cyan (#00E5FF) + Purple (#7C4DFF)
class PythonOpeningScreen extends StatefulWidget {
  const PythonOpeningScreen({super.key});

  @override
  State<PythonOpeningScreen> createState() => _PythonOpeningScreenState();
}

class _PythonOpeningScreenState extends State<PythonOpeningScreen> {
  final StoryEngine _storyEngine = StoryEngine();
  final FlutterTts _flutterTts = FlutterTts();
  
  int _currentStep = 0;
  bool _showButton = false;

  // Theme Colors
  final Color _primaryColor = const Color(0xFF00E5FF);
  final Color _accentColor = const Color(0xFF7C4DFF);

  @override
  void initState() {
    super.initState();
    _startSequence();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _startSequence() async {
    // Initialize the Python ByteStar Arena story
    await _storyEngine.initializePythonStory();

    // Step 1: Fly through space (Background animation)
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    setState(() => _currentStep = 1);

    // Step 2: Overlay "NEW SYSTEM DETECTED"
    await Future.delayed(const Duration(milliseconds: 2000));
    if (!mounted) return;
    setState(() => _currentStep = 2);

    // Step 3: NOVA Dialogue
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;
    setState(() => _currentStep = 3);
    
    // Speak Dialogue
    _speakNovaDialogue();
  }
  
  Future<void> _speakNovaDialogue() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.55);
    await _flutterTts.speak(
      "Engineer… while restoring primary systems… "
      "I discovered a secondary control engine. "
      "It runs on Python logic. "
      "Currently… it is empty. "
      "We will rebuild it together."
    );
  }

  void _onTypingComplete() {
    setState(() => _showButton = true);
  }

  void _activatePyEngine() {
    _flutterTts.stop();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const PythonMissionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.ideBackground,
      body: Stack(
        children: [
          // 1. Space Background with Neon Grid Feel
          const Positioned.fill(child: CodeBackground()),
          
          // Overlay gradient for "Deep Space" feel
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.5,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.8),
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),

          // 2. Main Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Step 1: ASTRA-X Ship / Core Animation
                    if (_currentStep >= 1)
                      Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _primaryColor.withValues(alpha: 0.5),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _primaryColor.withValues(alpha: 0.3),
                              blurRadius: 50,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.blur_on, // Represents the core
                          size: 100,
                          color: _primaryColor,
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 1.seconds)
                          .scale()
                          .then()
                          .shimmer(duration: 2.seconds, color: Colors.white24),

                    const SizedBox(height: 48),

                    // Step 2: System Detection Overlay
                    if (_currentStep >= 2)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                        decoration: BoxDecoration(
                          color: _accentColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: _accentColor, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: _accentColor.withValues(alpha: 0.2),
                              blurRadius: 30,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              "NEW SYSTEM DETECTED",
                              style: TextStyle(
                                fontFamily: 'Courier',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _primaryColor,
                                letterSpacing: 3,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "MODULE: PY-ENGINE\nSTATUS: UNINITIALIZED",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Courier',
                                fontSize: 16,
                                color: Colors.white70,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 800.ms)
                          .slideY(begin: 0.2, end: 0),

                    const SizedBox(height: 48),

                    // Step 3: NOVA Dialogue
                    if (_currentStep >= 3)
                      NovaMentorWidget(
                        dialogue: "Engineer… while restoring primary systems… "
                            "I discovered a secondary control engine. "
                            "It runs on Python logic. "
                            "Currently… it is empty. "
                            "We will rebuild it together.",
                        showTypingAnimation: true,
                        onComplete: _onTypingComplete,
                      ),

                    const SizedBox(height: 48),

                    // Step 4: Activate Button
                    if (_showButton)
                      ElevatedButton(
                        onPressed: _activatePyEngine,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 10,
                          shadowColor: _primaryColor.withValues(alpha: 0.5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.power_settings_new),
                            const SizedBox(width: 12),
                            Text(
                              "ACTIVATE PY-ENGINE",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn().scale(curve: Curves.elasticOut),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
