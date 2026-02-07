import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/phase1_theme.dart';

class OrbWidget extends StatefulWidget {
  final bool isStable;
  final double size;

  const OrbWidget({
    super.key,
    required this.isStable,
    this.size = 200,
  });

  @override
  State<OrbWidget> createState() => _OrbWidgetState();
}

class _OrbWidgetState extends State<OrbWidget> {
  @override
  Widget build(BuildContext context) {
    final color = widget.isStable ? Phase1Theme.cyanGlow : Phase1Theme.errorRed;
    
    return Container(
      width: widget.size,
      height: widget.size,
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Core Glow (Pulsing)
          Container(
            width: widget.size * 0.6,
            height: widget.size * 0.6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.5),
              boxShadow: [
                BoxShadow(color: color, blurRadius: 40, spreadRadius: 10),
              ],
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
           .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), duration: 1.seconds),

          // Outer Rings (Spinning)
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
            ),
          ).animate(onPlay: (c) => c.repeat())
           .rotate(duration: widget.isStable ? 4.seconds : 1.seconds), // Spin faster if unstable

          Container(
            width: widget.size * 0.8,
            height: widget.size * 0.8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.5), width: 4),
            ),
          ).animate(onPlay: (c) => c.repeat())
           .rotate(duration: widget.isStable ? 6.seconds : 2.seconds, begin: 0, end: -1), // Reverse spin
           
          // Particles (Sparks) - Simplified as small random dots
          // For high performance, we use a simple representation
          if (!widget.isStable)
             ...List.generate(5, (index) {
               return Positioned(
                 left: widget.size / 2,
                 top: widget.size / 2,
                 child: Container(
                   width: 4,
                   height: 4,
                   decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                 ).animate(onPlay: (c) => c.repeat()).move(
                   begin: const Offset(0, 0),
                   end: Offset((index % 2 == 0 ? 50 : -50).toDouble(), (index % 3 == 0 ? 50 : -50).toDouble()),
                   duration: 500.ms,
                 ).fadeOut(duration: 500.ms),
               );
             }),

          // Text Overlay if Unstable
          if (!widget.isStable)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                border: Border.all(color: Phase1Theme.errorRed),
              ),
              child: Text(
                "ENERGY UNASSIGNED",
                style: Phase1Theme.alertFont.copyWith(fontSize: 10),
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true)).fade(),
        ],
      ),
    );
  }
}
