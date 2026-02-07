import 'dart:math';
import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class FloatingSymbolsPainter extends CustomPainter {
  final List<FloatingSymbol> symbols;
  final double animationValue;

  FloatingSymbolsPainter({required this.symbols, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    for (var symbol in symbols) {
      final double yOffset = sin(animationValue * 2 * pi + symbol.xAxisOffset) * 10;
      final double xOffset = cos(animationValue * pi + symbol.yAxisOffset) * 5;

      final p = Offset(
        (symbol.x * size.width) + xOffset,
        (symbol.y * size.height) + yOffset,
      );

      final textSpan = TextSpan(
        text: symbol.char,
        style: TextStyle(
          color: (symbol.isMath ? AppTheme.knowledgeGold : AppTheme.syntaxGreen)
              .withValues(alpha: symbol.opacity * 0.4), // Low opacity for subtlety
          fontSize: symbol.size,
          fontFamily: symbol.isMath ? 'Times New Roman' : 'Roboto Mono',
          fontWeight: symbol.isMath ? FontWeight.bold : FontWeight.normal,
        ),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(canvas, p);
    }
  }

  @override
  bool shouldRepaint(covariant FloatingSymbolsPainter oldDelegate) {
    return true;
  }
}

class FloatingSymbol {
  double x;
  double y;
  double size;
  double opacity;
  String char;
  bool isMath;
  double xAxisOffset;
  double yAxisOffset;

  FloatingSymbol({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.char,
    required this.isMath,
    required this.xAxisOffset,
    required this.yAxisOffset,
  });
}
