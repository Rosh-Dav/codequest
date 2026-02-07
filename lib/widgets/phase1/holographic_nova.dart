import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../../utils/phase1_theme.dart';

class HolographicNova extends StatelessWidget {
  final String dialogue;
  final bool isTyping;
  final VoidCallback? onTypingFinished;

  const HolographicNova({
    super.key,
    required this.dialogue,
    this.isTyping = true,
    this.onTypingFinished,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: Phase1Theme.glassPanel,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Phase1Theme.cyanGlow, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Phase1Theme.cyanGlow.withValues(alpha: 0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(Icons.psychology, color: Colors.white, size: 30),
          )
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: 2.seconds, color: Phase1Theme.purpleGlow)
              .then()
              .shake(hz: 0.5),

          const SizedBox(width: 16),

          // Dialogue Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "NOVA <AI_CORE>",
                  style: Phase1Theme.sciFiFont.copyWith(fontSize: 12),
                ).animate().fadeIn(),
                const SizedBox(height: 8),
                if (isTyping)
                  AnimatedTextKit(
                    key: ValueKey(dialogue), // Force rebuild when text changes
                    animatedTexts: [
                      TypewriterAnimatedText(
                        dialogue,
                        textStyle: Phase1Theme.dialogueFont,
                        speed: const Duration(milliseconds: 50),
                        cursor: '_',
                      ),
                    ],
                    totalRepeatCount: 1,
                    onFinished: onTypingFinished,
                    displayFullTextOnTap: true,
                  )
                else
                  Text(
                    dialogue,
                    style: Phase1Theme.dialogueFont,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
