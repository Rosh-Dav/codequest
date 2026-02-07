import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/phase1_theme.dart';
import '../../widgets/background/calculation_background.dart';
import '../../services/story_state_service.dart';
import '../../services/tts_service.dart';
import '../../core/mission_validator.dart';
import '../../widgets/phase1/holographic_nova.dart';
import '../../widgets/phase1/code_editor_panel.dart';
import '../../widgets/phase1/guide_panel.dart';
import 'mission_title_screen.dart';

class Mission6Screen extends StatefulWidget {
  const Mission6Screen({super.key});

  @override
  State<Mission6Screen> createState() => _Mission6ScreenState();
}

class _Mission6ScreenState extends State<Mission6Screen> {
  final TextEditingController _codeController = TextEditingController();
  
  bool _isStable = false;
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
    "Use / for division.",
    "Store result in eff.",
    "eff = fuel / time",
  ];

  @override
  void initState() {
    super.initState();
    _startOpeningSequence();
  }

  void _startOpeningSequence() async {
    // Stage 1: Intro
    setState(() {
      _novaDialogue = "The system cannot calculate correctly. Logic is collapsing.";
      _isTyping = true;
    });
    TTSService().speak(_novaDialogue);
    
    await Future.delayed(4.seconds);
    if (!mounted) return;
    
    // Stage 2: Explained Operators
    setState(() {
      _novaDialogue = "Operators connect values. Use slash for division.";
      _isTyping = true;
    });
    TTSService().speak(_novaDialogue);
    
    await Future.delayed(4.seconds);
    if (!mounted) return;

    // Stage 3: Task
    setState(() {
      _isInTeachingMode = false;
      _isUIUnlocked = true;
      _novaDialogue = "Calculate efficiency. Create 'eff' equals 'fuel' divided by 'time'.";
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
    final result = MissionValidator.validateMission6(input);

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
      if (errorType == "SYNTAX_ERROR") {
        _novaDialogue = "Syntax error. Use: eff = fuel / time";
      } else {
         _novaDialogue = "Division requires the '/' operator.";
      }
    });
    TTSService().speak(_novaDialogue);
  }

  void _handleSuccess() async {
    setState(() {
      _isSuccess = true;
      _isStable = true; // Fix graph
      _novaDialogue = "Calculation stable. Logic restored.";
      _isTyping = true;
      _isUIUnlocked = false;
    });
    TTSService().speak(_novaDialogue);

    await StoryStateService().completeMission(6, 80);
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
      _codeController.clear();
      _isError = false;
      _isSuccess = false;
      _isStable = false;
      _hintLevel = 0;
      _novaDialogue = "System reset. Waiting for calculation.";
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
            child: CalculationBackground(isStable: _isStable),
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
                         _isSuccess ? "CALCULATION: STABLE" : "CALCULATION ERROR",
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
                                   border: Border.all(color: Colors.orange),
                                   borderRadius: BorderRadius.circular(8),
                                 ),
                                 padding: const EdgeInsets.all(16),
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Text("OPERATORS", style: Phase1Theme.sciFiFont.copyWith(color: Colors.orange)),
                                     const SizedBox(height: 16),
                                     Text("a + b", style: Phase1Theme.codeFont.copyWith(color: Colors.green)),
                                     Text("a - b", style: Phase1Theme.codeFont.copyWith(color: Colors.green)),
                                     Text("a * b", style: Phase1Theme.codeFont.copyWith(color: Colors.green)),
                                     Text("a / b", style: Phase1Theme.codeFont.copyWith(color: Colors.green)),
                                     const SizedBox(height: 16),
                                     Text("Logical:", style: Phase1Theme.sciFiFont.copyWith(color: Colors.blue)),
                                     Text("a > b", style: Phase1Theme.codeFont.copyWith(color: Colors.lightBlue)),
                                     Text("a == b", style: Phase1Theme.codeFont.copyWith(color: Colors.lightBlue)),
                                   ],
                                 ),
                               )
                             : GuidePanel(
                                 title: "MISSION GUIDE",
                                 content: "Calculate fuel efficiency.\n\nCreate variable 'eff' and assign 'fuel' / 'time' to it.",
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
                                              Navigator.of(context).pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (_) => const MissionTitleScreen(
                                                    missionId: 7,
                                                    title: "ENGINEER NOTES",
                                                    nextRoute: '/story/python/mission7',
                                                  ),
                                                ),
                                              );
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
                                                Text("NEXT", style: Phase1Theme.sciFiFont.copyWith(color: Phase1Theme.cyanGlow, fontSize: 12)),
                                                const SizedBox(width: 4),
                                                Icon(Icons.arrow_forward, color: Phase1Theme.cyanGlow, size: 14),
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
                                      child: Text("CALCULATE", style: Phase1Theme.sciFiFont.copyWith(color: Phase1Theme.successGreen)),
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
