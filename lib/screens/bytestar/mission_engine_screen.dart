import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/bytestar_theme.dart';
import '../../models/bytestar_data.dart';
import '../../widgets/bytestar/nova_hologram.dart';
import '../../widgets/bytestar/nova_hologram.dart';
import '../../widgets/bytestar/c_code_editor.dart';
import '../../widgets/bytestar/space_backgrounds.dart'; // Audio/Visual
import '../../services/judge0_service.dart';
import '../../services/mock_c_compiler.dart';
import '../../services/gemini_service.dart'; // AI Logic

import 'package:flutter_tts/flutter_tts.dart';
import '../../utils/dialogue_queue.dart';

class MissionEngineScreen extends StatefulWidget {
  final Mission mission;

  const MissionEngineScreen({super.key, required this.mission});

  @override
  State<MissionEngineScreen> createState() => _MissionEngineScreenState();
}

enum MissionState { intro, dialogue, teaching, task, success, failure }

class _MissionEngineScreenState extends State<MissionEngineScreen> {
  MissionState _currentState = MissionState.intro;
  int _dialogueIndex = 0;
  int _teachingStepIndex = 0;
  String _userCode = '';
  bool _isNovaTalking = false;
  final FlutterTts _flutterTts = FlutterTts();
  late final DialogueQueue _dialogueQueue;

  @override
  void initState() {
    super.initState();
    _dialogueQueue = DialogueQueue(_flutterTts);
    _userCode = widget.mission.task.initialCode;
    _initTts();
    _playIntro();
  }

  void _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.1); // Slightly higher pitch for female AI
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    
    _flutterTts.setStartHandler(() {
      if (mounted) setState(() => _isNovaTalking = true);
    });

    _flutterTts.setCompletionHandler(() {
      if (mounted) setState(() => _isNovaTalking = false);
    });

    try {
      // Get list of available voices
      List<dynamic>? voices = await _flutterTts.getVoices;
      if (voices != null) {
        // Try to find a female voice (heuristic based on common names/attributes)
        Map<dynamic, dynamic>? femaleVoice;
        
        // 1. Look for explicit "female" or "Google US English" (often female default)
        for (var v in voices) {
            String name = v['name'].toString().toLowerCase();
            if (name.contains('female') || name.contains('woman') || 
                name.contains('samantha') || name.contains('zira') || 
                name.contains('google us english')) {
              femaleVoice = v;
              break;
            }
        }
        
        if (femaleVoice != null) {
           await _flutterTts.setVoice({"name": femaleVoice["name"], "locale": femaleVoice["locale"]});
        }
      }
    } catch (e) {
      debugPrint("Error setting specific voice: $e");
    }
  }

  void _speak(String text) {
    _dialogueQueue.add(text);
  }

  void _stopSpeaking() {
    _dialogueQueue.clear();
    if (mounted) {
       setState(() => _isNovaTalking = false);
    }
  }

  @override
  void dispose() {
    _dialogueQueue.clear();
    super.dispose();
  }


  void _playIntro() async {
    // Simulate video playback
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() {
        _currentState = MissionState.dialogue;
        _isNovaTalking = true;
        
        if (widget.mission.dialogueLines.isNotEmpty) {
           _speak(widget.mission.dialogueLines[0]);
        }
      });
    }
  }

  void _advanceDialogue() {
    if (_dialogueIndex < widget.mission.dialogueLines.length - 1) {
      setState(() {
        _dialogueIndex++;
        _speak(widget.mission.dialogueLines[_dialogueIndex]);
      });
    } else {
      setState(() {
        // ALWAYS go to Teaching next, if available.
        if (widget.mission.teachingModule != null) {
          _currentState = MissionState.teaching;
          _teachingStepIndex = 0;
          _isNovaTalking = true;
          _speak(widget.mission.teachingModule!.steps[0].explanation);
        } else {
          // Fallback if no teaching module (shouldn't happen for M1-M3)
          _currentState = MissionState.task;
          _isNovaTalking = false;
          _stopSpeaking();
        }
      });
    }
  }

  void _advanceTeachingStep() {
    if (widget.mission.teachingModule != null && 
        _teachingStepIndex < widget.mission.teachingModule!.steps.length - 1) {
      setState(() {
        _teachingStepIndex++;
        _speak(widget.mission.teachingModule!.steps[_teachingStepIndex].explanation);
      });
    } else {
      // Teaching Complete -> Start Task
      setState(() {
        _currentState = MissionState.task;
        _isNovaTalking = false;
        _stopSpeaking();
      });
    }
  }

  bool _isRunningCode = false;
  final Judge0Service _judge0Service = Judge0Service();
  String _executionOutput = '';

  Future<void> _runCode() async {
    setState(() {
      _isRunningCode = true;
      _executionOutput = ''; // Clear previous output
    });

    // 1. Validation Rules Check (Static Analysis)
    for (final rule in widget.mission.task.validationRules) {
      final containsRef = _userCode.contains(rule.pattern);
      if ((rule.isMustContain && !containsRef) || (!rule.isMustContain && containsRef)) {
        await _handleSmartError(rule.errorMessage, isValidationError: true);
        return;
      }
    }

    // Execute code via Judge0 (Language ID 50 = C)
    ExecutionResult result;
    bool usingMock = false;

    try {
      result = await _judge0Service.executeCode(_userCode, 50);
      if (result.stderr.startsWith('API Error') || result.stderr.startsWith('Network Error')) {
        throw Exception(result.stderr); 
      }
    } catch (e) {
      usingMock = true;
      final mockResult = await MockCCompiler.compileAndRun(_userCode);
      result = ExecutionResult(
        stdout: mockResult['stdout']!,
        stderr: mockResult['stderr']!,
        status: mockResult['stderr']!.isEmpty ? 'Accepted' : 'Compilation Error',
      );
    }

    if (!mounted) return;

    setState(() {
      _isRunningCode = false;
      _executionOutput = result.stdout.isNotEmpty ? result.stdout : result.stderr;
      if (result.compileOutput.isNotEmpty) {
         _executionOutput += '\nCompilation: ${result.compileOutput}';
      }
      if (usingMock) {
        _executionOutput += '\n[System] Judge0 unavailable. Executed via ByteStar Simulator.';
      }
    });

    // Check success logic
    final normalizedOutput = result.stdout.replaceAll(' ', '').trim();
    final normalizedExpected = widget.mission.task.correctOutput.replaceAll(' ', '').trim();
    
    bool passed = false;
    if (result.status == 'Accepted') { 
       if (normalizedExpected.isNotEmpty) {
         passed = normalizedOutput.contains(normalizedExpected);
       } else {
          // For M1, as long as it compiles and runs without error, we consider it a pass
          // because we already validated the syntax with ValidationRules.
          passed = true;
       }
    } else {
       passed = false;
    }

    if (passed) {
      setState(() {
        _currentState = MissionState.success;
        _isNovaTalking = true;
        _speak("Mission Accomplished! Systems coming back online.");
      });
    } else {
      // Smart Error Handling via Gemini
      await _handleSmartError(result.stderr.isNotEmpty ? result.stderr : result.compileOutput);
    }
  }

  Future<void> _handleSmartError(String errorMsg, {bool isValidationError = false}) async {
      setState(() {
          _isRunningCode = false;
          _currentState = MissionState.failure;
          _executionOutput = errorMsg;
          _isNovaTalking = true;
      });

      // 1. Speak the immediate error first
      _speak(isValidationError ? errorMsg : "Alert. Code execution failed.");
      
      // 2. Ask Gemini for a helpful hint
      try {
          // Don't block UI, do this in background
          final prompt = "Role: You are NOVA, a supportive AI mentor for a C programming game.\n"
                         "Context: The user is learning '${widget.mission.concept}'.\n"
                         "Task: ${widget.mission.task.instruction}\n"
                         "User Code: $_userCode\n"
                         "Error: $errorMsg\n"
                         "Objective: Provide a 1-sentence helpful hint to fix this. Be encouraging. Do not give the answer directly.";
          
          final hint = await GeminiService().chat(prompt);
          
          if (!mounted) return;
          if (_currentState == MissionState.failure) { // Only if still on failure screen
              _speak(hint);
              // meaningful delay to let the voice finish before showing text? 
              // The DialogueQueue handles the voice, but we can also popup the hint.
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("NOVA: $hint"),
                  backgroundColor: ByteStarTheme.accent,
                  duration: const Duration(seconds: 5),
              ));
          }
      } catch (e) {
          debugPrint("Gemini Hint Error: $e");
      }
  }

  bool _isQueryingGemini = false;

  Future<void> _askNova() async {
    final TextEditingController _promptController = TextEditingController();
    
    final query = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ByteStarTheme.cardBg,
        title: Text('Ask NOVA', style: ByteStarTheme.heading),
        content: TextField(
          controller: _promptController,
          style: ByteStarTheme.body,
          decoration: InputDecoration(
            hintText: "What's on your mind, Cadet?",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: ByteStarTheme.accent)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: ByteStarTheme.primary)),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, _promptController.text),
            child: Text('Transmit', style: ByteStarTheme.code.copyWith(color: ByteStarTheme.accent)),
          ),
        ],
      ),
    );

    if (query == null || query.trim().isEmpty) return;

    setState(() {
      _isQueryingGemini = true;
      _isNovaTalking = true;
    });

    _speak("Accessing database...");

    String fullPrompt = query;
    if (_currentState == MissionState.task) {
      fullPrompt = "User Task: ${widget.mission.task.instruction}\n"
          "User Code:\n${_userCode}\n\n"
          "Question: $query";
    }

    final response = await GeminiService().chat(fullPrompt);

    if (!mounted) return;

    setState(() {
      _isQueryingGemini = false;
    });

    _speak(response);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ByteStarTheme.cardBg,
        title: Row(children: [Icon(Icons.auto_awesome, color: ByteStarTheme.accent), SizedBox(width:8), Text('NOVA Response', style: ByteStarTheme.heading)]),
        content: SingleChildScrollView(child: Text(response, style: ByteStarTheme.body)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Acknowledged', style: ByteStarTheme.code)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ByteStarTheme.primary,
      body: Stack(
        children: [
          // Background
          Positioned.fill(
             child: CustomPaint(
               painter: widget.mission.openingScene == SceneType.darkSpaceship
                   ? DarkSpaceshipPainter()
                   : widget.mission.openingScene == SceneType.engineRoom
                       ? EngineRoomPainter()
                       : DeepSpacePainter(),
             ),
          ),
          

          // Ask AI FAB (Visible in Task Mode)
          if (_currentState == MissionState.task)
            Positioned(
              bottom: 100,
              right: 16,
              child: FloatingActionButton.extended(
                onPressed: _askNova,
                backgroundColor: ByteStarTheme.accent,
                icon: const Icon(Icons.auto_awesome, color: Colors.white),
                label: const Text('Ask NOVA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ).animate().scale(),
            ),

          // Main Content Area
          SafeArea(
            child: Column(
              children: [
                // Top Bar
                _buildTopBar(),
                
                // Dynamic Body
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: _buildBody(),
                  ),
                ),
              ],
            ),
          ),

          // NOVA Overlay (Bottom Right)
          if (_currentState != MissionState.intro)
            Positioned(
              bottom: 20,
              right: 20,
              child: _buildNovaOverlay(),
            ),
            
          // Success Overlay
          if (_currentState == MissionState.success)
            Positioned.fill(child: _buildSuccessOverlay()),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: ByteStarTheme.secondary,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: ByteStarTheme.accent),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Text(widget.mission.title, style: ByteStarTheme.heading.copyWith(fontSize: 18)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: ByteStarTheme.accent),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(widget.mission.concept, style: ByteStarTheme.code),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentState) {
      case MissionState.intro:
        return _buildIntroView();
      case MissionState.dialogue:
        return _buildDialogueView();
      case MissionState.teaching:
        return _buildTeachingView();
      case MissionState.task:
        return _buildTaskView();
      case MissionState.success:
        return _buildTaskView(); // Keep task view visible behind result
      case MissionState.failure:
        return _buildTaskView();
    }
  }

  Widget _buildIntroView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Simulated Ship Entry
          const Icon(Icons.rocket, size: 100, color: ByteStarTheme.accent)
              .animate()
              .scale(begin: const Offset(0.0, 0.0), end: const Offset(1.5, 1.5), duration: 2.seconds, curve: Curves.elasticOut)
              .moveY(begin: 300, end: 0, duration: 1.5.seconds, curve: Curves.decelerate)
              .then()
              .shake(duration: 500.ms), // Landing impact
              
          const SizedBox(height: 32),
          
          Text(widget.mission.id == 'm1' ? 'INITIATING WAKE-UP SEQUENCE...' : 'APPROACHING NEXT OBJECTIVE...', 
              style: ByteStarTheme.code.copyWith(letterSpacing: 2))
              .animate(onPlay: (c) => c.repeat())
              .fadeIn(duration: 1.seconds)
              .fadeOut(delay: 1.seconds, duration: 1.seconds),
              
          const SizedBox(height: 20),
          
          // Technical loading indicators
          SizedBox(
            width: 250,
            child: Column(
              children: [
                LinearProgressIndicator(backgroundColor: Colors.black, color: ByteStarTheme.accent, minHeight: 2)
                    .animate(onPlay: (c) => c.repeat()).slideX(begin: -1, end: 1, duration: 1.seconds),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('SYSTEM CHECK... OK', style: TextStyle(color: ByteStarTheme.success, fontSize: 10))
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDialogueView() {
    // Just a placeholder, main dialogue is in the overlay
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
            border: Border.all(color: ByteStarTheme.accent.withValues(alpha: 0.3)),
            shape: BoxShape.circle,
        ),
        child: const Icon(Icons.record_voice_over, size: 64, color: Colors.white24),
      ),
    );
  }

  Widget _buildTeachingView() {
    final module = widget.mission.teachingModule!;
    final step = module.steps[_teachingStepIndex];
    final lines = module.codeSnippet.split('\n');

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('LEARNING MODULE', style: ByteStarTheme.code.copyWith(color: ByteStarTheme.accent)),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black54,
                border: Border.all(color: ByteStarTheme.accent),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.builder(
                itemCount: lines.length,
                itemBuilder: (context, index) {
                  final lineNum = index + 1;
                  final isHighlighted = step.highlightedLines.contains(lineNum);
                  
                  return AnimatedContainer(
                    duration: 300.ms,
                    color: isHighlighted ? ByteStarTheme.accent.withValues(alpha: 0.2) : Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 30,
                          child: Text(
                            '$lineNum', 
                            style: ByteStarTheme.code.copyWith(color: Colors.grey),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            lines[index],
                            style: ByteStarTheme.code.copyWith(
                              color: isHighlighted ? Colors.white : Colors.white70,
                              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                              fontFamily: 'Courier', // Ensure monospace
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Placeholder for visual asset if needed
          if (step.visualAssetId.isNotEmpty)
             Icon(
               step.visualAssetId == 'toolbox' ? Icons.build : 
               step.visualAssetId == 'engine_start' ? Icons.play_circle_fill :
               step.visualAssetId == 'brackets' ? Icons.code :
               step.visualAssetId == 'check_mark' ? Icons.check_circle : Icons.info,
               size: 48,
               color: ByteStarTheme.accent.withValues(alpha: 0.5),
             ).animate().scale().fadeIn(),
             
          const SizedBox(height: 100), // Space for NOVA overlay
        ],
      ),
    );
  }

  Widget _buildTaskView() {
    return Column(
      children: [
        // Task Instruction
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: ByteStarTheme.secondary.withValues(alpha: 0.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('MISSION OBJECTIVE:', style: ByteStarTheme.code.copyWith(color: ByteStarTheme.warning)),
              const SizedBox(height: 8),
              Text(widget.mission.task.instruction, style: ByteStarTheme.body),
              if (widget.mission.task.hints.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'HINT: ${widget.mission.task.hints.first}',
                    style: ByteStarTheme.body.copyWith(color: Colors.white54, fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
        
        // Editor
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: CCodeEditor(
              initialCode: _userCode,
              onCodeChanged: (val) => _userCode = val,
            ),
          ),
        ),
        
        // Run Button & Console
        Container(
          padding: const EdgeInsets.all(16),
          color: ByteStarTheme.primary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_isRunningCode)
                Center(
                  child: CircularProgressIndicator(color: ByteStarTheme.accent),
                )
              else
                ElevatedButton(
                  onPressed: _runCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ByteStarTheme.success,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_arrow),
                      SizedBox(width: 8),
                      Text('EXECUTE CODE'),
                    ],
                  ),
                ),
                
              // Console Output (Visible if there is output or error)
              if (_executionOutput.isNotEmpty || _currentState == MissionState.failure)
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.all(12),
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(
                      color: _currentState == MissionState.failure ? ByteStarTheme.warning : Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CONSOLE OUTPUT:', style: ByteStarTheme.code.copyWith(fontSize: 10, color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text(
                          _executionOutput.isEmpty ? 'Execution failed.' : _executionOutput,
                          style: ByteStarTheme.code.copyWith(
                            color: _currentState == MissionState.failure ? ByteStarTheme.warning : Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNovaOverlay() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_currentState == MissionState.dialogue || _currentState == MissionState.teaching)
          Container(
            width: 300,
            margin: const EdgeInsets.only(bottom: 20, right: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ByteStarTheme.secondary.withValues(alpha: 0.9),
              border: Border.all(color: ByteStarTheme.accent),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [BoxShadow(color: ByteStarTheme.accent, blurRadius: 10)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('NOVA', style: ByteStarTheme.code.copyWith(color: ByteStarTheme.accent, fontSize: 12)),
                const SizedBox(height: 4),
                // Dynamic Text content
                Builder(
                  builder: (context) {
                    final text = _currentState == MissionState.teaching 
                        ? widget.mission.teachingModule!.steps[_teachingStepIndex].explanation
                        : widget.mission.dialogueLines[_dialogueIndex];
                    final keyVal = _currentState == MissionState.teaching ? 'teach_$_teachingStepIndex' : 'dial_$_dialogueIndex';
                    
                    return Text(
                      text,
                      style: ByteStarTheme.body,
                    ).animate(key: ValueKey(keyVal)).custom(
                      duration: 40.ms * text.length, // Faster talking
                      builder: (context, value, child) {
                        final count = (text.length * value).toInt().clamp(0, text.length);
                        return Text(
                          text.substring(0, count),
                          style: ByteStarTheme.body,
                        );
                      },
                    );
                  }
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _currentState == MissionState.teaching ? _advanceTeachingStep : _advanceDialogue,
                    child: Text('NEXT >>', style: ByteStarTheme.code),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn().slideX(begin: 1, end: 0),
          
        NovaHologram(
            size: 100,
            isTalking: _isSpeaking(),
        ),
      ],
    );
  }

  bool _isSpeaking() {
     return (_currentState == MissionState.dialogue || _currentState == MissionState.teaching) && _isNovaTalking;
  }
  
  Widget _buildSuccessOverlay() {
      return Container(
          color: Colors.black.withValues(alpha: 0.8),
          child: Center(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                      const Icon(Icons.check_circle, color: ByteStarTheme.success, size: 100)
                          .animate().scale(curve: Curves.elasticOut),
                      const SizedBox(height: 24),
                      Text('MISSION ACCOMPLISHED', style: ByteStarTheme.heading.copyWith(color: ByteStarTheme.success)),
                      const SizedBox(height: 16),
                      Text('Power systems restored.\nXP Gained: +50', textAlign: TextAlign.center, style: ByteStarTheme.body),
                      const SizedBox(height: 32),
                      ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true), // Return success
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ByteStarTheme.accent,
                              foregroundColor: Colors.black,
                          ),
                          child: const Text('Return to Orbit'),
                      ),
                  ],
              ),
          ),
      ).animate().fadeIn();
  }
}
