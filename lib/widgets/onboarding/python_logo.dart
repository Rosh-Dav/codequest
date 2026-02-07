import 'package:flutter/material.dart';

class PythonLogo extends StatelessWidget {
  final double size;

  const PythonLogo({super.key, this.size = 80});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: PythonLogoPainter(),
      ),
    );
  }
}

class PythonLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Python official colors
    final Paint bluePaint = Paint()
      ..color = const Color(0xFF3776AB)
      ..style = PaintingStyle.fill;

    final Paint yellowPaint = Paint()
      ..color = const Color(0xFFFFD43B)
      ..style = PaintingStyle.fill;

    final Paint whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Build two interlocking rounded shapes (closer to official mark)
    final double r = w * 0.18;
    final double inset = w * 0.08;
    final Rect topRect = Rect.fromLTWH(
      inset,
      inset,
      w - inset * 1.8,
      h * 0.48,
    );
    final Rect bottomRect = Rect.fromLTWH(
      inset * 1.2,
      h * 0.44,
      w - inset * 1.8,
      h * 0.48,
    );

    // Top blue "snake"
    final RRect topRRect = RRect.fromRectAndRadius(topRect, Radius.circular(r));
    final Path topPath = Path()..addRRect(topRRect);
    // Carve out inner notch (bottom-right)
    final Rect topNotch = Rect.fromLTWH(w * 0.55, h * 0.30, w * 0.28, h * 0.22);
    final Path topNotchPath = Path()
      ..addRRect(RRect.fromRectAndRadius(topNotch, Radius.circular(w * 0.08)));
    canvas.drawPath(
      Path.combine(PathOperation.difference, topPath, topNotchPath),
      bluePaint,
    );

    // Bottom yellow "snake"
    final RRect bottomRRect =
        RRect.fromRectAndRadius(bottomRect, Radius.circular(r));
    final Path bottomPath = Path()..addRRect(bottomRRect);
    // Carve out inner notch (top-left)
    final Rect bottomNotch = Rect.fromLTWH(w * 0.18, h * 0.48, w * 0.28, h * 0.22);
    final Path bottomNotchPath = Path()
      ..addRRect(RRect.fromRectAndRadius(bottomNotch, Radius.circular(w * 0.08)));
    canvas.drawPath(
      Path.combine(PathOperation.difference, bottomPath, bottomNotchPath),
      yellowPaint,
    );

    // Eyes (white dots)
    canvas.drawCircle(Offset(w * 0.30, h * 0.28), w * 0.04, whitePaint);
    canvas.drawCircle(Offset(w * 0.70, h * 0.72), w * 0.04, whitePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
