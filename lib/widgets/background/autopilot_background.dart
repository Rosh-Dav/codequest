import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/phase1_theme.dart';

class AutopilotBackground extends StatelessWidget {
  final bool isOptimal;
  const AutopilotBackground({super.key, this.isOptimal = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          // Navigation Grid
          Positioned.fill(
            child: CustomPaint(
              painter: _NavGridPainter(isOptimal: isOptimal),
            ),
          ),
          
          // Pulsing Decision Nodes
          _DecisionNode(position: const Offset(100, 200), isActive: isOptimal),
          _DecisionNode(position: const Offset(300, 400), isActive: isOptimal),
          _DecisionNode(position: const Offset(150, 600), isActive: isOptimal),
          
          // Scanning Beam
          Positioned.fill(
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: (isOptimal ? Phase1Theme.successGreen : Phase1Theme.purplish).withValues(alpha: 0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    (isOptimal ? Phase1Theme.successGreen : Phase1Theme.purplish).withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ).animate(onPlay: (c) => c.repeat()).moveY(begin: 0, end: 800, duration: 4.seconds),
          ),
        ],
      ),
    );
  }
}

class _NavGridPainter extends CustomPainter {
  final bool isOptimal;
  _NavGridPainter({required this.isOptimal});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isOptimal ? Phase1Theme.successGreen : Phase1Theme.purplish).withValues(alpha: 0.1)
      ..strokeWidth = 1.0;

    double spacing = 40.0;
    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
    
    // Path lines
    if (isOptimal) {
      final pathPaint = Paint()
        ..color = Phase1Theme.successGreen.withValues(alpha: 0.3)
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;
      
      final path = Path();
      path.moveTo(0, size.height * 0.8);
      path.lineTo(size.width * 0.3, size.height * 0.6);
      path.lineTo(size.width * 0.7, size.height * 0.4);
      path.lineTo(size.width, size.height * 0.2);
      canvas.drawPath(path, pathPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _NavGridPainter oldDelegate) => oldDelegate.isOptimal != isOptimal;
}

class _DecisionNode extends StatelessWidget {
  final Offset position;
  final bool isActive;
  const _DecisionNode({required this.position, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: (isActive ? Phase1Theme.successGreen : Phase1Theme.purplish).withValues(alpha: 0.6),
          boxShadow: [
            BoxShadow(
              color: (isActive ? Phase1Theme.successGreen : Phase1Theme.purplish).withValues(alpha: 0.4),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
      ).animate(onPlay: (c) => c.repeat(reverse: true))
       .scale(begin: const Offset(1, 1), end: const Offset(1.5, 1.5), duration: 2.seconds),
    );
  }
}
