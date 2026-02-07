import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/phase1_theme.dart';

class CalibrationBackground extends StatelessWidget {
  final bool isAutomated;
  const CalibrationBackground({super.key, this.isAutomated = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          // Grid
          Positioned.fill(
            child: GridPaper(
              color: (isAutomated ? Phase1Theme.successGreen : Phase1Theme.purplish).withValues(alpha: 0.1),
              interval: 100,
              divisions: 2,
              subdivisions: 2,
            ),
          ),
          
          // Robotic Arms (Simplified as lines/shapes)
          _RoboticArm(position: const Offset(50, 100), isActive: isAutomated),
          _RoboticArm(position: const Offset(350, 200), isActive: isAutomated, isReversed: true),
          
          // Scanning Circle
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: (isAutomated ? Phase1Theme.successGreen : Phase1Theme.purplish).withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
            ).animate(onPlay: (c) => c.repeat())
             .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2), duration: 2.seconds)
             .fade(begin: 0.1, end: 0.4, duration: 2.seconds),
          ),
          
          // Progress Bars
          if (isAutomated)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                children: List.generate(3, (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: LinearProgressIndicator(
                    value: 1.0,
                    backgroundColor: Colors.white10,
                    color: Phase1Theme.successGreen.withValues(alpha: 0.5),
                  ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 2.seconds),
                )),
              ),
            ),
        ],
      ),
    );
  }
}

class _RoboticArm extends StatelessWidget {
  final Offset position;
  final bool isActive;
  final bool isReversed;
  const _RoboticArm({required this.position, required this.isActive, this.isReversed = false});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Transform.scale(
        scaleX: isReversed ? -1 : 1,
        child: Container(
          width: 100,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Stack(
            children: [
              Positioned(
                right: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: (isActive ? Phase1Theme.successGreen : Phase1Theme.purplish).withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ).animate(onPlay: (c) => isActive ? c.repeat(reverse: true) : c.stop())
         .rotate(begin: -0.2, end: 0.2, duration: 1.seconds),
      ),
    );
  }
}
