import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/phase1_theme.dart';
import '../../widgets/background/life_support_background.dart';
import '../../services/story_state_service.dart';
import '../../services/tts_service.dart';
import '../../core/mission_validator.dart';
import '../../widgets/phase1/holographic_nova.dart';
import '../../widgets/phase1/code_editor_panel.dart';
import '../../widgets/phase1/guide_panel.dart';

class Mission11Screen extends StatefulWidget {
  const Mission11Screen({super.key});

  @override
  State<Mission11Screen> createState() => _Mission11ScreenState();
}

class _Mission11ScreenState extends State<Mission11Screen> {
  final TextEditingController _codeController = TextEditingController();
  
  bool _isMonitoring = false;
  bool _isUIUnlocked = false;
  bool _isSuccess = false;
  bool _isError = false;
  
  // Teaching
  bool _isInTeachingMode = true;
  
  // Dialogue
  String _novaDialogue = "";
  bool _isTyping = true;
  
  int _hintLevel = 0;
  final List<String> _hints = [
    "Use 'while fuel > 0:'.",
    "Inside the loop, decrease fuel: 'fuel -= 1'.",
    "Example:\nwhile fuel > 0:\n    print('Monitoring')\n    fuel -= 1",
  ];

  @override
  void initState() {
    super.initState();
    _startOpeningSequence();
  }

  void _startOpeningSequence() async {
    // Stage 1: Intro
    setState(() {
      _novaDialogue = "Stability isn't a state, it's a process. We must monitor continuously.";
      _isTyping = true;
    });
    TTSService().speak(_novaDialogue);
    
    await Future.delayed(5.seconds);
    if (!mounted) return;
    
    // Stage 2: Explained While Loops
    setState(() {
      _novaDialogue = "A 'while' loop repeats as long as a condition is true. Perfect for life support.";
      _isTyping = true;
    });
    TTSService().speak(_novaDialogue);
    
    await Future.delayed(5.seconds);
    if (!mounted) return;

    // Stage 3: Task
    setState(() {
      _isInTeachingMode = false;
      _isUIUnlocked = true;
      _codeController.text = "while fuel > 0:\n    "; // Start them off
      _novaDialogue = "Maintain life support while fuel is greater than 0. Don't forget to decrease fuel!";
      _isTyping = true;
    });
    TTSService().speak(_novaDialogue);
  }

  void _onTypingFinished() {
    setState(() => _isTyping = false);
  }

  void _runCode() {
    if (_isTyping) return;
    
    final input = _codeController.text;
    final result = MissionValidator.validateMission11(input);

    if (result == "SUCCESS") {
      _handleSuccess();
    } else {
      _handleError(result);
    }
  }

  void _handleError(String errorType) {
    setState(() {
      _isError = true;
      _isTyping = true;
      if (errorType == "FORMAT_ERROR") {
        _novaDialogue = "The loop needs a way to end. Decrease the fuel inside the loop.";
      } else {
         _novaDialogue = "Check your condition or syntax. It should be 'while fuel > 0:'.";
      }
    });
    TTSService().speak(_novaDialogue);
  }

  void _handleSuccess() async {
    setState(() {
      _isSuccess = true;
      _isMonitoring = true;
      _novaDialogue = "MONITORING STABLE. High-level logic systems are now fully integrated.";
      _isTyping = true;
      _isUIUnlocked = false;
    });
    TTSService().speak(_novaDialogue);

    await StoryStateService().completeMission(11, 100);
  }

  void _showNextHint() {
    if (_hintLevel < _hints.length) {
      setState(() {
        _hintLevel++;
        _novaDialogue = _hints[_hintLevel - 1];
        _isTyping = true;
      });
      TTSService().speak("Hint: ${_hints[_hintLevel - 1]}");
    }
  }
  
  void _resetMission() {
    setState(() {
      _codeController.text = "while fuel > 0:\n    ";
      _isError = false;
      _isSuccess = false;
      _isMonitoring = false;
      _hintLevel = 0;
      _novaDialogue = "System reset. Waiting for monitoring loop.";
      _isTyping = true;
      _isUIUnlocked = true;
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
          Positioned.fill(
            child: LifeSupportBackground(isMonitoring: _isMonitoring),
          ),
          
          // Main UI
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                         _isSuccess ? "MONITORING: ACTIVE" : "LIFE SUPPORT: MANUAL",
                         style: Phase1Theme.alertFont.copyWith(
                           color: _isSuccess ? Phase1Theme.successGreen : Phase1Theme.errorRed, 
                           fontSize: 20
                         ),
                      ).animate(onPlay: (c) => _isSuccess ? c.stop() : c.repeat(reverse: true))
                       .fade(duration: 500.ms),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Middle: Code + Guide
                  Expanded(
                    flex: 3,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                           flex: 2,
                           child: CodeEditorPanel(
                             controller: _codeController,
                             isError: _isError,
                             onChanged: () {
                               if (_isError) setState(() => _isError = false);
                             },
                           ),
                         ),
                         const SizedBox(width: 16),
                         Expanded(
                           flex: 1,
                           child: _isInTeachingMode
                             ? Container(
                                 decoration: BoxDecoration(
                                   color: Colors.black.withValues(alpha: 0.8),
                                   border: Border.all(color: Colors.grey),
                                   borderRadius: BorderRadius.circular(8),
                                 ),
                                 padding: const EdgeInsets.all(16),
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Text("WHILE LOOPS", style: Phase1Theme.sciFiFont.copyWith(color: Colors.grey)),
                                     const SizedBox(height: 16),
                                     Text("while oxygen < 50:", style: Phase1Theme.codeFont.copyWith(color: Colors.white)),
                                     Text("    print(\"Adjust\")", style: Phase1Theme.codeFont.copyWith(color: Phase1Theme.cyanGlow)),
                                     Text("    oxygen += 1", style: Phase1Theme.codeFont.copyWith(color: Phase1Theme.cyanGlow)),
                                     const SizedBox(height: 16),
                                     Text("Rules:", style: Phase1Theme.sciFiFont.copyWith(color: Colors.blue)),
                                     Text("- Loops while TRUE", style: Phase1Theme.codeFont.copyWith(color: Colors.white)),
                                     Text("- Needs a way to stop", style: Phase1Theme.codeFont.copyWith(color: Colors.white)),
                                     Text("- Essential for monitoring", style: Phase1Theme.codeFont.copyWith(color: Colors.white)),
                                   ],
                                 ),
                               )
                             : GuidePanel(
                                 title: "MISSION GUIDE",
                                 content: "Set up continuous monitoring.\n\nUse a while loop to check fuel and decrease it inside the loop.",
                                 hint: _hintLevel > 0 ? _hints[_hintLevel - 1] : null,
                               ),
                         ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Bottom
                  SizedBox(
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: HolographicNova(
                            dialogue: _novaDialogue,
                            isTyping: _isTyping,
                            onTypingFinished: _onTypingFinished,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: _isSuccess 
                                  ? Column(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Phase1Theme.cyanGlow.withValues(alpha: 0.2),
                                              side: BorderSide(color: Phase1Theme.cyanGlow),
                                              padding: EdgeInsets.zero,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text("FINISH", style: Phase1Theme.sciFiFont.copyWith(color: Phase1Theme.cyanGlow, fontSize: 12)),
                                                const SizedBox(width: 4),
                                                Icon(Icons.check_circle, color: Phase1Theme.cyanGlow, size: 14),
                                              ],
                                            ),
                                          ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(1.0, 1.0), end: const Offset(1.03, 1.03), duration: 1.seconds),
                                        ),
                                        const SizedBox(height: 4),
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            style: OutlinedButton.styleFrom(
                                              side: BorderSide(color: Colors.white24),
                                              padding: EdgeInsets.zero,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text("MAP", style: Phase1Theme.sciFiFont.copyWith(color: Colors.white70, fontSize: 12)),
                                                const SizedBox(width: 4),
                                                Icon(Icons.map, color: Colors.white70, size: 14),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : ElevatedButton(
                                      onPressed: _isUIUnlocked ? _runCode : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Phase1Theme.successGreen.withValues(alpha: 0.2),
                                        side: BorderSide(color: Phase1Theme.successGreen),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      child: Text("MONITOR", style: Phase1Theme.sciFiFont.copyWith(color: Phase1Theme.successGreen)),
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: (_isUIUnlocked && _hintLevel < _hints.length) ? _showNextHint : null,
                                      style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.yellow)),
                                      child: const Icon(Icons.lightbulb_outline, color: Colors.yellow),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: _isUIUnlocked ? _resetMission : null,
                                      style: OutlinedButton.styleFrom(side: BorderSide(color: Phase1Theme.errorRed)),
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
