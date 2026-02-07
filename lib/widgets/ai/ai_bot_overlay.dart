import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../utils/theme.dart';
import '../../widgets/auth/gaming_button.dart';

class AIBotOverlay extends StatefulWidget {
  const AIBotOverlay({super.key});

  @override
  State<AIBotOverlay> createState() => _AIBotOverlayState();
}

class _AIBotOverlayState extends State<AIBotOverlay> {
  bool _showText = false;
  bool _showButton = false;
  late FlutterTts _flutterTts;
  final String _greetingText = 'Welcome, Player. Your coding journey begins now.\nPrepare to master programming and conquer challenges.';

  @override
  void initState() {
    super.initState();
    _initTts();
    // Simulate bot arrival delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() => _showText = true);
        _speak();
      }
    });
  }

  Future<void> _initTts() async {
    _flutterTts = FlutterTts();
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5); // Slower, more robotic/clear
  }

  Future<void> _speak() async {
    await _flutterTts.speak(_greetingText);
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.9),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Bot Avatar (Abstract geometric representation)
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.electricCyan, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.electricCyan.withValues(alpha: 0.5),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.smart_toy_outlined,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              )
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: 2.seconds, color: AppTheme.neonPurple)
              .animate()
              .scale(duration: 500.ms, curve: Curves.easeOutBack), // Entrance

              const SizedBox(height: 32),

              // Bot Greeting
              if (_showText)
                Container(
                  padding: const EdgeInsets.all(24),
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    color: AppTheme.glassWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.glassBorder),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.neonBlue.withValues(alpha: 0.2),
                        blurRadius: 20,
                        spreadRadius: 1,
                      )
                    ]
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        _greetingText,
                        textStyle: AppTheme.bodyStyle.copyWith(
                          fontSize: 16,
                          height: 1.5,
                          fontFamily: 'Roboto Mono', // Ensure monospaced
                        ),
                        textAlign: TextAlign.center,
                        speed: const Duration(milliseconds: 60),
                        cursor: '_',
                      ),
                    ],
                    isRepeatingAnimation: false,
                    onFinished: () {
                      setState(() => _showButton = true);
                    },
                  ),
                ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),

              const SizedBox(height: 32),

              if (_showButton)
                GamingButton(
                  text: 'START TRAINING',
                  onPressed: () {
                    // Navigate to next screen or close overlay
                    // For now just print
                    debugPrint("Entering Game...");
                  },
                ).animate().fadeIn(duration: 500.ms).scale(),
            ],
          ),
        ),
      ),
    );
  }
}
