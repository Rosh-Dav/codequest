import 'package:flutter/material.dart';

import 'dart:math' as math;

// --- DEEP SPACE PAINTER (Galaxy/Nebula) ---
class DeepSpacePainter extends CustomPainter {
  final double animationValue;

  DeepSpacePainter({this.animationValue = 0});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Base Gradient (Dark Blue/Purple)
    final rect = Offset.zero & size;
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        const Color(0xFF050A18), // Deep Navy
        const Color(0xFF120524), // Deep Purple
      ],
    ).createShader(rect);
    canvas.drawRect(rect, Paint()..shader = gradient);

    // 2. Stars (Twinkling)
    final starPaint = Paint();
    
    // Simple pseudo-random stars (deterministic for stability)
    for (int i = 0; i < 100; i++) {
      final x = (i * 137.5) % size.width;
      final y = (i * 293.3) % size.height;
      final baseRadius = (i % 3 == 0) ? 1.5 : 0.8;
      
      // Twinkle effect: Use sine wave based on index + animation
      // Creates individual twinkle timing for each star
      final twinkle = 1.0 + 0.5 * (i % 2 == 0 ? 1 : -1) * 
          math.sin(animationValue * 6.28 + i); // 0.5 to 1.5 multiplier
          
      starPaint.color = Colors.white.withValues(alpha: (0.4 + 0.2 * twinkle).clamp(0.1, 0.9));
      canvas.drawCircle(Offset(x, y), baseRadius * twinkle, starPaint); // Radius also subtly changes
    }
    
    // 3. Nebula Cloud (Using radial gradients with slight rotation/shift)
    // We shift the center slightly in a circle
    final shiftX = 20 * math.cos(animationValue * 6.28);
    final shiftY = 20 * math.sin(animationValue * 6.28);
    
    final nebulaPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.purpleAccent.withValues(alpha: 0.15),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(
          center: Offset(size.width * 0.8 + shiftX, size.height * 0.2 + shiftY), 
          radius: 200 + 10 * math.sin(animationValue * 6.28 * 2) // Pulse radius
      ));
    canvas.drawCircle(Offset(size.width * 0.8 + shiftX, size.height * 0.2 + shiftY), 250, nebulaPaint);
  }
  @override
  bool shouldRepaint(covariant DeepSpacePainter oldDelegate) => oldDelegate.animationValue != animationValue;
}


// --- DARK SPACESHIP PAINTER (Metallic/Red Alert) ---
class DarkSpaceshipPainter extends CustomPainter {
  final double animationValue;

  DarkSpaceshipPainter({this.animationValue = 0});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Metallic Base
    canvas.drawColor(const Color(0xFF101215), BlendMode.src);

    final panelPaint = Paint()
      ..color = const Color(0xFF202225)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // 2. Grid Panels (Scroll slightly?)
    // Let's make them static for solidity, but maybe a subtle light scan?
    for (double i = 0; i < size.width; i += 60) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), panelPaint);
    }
    
    // 3. Red Alert Overlay (Vignette Pulse)
    // Pulse alpha between 0.2 and 0.4
    final double alertAlpha = 0.2 + 0.2 * (0.5 + 0.5 * math.sin(animationValue * 6.28 * 0.5)); // Slow pulse

    final alertPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 1.2,
        colors: [
           Colors.transparent,
           Colors.red.withValues(alpha: alertAlpha), // Red edges
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, alertPaint);
  }
  @override
  bool shouldRepaint(covariant DarkSpaceshipPainter oldDelegate) => oldDelegate.animationValue != animationValue;
}

// --- ENGINE ROOM PAINTER (Glowing Blue Core) ---
class EngineRoomPainter extends CustomPainter {
  final double animationValue;

  EngineRoomPainter({this.animationValue = 0});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Dark Base
    canvas.drawColor(Colors.black, BlendMode.src);

    // 2. Blue Core Glow (Pulse)
    final pulse = 0.3 + 0.1 * math.sin(animationValue * 12.56); // Faster pulse (2Hz roughly)
    
    final corePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.cyanAccent.withValues(alpha: 0.5 + pulse),
          Colors.blue.withValues(alpha: 0.1),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: size.center(Offset.zero), radius: 300));
    
    canvas.drawCircle(size.center(Offset.zero), 300, corePaint);
    
    // 3. Energy Particles (Orbiting)
    final p = Paint()..color = Colors.cyanAccent;
    final center = size.center(Offset.zero);
    
    // Particle 1
    double t1 = animationValue * 6.28;
    canvas.drawCircle(center + Offset(60 * math.cos(t1), 60 * math.sin(t1)), 3, p);
    
    // Particle 2 (Reverse, slower)
    double t2 = -animationValue * 6.28 * 0.7;
    canvas.drawCircle(center + Offset(100 * math.cos(t2), 40 * math.sin(t2)), 2, p);
    
    // Particle 3
    double t3 = animationValue * 6.28 * 1.5 + 2.0;
    canvas.drawCircle(center + Offset(30 * math.cos(t3), 80 * math.sin(t3)), 4, p);
  }
  @override
  bool shouldRepaint(covariant EngineRoomPainter oldDelegate) => oldDelegate.animationValue != animationValue;
}
