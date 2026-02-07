import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class NeonInput extends StatefulWidget {
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final TextEditingController? controller;

  const NeonInput({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.controller,
  });

  @override
  State<NeonInput> createState() => _NeonInputState();
}

class _NeonInputState extends State<NeonInput> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.ideBackground.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isFocused 
            ? AppTheme.accentColor 
            : AppTheme.glassBorder,
          width: _isFocused ? 2 : 1,
        ),
      ),
      child: Focus(
        onFocusChange: (hasFocus) {
          setState(() => _isFocused = hasFocus);
        },
        child: TextFormField(
          obscureText: widget.obscureText,
          controller: widget.controller,
          style: AppTheme.bodyStyle.copyWith(fontSize: 15),
          cursorColor: AppTheme.accentColor,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppTheme.bodyStyle.copyWith(
              color: AppTheme.syntaxComment.withValues(alpha: 0.5),
              fontSize: 15,
            ),
            prefixIcon: Icon(
              widget.prefixIcon,
              color: _isFocused 
                ? AppTheme.accentColor 
                : AppTheme.syntaxComment,
              size: 22,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
          ),
        ),
      ),
    );
  }
}
