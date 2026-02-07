import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class GamingButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isLoading;

  const GamingButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.isLoading = false,
  });

  @override
  State<GamingButton> createState() => _GamingButtonState();
}

class _GamingButtonState extends State<GamingButton> with SingleTickerProviderStateMixin {
  bool _isHovering = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? AppTheme.accentColor,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              if (_isHovering)
                BoxShadow(
                  color: (widget.backgroundColor ?? AppTheme.accentColor).withValues(alpha: 0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
            ],
          ),
          child: widget.isLoading
              ? const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_arrow_rounded,
                        color: widget.textColor ?? Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      widget.text,
                      style: AppTheme.buttonStyle
                          .copyWith(color: widget.textColor ?? Colors.white),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
