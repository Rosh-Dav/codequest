import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/theme.dart';

class AIMentorWidget extends StatefulWidget {
  final String storyMode;
  final String greeting;
  final bool showWaveform;

  const AIMentorWidget({
    super.key,
    required this.storyMode,
    required this.greeting,
    this.showWaveform = false,
  });

  @override
  State<AIMentorWidget> createState() => _AIMentorWidgetState();
}

class _AIMentorWidgetState extends State<AIMentorWidget> with SingleTickerProviderStateMixin {
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  Color get _mentorColor {
    return widget.storyMode == 'Rune City Quest'
        ? AppTheme.syntaxBlue
        : AppTheme.syntaxYellow;
  }

  IconData get _mentorIcon {
    return widget.storyMode == 'Rune City Quest'
        ? Icons.school
        : Icons.emoji_events;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Mentor Avatar
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                _mentorColor.withValues(alpha: 0.3),
                _mentorColor.withValues(alpha: 0.1),
              ],
            ),
            border: Border.all(
              color: _mentorColor,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: _mentorColor.withValues(alpha: 0.5),
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Icon(
            _mentorIcon,
            size: 70,
            color: _mentorColor,
          ),
        ).animate()
          .scale(
            begin: const Offset(0, 0),
            end: const Offset(1, 1),
            duration: 800.ms,
            curve: Curves.elasticOut,
          )
          .then()
          .shimmer(duration: 2.seconds, color: Colors.white24)
          .animate(onPlay: (c) => c.repeat())
          .boxShadow(
            begin: BoxShadow(
              color: _mentorColor.withValues(alpha: 0.3),
              blurRadius: 20,
            ),
            end: BoxShadow(
              color: _mentorColor.withValues(alpha: 0.6),
              blurRadius: 40,
            ),
            duration: 2.seconds,
          ),

        const SizedBox(height: 32),

        // Greeting Bubble
        Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.idePanel.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _mentorColor, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                widget.greeting,
                style: AppTheme.bodyStyle.copyWith(
                  fontSize: 16,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),

              if (widget.showWaveform) ...[
                const SizedBox(height: 16),
                // Voice Waveform
                AnimatedBuilder(
                  animation: _waveController,
                  builder: (context, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final height = 20 +
                            (30 *
                                (0.5 +
                                    0.5 *
                                        (index % 2 == 0
                                            ? _waveController.value
                                            : 1 - _waveController.value)));
                        return Container(
                          width: 4,
                          height: height,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            color: _mentorColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ],
            ],
          ),
        ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.3, end: 0),
      ],
    );
  }
}
