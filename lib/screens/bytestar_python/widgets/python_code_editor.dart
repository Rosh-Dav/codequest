import 'package:flutter/material.dart';
import '../../../utils/python_bytestar_theme.dart';

class PythonCodeEditor extends StatefulWidget {
  const PythonCodeEditor({
    super.key,
    required this.controller,
    required this.focusNode,
    this.readOnly = false,
    required this.filename,
    this.initialCode = '',
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool readOnly;
  final String filename;
  final String initialCode;

  @override
  State<PythonCodeEditor> createState() => _PythonCodeEditorState();
}

class PythonSyntaxTextController extends TextEditingController {
  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    final List<TextSpan> children = [];
    final text = value.text;
    
    // Simple Python Regex for syntax highlighting
    // Matches: Comments, Strings, Keywords, Built-ins, Numbers, Operators
    final pattern = RegExp(
      r'(#.*)|' // Comments
      r'(".*?"|\047.*?\047)|' // Strings (double or single quotes)
      r'\b(def|class|if|elif|else|while|for|in|return|import|from|as|try|except|finally|with|pass|lambda|global|nonlocal|assert|del|yield|raise|break|continue|and|or|not|is|True|False|None)\b|' // Keywords
      r'\b(print|input|int|float|str|bool|type|len|range|list|dict|set|tuple)\b|' // Built-ins
      r'([0-9]+(\.[0-9]+)?)|' // Numbers
      r'(\+|\-|\*|/|%|=|==|!=|>|<|>=|<=)' // Operators
    );

    int currentIndex = 0;
    
    // Default style
    TextStyle effectiveStyle = style ?? const TextStyle(color: Colors.white);

    for (final match in pattern.allMatches(text)) {
      // Add text before the match
      if (match.start > currentIndex) {
        children.add(TextSpan(text: text.substring(currentIndex, match.start), style: effectiveStyle));
      }

      final String token = match.group(0)!;
      TextStyle tokenStyle = effectiveStyle;

      if (token.startsWith('#')) {
        // Comment - Grey
        tokenStyle = effectiveStyle.copyWith(color: Colors.grey);
      } else if (token.startsWith('"') || token.startsWith("'")) {
        // String - Yellow/Gold
        tokenStyle = effectiveStyle.copyWith(color: Colors.amber);
      } else if (RegExp(r'\b(def|class|if|elif|else|while|for|in|return|import|from|as|try|except)\b').hasMatch(token)) {
        // Keywords - Purple
        tokenStyle = effectiveStyle.copyWith(color: PythonByteStarTheme.accent);
      } else if (RegExp(r'\b(True|False|None)\b').hasMatch(token)) {
        // Booleans - Cyan
        tokenStyle = effectiveStyle.copyWith(color: PythonByteStarTheme.primary);
      } else if (RegExp(r'\b(print|input|int|float|str|bool|type|len|range)\b').hasMatch(token)) {
        // Built-ins - Green or Cyan
        tokenStyle = effectiveStyle.copyWith(color: PythonByteStarTheme.success);
      } else if (RegExp(r'[0-9]').hasMatch(token)) {
        // Numbers - Green
        tokenStyle = effectiveStyle.copyWith(color: PythonByteStarTheme.success);
      } else if (RegExp(r'[+\-*/%=<>]').hasMatch(token)) {
         // Operators - Pink/Accent
         tokenStyle = effectiveStyle.copyWith(color: PythonByteStarTheme.accent);
      } else {
        // Default (Variables) - Cyan (Primary)
         tokenStyle = effectiveStyle.copyWith(color: PythonByteStarTheme.primary);
      }

      children.add(TextSpan(text: token, style: tokenStyle));
      currentIndex = match.end;
    }

    // Add remaining text
    if (currentIndex < text.length) {
      children.add(TextSpan(text: text.substring(currentIndex), style: effectiveStyle));
    }

    return TextSpan(style: effectiveStyle, children: children);
  }
}

class _PythonCodeEditorState extends State<PythonCodeEditor> {
  late final ScrollController _scrollController;
  
  // Create line numbers logic
  String _getLineNumbers(String code) {
    int lines = code.split('\n').length;
    if (lines == 0) lines = 1;
    return List.generate(lines, (index) => (index + 1).toString()).join('\n');
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    if (widget.initialCode.isNotEmpty && widget.controller.text.isEmpty) {
      widget.controller.text = widget.initialCode;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F111A), // Darker editor bg
        border: Border.all(color: PythonByteStarTheme.primary.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: PythonByteStarTheme.secondary,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7)),
              border: Border(bottom: BorderSide(color: PythonByteStarTheme.primary.withOpacity(0.2))),
            ),
            child: Row(
              children: [
                const Icon(Icons.code, color: PythonByteStarTheme.primary, size: 16),
                const SizedBox(width: 8),
                Text(widget.filename, style: const TextStyle(color: Colors.white70, fontFamily: 'Fira Code', fontSize: 12)),
                const Spacer(),
                if (widget.readOnly) const Icon(Icons.lock, color: Colors.grey, size: 14),
              ],
            ),
          ),
          
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Line Numbers
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  width: 40,
                  color: Colors.black.withOpacity(0.3),
                  child: AnimatedBuilder(
                    animation: widget.controller,
                    builder: (context, _) => Text(
                      _getLineNumbers(widget.controller.text),
                      style: TextStyle(
                        fontFamily: 'Fira Code',
                        color: Colors.grey.withOpacity(0.5),
                        fontSize: 14,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
                
                // Vertical Divider
                Container(width: 1, color: Colors.grey.withOpacity(0.1)),
                
                // Editor
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: TextField(
                        controller: widget.controller,
                        focusNode: widget.focusNode,
                        readOnly: widget.readOnly,
                        maxLines: null,
                        style: const TextStyle(
                          fontFamily: 'Fira Code',
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.5,
                        ),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        cursorColor: PythonByteStarTheme.primary,
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
