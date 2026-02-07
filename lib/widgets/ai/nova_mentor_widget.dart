import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../../utils/theme.dart';

class NovaMentorWidget extends StatelessWidget {
  final String dialogue;
  final bool showTypingAnimation;
  final VoidCallback? onComplete;

  const NovaMentorWidget({
    super.key,
    required this.dialogue,
    this.showTypingAnimation = true,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.idePanel.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.syntaxBlue.withValues(alpha: 0.6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.syntaxBlue.withValues(alpha: 0.2),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.syntaxBlue.withValues(alpha: 0.2),
              border: Border.all(color: AppTheme.syntaxBlue, width: 1.2),
            ),
            child: const Icon(Icons.auto_awesome, color: AppTheme.syntaxBlue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: showTypingAnimation
                ? AnimatedTextKit(
                    isRepeatingAnimation: false,
                    totalRepeatCount: 1,
                    onFinished: onComplete,
                    animatedTexts: [
                      TyperAnimatedText(
                        dialogue,
                        textStyle: AppTheme.bodyStyle.copyWith(
                          color: Colors.white,
                          height: 1.4,
                        ),
                        speed: const Duration(milliseconds: 30),
                      ),
                    ],
                  )
                : Text(
                    dialogue,
                    style: AppTheme.bodyStyle.copyWith(
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}