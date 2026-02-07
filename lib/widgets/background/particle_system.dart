import 'dart:math';
import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class ParticleSystem extends StatefulWidget {
  final int numberOfParticles;

  const ParticleSystem({super.key, this.numberOfParticles = 75});

  @override
  State<ParticleSystem> createState() => _ParticleSystemState();
}

class _ParticleSystemState extends State<ParticleSystem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(seconds: 10))
      ..repeat();

    _particles = List.generate(
      widget.numberOfParticles,
      (index) => Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        speed: _random.nextDouble() * 0.4 + 0.1, // Faster upward movement
        size: _random.nextDouble() * 2 + 0.5, // Smaller, sharper
        opacity: _random.nextDouble() * 0.6 + 0.1,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(_particles, _controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class Particle {
  double x;
  double y;
  double speed;
  double size;
  double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.opacity,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;

    for (var particle in particles) {
      // Move particle upwards consistently
      double y = particle.y - (particle.speed * 0.01);
      if (y < 0) {
        y = 1.0;
        particle.x = Random().nextDouble();
      }
      particle.y = y;

      // Color variation
      paint.color = (Random().nextBool() ? AppTheme.neonBlue : AppTheme.electricCyan)
          .withValues(alpha: particle.opacity);

      // Draw as small squares for "digital" feel
      canvas.drawRect(
        Rect.fromCenter(
            center: Offset(particle.x * size.width, particle.y * size.height),
            width: particle.size,
            height: particle.size * 3), // Elongated spark
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) {
    return true;
  }
}
