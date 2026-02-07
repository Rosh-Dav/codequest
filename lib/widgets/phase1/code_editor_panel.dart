import 'package:flutter/material.dart';
import '../../utils/phase1_theme.dart';

class CodeEditorPanel extends StatelessWidget {
  final TextEditingController controller;
  final bool isError;
  final VoidCallback? onChanged;

  const CodeEditorPanel({
    super.key,
    required this.controller,
    this.isError = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.8),
        border: Border.all(
          color: isError ? Phase1Theme.errorRed : Phase1Theme.cyanGlow.withValues(alpha: 0.3),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: isError 
          ? [BoxShadow(color: Phase1Theme.errorRed.withValues(alpha: 0.5), blurRadius: 20)]
          : [],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
         Row(
           children: [
             Icon(Icons.terminal, color: Phase1Theme.cyanGlow, size: 16),
             const SizedBox(width: 8),
             Text(
               "MAIN TERMINAL",
               style: Phase1Theme.sciFiFont.copyWith(fontSize: 12, color: Phase1Theme.cyanGlow),
             ),
           ],
         ),
         const Divider(color: Colors.white24),
         Expanded(
           child: TextField(
             controller: controller,
             style: Phase1Theme.codeFont.copyWith(color: Colors.white),
             decoration: const InputDecoration(
               border: InputBorder.none,
               hintText: 'Type your code here...',
               hintStyle: TextStyle(color: Colors.white24),
             ),
             maxLines: null,
             cursorColor: Phase1Theme.cyanGlow,
             onChanged: (_) => onChanged?.call(),
           ),
         ),
        ],
      ),
    );
  }
}
