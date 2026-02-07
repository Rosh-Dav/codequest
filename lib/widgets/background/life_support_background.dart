import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/phase1_theme.dart';

class LifeSupportBackground extends StatelessWidget {
  final bool isMonitoring;
  const LifeSupportBackground({super.key, this.isMonitoring = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          // Heartbeat Monitor (Sine Wave)
          Positioned(
            left: 0,
            right: 0,
            top: 150,
            height: 200,
            child: CustomPaint(
              painter: _HeartbeatPainter(isStable: isMonitoring),
            ),
          ),
          
          // Oxygen Bars
          Positioned(
            left: 20,
            top: 50,
            child: _OxygenMonitor(isActive: isMonitoring),
          ),
          
          // Pulsing Core
          Center(
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    (isMonitoring ? Phase1Theme.cyanGlow : Phase1Theme.errorRed).withValues(alpha: 0.4),
                    Colors.transparent,
                  ],
                ),
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
             .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.1, 1.1), duration: 1.5.seconds),
          ),
          
          // Floating Particles
          ...List.generate(20, (index) => _LifeParticle(index: index, isStable: isMonitoring)),
        ],
      ),
    );
  }
}

class _HeartbeatPainter extends CustomPainter {
  final bool isStable;
  _HeartbeatPainter({required this.isStable});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isStable ? Phase1Theme.cyanGlow : Phase1Theme.errorRed).withValues(alpha: 0.5)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height / 2);
    
    for (double i = 0; i < size.width; i++) {
      double y;
      if (isStable) {
        // Normal sine wave
        y = size.height / 2 + math.sin(i * 0.05) * 30;
      } else {
        // Erratic wave
        y = size.height / 2 + math.sin(i * 0.1) * 60 * math.cos(i * 0.02);
      }
      path.lineTo(i, y);
    }
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _HeartbeatPainter oldDelegate) => oldDelegate.isStable != isStable;
}

class _OxygenMonitor extends StatelessWidget {
  final bool isActive;
  const _OxygenMonitor({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("O2 LEVELS", style: Phase1Theme.sciFiFont.copyWith(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 8),
        Row(
          children: List.generate(10, (index) => Container(
            width: 8,
            height: 20,
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              color: isActive && index < 8 
                ? Phase1Theme.successGreen.withValues(alpha: 0.5)
                : (isActive ? Colors.white10 : Phase1Theme.errorRed.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(2),
            ),
          ).animate(onPlay: (c) => isActive ? c.repeat(reverse: true) : c.stop()).fade(delay: (index * 100).ms, duration: 500.ms)),
        ),
      ],
    );
  }
}

class _LifeParticle extends StatelessWidget {
  final int index;
  final bool isStable;
  const _LifeParticle({required this.index, required this.isStable});

  @override
  Widget build(BuildContext context) {
    final random = math.Random(index);
    return Positioned(
      left: random.nextDouble() * 400,
      top: random.nextDouble() * 800,
      child: Container(
        width: 4,
        height: 4,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: (isStable ? Phase1Theme.cyanGlow : Phase1Theme.errorRed).withValues(alpha: 0.3),
        ),
      ).animate(onPlay: (c) => c.repeat())
       .moveY(begin: 0, end: -100, duration: (2 + random.nextDouble() * 3).seconds)
       .fade(begin: 0, end: 1, duration: 1.seconds)
       .then()
       .fade(begin: 1, end: 0, duration: 1.seconds),
    );
  }
}
