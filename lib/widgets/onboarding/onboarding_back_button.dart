import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/theme.dart';

class OnboardingBackButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Color? color;

  const OnboardingBackButton({
    super.key,
    this.onPressed,
    this.color,
  });

  @override
  State<OnboardingBackButton> createState() => _OnboardingBackButtonState();
}

class _OnboardingBackButtonState extends State<OnboardingBackButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed ?? () => Navigator.of(context).pop(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _isHovered 
                ? (widget.color ?? AppTheme.accentColor).withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered 
                  ? (widget.color ?? AppTheme.accentColor) 
                  : Colors.white.withValues(alpha: 0.1),
              width: 1.5,
            ),
            boxShadow: _isHovered ? [
              BoxShadow(
                color: (widget.color ?? AppTheme.accentColor).withValues(alpha: 0.3),
                blurRadius: 15,
                spreadRadius: 1,
              )
            ] : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_back_ios_new_rounded,
                color: _isHovered ? (widget.color ?? AppTheme.accentColor) : Colors.white70,
                size: 18,
              ),
              if (_isHovered) ...[
                const SizedBox(width: 8),
                Text(
                  'BACK',
                  style: AppTheme.codeStyle.copyWith(
                    color: widget.color ?? AppTheme.accentColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ).animate().fadeIn(duration: 200.ms).slideX(begin: 0.2, end: 0),
              ],
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.2, end: 0);
  }
}
