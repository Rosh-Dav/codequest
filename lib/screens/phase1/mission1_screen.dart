import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/phase1_theme.dart';
import '../../widgets/background/code_background.dart';
import '../../services/story_state_service.dart';
import '../../core/mission_validator.dart';
import '../../widgets/phase1/holographic_nova.dart';
import '../../widgets/phase1/code_editor_panel.dart';
import '../../widgets/phase1/guide_panel.dart';

class Mission1Screen extends StatefulWidget {
  const Mission1Screen({super.key});

  @override
  State<Mission1Screen> createState() => _Mission1ScreenState();
}

class _Mission1ScreenState extends State<Mission1Screen> {
  // Logic State
  final TextEditingController _codeController = TextEditingController();
  bool _isUIUnlocked = false;
  bool _isSuccess = false;
  bool _isError = false;
  int _hintLevel = 0; // 0: None, 1, 2, 3
  
  // Intro State
  int _introLineIndex = 0;
  final List<String> _introLines = [
    "The ship cannot send messages.",
    "Without output, we are blind.",
    "Let's send our first signal.",
  ];
  String _novaDialogue = "";
  bool _isIntroTyping = true;

  // Hints
  final List<String> _hints = [
    "You need to display text.",
    "Use print().",
    "Write: print(\"System Online\")",
  ];

  @override
  void initState() {
    super.initState();
    _startIntro();
  }

  void _startIntro() {
    _playNextIntroLine();
  }

  void _playNextIntroLine() {
    setState(() {
      _novaDialogue = _introLines[_introLineIndex];
      _isIntroTyping = true;
    });
  }

  void _onNovaTypingFinished() {
    setState(() => _isIntroTyping = false);
    
    // Auto-advance
    if (_introLineIndex < _introLines.length - 1) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          setState(() => _introLineIndex++);
          _playNextIntroLine();
        }
      });
    } else {
      // Intro done, unlock UI
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          setState(() {
            _isUIUnlocked = true;
            _novaDialogue = "Enter the command to print \"System Online\".";
          });
        }
      });
    }
  }

  void _runCode() {
    setState(() => _isError = false);
    
    final input = _codeController.text;
    final result = MissionValidator.validateMission1(input);

    if (result == "SUCCESS") {
      _handleSuccess();
    } else {
      _handleError(result);
    }
  }

  void _handleError(String errorType) {
    setState(() {
      _isError = true;
      if (errorType == "SYNTAX_ERROR") {
        _novaDialogue = "Syntax incorrect. Check your parentheses and quotes.";
      } else if (errorType == "FORMAT_ERROR") {
        _novaDialogue = "Output does not match. We need exactly \"System Online\".";
      }
    });
  }

  void _handleSuccess() async {
    setState(() {
      _isSuccess = true;
      _novaDialogue = "Signal received. Communication restored. Well done, Engineer.";
      _isUIUnlocked = false; // Lock UI
    });

    // Save Progress
    await StoryStateService().completeMission(1, 50);

    // After animations, maybe show a "Next Mission" button or return to hub
    // For now, we just stay in success state as per request
  }

  void _showNextHint() {
    if (_hintLevel < _hints.length) {
      setState(() {
        _hintLevel++;
        _novaDialogue = "Analyzing... sending hint data.";
      });
    }
  }

  void _resetMission() {
    setState(() {
      _codeController.clear();
      _isError = false;
      _isSuccess = false;
      _hintLevel = 0;
      _novaDialogue = "System reset. Ready for input.";
      _isUIUnlocked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Scene Background
          const Positioned.fill(child: CodeBackground()), // Base stars
          
          // Environment: Flickering Emergency Lights
          if (!_isSuccess)
            Positioned.fill(
              child: Container(
                color: Phase1Theme.errorRed.withValues(alpha: 0.05),
              ).animate(onPlay: (c) => c.repeat(reverse: true))
               .fade(duration: 2.seconds, begin: 0.0, end: 0.5),
            ),

          // Static Effect (Subtle overlay)
          if (!_isSuccess)
             Positioned.fill(
               child: Opacity(
                 opacity: 0.05,
                 child: Image.network(
                   'https://media.giphy.com/media/oEI9uBYSzLpBK/giphy.gif', // Placeholder noise or just logic
                   // Since I can't use network images easily without checking permissions/connectivity and avoiding placeholders...
                   // I'll stick to a code-generated static effect or just skip the image.
                   // I'll use a fast flickering random container instead.
                   errorBuilder: (context, error, stackTrace) => const SizedBox(),
                 ),
               ),
             ),
             
          // Success Effect: Monitors On (Blue Glow)
          if (_isSuccess)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.0,
                    colors: [
                      Phase1Theme.cyanGlow.withValues(alpha: 0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ).animate().fadeIn(duration: 1.seconds),
            ),

          // 2. Main Layout (Grid)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Top Bar: Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isSuccess ? Icons.wifi : Icons.wifi_off,
                        color: _isSuccess ? Phase1Theme.successGreen : Phase1Theme.errorRed,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isSuccess ? "COMMUNICATION STATUS: ONLINE" : "COMMUNICATION STATUS: SILENT",
                        style: Phase1Theme.alertFont.copyWith(
                          color: _isSuccess ? Phase1Theme.successGreen : Phase1Theme.errorRed,
                          fontSize: 16,
                          letterSpacing: 2,
                        ),
                      ).animate(onPlay: (c) => _isSuccess ? c.stop() : c.repeat(reverse: true))
                       .fade(duration: 1.seconds),
                    ],
                  ),
                  
                  const SizedBox(height: 16),

                  // Middle Area: Panels
                  Expanded(
                    flex: 3,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Left: Code Editor
                        Expanded(
                          flex: 2,
                          child: CodeEditorPanel(
                            controller: _codeController,
                            isError: _isError,
                            onChanged: () {
                              if (_isError) setState(() => _isError = false);
                            },
                          ).animate(target: _isError ? 1 : 0).shake(hz: 8, duration: 500.ms),
                        ),
                        
                        const SizedBox(width: 16),

                        // Right: Guide & Hints
                        Expanded(
                          flex: 1,
                          child: GuidePanel(
                            title: "MISSION GUIDE",
                            content: "Use the print() command to broadcast a message.\n\nRequired Output:\n\"System Online\"",
                            hint: _hintLevel > 0 ? _hints[_hintLevel - 1] : null,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Bottom Area: NOVA & Controls
                  SizedBox(
                    height: 150,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // NOVA Avatar
                        Expanded(
                          flex: 2,
                          child: HolographicNova(
                            dialogue: _novaDialogue,
                            isTyping: _isIntroTyping,
                            onTypingFinished: _isIntroTyping ? _onNovaTypingFinished : null,
                          ),
                        ),
                        
                        const SizedBox(width: 16),

                        // Controls
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Run Button
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _isUIUnlocked ? _runCode : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Phase1Theme.successGreen.withValues(alpha: 0.2),
                                    side: BorderSide(color: Phase1Theme.successGreen),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: Text(
                                    "RUN SEQUENCE",
                                    style: Phase1Theme.sciFiFont.copyWith(color: Phase1Theme.successGreen),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              
                              // Hint & Reset Row
                              Row(
                                children: [
                                  // Hint
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: (_isUIUnlocked && _hintLevel < _hints.length) 
                                          ? _showNextHint 
                                          : null,
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: Colors.yellow),
                                      ),
                                      child: const Icon(Icons.lightbulb_outline, color: Colors.yellow),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // Reset
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: _isUIUnlocked ? _resetMission : null,
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(color: Phase1Theme.errorRed),
                                      ),
                                      child: Icon(Icons.refresh, color: Phase1Theme.errorRed),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
