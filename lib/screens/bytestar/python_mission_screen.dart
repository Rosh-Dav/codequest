import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/theme.dart';
import '../../core/story_engine.dart';
import '../../widgets/ai/nova_mentor_widget.dart';
import '../../widgets/background/code_background.dart';

class PythonMissionScreen extends StatefulWidget {
  const PythonMissionScreen({super.key});

  @override
  State<PythonMissionScreen> createState() => _PythonMissionScreenState();
}

class _PythonMissionScreenState extends State<PythonMissionScreen> {
  final StoryEngine _storyEngine = StoryEngine();
  final TextEditingController _codeController = TextEditingController();
  
  Map<String, dynamic>? _missionData;
  bool _isLoading = true;
  String _feedbackMessage = "";
  bool _isSuccess = false;

  // Theme Colors
  final Color _primaryColor = const Color(0xFF00E5FF);
  final Color _accentColor = const Color(0xFF7C4DFF);
  final Color _successColor = const Color(0xFF00FF88);
  final Color _errorColor = const Color(0xFFFF4C4C);

  @override
  void initState() {
    super.initState();
    _loadMission();
  }

  Future<void> _loadMission() async {
    setState(() => _isLoading = true);
    final data = await _storyEngine.getCurrentMissionData();
    setState(() {
      _missionData = data;
      _isLoading = false;
      _codeController.text = data?['template'] ?? '';
      _feedbackMessage = "";
      _isSuccess = false;
    });
  }

  void _checkSolution() {
    if (_missionData == null) return;

    final code = _codeController.text;
    final isValid = _storyEngine.validateMission(code, _missionData!);

    setState(() {
      if (isValid) {
        _isSuccess = true;
        _feedbackMessage = _missionData!['success_message'];
      } else {
        _isSuccess = false;
        _feedbackMessage = "ERROR: SYSTEM SYNTAX INVALID. RETRY.";
      }
    });

    if (isValid) {
      _handleSuccess();
    }
  }

  Future<void> _handleSuccess() async {
    await Future.delayed(const Duration(seconds: 2));
    await _storyEngine.completeCurrentMission();
    
    if (!mounted) return;
    
    // Quick transition effect or dialog could go here
    // For now, simple reload of next mission
    // Check if there are more missions by blindly reloading
    // In a real app, we'd check if `nextMission` exists or navigate to a specialized "Level Complete" screen
    
    // Reload animation
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    _loadMission();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.ideBackground,
        body: Center(child: CircularProgressIndicator(color: _primaryColor)),
      );
    }

    if (_missionData == null) {
      return Scaffold(
        backgroundColor: AppTheme.ideBackground,
        body: Center(
          child: Text(
            "ALL SYSTEMS OPERATIONAL.\nTRAINING COMPLETE.",
            textAlign: TextAlign.center,
            style: TextStyle(color: _primaryColor, fontSize: 24, letterSpacing: 2),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.ideBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "MISSION ${_missionData!['phase']}-${_missionData!['mission']}: ${_missionData!['title']}",
          style: TextStyle(fontFamily: 'Courier', color: _primaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: CodeBackground()),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Mission Context / NOVA
                  NovaMentorWidget(
                    dialogue: _missionData!['description'],
                    showTypingAnimation: false, // Don't re-animate every validation
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // 2. Teaching Panel
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E).withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _accentColor.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "OBJECTIVES",
                          style: TextStyle(color: _accentColor, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                        ),
                        const SizedBox(height: 8),
                        ...(_missionData!['objectives'] as List).map((obj) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle_outline, color: _primaryColor, size: 16),
                              const SizedBox(width: 8),
                              Text(obj, style: const TextStyle(color: Colors.white70)),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  
                  // 3. Code Editor
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _isSuccess ? _successColor : (_feedbackMessage.isNotEmpty && !_isSuccess ? _errorColor : Colors.white24),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Editor Header
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                          ),
                          child: const Text("TERMINAL", style: TextStyle(fontFamily: 'Courier', color: Colors.white54)),
                        ),
                        // Text Field
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: TextField(
                            controller: _codeController,
                            style: TextStyle(
                              fontFamily: 'Courier',
                              fontSize: 16,
                              color: _primaryColor,
                            ),
                            maxLines: 8,
                            decoration: const InputDecoration.collapsed(
                              hintText: "Enter your code here...",
                              hintStyle: TextStyle(color: Colors.white24),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  
                  // 4. Feedback & Action
                  if (_feedbackMessage.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: _isSuccess ? _successColor.withValues(alpha: 0.1) : _errorColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: _isSuccess ? _successColor : _errorColor),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _isSuccess ? Icons.check_circle : Icons.error,
                            color: _isSuccess ? _successColor : _errorColor,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _feedbackMessage,
                              style: TextStyle(
                                color: _isSuccess ? _successColor : _errorColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn().slideX(),

                  ElevatedButton(
                    onPressed: _checkSolution,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      "EXECUTE COMMAND",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5),
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
