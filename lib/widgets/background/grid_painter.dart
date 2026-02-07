import 'dart:math';
import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class GridPainter extends CustomPainter {
  final double animationValue;

  GridPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = AppTheme.gridLine
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final double horizonY = size.height * 0.4;
    final double bottomY = size.height;
    // Perspective intensity
    final double centerX = size.width / 2;

    // Vertical lines (perspective)
    for (double i = -10; i <= 10; i++) {
      // Calculate x position at bottom based on divergence from center
      double bottomX = centerX + (i * size.width * 0.15);
      // Calculate x position at horizon (converging to center largely)
      // Actually for a true grid they converge to a vanishing point.
      // Let's settle for a simpler "retro wave" style grid.
      double topX = centerX + (i * size.width * 0.02);

      canvas.drawLine(
        Offset(topX, horizonY),
        Offset(bottomX, bottomY),
        linePaint,
      );
    }

    // Horizontal lines (moving towards camera)
    // We want lines to appear from horizon and move down.
    // The spacing should increase as they get closer to bottom (perspective).
    
    double progress = animationValue;
    
    // Draw moving lines
    for (double i = 0; i < 20; i++) {
       // Non-linear pacing to simulate perspective depth
       // y = horizonY + (bottomY - horizonY) * (i + progress)^2 / max^2 ?
       
       double t = (i + progress) / 10.0;
       if (t > 1.0) t -= 2.0; // Wrap around roughly
       if (t < 0) continue;
       
       // Exponential spacing
       double y = horizonY + (bottomY - horizonY) * pow(t, 2.5);
       
       if (y > bottomY || y < horizonY) continue;

       // Opacity fades near horizon
       double opacity = (y - horizonY) / (bottomY - horizonY);
       linePaint.color = AppTheme.neonBlue.withValues(alpha: opacity * 0.5);

       canvas.drawLine(
         Offset(0, y),
         Offset(size.width, y),
         linePaint,
       );
    }
    
    // Add a glow at the horizon
    final Paint glowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppTheme.neonPurple.withValues(alpha: 0.0),
          AppTheme.neonPurple.withValues(alpha: 0.5),
          AppTheme.neonBlue.withValues(alpha: 0.0),
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, horizonY - 50, size.width, 100));

    canvas.drawRect(Rect.fromLTWH(0, horizonY - 50, size.width, 100), glowPaint);
  }

  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
