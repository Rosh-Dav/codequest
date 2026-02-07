import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/theme.dart';

class SelectionCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData? icon;
  final Widget? customLogo;
  final Color accentColor;
  final VoidCallback onTap;
  final bool isSelected;

  const SelectionCard({
    super.key,
    required this.title,
    required this.description,
    this.icon,
    this.customLogo,
    required this.accentColor,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  State<SelectionCard> createState() => _SelectionCardState();
}

class _SelectionCardState extends State<SelectionCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          transform: Matrix4.diagonal3Values(
            _isHovering || widget.isSelected ? 1.05 : 1.0,
            _isHovering || widget.isSelected ? 1.05 : 1.0,
            1.0,
          ),
          child: Container(
            width: 280,
            height: 320,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppTheme.idePanel.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: widget.isSelected
                    ? widget.accentColor
                    : (_isHovering
                        ? widget.accentColor.withValues(alpha: 0.5)
                        : AppTheme.glassBorder),
                width: widget.isSelected ? 3 : 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
                if (_isHovering || widget.isSelected)
                  BoxShadow(
                    color: widget.accentColor.withValues(alpha: 0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon or Custom Logo
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.customLogo != null 
                        ? Colors.transparent 
                        : widget.accentColor.withValues(alpha: 0.2),
                    border: widget.customLogo != null 
                        ? null 
                        : Border.all(
                            color: widget.accentColor,
                            width: 2,
                          ),
                  ),
                  child: widget.customLogo ?? Icon(
                    widget.icon!,
                    size: 50,
                    color: widget.accentColor,
                  ),
                ).animate(
                  target: _isHovering || widget.isSelected ? 1 : 0,
                ).rotate(
                  begin: 0,
                  end: 0.05,
                  duration: 300.ms,
                ).scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.1, 1.1),
                  duration: 300.ms,
                ),

                const SizedBox(height: 24),

                // Title
                Text(
                  widget.title,
                  style: AppTheme.headingStyle.copyWith(fontSize: 24),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                // Description
                Text(
                  widget.description,
                  style: AppTheme.bodyStyle.copyWith(
                    color: AppTheme.syntaxComment,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
