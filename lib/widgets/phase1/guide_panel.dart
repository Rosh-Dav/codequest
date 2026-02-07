import 'package:flutter/material.dart';
import '../../utils/phase1_theme.dart';

class GuidePanel extends StatelessWidget {
  final String title;
  final String content;
  final String? hint;

  const GuidePanel({
    super.key,
    required this.title,
    required this.content,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Phase1Theme.glassPanel,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Phase1Theme.sciFiFont.copyWith(fontSize: 16, color: Phase1Theme.purpleGlow),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content,
                    style: Phase1Theme.dialogueFont.copyWith(fontSize: 14),
                  ),
                  if (hint != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.yellow.withValues(alpha: 0.1),
                        border: Border.all(color: Colors.yellow),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.lightbulb, color: Colors.yellow, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              hint!,
                              style: Phase1Theme.dialogueFont.copyWith(color: Colors.yellow),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
