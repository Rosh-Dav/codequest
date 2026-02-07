import 'dart:math';
import 'package:flutter/material.dart';
import '../../utils/theme.dart';
import 'neural_network_painter.dart';
import 'floating_symbols_painter.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  final List<NeuralNode> _nodes = [];
  final List<FloatingSymbol> _symbols = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(seconds: 20))
      ..repeat();

    _initNodes();
    _initSymbols();
  }

  void _initNodes() {
    for (int i = 0; i < 40; i++) {
      _nodes.add(NeuralNode(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        vx: (_random.nextDouble() - 0.5) * 0.0005,
        vy: (_random.nextDouble() - 0.5) * 0.0005,
        baseSize: _random.nextDouble() * 3 + 1,
        opacity: _random.nextDouble() * 0.5 + 0.3,
        pulseOffset: _random.nextDouble() * 2 * pi,
        isGold: _random.nextDouble() > 0.9, // 10% chance to be gold
      ));
    }
  }

  void _initSymbols() {
    final List<String> codeChars = ['{ }', '</>', 'var', 'int', 'void', '[]', '01'];
    final List<String> mathChars = ['∫', '∑', 'π', 'f(x)', '√', '∞'];

    for (int i = 0; i < 15; i++) {
      bool isMath = _random.nextBool();
      
      _symbols.add(FloatingSymbol(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 10 + 10,
        opacity: _random.nextDouble() * 0.3 + 0.1,
        char: isMath 
            ? mathChars[_random.nextInt(mathChars.length)]
            : codeChars[_random.nextInt(codeChars.length)],
        isMath: isMath,
        xAxisOffset: _random.nextDouble() * 2 * pi,
        yAxisOffset: _random.nextDouble() * 2 * pi,
      ));
    }
  }

  void _updatePositions() {
    for (var node in _nodes) {
      node.x += node.vx;
      node.y += node.vy;

      // Bounce off edges
      if (node.x < 0 || node.x > 1) node.vx *= -1;
      if (node.y < 0 || node.y > 1) node.vy *= -1;
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Deep Academic Blue Background
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.5,
              colors: [
                AppTheme.academicBlue,
                AppTheme.deepNavy,
                Colors.black,
              ],
            ),
          ),
        ),

        // 2. Animated Neural Network
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              _updatePositions();
              return CustomPaint(
                painter: NeuralNetworkPainter(
                  nodes: _nodes,
                  animationValue: _animController.value,
                ),
              );
            },
          ),
        ),

        // 3. Floating Symbols
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              return CustomPaint(
                painter: FloatingSymbolsPainter(
                  symbols: _symbols,
                  animationValue: _animController.value,
                ),
              );
            },
          ),
        ),
        
        // 4. Subtle Overlay for text readability
        Container(
          color: Colors.black.withValues(alpha: 0.1),
        ),
      ],
    );
  }
}
