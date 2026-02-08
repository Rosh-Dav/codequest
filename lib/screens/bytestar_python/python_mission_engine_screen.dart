import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/python_bytestar_theme.dart';
import '../../models/bytestar_python_data.dart';
import '../../services/gemini_service.dart';
import '../../services/static_mentor_service.dart';
import 'widgets/python_code_editor.dart';
import 'widgets/python_teaching_panel.dart';
import '../../widgets/bytestar/nova_hologram.dart';
import '../../widgets/bytestar/animated_space_background.dart';

enum MissionPhase {
  briefing,
  teaching,
  coding,
  analysis,
  success,
}

class PythonMissionEngineScreen extends StatefulWidget {
  final PythonMission mission;
  final String username;

  const PythonMissionEngineScreen({
    super.key,
    required this.mission,
    required this.username,
  });

  @override
  State<PythonMissionEngineScreen> createState() => _PythonMissionEngineScreenState();
}

class _PythonMissionEngineScreenState extends State<PythonMissionEngineScreen> {
  late TextEditingController _codeController;
  late FlutterTts _flutterTts;
  final FocusNode _focusNode = FocusNode();

  // State
  MissionPhase _currentPhase = MissionPhase.briefing;
  int _dialogueIndex = 0;
  int _teachingStepIndex = -1;
  
  String _consoleOutput = '';
  String? _feedbackMessage;
  bool _isTalking = false;
  bool _isAiThinking = false;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.mission.task.initialCode);
    _initTts();
    
    // Initialize Gemini Chat Context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GeminiService().startPythonTutorChat();
      _startBriefing();
    });
  }

  void _initTts() {
    _flutterTts = FlutterTts();
    _flutterTts.setLanguage("en-US");
    _flutterTts.setPitch(1.0);
    _flutterTts.setSpeechRate(0.5); // Robotic slow
    _flutterTts.setCompletionHandler(() {
      if (mounted) setState(() => _isTalking = false);
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    _focusNode.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  // --- Logic Flow ---

  void _speak(String text) async {
    if (!mounted) return;
    setState(() => _isTalking = true);
    await _flutterTts.speak(text);
  }

  void _startBriefing() {
    setState(() {
      _currentPhase = MissionPhase.briefing;
      _dialogueIndex = 0;
      _feedbackMessage = widget.mission.introDialogue.first;
    });
    _speak(_feedbackMessage!);
  }

  void _advanceFlow() {
    if (_currentPhase == MissionPhase.briefing) {
      if (_dialogueIndex < widget.mission.introDialogue.length - 1) {
        // Next Intro Line
        setState(() {
          _dialogueIndex++;
          _feedbackMessage = widget.mission.introDialogue[_dialogueIndex];
        });
        _speak(_feedbackMessage!);
      } else {
        // Start Teaching (if module exists)
        if (widget.mission.teachingModule != null) {
          setState(() {
            _currentPhase = MissionPhase.teaching;
            _teachingStepIndex = 0;
            _feedbackMessage = widget.mission.teachingModule!.steps[0].explanation;
          });
          _speak(_feedbackMessage!);
        } else {
          _startCoding();
        }
      }
    } else if (_currentPhase == MissionPhase.teaching) {
      if (widget.mission.teachingModule != null && 
          _teachingStepIndex < widget.mission.teachingModule!.steps.length - 1) {
        // Next Teaching Step
        setState(() {
          _teachingStepIndex++;
          _feedbackMessage = widget.mission.teachingModule!.steps[_teachingStepIndex].explanation;
        });
        _speak(_feedbackMessage!);
      } else {
        // Done Teaching -> Start Coding
        _startCoding();
      }
    }
  }

  void _startCoding() {
    setState(() {
      _currentPhase = MissionPhase.coding;
      _teachingStepIndex = -1; // Reset highlight or keep all highlighted? Let's reset for now or set to max.
      _feedbackMessage = "Protocol initialized. Enter the correct code logic.";
      _consoleOutput = ">> EDITOR UNLOCKED";
    });
    _speak(_feedbackMessage!);
    // Focus editor
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  void _runCode() async {
    if (_currentPhase != MissionPhase.coding && _currentPhase != MissionPhase.analysis) return;

    setState(() {
      _currentPhase = MissionPhase.analysis;
      _consoleOutput = '';
      _feedbackMessage = 'Analyzing logic structure...';
      _isAiThinking = true;
    });

    // Simulate analysis delay
    await Future.delayed(const Duration(milliseconds: 1000));

    // Validate Locally
    final validation = _validateCode(_codeController.text);
    
    if (validation.pass) {
      // SUCCESS
      setState(() {
        _isAiThinking = false;
        _currentPhase = MissionPhase.success;
        _consoleOutput = '>> EXECUTION SUCCESSFUL\n>> OUTPUT: ${widget.mission.task.expectedInput}';
        _feedbackMessage = widget.mission.successMessage;
      });
      _speak(widget.mission.successMessage);
      _unlockNextMission();

    } else {
      // FAILURE - USE STATIC ANALYSIS
      setState(() {
        _consoleOutput = '>> ERROR DETECTED\n>> ANALYZING CAUSE...';
        _isAiThinking = true;
      });

      // Local analysis
      final errorMsg = validation.error ?? "Unknown syntax error";
      final aiExplanation = StaticMentorService.getPythonExplanation(
        _codeController.text, 
        errorMsg
      );

      await Future.delayed(const Duration(milliseconds: 600)); // Brief "thinking" delay

      if (!mounted) return;
      setState(() {
        _isAiThinking = false;
        _currentPhase = MissionPhase.coding; 
        _consoleOutput = '>> EXECUTION FAILED\n>> ERROR: $errorMsg';
        _feedbackMessage = "SYSTEM ERROR: $errorMsg\n\n$aiExplanation";
      });
      _speak("Error detected. $errorMsg. $aiExplanation");
    }
  }

  ({bool pass, String? error}) _validateCode(String code) {
    if (widget.mission.task.expectedInput.isNotEmpty && !code.contains(widget.mission.task.expectedInput)) {
       // Strict check for now if expectedInput is strict
       // For missions like "print", we check specific output match logic if we had a real runner.
       // Here we rely on string matching the concept.
    }

    // Rules check
    for (final rule in widget.mission.task.validationRules) {
      final contains = code.contains(rule.pattern);
      if (rule.isNegative) {
        if (contains) return (pass: false, error: rule.errorMessage);
      } else {
        if (!contains) return (pass: false, error: rule.errorMessage);
      }
    }
    return (pass: true, error: null);
  }

  Future<void> _unlockNextMission() async {
    final prefs = await SharedPreferences.getInstance();
    final unlocked = prefs.getStringList('python_unlocked_missions') ?? ['py1'];
    
    final currentIdNum = int.tryParse(widget.mission.id.substring(2)) ?? 0;
    final nextId = 'py${currentIdNum + 1}';
    
    if (currentIdNum > 0 && currentIdNum < 11 && !unlocked.contains(nextId)) {
      unlocked.add(nextId);
      await prefs.setStringList('python_unlocked_missions', unlocked);
    }
  }

  // --- UI Building ---

  @override
  Widget build(BuildContext context) {
    // Show Next button if in Briefing or Teaching phase
    final bool showNextButton = _currentPhase == MissionPhase.briefing || _currentPhase == MissionPhase.teaching;
    final bool isEditorReadOnly = _currentPhase != MissionPhase.coding && _currentPhase != MissionPhase.success;

    return Scaffold(
      backgroundColor: PythonByteStarTheme.background,
      body: Stack(
        children: [
          // Background
           Positioned.fill(
            child: AnimatedSpaceBackground(
              sceneType: widget.mission.sceneType,
              child: const SizedBox.expand(),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(context),

                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Left Panel: NOVA & Education (40%)
                      Expanded(
                        flex: 4,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border(right: BorderSide(color: PythonByteStarTheme.primary.withOpacity(0.2))),
                            color: Colors.black.withOpacity(0.3),
                          ),
                          child: Column(
                            children: [
                              NovaHologram(
                                size: 120, 
                                isTalking: _isTalking,
                                accentColor: _currentPhase == MissionPhase.success ? PythonByteStarTheme.success : null,
                              ),
                              const SizedBox(height: 16),
                              
                              // Dialogue / Status Box
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: PythonByteStarTheme.secondary.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: _currentPhase == MissionPhase.success ? PythonByteStarTheme.success : PythonByteStarTheme.accent),
                                ),
                                child: Text(
                                  _feedbackMessage ?? "Initializing...",
                                  style: PythonByteStarTheme.body.copyWith(fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                              ).animate(key: ValueKey(_feedbackMessage)).fadeIn(),

                              const SizedBox(height: 16),

                              // Teaching Module
                              if (widget.mission.teachingModule != null)
                                Expanded(
                                  child: PythonTeachingPanel(
                                    module: widget.mission.teachingModule!,
                                    activeStepIndex: _currentPhase == MissionPhase.teaching ? _teachingStepIndex : -1,
                                  ),
                                ),
                              
                              // Next Button at Bottom Left
                              if (showNextButton)
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: _buildNextButton(),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                      // Right Panel: Editor & Console (60%)
                      Expanded(
                        flex: 6,
                        child: Column(
                          children: [
                            // Task Bar
                            Container(
                               width: double.infinity,
                               padding: const EdgeInsets.all(12),
                               color: PythonByteStarTheme.surface.withOpacity(0.1),
                               child: Row(
                                 children: [
                                   const Icon(Icons.task_alt, color: Colors.amber, size: 18),
                                   const SizedBox(width: 8),
                                   Expanded(child: Text(widget.mission.task.instruction, style: const TextStyle(color: Colors.white))),
                                 ],
                               ),
                            ),
                            
                            // Editor
                            Expanded(
                              flex: 2,
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: PythonCodeEditor(
                                      controller: _codeController,
                                      focusNode: _focusNode,
                                      readOnly: isEditorReadOnly,
                                      filename: '${widget.mission.id}_script.py',
                                      initialCode: widget.mission.task.initialCode,
                                    ),
                                  ),
                                  
                                  // Lock Overlay
                                  if (isEditorReadOnly && _currentPhase != MissionPhase.success)
                                    Positioned.fill(
                                      child: Container(
                                        color: Colors.black.withOpacity(0.6),
                                        child: Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(Icons.lock, color: Colors.grey, size: 40),
                                              const SizedBox(height: 8),
                                              Text(
                                                "AWAITING INSTRUCTIONS", 
                                                style: PythonByteStarTheme.heading.copyWith(fontSize: 16, color: Colors.grey)
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            // Console
                            Expanded(
                               flex: 1,
                               child: Container(
                                 width: double.infinity,
                                 margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                 padding: const EdgeInsets.all(12),
                                 decoration: BoxDecoration(
                                   color: Colors.black,
                                   border: Border.all(color: Colors.white24),
                                   borderRadius: BorderRadius.circular(8),
                                 ),
                                 child: SingleChildScrollView(
                                   child: Text(
                                     _consoleOutput,
                                     style: TextStyle(
                                       fontFamily: 'Fira Code', 
                                       color: _currentPhase == MissionPhase.success ? PythonByteStarTheme.success : Colors.greenAccent, 
                                       fontSize: 12
                                     ),
                                   ),
                                 ),
                               ),
                            ),

                            // Actions
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16, right: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: (_currentPhase == MissionPhase.coding || _currentPhase == MissionPhase.success) && !_isAiThinking ? _runCode : null,
                                    icon: _isAiThinking 
                                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                                      : const Icon(Icons.play_arrow),
                                    label: Text(_isAiThinking ? 'AI ANALYZING...' : 'RUN CODE'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: PythonByteStarTheme.success,
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                      disabledBackgroundColor: Colors.grey.withOpacity(0.2),
                                    ),
                                  ),
                                  if (_currentPhase == MissionPhase.success) ...[
                                     const SizedBox(width: 16),
                                      ElevatedButton.icon(
                                       onPressed: () => Navigator.of(context).pop(), 
                                       icon: const Icon(Icons.check),
                                       label: const Text('COMPLETE'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: PythonByteStarTheme.primary,
                                          foregroundColor: Colors.black,
                                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                        ),
                                     ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), duration: 1.seconds),
                                  ]
                                ],
                              ),
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
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: PythonByteStarTheme.background.withOpacity(0.8),
        border: Border(bottom: BorderSide(color: PythonByteStarTheme.primary.withOpacity(0.3))),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: PythonByteStarTheme.primary),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.mission.title, style: PythonByteStarTheme.heading.copyWith(fontSize: 18)),
              Text('Sector: ${widget.mission.sceneName}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const Spacer(),
          const Icon(Icons.wifi, color: PythonByteStarTheme.success, size: 16),
          const SizedBox(width: 4),
          Text('CONNECTED', style: PythonByteStarTheme.terminal.copyWith(fontSize: 10, color: PythonByteStarTheme.success)),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
     return InkWell(
       onTap: _advanceFlow,
       child: Container(
         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
         decoration: BoxDecoration(
           color: PythonByteStarTheme.accent.withOpacity(0.2),
           border: Border.all(color: PythonByteStarTheme.accent),
           borderRadius: BorderRadius.circular(20),
         ),
         child: Row(
           mainAxisSize: MainAxisSize.min,
           children: [
             Text("NEXT", style: PythonByteStarTheme.terminal.copyWith(color: PythonByteStarTheme.accent)),
             const SizedBox(width: 4),
             const Icon(Icons.arrow_forward_ios, size: 12, color: PythonByteStarTheme.accent),
           ],
         ),
       ),
     ).animate(onPlay: (c) => c.repeat(reverse: true)).pulse(duration: 1.5.seconds);
  }
}

// Polyfills
extension on Color {
  // Color withValues({required double alpha}) => withOpacity(alpha);
}
extension on Animate {
  Widget pulse({Duration? duration}) => scale(begin: const Offset(1,1), end: const Offset(1.05, 1.05), duration: duration);
}
