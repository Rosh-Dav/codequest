import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/phase1_theme.dart';

class StructureBackground extends StatelessWidget {
  final bool isAligned;
  const StructureBackground({super.key, this.isAligned = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          // Misaligned Grid
          Positioned.fill(
            child: CustomPaint(
              painter: _GridPainter(isAligned: isAligned),
            ),
          ),
          
          // Floating Data Cubes
          ...List.generate(15, (index) => _FloatingCube(index: index, isAligned: isAligned)),
          
          // Warning Beams
          if (!isAligned)
            ...List.generate(3, (index) => _WarningBeam(index: index)),
            
          // Scanlines
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.white.withValues(alpha: 0.02),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ).animate(onPlay: (c) => c.repeat()).moveY(begin: -500, end: 500, duration: 3.seconds),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final bool isAligned;
  _GridPainter({required this.isAligned});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isAligned ? Phase1Theme.cyanGlow.withValues(alpha: 0.1) : Phase1Theme.errorRed.withValues(alpha: 0.1)
      ..strokeWidth = 1.0;

    double spacing = 50.0;
    for (double i = 0; i < size.width; i += spacing) {
      double offset = isAligned ? 0 : math.sin(i) * 5;
      canvas.drawLine(Offset(i + offset, 0), Offset(i - offset, size.height), paint);
    }
    for (double i = 0; i < size.height; i += spacing) {
      double offset = isAligned ? 0 : math.cos(i) * 5;
      canvas.drawLine(Offset(0, i + offset), Offset(size.width, i - offset), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) => oldDelegate.isAligned != isAligned;
}

class _FloatingCube extends StatelessWidget {
  final int index;
  final bool isAligned;
  const _FloatingCube({required this.index, required this.isAligned});

  @override
  Widget build(BuildContext context) {
    final random = math.Random(index);
    final size = random.nextDouble() * 30 + 10;
    final startPos = Offset(random.nextDouble() * 400, random.nextDouble() * 800);
    
    return Positioned(
      left: startPos.dx,
      top: startPos.dy,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border.all(color: isAligned ? Phase1Theme.cyanGlow.withValues(alpha: 0.3) : Phase1Theme.purplish.withValues(alpha: 0.3)),
          color: (isAligned ? Phase1Theme.cyanGlow : Phase1Theme.purplish).withValues(alpha: 0.1),
        ),
      ).animate(onPlay: (c) => c.repeat(reverse: true))
       .moveY(begin: -20, end: 20, duration: (2 + random.nextDouble() * 2).seconds)
       .rotate(begin: 0, end: 0.5, duration: 5.seconds),
    );
  }
}

class _WarningBeam extends StatelessWidget {
  final int index;
  const _WarningBeam({required this.index});

  @override
  Widget build(BuildContext context) {
    final random = math.Random(index + 100);
    return Positioned(
      left: random.nextDouble() * 400,
      top: 0,
      bottom: 0,
      width: 2,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Phase1Theme.errorRed.withValues(alpha: 0.5),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
          color: Phase1Theme.errorRed.withValues(alpha: 0.3),
        ),
      ).animate(onPlay: (c) => c.repeat())
       .fade(begin: 0, end: 0.5, duration: 1.seconds)
       .then()
       .fade(begin: 0.5, end: 0, duration: 1.seconds),
    );
  }
}
