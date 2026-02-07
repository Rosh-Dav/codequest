import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/phase1_theme.dart';
import '../../widgets/background/code_background.dart';
import '../../services/story_state_service.dart';
import '../../services/tts_service.dart';
import '../../core/mission_validator.dart';
import '../../widgets/phase1/holographic_nova.dart';
import '../../widgets/phase1/code_editor_panel.dart';
import '../../widgets/phase1/teaching_panel.dart';
import '../../widgets/phase1/orb_widget.dart';
import '../../widgets/phase1/guide_panel.dart';
import 'mission_title_screen.dart';

class Mission2Screen extends StatefulWidget {
  const Mission2Screen({super.key});

  @override
  State<Mission2Screen> createState() => _Mission2ScreenState();
}

class _Mission2ScreenState extends State<Mission2Screen> {
  final TextEditingController _codeController = TextEditingController();
  bool _isUIUnlocked = false;
  bool _isSuccess = false;
  bool _isError = false;
  int _teachingStep = 0; // 0..4 for TeachingPanel sequence
  int _hintLevel = 0;
  
  // Dialogue & Sequence
  String _novaDialogue = "Energy has no identity. We must label it.";
  bool _isTyping = true;
  bool _isInTeachingMode = true; // Shows TeachingPanel vs GuidePanel
  
  final List<String> _hints = [
    "Give energy a name.",
    "Use = to connect name and value.",
    "Write: fuel = 60",
  ];

  @override
  void initState() {
    super.initState();
    _startOpeningSequence();
  }

  void _startOpeningSequence() async {
    // 1. Initial Dialogue
    await Future.delayed(2.seconds); 
    if (!mounted) return;
    
    // 2. Start Teaching Sequence
    _nextTeachingStep();
  }

  void _nextTeachingStep() async {
    if (_teachingStep < 4) {
      if (!mounted) return;
      setState(() {
        _teachingStep++;
        _isTyping = true;
        // Update dialogue based on step (matches TeachingPanel steps)
        switch (_teachingStep) {
          case 1:
            _novaDialogue = "power is the variable name. It represents stored energy.";
            break;
          case 2:
            _novaDialogue = "= assigns a value.";
            break;
          case 3:
            _novaDialogue = "80 is the stored value.";
            break;
          case 4:
            _novaDialogue = "Stored values can be reused.";
            break;
        }
      });
      TTSService().speak(_novaDialogue);
      
      // Auto-advance after delay
      await Future.delayed(4.seconds);
      if (_teachingStep < 4) _nextTeachingStep();
      else {
        // End of teaching -> Task Intro
        if (mounted) {
           setState(() {
             _isTyping = true;
             _novaDialogue = "The fuel core is unstable. Assign it a fixed value. Create a variable named fuel and store 60 inside it.";
             _isUIUnlocked = true;
           });
           // Speak Nova's line + Guide Panel instructions
           TTSService().speak("${_novaDialogue} Assign value 60 to variable fuel.");
        }
      }
    }
  }

  void _onTypingFinished() {
    setState(() => _isTyping = false);
  }

  void _runCode() {
    if (_isTyping) return; // Prevent run while typing
    
    final input = _codeController.text;
    final result = MissionValidator.validateMission2(input);

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
         _novaDialogue = "Output format incorrect. Check your syntax.";
      } else {
         _novaDialogue = "We need 'fuel' assigned to '60'. Check your spelling.";
      }
      _isTyping = true;
    });
    TTSService().speak(_novaDialogue);
  }

  void _handleSuccess() async {
    setState(() {
      _isSuccess = true;
      _novaDialogue = "Excellent. The fuel system now has identity. We can control it.";
      _isTyping = true;
      _isUIUnlocked = false;
    });
    TTSService().speak(_novaDialogue);

    await StoryStateService().completeMission(2, 60);
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
      _hintLevel = 0;
      _novaDialogue = "System reset. Waiting for assignment.";
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
          const Positioned.fill(child: CodeBackground()),
          
          // Scene: Power Chamber (Sparks / Distortion) - Simplified
          // Centered Orb
          Align(
            alignment: Alignment.center,
            child: OrbWidget(isStable: _isSuccess, size: 250),
          ),
          
          // Main Layout
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Top Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                         _isSuccess ? "ENERGY ASSIGNED: 60 UNITS" : "ENERGY UNASSIGNED",
                         style: Phase1Theme.alertFont.copyWith(
                           color: _isSuccess ? Phase1Theme.successGreen : Phase1Theme.errorRed, 
                           fontSize: 16
                         ),
                      ).animate(target: _isSuccess ? 0 : 1).fade(duration: 500.ms, end: 0.8),
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
                           child: _isInTeachingMode && !_isSuccess
                             ? TeachingPanel(step: _teachingStep)
                             : GuidePanel(
                                 title: "MISSION GUIDE",
                                 content: "Assign value 60 to variable fuel.\n\nExample:\nfuel = 60",
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
                                                        missionId: 3,
                                                        title: "SIGNAL FORMATS",
                                                        nextRoute: '/story/python/mission3',
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
                                          child: Text("STABILIZE", style: Phase1Theme.sciFiFont.copyWith(color: Phase1Theme.successGreen)),
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
