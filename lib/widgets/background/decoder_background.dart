import 'package:flutter/material.dart';

class DecoderBackground extends StatefulWidget {
  final bool isGlitched;
  const DecoderBackground({super.key, required this.isGlitched});

  @override
  State<DecoderBackground> createState() => _DecoderBackgroundState();
}

class _DecoderBackgroundState extends State<DecoderBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If glitched, show random colored blocks/lines
    // If stable, show clean grid or matrix
    // For now, simpler implementation:
    // Glitched = Red/Orange Tint + Random Opacity
    // Stable = Blue/Green Tint + Steady
    
    return Stack(
      children: [
        // Base Color
        Container(color: Colors.black),
        
        // Grid/Matrix Overlay
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _DecoderPainter(
                progress: _controller.value,
                isGlitched: widget.isGlitched,
              ),
              child: Container(),
            );
          },
        ),
      ],
    );
  }
}

class _DecoderPainter extends CustomPainter {
  final double progress;
  final bool isGlitched;

  _DecoderPainter({required this.progress, required this.isGlitched});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isGlitched ? Colors.orange.withValues(alpha: 0.2) : Colors.cyan.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw some random lines if glitched
    if (isGlitched) {
       // Chaotic lines
       for (int i = 0; i < 20; i++) {
         final y = (size.height * ((progress + i * 0.1) % 1.0));
         canvas.drawLine(
           Offset(0, y), 
           Offset(size.width, y + (i % 2 == 0 ? 20 : -20)), 
           paint..color = Colors.red.withValues(alpha: 0.3)
         );
       }
    } else {
       // Stable Grid
       double step = 40;
       for (double y = 0; y < size.height; y += step) {
         canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
       }
       for (double x = 0; x < size.width; x += step) {
         canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
       }
    }
  }

  @override
  bool shouldRepaint(covariant _DecoderPainter oldDelegate) => true;
}
