import 'package:flutter/material.dart';
import '../../utils/phase1_theme.dart';

class ConverterBackground extends StatefulWidget {
  final bool isStabilized; 
  const ConverterBackground({super.key, required this.isStabilized});

  @override
  State<ConverterBackground> createState() => _ConverterBackgroundState();
}

class _ConverterBackgroundState extends State<ConverterBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat();
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
        Container(color: const Color(0xFF101015)),
        
        // Pipes / Streams
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _ConverterPainter(
                progress: _controller.value,
                isStabilized: widget.isStabilized,
              ),
              child: Container(),
            );
          },
        ),
      ],
    );
  }
}

class _ConverterPainter extends CustomPainter {
  final double progress;
  final bool isStabilized;

  _ConverterPainter({required this.progress, required this.isStabilized});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // Draw localized pipelines
    // Vertical lines
    double spacing = size.width / 5;
    
    for (int i = 0; i < 5; i++) {
        double x = spacing * i + spacing / 2;
        
        // Color depend on state
        if (isStabilized) {
           paint.color = Phase1Theme.cyanGlow.withValues(alpha: 0.2);
           paint.strokeWidth = 3.0;
        } else {
           // Glitchy colors
           paint.color = (i % 2 == 0 ? Colors.orange : Colors.red).withValues(alpha: 0.3);
           paint.strokeWidth = 2.0 + (progress * 2); // Pulsing width
        }
        
        canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
        
        // Flowing data packets
        if (isStabilized) {
           paint.color = Phase1Theme.cyanGlow;
           double y = (progress * size.height + (i * 100)) % size.height;
           canvas.drawRect(Rect.fromLTWH(x - 2, y, 4, 20), paint..style = PaintingStyle.fill);
        } else {
           // Chaotic particles
           paint.color = Colors.orange;
           double y = ((progress + i * 0.2) * size.height) % size.height;
           if (i % 2 == 0) y = size.height - y; // Some go up
           
           canvas.drawCircle(Offset(x, y), 3, paint..style = PaintingStyle.fill);
        }
    }
  }

  @override
  bool shouldRepaint(covariant _ConverterPainter oldDelegate) => true;
}
