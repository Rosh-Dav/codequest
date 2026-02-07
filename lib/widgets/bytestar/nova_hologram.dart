import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/bytestar_theme.dart';

class NovaHologram extends StatefulWidget {
  final double size;
  final bool isTalking;

  const NovaHologram({
    super.key,
    this.size = 120,
    this.isTalking = false,
  });

  @override
  State<NovaHologram> createState() => _NovaHologramState();
}

class _NovaHologramState extends State<NovaHologram> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Holographic Base Glow
          Container(
            width: widget.size * 0.8,
            height: widget.size * 0.8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ByteStarTheme.accent.withValues(alpha: 0.1),
              boxShadow: [
                BoxShadow(
                  color: ByteStarTheme.accent.withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                begin: const Offset(0.9, 0.9),
                end: const Offset(1.1, 1.1),
                duration: 2.seconds,
              ),

          // Scanlines Effect
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      ByteStarTheme.accent.withValues(alpha: 0.2),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                    transform: GradientRotation(_controller.value * 6.28),
                  ).createShader(bounds);
                },
                child: child,
              );
            },
            child: Icon(
              Icons.face_retouching_natural, // Female AI face
              size: widget.size * 0.6,
              color: ByteStarTheme.accent.withValues(alpha: 0.8),
            ),
          ),

          // Rotating Rings
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: ByteStarTheme.highlight.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
          ).animate(onPlay: (c) => c.repeat()).rotate(duration: 10.seconds),

          Container(
            width: widget.size * 0.9,
            height: widget.size * 0.9,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: ByteStarTheme.accent.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).rotate(duration: 8.seconds),
          
          // Voice Waveform (if talking)
          if (widget.isTalking)
            Positioned(
              bottom: 0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    width: 4,
                    height: 12,
                    decoration: BoxDecoration(
                      color: ByteStarTheme.accent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scaleY(
                        begin: 0.5,
                        end: 1.5,
                        duration: (300 + index * 100).ms,
                      );
                }),
              ),
            ),
        ],
      ),
    );
  }
}
