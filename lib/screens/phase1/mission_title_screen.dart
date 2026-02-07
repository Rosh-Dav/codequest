import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/phase1_theme.dart';
import '../../widgets/background/code_background.dart';
import '../../services/tts_service.dart';

class MissionTitleScreen extends StatefulWidget {
  final int missionId;
  final String title;
  final String nextRoute;

  const MissionTitleScreen({
    super.key,
    required this.missionId,
    required this.title,
    required this.nextRoute,
  });

  @override
  State<MissionTitleScreen> createState() => _MissionTitleScreenState();
}

class _MissionTitleScreenState extends State<MissionTitleScreen> {
  @override
  void initState() {
    super.initState();
    // Auto-advance after animation, or wait for click?
    // User probably wants to see it. Let's auto-advance after 3-4 seconds.
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(widget.nextRoute);
      }
    });
    
    // Announce Mission
    TTSService().speak("Mission ${widget.missionId}. ${widget.title}.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
           // Clean Background
           const Positioned.fill(child: CodeBackground()),
           
           Center(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 // Mission ID
                 Text(
                   "MISSION ${widget.missionId.toString().padLeft(2, '0')}",
                   style: Phase1Theme.sciFiFont.copyWith(
                     fontSize: 24,
                     color: Phase1Theme.cyanGlow,
                     letterSpacing: 4,
                   ),
                 ).animate()
                  .fadeIn(duration: 800.ms)
                  .slideY(begin: 0.5, end: 0)
                  .then()
                  .shimmer(duration: 1.seconds, color: Colors.white),

                 const SizedBox(height: 16),
                 
                 // Divider Line
                 Container(
                   width: 200,
                   height: 2,
                   color: Phase1Theme.purpleGlow,
                 ).animate()
                  .scaleX(begin: 0, end: 1, duration: 1.seconds, curve: Curves.easeOut),

                 const SizedBox(height: 24),

                 // Mission Title
                 Text(
                   widget.title,
                   style: GoogleFonts.orbitron(
                     fontSize: 42,
                     fontWeight: FontWeight.bold,
                     color: Colors.white,
                     letterSpacing: 2,
                   ),
                   textAlign: TextAlign.center,
                 ).animate(delay: 500.ms)
                  .fadeIn(duration: 800.ms)
                  .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
                  
                 const SizedBox(height: 48),
                 
                 // Loading/System Text
                 Text(
                   "INITIALIZING ENVIRONMENT...",
                   style: GoogleFonts.firaCode(
                     fontSize: 12,
                     color: Colors.white54,
                   ),
                 ).animate(delay: 1500.ms)
                  .fadeIn()
                  .then(delay: 500.ms)
                  .callback(callback: (_) {}), // Keep alive
                  
                 // Progress Bar
                 Container(
                    margin: const EdgeInsets.only(top: 8),
                    width: 150,
                    height: 2,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      color: Phase1Theme.successGreen,
                    ).animate(delay: 1500.ms)
                     .scaleX(begin: 0, end: 1, duration: 2.seconds, alignment: Alignment.centerLeft),
                 ),
               ],
             ),
           ),
        ],
      ),
    );
  }
}
