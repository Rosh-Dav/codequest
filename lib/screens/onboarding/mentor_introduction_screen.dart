import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../utils/theme.dart';
import '../../utils/bytestar_theme.dart';
import '../../widgets/background/code_background.dart';
import '../../widgets/auth/gaming_button.dart';
import '../../widgets/onboarding/ai_mentor_widget.dart';
import '../../widgets/bytestar/nova_hologram.dart';
import '../login_screen.dart';
import '../bytestar/mission_map_screen.dart';
import '../runecity/rune_city_dashboard.dart';
import '../runecity/rune_city_mission_map_screen.dart';
import '../runecity_c/rune_city_c_mission_map_screen.dart'; // Add this line
import '../bytestar_python/opening_cinematic_screen.dart'; // Import Python Cinematic
import '../bytestar_python/python_mission_map_screen.dart'; // Import Python Map
import '../../widgets/navigation/global_sidebar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MentorIntroductionScreen extends StatefulWidget {
  final String username;
  final String selectedLanguage;
  final String selectedStoryMode;

  const MentorIntroductionScreen({
    super.key,
    required this.username,
    required this.selectedLanguage,
    required this.selectedStoryMode,
  });

  @override
  State<MentorIntroductionScreen> createState() => _MentorIntroductionScreenState();
}

class _MentorIntroductionScreenState extends State<MentorIntroductionScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;
  bool _showButton = false;

  @override
  void initState() {
    super.initState();
    _initMentor();
  }

  Future<void> _initMentor() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // Configure TTS
    await _flutterTts.setLanguage("en-US");
    // Attempt to pick a good voice, but fallback to default
    try {
      if (widget.selectedStoryMode == 'ByteStar Arena') {
        // Sci-fi NOVA voice - slightly higher, faster
        await _flutterTts.setPitch(1.2); 
        await _flutterTts.setSpeechRate(0.55);
      } else {
        // Fantasy Luna voice - standard, warm
        await _flutterTts.setPitch(1.0);
        await _flutterTts.setSpeechRate(0.5);
      }
    } catch (e) {
      debugPrint('TTS Error: $e');
    }

    // Speak greeting
    if (mounted) setState(() => _isSpeaking = true);
    await _speak(_getGreeting());
    
    if (mounted) {
      setState(() {
        _isSpeaking = false;
        _showButton = true;
      });
    }
  }

  String get _mentorName {
    if (widget.selectedStoryMode == 'Rune City Quest') return 'Luna';
    if (widget.selectedStoryMode == 'ByteStar Arena' || widget.selectedStoryMode == 'Byte Star Arena') return 'NOVA';
    return 'Guide';
  }

  String _getGreeting() {
    if (widget.selectedStoryMode == 'ByteStar Arena' || widget.selectedStoryMode == 'Byte Star Arena') {
      return "Welcome to the Arena, Cadet ${widget.username}. I am $_mentorName, your tactical AI. "
          "You've accessed the ${widget.selectedLanguage} systems. Prepare for training.";
    }
    
    return "Welcome ${widget.username}! I am $_mentorName, your guide in Rune City. "
        "Together we will master the arts of ${widget.selectedLanguage}. Let our journey begin!";
  }

  Future<void> _speak(String text) async {
    await _flutterTts.speak(text);
  }

  Future<void> _beginJourney() async {
    // Handle both "Byte Star Arena" (UI) and "ByteStar Arena" (Internal)
    if (widget.selectedStoryMode == 'Byte Star Arena' || widget.selectedStoryMode == 'ByteStar Arena') {
      if (widget.selectedLanguage == 'Python') {
          // Check if story started
          final prefs = await SharedPreferences.getInstance();
          final storyStarted = prefs.getBool('python_story_started') ?? false;

          if (!mounted) return;
          
          if (!storyStarted) {
             Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => OpeningCinematicScreen(username: widget.username),
              ),
            );
          } else {
             Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => PythonMissionMapScreen(username: widget.username),
              ),
            );
          }
      } else {
          // Default C++ path
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => MissionMapScreen(
                username: widget.username,
                selectedLanguage: widget.selectedLanguage,
              ),
            ),
          );
      }
    } else {
      if (widget.selectedStoryMode == 'Rune City Quest') {
        if (widget.selectedLanguage == 'Python') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => RuneCityMissionMapScreen(username: widget.username),
            ),
          );
          return;
        } else if (widget.selectedLanguage == 'C') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => RuneCityCMissionMapScreen(username: widget.username),
            ),
          );
          return;
        }
      }
      // Navigate to Rune City Dashboard (Fallback)
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => RuneCityDashboard(
            username: widget.username,
            selectedLanguage: widget.selectedLanguage,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isByteStar = widget.selectedStoryMode == 'ByteStar Arena' ||
        widget.selectedStoryMode == 'Byte Star Arena';
    
    return Scaffold(
      backgroundColor: isByteStar ? ByteStarTheme.primary : AppTheme.ideBackground,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: GlobalSidebar(username: widget.username),
      body: Stack(
        children: [
          // Background
          if (isByteStar)
             // Starfield for ByteStar (using simple color for now, can enhance)
             Positioned.fill(
               child: Container(
                 decoration: const BoxDecoration(
                   gradient: LinearGradient(
                     begin: Alignment.topCenter,
                     end: Alignment.bottomCenter,
                     colors: [ByteStarTheme.primary, ByteStarTheme.secondary],
                   ),
                 ),
               ),
             )
          else
             const Positioned.fill(
               child: CodeBackground(),
             ),

          // Content
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  const Spacer(),

                  // Mentor Avatar
                  if (isByteStar)
                    NovaHologram(size: 180, isTalking: _isSpeaking)
                  else
                    AIMentorWidget(
                      storyMode: widget.selectedStoryMode, // Pass mode to pick color
                      // We can pass empty greeting since we handle speech here
                      greeting: '', 
                      showWaveform: _isSpeaking,
                    ),

                  const SizedBox(height: 40),

                  // Greeting Text Container
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                         Text(
                          isByteStar ? 'SYSTEM INITIALIZED' : 'JOURNEY BEGINS',
                          style: (isByteStar ? ByteStarTheme.code : AppTheme.codeStyle).copyWith(
                            letterSpacing: 2,
                            fontSize: 14,
                            color: isByteStar ? ByteStarTheme.accent : AppTheme.syntaxComment,
                          ),
                        ).animate().fadeIn(duration: 800.ms),
                        
                        const SizedBox(height: 16),
                        
                        Text(
                          _getGreeting(),
                          style: (isByteStar ? ByteStarTheme.body : AppTheme.headingStyle).copyWith(
                            fontSize: 20,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ).animate(delay: 500.ms).fadeIn(),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Continue Button
                  if (_showButton)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: GamingButton(
                        text: isByteStar ? 'ENTER ARENA' : 'BEGIN JOURNEY',
                        onPressed: _beginJourney,
                        backgroundColor: isByteStar ? ByteStarTheme.accent : AppTheme.syntaxYellow,
                        textColor: isByteStar ? Colors.white : AppTheme.ideBackground,
                      ),
                    ).animate().fadeIn().slideY(begin: 0.5, end: 0),
                  
                  if (!_showButton)
                     const SizedBox(height: 90), // Placeholder for button height
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
