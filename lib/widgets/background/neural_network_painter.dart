import 'dart:math';
import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class NeuralNetworkPainter extends CustomPainter {
  final List<NeuralNode> nodes;
  final double animationValue;

  NeuralNetworkPainter({required this.nodes, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint nodePaint = Paint()
      ..color = AppTheme.neonBlue.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;

    final Paint linePaint = Paint()
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    // Draw connections first (behind nodes)
    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        final nodeA = nodes[i];
        final nodeB = nodes[j];
        
        // Calculate distance
        final double dx = (nodeA.x - nodeB.x) * size.width;
        final double dy = (nodeA.y - nodeB.y) * size.height;
        final double distance = sqrt(dx * dx + dy * dy);
        
        // Connect if close enough
        if (distance < 120) {
          final double opacity = (1.0 - (distance / 120)) * 0.5 * nodeA.opacity * nodeB.opacity;
          if (opacity > 0) {
            linePaint.color = AppTheme.neonBlue.withValues(alpha: opacity);
            canvas.drawLine(
              Offset(nodeA.x * size.width, nodeA.y * size.height),
              Offset(nodeB.x * size.width, nodeB.y * size.height),
              linePaint,
            );
          }
        }
      }
    }

    // Draw nodes
    for (var node in nodes) {
      double pulse = sin(animationValue * 2 * pi + node.pulseOffset) * 0.5 + 0.5;
      double currentSize = node.baseSize + (pulse * 1.5); // Subtle pulsing size
      
      nodePaint.color = (node.isGold ? AppTheme.knowledgeGold : AppTheme.neonBlue).withValues(alpha: node.opacity);
        
      canvas.drawCircle(
        Offset(node.x * size.width, node.y * size.height),
        currentSize,
        nodePaint,
      );
      
      // Draw a "glow" halo around gold nodes
      if (node.isGold) {
        final Paint glowPaint = Paint()
            ..color = AppTheme.knowledgeGold.withValues(alpha: 0.2 * pulse)
            ..style = PaintingStyle.fill;
        canvas.drawCircle(
            Offset(node.x * size.width, node.y * size.height),
            currentSize * 3,
            glowPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant NeuralNetworkPainter oldDelegate) {
    return true; // Always repaint for animation
  }
}

class NeuralNode {
  double x;
  double y;
  double vx;
  double vy;
  double baseSize;
  double opacity;
  double pulseOffset;
  bool isGold;

  NeuralNode({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    this.baseSize = 2.0,
    this.opacity = 1.0,
    this.pulseOffset = 0.0,
    this.isGold = false,
  });
}
