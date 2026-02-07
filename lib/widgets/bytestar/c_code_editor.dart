import 'package:flutter/material.dart';
import '../../utils/bytestar_theme.dart';

class CCodeEditor extends StatefulWidget {
  final String initialCode;
  final Function(String) onCodeChanged;
  final bool isReadOnly;

  const CCodeEditor({
    super.key,
    required this.initialCode,
    required this.onCodeChanged,
    this.isReadOnly = false,
  });

  @override
  State<CCodeEditor> createState() => _CCodeEditorState();
}

// Basic C Syntax Highlighting Controller
class SyntaxTextController extends TextEditingController {
  SyntaxTextController({super.text});

  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    final TextStyle effectiveStyle = style ?? const TextStyle(); // Handle null style
    final List<TextSpan> children = [];
    final pattern = RegExp(
      r'(//.*)|' // Comments
      r'(".*?")|' // Strings
      r'\b(int|float|double|char|void|return|if|else|for|while|do|switch|case|break|continue)\b|' // Keywords
      r'\b(true|false|NULL)\b|' // Literals
      r'([0-9]+)|' // Numbers
      r'([{}();,])' // Punctuation
    );


    
    // Simpler splitMapJoin implementation
    children.clear();
    text.splitMapJoin(
      pattern,
      onMatch: (Match match) {
        final String token = match.group(0)!;
        TextStyle? tokenStyle;

        if (token.startsWith('//')) {
           tokenStyle = effectiveStyle.copyWith(color: Colors.grey);
        } else if (token.startsWith('"')) {
           tokenStyle = effectiveStyle.copyWith(color: const Color(0xFFCE9178));
        } else if (RegExp(r'\b(int|float|double|char|void)\b').hasMatch(token)) {
           tokenStyle = effectiveStyle.copyWith(color: const Color(0xFF569CD6));
        } else if (RegExp(r'\b(return|if|else|for|while|do|switch|case|break|continue)\b').hasMatch(token)) {
           tokenStyle = effectiveStyle.copyWith(color: const Color(0xFFC586C0));
        } else if (RegExp(r'[0-9]+').hasMatch(token)) {
           tokenStyle = effectiveStyle.copyWith(color: const Color(0xFFB5CEA8));
        } else {
           tokenStyle = effectiveStyle.copyWith(color: Colors.white);
        }

        children.add(TextSpan(text: token, style: tokenStyle));
        return '';
      },
      onNonMatch: (String text) {
        children.add(TextSpan(text: text, style: effectiveStyle));
        return '';
      },
    );

    return TextSpan(style: effectiveStyle, children: children);
  }
}

class _CCodeEditorState extends State<CCodeEditor> {
  late SyntaxTextController _controller; // Updated type
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = SyntaxTextController(text: widget.initialCode);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
// ... rest of build method (stays mostly same, just ensuring TextField uses _controller)

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ByteStarTheme.primary.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ByteStarTheme.secondary,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Editor Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: ByteStarTheme.secondary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.code, color: ByteStarTheme.accent, size: 16),
                const SizedBox(width: 8),
                Text(
                  'main.c',
                  style: ByteStarTheme.code.copyWith(color: Colors.white70),
                ),
                const Spacer(),
                if (widget.isReadOnly)
                  const Icon(Icons.lock, color: Colors.grey, size: 16),
              ],
            ),
          ),
          
          // Editor Body
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Line Numbers
                Container(
                  width: 40,
                  padding: const EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                    color: ByteStarTheme.primary.withValues(alpha: 0.5),
                    border: const Border(
                      right: BorderSide(color: ByteStarTheme.secondary),
                    ),
                  ),
                  child: ListView.builder(
                    controller: _scrollController, // Sync scroll (simplified)
                    itemCount: 100, // Arbitrary max lines for now
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 2), // Match line height roughly
                        child: Text(
                          '${index + 1}',
                          textAlign: TextAlign.center,
                          style: ByteStarTheme.code.copyWith(
                            color: Colors.grey.withValues(alpha: 0.5),
                            fontSize: 14,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Text Field
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _controller,
                      onChanged: widget.onCodeChanged,
                      readOnly: widget.isReadOnly,
                      maxLines: null,
                      expands: true,
                      style: ByteStarTheme.code.copyWith(
                        color: Colors.white,
                        height: 1.5, // Line height
                      ),
                      cursorColor: ByteStarTheme.accent,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(top: 16, bottom: 16),
                      ),
                      // Basic syntax highlighting can be done with a custom TextEditingController
                      // For now, we use a simple text field
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
