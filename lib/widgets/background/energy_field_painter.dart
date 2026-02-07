import 'dart:math';
import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class EnergyFieldPainter extends CustomPainter {
  final double animationValue;

  EnergyFieldPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxDist = sqrt(pow(size.width, 2) + pow(size.height, 2)) / 2;

    final Paint wavePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw concentric waves emanating from center
    for (int i = 0; i < 5; i++) {
      double progress = (animationValue + (i * 0.2)) % 1.0;
      double radius = progress * maxDist;
      double opacity = (1.0 - progress) * 0.3;

      wavePaint.color = AppTheme.neonBlue.withValues(alpha: opacity);
      canvas.drawCircle(center, radius, wavePaint);
    }
    
    // Draw some random "glitch" lines occasionally
    if (Random().nextDouble() > 0.95) {
       final Paint glitchPaint = Paint()
         ..color = AppTheme.electricCyan.withValues(alpha: 0.5)
         ..strokeWidth = 1.0;
         
       double y = Random().nextDouble() * size.height;
       canvas.drawLine(Offset(0, y), Offset(size.width, y), glitchPaint);
    }
  }

  @override
  bool shouldRepaint(covariant EnergyFieldPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
