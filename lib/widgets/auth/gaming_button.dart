import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class GamingButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isSecondary;

  const GamingButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isSecondary = false,
  });

  @override
  State<GamingButton> createState() => _GamingButtonState();
}

class _GamingButtonState extends State<GamingButton> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: widget.isSecondary 
                    ? LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppTheme.neonPurple.withValues(alpha: 0.2),
                        ],
                      )
                    : LinearGradient(
                        colors: [
                          AppTheme.neonPurple,
                          AppTheme.neonBlue,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                border: Border.all(
                    color: widget.isSecondary ? AppTheme.neonBlue : Colors.transparent,
                    width: 1.5,
                ),
                boxShadow: widget.isSecondary
                    ? []
                    : [
                        BoxShadow(
                          color: AppTheme.neonPurple.withValues(alpha: 0.5 + (_pulseController.value * 0.2)),
                          blurRadius: 10 + (_pulseController.value * 5),
                          spreadRadius: 1,
                        ),
                      ],
              ),
              child: Center(
                child: Text(
                  widget.text,
                  style: AppTheme.buttonStyle.copyWith(
                    color: widget.isSecondary ? AppTheme.electricCyan : Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
