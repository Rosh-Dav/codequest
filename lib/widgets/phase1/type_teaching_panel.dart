import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/phase1_theme.dart';

class TypeTeachingPanel extends StatefulWidget {
  final int step; // 0..4 (Intro, Int, Float, Str, Bool)
  
  const TypeTeachingPanel({super.key, required this.step});

  @override
  State<TypeTeachingPanel> createState() => _TypeTeachingPanelState();
}

class _TypeTeachingPanelState extends State<TypeTeachingPanel> {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Phase1Theme.purpleGlow.withValues(alpha: 0.5)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.data_object, color: Phase1Theme.purpleGlow, size: 20),
              const SizedBox(width: 8),
              Text("DATA SCANNER", style: Phase1Theme.sciFiFont.copyWith(color: Phase1Theme.purpleGlow)),
            ],
          ),
          const Divider(color: Colors.white24),
          
          Expanded(
            child: ListView(
              children: [
                 _buildCodeRow("count = 10", "int", Colors.green, widget.step >= 1),
                 _buildCodeRow("temp = 36.5", "float", Colors.lightBlue, widget.step >= 2),
                 _buildCodeRow("name = \"Astra\"", "str", Colors.yellow, widget.step >= 3),
                 _buildCodeRow("ready = True", "bool", Colors.pinkAccent, widget.step >= 4),
                 
                 const SizedBox(height: 16),
                 
                 // Type Check Demo
                 if (widget.step > 0)
                   Container(
                     padding: const EdgeInsets.all(8),
                     decoration: BoxDecoration(
                       color: Colors.black,
                       border: Border.all(color: Colors.white24),
                       borderRadius: BorderRadius.circular(4),
                     ),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(">>> TYPE CHECK", style: Phase1Theme.codeFont.copyWith(color: Colors.grey)),
                         const SizedBox(height: 4),
                         if (widget.step >= 1) _buildConsoleOutput("type(count)", "<class 'int'>", Colors.green),
                         if (widget.step >= 2) _buildConsoleOutput("type(temp)", "<class 'float'>", Colors.lightBlue),
                         if (widget.step >= 3) _buildConsoleOutput("type(name)", "<class 'str'>", Colors.yellow),
                         if (widget.step >= 4) _buildConsoleOutput("type(ready)", "<class 'bool'>", Colors.pinkAccent),
                       ],
                     ),
                   ).animate().fadeIn(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeRow(String code, String type, Color color, bool isVisible) {
    if (!isVisible) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(code, style: Phase1Theme.codeFont.copyWith(color: Colors.white)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(type, style: Phase1Theme.codeFont.copyWith(color: color, fontSize: 10)),
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: 0.1, end: 0);
  }

  Widget _buildConsoleOutput(String input, String output, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Text(input, style: Phase1Theme.codeFont.copyWith(color: Colors.white70, fontSize: 11)),
          const SizedBox(width: 8),
          Icon(Icons.arrow_right_alt, color: Colors.grey, size: 12),
          const SizedBox(width: 8),
          Text(output, style: Phase1Theme.codeFont.copyWith(color: color, fontSize: 11)),
        ],
      ),
    ).animate().fadeIn();
  }
}
