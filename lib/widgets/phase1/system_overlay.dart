import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/phase1_theme.dart';

class SystemOverlay extends StatelessWidget {
  final VoidCallback? onComplete;

  const SystemOverlay({super.key, this.onComplete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF001122).withValues(alpha: 0.9),
        border: Border.all(color: Phase1Theme.cyanGlow, width: 1.5),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Phase1Theme.cyanGlow.withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLine("NEW SYSTEM DETECTED", delay: 0),
          const SizedBox(height: 8),
          _buildLine("MODULE: PY-ENGINE", delay: 1000),
          const SizedBox(height: 8),
          _buildLine("STATUS: UNINITIALIZED", delay: 2000, isAlert: true),
        ],
      ),
    ).animate(onComplete: (controller) => onComplete?.call())
     .fadeIn(duration: 500.ms)
     .then(delay: 4.seconds) // Hold for 4 seconds then fade out? Or just stay? 
     // The prompt says "After overlay finishes: Show NOVA panel". 
     // So I should probably trigger the callback after the lines are done.
     // I'll use a timer in the parent or just let the callback fire after the last animation.
     ;
  }

  Widget _buildLine(String text, {required int delay, bool isAlert = false}) {
    return Text(
      text,
      style: Phase1Theme.sciFiFont.copyWith(
        fontSize: 18,
        letterSpacing: 2,
        color: isAlert ? Phase1Theme.errorRed : Phase1Theme.cyanGlow,
      ),
    )
        .animate(delay: delay.ms)
        .fadeIn(duration: 300.ms)
        .slideX(begin: -0.1, end: 0, curve: Curves.easeOut);
  }
}
