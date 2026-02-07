import 'package:flutter/material.dart';
import 'dart:math' as math;

class CalculationBackground extends StatefulWidget {
  final bool isStable; // True = Green/Smooth, False = Red/Broken
  const CalculationBackground({super.key, required this.isStable});

  @override
  State<CalculationBackground> createState() => _CalculationBackgroundState();
}

class _CalculationBackgroundState extends State<CalculationBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
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
        Container(color: const Color(0xFF0F0505)), // Dark Red/Black base
        
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _GraphPainter(
                progress: _controller.value,
                isStable: widget.isStable,
              ),
              child: Container(),
            );
          },
        ),
      ],
    );
  }
}

class _GraphPainter extends CustomPainter {
  final double progress;
  final bool isStable;

  _GraphPainter({required this.progress, required this.isStable});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Grid lines
    paint.color = (isStable ? Colors.green : Colors.red).withValues(alpha: 0.1);
    double step = 50;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Graph Line
    paint.color = isStable ? Colors.greenAccent : Colors.redAccent;
    paint.strokeWidth = 3.0;
    
    final path = Path();
    bool first = true;
    
    for (double x = 0; x < size.width; x += 5) {
      double y = size.height / 2;
      
      // Wave function
      if (isStable) {
        // Smooth Sine with progress
        double normalizedX = x / size.width;
        double phase = progress * 2 * math.pi;
        double amplitude = 50.0;
        double frequency = 3.0;
        
        y += math.sin(normalizedX * frequency * 2 * math.pi + phase) * amplitude;
        
      } else {
         // Chaos/Glitch
         double noise = math.Random((x * 10 + progress * 100).toInt()).nextDouble() * 100 - 50;
         y += noise;
         
         // Occasional big spikes
         if (math.Random().nextDouble() > 0.95) {
           y += (math.Random().nextBool() ? -50 : 50);
         }
      }
      
      if (first) {
        path.moveTo(x, y);
        first = false;
      } else {
        path.lineTo(x, y);
      }
    }
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _GraphPainter oldDelegate) => true;
}
