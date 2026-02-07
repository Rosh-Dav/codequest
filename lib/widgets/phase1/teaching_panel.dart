import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/phase1_theme.dart';

class TeachingPanel extends StatefulWidget {
  final int step; // Controls which part is highlighted
  
  const TeachingPanel({super.key, required this.step});

  @override
  State<TeachingPanel> createState() => _TeachingPanelState();
}

class _TeachingPanelState extends State<TeachingPanel> {
  @override
  Widget build(BuildContext context) {
    // Code: power = 80
    // Step 0: Show code, no highlight
    // Step 1: Highlight 'power'
    // Step 2: Highlight '='
    // Step 3: Highlight '80'
    // Step 4: Show mini-demo
    
    return Container(
      decoration: Phase1Theme.glassPanel,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "CONCEPT: VARIABLES",
            style: Phase1Theme.sciFiFont.copyWith(fontSize: 16, color: Phase1Theme.cyanGlow),
          ),
          const SizedBox(height: 16),
          
          // Main Code Display
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white12),
            ),
            child: Center(
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.firaCode(fontSize: 24, color: Colors.white),
                  children: [
                    _buildSpan("power", 1, Phase1Theme.cyanGlow),
                    const TextSpan(text: " "),
                    _buildSpan("=", 2, Phase1Theme.purpleGlow),
                     const TextSpan(text: " "),
                    _buildSpan("80", 3, Phase1Theme.successGreen),
                  ],
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Explanation Area (Dynamic based on step)
          Expanded(
            child: AnimatedSwitcher(
              duration: 300.ms,
              child: _buildExplanation(),
            ),
          ),
          
          if (widget.step >= 4)
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white24),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("PREVIEW:", style: GoogleFonts.firaCode(fontSize: 10, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text("print(power)", style: GoogleFonts.firaCode(fontSize: 12, color: Colors.white)),
                      const Spacer(),
                      const Icon(Icons.arrow_right_alt, color: Colors.grey, size: 16),
                      const SizedBox(width: 8),
                      Text("80", style: GoogleFonts.firaCode(fontSize: 12, color: Phase1Theme.successGreen)),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(),
        ],
      ),
    );
  }

  TextSpan _buildSpan(String text, int targetStep, Color highlightColor) {
    final isHighlighted = widget.step == targetStep;
    return TextSpan(
      text: text,
      style: TextStyle(
        color: isHighlighted ? highlightColor : Colors.white.withValues(alpha: widget.step > 0 && widget.step < 4 ? 0.3 : 1.0),
        fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
        shadows: isHighlighted ? [Shadow(color: highlightColor, blurRadius: 10)] : [],
      ),
    );
  }

  Widget _buildExplanation() {
    String text = "";
    switch (widget.step) {
      case 1:
        text = "'power' is the variable name.\nIt acts as a container.";
        break;
      case 2:
        text = "'=' is the assignment operator.\nIt puts value into the container.";
        break;
      case 3:
        text = "'80' is the value stored inside.";
        break;
      default:
        text = "Variables store data for later use.";
    }
    
    return Container(
      key: ValueKey(widget.step),
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Phase1Theme.cyanGlow.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: Phase1Theme.dialogueFont.copyWith(fontSize: 14),
        textAlign: TextAlign.center,
      ),
    );
  }
}
