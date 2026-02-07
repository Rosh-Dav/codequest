import 'package:flutter/material.dart';

class CockpitBackground extends StatefulWidget {
  final bool isOffline; // True = Red/Static, False = Green/Active
  const CockpitBackground({super.key, required this.isOffline});

  @override
  State<CockpitBackground> createState() => _CockpitBackgroundState();
}

class _CockpitBackgroundState extends State<CockpitBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base Color
        Container(color: Colors.black),
        
        // Animated Overlay
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _CockpitPainter(
                progress: _controller.value,
                isOffline: widget.isOffline,
              ),
              child: Container(),
            );
          },
        ),
      ],
    );
  }
}

class _CockpitPainter extends CustomPainter {
  final double progress;
  final bool isOffline;

  _CockpitPainter({required this.progress, required this.isOffline});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Color: Offline = Red, Online = Green
    final color = isOffline ? Colors.red : Colors.green;
    
    // Draw Cockpit HUD lines
    paint.color = color.withValues(alpha: 0.3);
    
    // Frame
    canvas.drawRect(Rect.fromLTWH(20, 20, size.width - 40, size.height - 40), paint);
    
    // Crosshairs or Grid
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    
    canvas.drawLine(Offset(centerX - 50, centerY), Offset(centerX + 50, centerY), paint);
    canvas.drawLine(Offset(centerX, centerY - 50), Offset(centerX, centerY + 50), paint);
    
    // Blinking effect if offline
    if (isOffline) {
      if ((progress * 10).toInt() % 2 == 0) {
        paint.color = Colors.red.withValues(alpha: 0.1);
        canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint..style = PaintingStyle.fill);
      }
      
      // Static noise lines
      final randomY = (progress * 1327) % size.height;
      paint.color = Colors.white.withValues(alpha: 0.2);
      paint.style = PaintingStyle.stroke;
      canvas.drawLine(Offset(0, randomY), Offset(size.width, randomY), paint);
    } else {
      // Stable Green Glow
       paint.color = Colors.green.withValues(alpha: 0.1);
       canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint..style = PaintingStyle.fill);
    }
  }

  @override
  bool shouldRepaint(covariant _CockpitPainter oldDelegate) => true;
}
