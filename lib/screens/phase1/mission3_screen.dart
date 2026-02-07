import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/phase1_theme.dart';
import '../../widgets/background/decoder_background.dart';
import '../../services/story_state_service.dart';
import '../../services/tts_service.dart';
import '../../core/mission_validator.dart';
import '../../widgets/phase1/holographic_nova.dart';
import '../../widgets/phase1/code_editor_panel.dart';
import '../../widgets/phase1/type_teaching_panel.dart';
import '../../widgets/phase1/guide_panel.dart';
import 'mission_title_screen.dart';

class Mission3Screen extends StatefulWidget {
  const Mission3Screen({super.key});

  @override
  State<Mission3Screen> createState() => _Mission3ScreenState();
}

class _Mission3ScreenState extends State<Mission3Screen> {
  final TextEditingController _codeController = TextEditingController();
  
  // State
  bool _isGlitched = true;
  bool _isUIUnlocked = false;
  bool _isSuccess = false;
  bool _isError = false;
  
  // Teaching
  int _teachingStep = 0; // 0=Intro, 1=Int, 2=Float, 3=Str, 4=Bool
  bool _isInTeachingMode = true;

  // Dialogue
  String _novaDialogue = "";
  bool _isTyping = true;
  
  // Hints
  int _hintLevel = 0;
  final List<String> _hints = [
    "Numbers without decimals are int.",
    "Use quotes for text.",
    "True/False for status.",
    "Use type() to check data.",
  ];

  @override
  void initState() {
    super.initState();
    _startOpeningSequence();
  }

  void _startOpeningSequence() async {
    // Stage 1: Intro
    setState(() {
      _novaDialogue = "Not all data is the same. Each type needs proper format.";
      _isTyping = true;
    });
    TTSService().speak(_novaDialogue);
    
    await Future.delayed(4.seconds);
    if (!mounted) return;

    // Stage 2: Intro Part 2
    setState(() {
      _novaDialogue = "We can also scan data to see its exact type.";
      _isTyping = true;
    });
    TTSService().speak(_novaDialogue);

    await Future.delayed(4.seconds);
    if (!mounted) return;
    
    // Stage 3: Start Teaching
    _nextTeachingStep();
  }

  void _nextTeachingStep() async {
    if (_teachingStep < 4) {
      setState(() {
        _teachingStep++;
        _isTyping = true;
        
        switch (_teachingStep) {
          case 1:
            _novaDialogue = "Numbers without decimals are integers. They are used for counting.";
            break;
          case 2:
            _novaDialogue = "Numbers with decimals are floats. They store measurements.";
            break;
          case 3:
            _novaDialogue = "Text inside quotes is a string.";
            break;
          case 4:
            _novaDialogue = "True and False represent system status.";
            break;
        }
      });
      TTSService().speak(_novaDialogue);
      
      await Future.delayed(5.seconds);
      if (!mounted) return;
      
      if (_teachingStep < 4) {
        _nextTeachingStep();
      } else {
        // Teaching Done -> Task
        setState(() {
          _isInTeachingMode = false; // Show Guide
          _isUIUnlocked = true;
          _novaDialogue = "The signal decoder is confused. Assign values correctly and verify them using type().";
          _isTyping = true;
        });
        TTSService().speak("${_novaDialogue} Create one int, one float, one string, and one boolean.");
      }
    }
  }

  void _onTypingFinished() {
    setState(() => _isTyping = false);
  }

  void _runCode() {
    if (_isTyping) return;
    
    final input = _codeController.text;
    final result = MissionValidator.validateMission3(input);

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
      
      if (errorType == "TYPE_ERROR") {
        if (!_codeController.text.contains("True") && !_codeController.text.contains("False")) {
             _novaDialogue = "Boolean must be True or False.";
        } else if (!_codeController.text.contains('"') && !_codeController.text.contains("'")) {
             _novaDialogue = "Text must be inside quotes.";
        } else {
             _novaDialogue = "You are missing a required data type (int, float, str, bool).";
        }
      } else if (errorType == "MISSING_CHECK") {
        _novaDialogue = "Use type(variable) to scan data. Check at least 4 variables.";
      } else {
        _novaDialogue = "Format error. Check your syntax.";
      }
    });
    TTSService().speak(_novaDialogue);
  }

  void _handleSuccess() async {
    setState(() {
      _isSuccess = true;
      _isGlitched = false; // Stabilize
      _novaDialogue = "Perfect. The system now understands every signal. Data is flowing correctly.";
      _isTyping = true;
      _isUIUnlocked = false;
    });
    TTSService().speak(_novaDialogue);

    await StoryStateService().completeMission(3, 80);
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
      _isGlitched = true;
      _hintLevel = 0;
      _novaDialogue = "System reset. Decoder waiting.";
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
          // Background (Decoder Room)
          Positioned.fill(
            child: DecoderBackground(isGlitched: _isGlitched),
          ),
          
          // Main Layout
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Top Status: Error/Online
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                         _isSuccess ? "DECODER ONLINE" : "FORMAT ERROR",
                         style: Phase1Theme.alertFont.copyWith(
                           color: _isSuccess ? Phase1Theme.successGreen : Phase1Theme.errorRed, 
                           fontSize: 20,
                           letterSpacing: 2,
                         ),
                      ).animate(onPlay: (c) => _isSuccess ? c.stop() : c.repeat(reverse: true))
                       .fade(duration: 300.ms),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Middle Area
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
                           ).animate(target: _isError ? 1 : 0).shake(hz: 8),
                         ),

                         const SizedBox(width: 16),
                         
                         // Right: Teaching / Guide Panel
                         Expanded(
                           flex: 1,
                           child: _isInTeachingMode
                             ? TypeTeachingPanel(step: _teachingStep)
                             : GuidePanel(
                                 title: "MISSION GUIDE",
                                 content: "Assign one valid example of each type:\n- int\n- float\n- str\n- bool\n\nThen use type() on each.",
                                 hint: _hintLevel > 0 ? _hints[_hintLevel - 1] : null,
                               ),
                         ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Bottom Area
                  SizedBox(
                    height: 150,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          
                          // Controls
                         Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Run
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
                                                    missionId: 4,
                                                    title: "COMMAND RECEIVER",
                                                    nextRoute: '/story/python/mission4',
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
                                      child: Text("ALIGN SIGNAL", style: Phase1Theme.sciFiFont.copyWith(color: Phase1Theme.successGreen)),
                                    ),
                              ),
                              const SizedBox(height: 8),
                              // Hint/Reset
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
