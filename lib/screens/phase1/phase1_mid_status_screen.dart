import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/phase1_theme.dart';
import 'mission_title_screen.dart';

class Phase1MidStatusScreen extends StatelessWidget {
  const Phase1MidStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background - Distant Grid
          Positioned.fill(
            child: GridPaper(
              color: Phase1Theme.cyanGlow.withValues(alpha: 0.05),
              interval: 100,
              divisions: 1,
              subdivisions: 1,
            ),
          ),
          
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "PHASE 1: MID-POINT REACHED",
                      style: Phase1Theme.sciFiFont.copyWith(color: Colors.grey, fontSize: 14),
                    ).animate().fadeIn(),
                    
                    const SizedBox(height: 24),
                    
                    Text(
                      "INTELLIGENCE CORE: ACTIVE",
                      style: Phase1Theme.alertFont.copyWith(color: Phase1Theme.successGreen, fontSize: 32),
                    ).animate().scale(delay: 500.ms).shimmer(duration: 2.seconds),
                    
                    const SizedBox(height: 48),
                    
                    _buildStatusCard(
                      "PY-ENGINE",
                      0.7,
                      Phase1Theme.cyanGlow,
                      "70% OPERATIONAL",
                    ),
                    
                    const SizedBox(height: 64),
                    
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        border: Border.all(color: Phase1Theme.cyanGlow.withValues(alpha: 0.3)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                           Text(
                            "NOVA:",
                            style: Phase1Theme.sciFiFont.copyWith(color: Phase1Theme.cyanGlow, fontSize: 16),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "\"Outstanding, Engineer. The system can now think and act. One final challenge remains to ensure continuous monitoring.\"",
                            textAlign: TextAlign.center,
                            style: Phase1Theme.codeFont.copyWith(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                    ).animate().slideY(begin: 0.2, end: 0, delay: 1.seconds).fadeIn(),
                    
                    const SizedBox(height: 48),
                    
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: const BorderSide(color: Colors.white24),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text("RETURN TO MAP", style: Phase1Theme.sciFiFont.copyWith(color: Colors.white70)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => MissionTitleScreen(
                                    missionId: 11,
                                    title: "CONTINUOUS MONITOR",
                                    nextRoute: '/story/python/mission11',
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Phase1Theme.cyanGlow.withValues(alpha: 0.2),
                              side: BorderSide(color: Phase1Theme.cyanGlow),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text("FINAL MISSION", style: Phase1Theme.sciFiFont.copyWith(color: Phase1Theme.cyanGlow)),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 2.seconds),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(String label, double progress, Color color, String statusText) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Phase1Theme.sciFiFont.copyWith(color: Colors.white, fontSize: 18)),
            Text(statusText, style: Phase1Theme.codeFont.copyWith(color: color, fontSize: 16)),
          ],
        ),
        const SizedBox(height: 12),
        LinearProgressIndicator(
          value: progress,
          minHeight: 12,
          backgroundColor: Colors.white10,
          color: color,
          borderRadius: BorderRadius.circular(6),
        ).animate().shimmer(duration: 3.seconds),
      ],
    );
  }
}
