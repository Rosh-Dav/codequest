import 'package:flutter/material.dart';
import '../../utils/bytestar_theme.dart';

// --- DEEP SPACE PAINTER (Galaxy/Nebula) ---
class DeepSpacePainter extends CustomPainter {
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

    // 2. Stars
    final starPaint = Paint()..color = Colors.white.withValues(alpha: 0.6);
    // Simple pseudo-random stars (deterministic for stability)
    for (int i = 0; i < 100; i++) {
      final x = (i * 137.5) % size.width;
      final y = (i * 293.3) % size.height;
      final radius = (i % 3 == 0) ? 1.5 : 0.8;
      canvas.drawCircle(Offset(x, y), radius, starPaint);
    }
    
    // 3. Nebula Cloud (Using radial gradients)
    final nebulaPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.purpleAccent.withValues(alpha: 0.1),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: Offset(size.width * 0.8, size.height * 0.2), radius: 200));
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.2), 200, nebulaPaint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


// --- DARK SPACESHIP PAINTER (Metallic/Red Alert) ---
class DarkSpaceshipPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Metallic Base
    canvas.drawColor(const Color(0xFF101215), BlendMode.src);

    final panelPaint = Paint()
      ..color = const Color(0xFF202225)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // 2. Grid Panels
    for (double i = 0; i < size.width; i += 60) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), panelPaint);
    }
    
    // 3. Red Alert Overlay (Vignette)
    final alertPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 1.2,
        colors: [
           Colors.transparent,
           Colors.red.withValues(alpha: 0.3), // Red edges
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, alertPaint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// --- ENGINE ROOM PAINTER (Glowing Blue Core) ---
class EngineRoomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Dark Base
    canvas.drawColor(Colors.black, BlendMode.src);

    // 2. Blue Core Glow
    final corePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.cyanAccent.withValues(alpha: 0.4),
          Colors.blue.withValues(alpha: 0.1),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: size.center(Offset.zero), radius: 300));
    
    canvas.drawCircle(size.center(Offset.zero), 300, corePaint);
    
    // 3. Energy Particles (Static for now)
    final p = Paint()..color = Colors.cyanAccent;
    canvas.drawCircle(size.center(const Offset(-50, -50)), 2, p);
    canvas.drawCircle(size.center(const Offset(60, 40)), 3, p);
    canvas.drawCircle(size.center(const Offset(-20, 80)), 1, p);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
