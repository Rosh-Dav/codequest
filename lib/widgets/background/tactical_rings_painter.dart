import 'dart:math';
import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class TacticalRingsPainter extends CustomPainter {
  final double animationValue;

  TacticalRingsPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.height * 0.8;

    final Paint ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = AppTheme.neonBlue.withValues(alpha: 0.1);

    // Ring 1: Slow rotating dashed circle
    _drawDashedCircle(canvas, center, maxRadius * 0.5, ringPaint, 12, animationValue * 0.2);

    // Ring 2: Counter-rotating thinner circle
    ringPaint.color = AppTheme.neonPurple.withValues(alpha: 0.1);
    ringPaint.strokeWidth = 1.0;
    _drawDashedCircle(canvas, center, maxRadius * 0.7, ringPaint, 24, -animationValue * 0.15);

    // Ring 3: Static outer ring with tick marks
    ringPaint.color = AppTheme.electricCyan.withValues(alpha: 0.15);
    _drawTicks(canvas, center, maxRadius * 0.85, ringPaint, 60);
    
    // Crosshairs
    final Paint crosshairPaint = Paint()
      ..color = AppTheme.electricCyan.withValues(alpha: 0.1)
      ..strokeWidth = 1.0;
      
    canvas.drawLine(Offset(center.dx - 50, center.dy), Offset(center.dx + 50, center.dy), crosshairPaint);
    canvas.drawLine(Offset(center.dx, center.dy - 50), Offset(center.dx, center.dy + 50), crosshairPaint);
  }

  void _drawDashedCircle(Canvas canvas, Offset center, double radius, Paint paint, int dashes, double rotationOffset) {
    final double gap = pi * 2 / dashes;
    final double dashSize = gap * 0.5;

    for (int i = 0; i < dashes; i++) {
      double startAngle = (i * gap) + rotationOffset;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        dashSize,
        false,
        paint,
      );
    }
  }

  void _drawTicks(Canvas canvas, Offset center, double radius, Paint paint, int ticks) {
    final double angleStep = pi * 2 / ticks;

    for (int i = 0; i < ticks; i++) {
        double angle = i * angleStep;
        // Make cardinal directions larger
        double length = (i % (ticks / 4) == 0) ? 15.0 : 5.0; 
        
        double x1 = center.dx + cos(angle) * radius;
        double y1 = center.dy + sin(angle) * radius;
        double x2 = center.dx + cos(angle) * (radius + length);
        double y2 = center.dy + sin(angle) * (radius + length);
        
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant TacticalRingsPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
