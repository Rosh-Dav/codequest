import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../utils/python_bytestar_theme.dart';
import '../../../models/bytestar_python_data.dart';

class PythonTeachingPanel extends StatefulWidget {
  final PythonTeachingModule module;
  final int activeStepIndex;

  const PythonTeachingPanel({
    super.key, 
    required this.module,
    this.activeStepIndex = -1,
  });

  @override
  State<PythonTeachingPanel> createState() => _PythonTeachingPanelState();
}

class _PythonTeachingPanelState extends State<PythonTeachingPanel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: PythonByteStarTheme.glassDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(Icons.school, color: PythonByteStarTheme.accent, size: 20),
              const SizedBox(width: 8),
              Text('TRAINING PROTOCOL', style: PythonByteStarTheme.heading.copyWith(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),

          // Code Snippet - The "Board"
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: PythonByteStarTheme.primary.withOpacity(0.3)),
            ),
            child: Text(
              widget.module.codeSnippet,
              style: PythonByteStarTheme.terminal.copyWith(fontSize: 14),
            ),
          ),
          
          const SizedBox(height: 12),

          // Steps list
          Expanded(
            child: ListView.separated(
              itemCount: widget.module.steps.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final step = widget.module.steps[index];
                return _buildStep(step, index)
                    .animate()
                    .fadeIn(delay: (300 * index).ms)
                    .slideX(begin: 0.1, end: 0);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(PythonTeachingStep step, int index) {
    final isActive = index == widget.activeStepIndex;
    final isPast = index < widget.activeStepIndex;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isActive 
            ? PythonByteStarTheme.accent.withOpacity(0.2) 
            : PythonByteStarTheme.secondary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive 
              ? PythonByteStarTheme.accent 
              : (step.focusElement != null ? PythonByteStarTheme.accent.withOpacity(0.3) : Colors.transparent),
          width: isActive ? 2 : 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.arrow_right, color: PythonByteStarTheme.success.withOpacity(0.7), size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.explanation,
                  style: PythonByteStarTheme.body.copyWith(fontSize: 14, color: Colors.white70),
                ),
                if (step.focusElement != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      'Focus: ${step.focusElement}',
                      style: const TextStyle(
                        fontFamily: 'Fira Code',
                        color: PythonByteStarTheme.accent,
                        fontSize: 12,
                      ),
                    ).animate(onPlay: (c) => c.repeat(reverse: true))
                     .shimmer(duration: 2.seconds, color: PythonByteStarTheme.accent.withOpacity(0.2)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
