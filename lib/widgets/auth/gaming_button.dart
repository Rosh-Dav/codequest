import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class GamingButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const GamingButton({
    super.key,
    required this.text,
    required this.onPressed,
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
    final isEnabled = widget.onPressed != null && !widget.isLoading;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: isEnabled ? widget.onPressed : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: isEnabled
                ? AppTheme.accentColor
                : AppTheme.accentColor.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              if (_isHovering && isEnabled)
                BoxShadow(
                  color: AppTheme.accentColor.withValues(alpha: 0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.isLoading) ...[
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ] else ...[
                const Icon(Icons.play_arrow_rounded, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  widget.text,
                  style: AppTheme.buttonStyle,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
