import 'package:flutter/material.dart';
import '../../models/bytestar_data.dart';
import 'space_backgrounds.dart';

class AnimatedSpaceBackground extends StatefulWidget {
  final SceneType sceneType;
  final Widget child;

  const AnimatedSpaceBackground({
    super.key,
    required this.sceneType,
    required this.child,
  });

  @override
  State<AnimatedSpaceBackground> createState() => _AnimatedSpaceBackgroundState();
}

class _AnimatedSpaceBackgroundState extends State<AnimatedSpaceBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // A slow, looping 10-second animation for atmospheric effects
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. The Animated Background Painter
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: _getPainterForScene(widget.sceneType, _controller.value),
              );
            },
          ),
        ),
        
        // 2. The Content
        widget.child,
      ],
    );
  }

  CustomPainter _getPainterForScene(SceneType type, double animationValue) {
    switch (type) {
      case SceneType.darkSpaceship:
        return DarkSpaceshipPainter(animationValue: animationValue);
      case SceneType.engineRoom:
        return EngineRoomPainter(animationValue: animationValue);
      case SceneType.deepSpace:
      default:
        return DeepSpacePainter(animationValue: animationValue);
    }
  }
}
