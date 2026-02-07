import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class NeonInput extends StatefulWidget {
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const NeonInput({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.controller,
    this.validator,
  });

  @override
  State<NeonInput> createState() => _NeonInputState();
}

class _NeonInputState extends State<NeonInput> with SingleTickerProviderStateMixin {
  late FocusNode _focusNode;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _glowController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _glowAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _glowController.forward();
      } else {
        _glowController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.neonBlue.withValues(alpha: 0.5 * _glowAnimation.value),
                blurRadius: 10 + (10 * _glowAnimation.value),
                spreadRadius: 1 * _glowAnimation.value,
              ),
            ],
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: widget.obscureText,
            style: AppTheme.bodyStyle.copyWith(color: Colors.white),
            cursorColor: AppTheme.electricCyan,
            validator: widget.validator,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppTheme.glassWhite,
              hintText: widget.hintText,
              hintStyle: AppTheme.bodyStyle.copyWith(color: Colors.white38),
              prefixIcon: Icon(
                widget.prefixIcon,
                color: Color.lerp(
                  Colors.white38,
                  AppTheme.electricCyan,
                  _glowAnimation.value,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.glassBorder,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.glassBorder,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.electricCyan,
                  width: 2,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
