import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Modern IDE Palette
  static const Color ideBackground = Color(0xFF0D1117); // Github Dimmed / VS Code dark
  static const Color idePanel = Color(0xFF161B22); // Slightly lighter panel
  static const Color syntaxBlue = Color(0xFF79C0FF); // Variables/Functions
  static const Color syntaxGreen = Color(0xFF7EE787); // Strings/Success
  static const Color syntaxYellow = Color(0xFFE3B341); // Warnings/Keywords
  static const Color syntaxPurple = Color(0xFFD2A8FF); // Control flow/Methods
  static const Color syntaxRed = Color(0xFFFF7B72); // Errors/Deletions
  static const Color syntaxComment = Color(0xFF8B949E); // Comments
  static const Color textPrimary = Color(0xFFC9D1D9); // Main text
  static const Color accentColor = Color(0xFF58A6FF); // Focus/Buttons

  // Legacy mappings for compatibility (will be refactored later)
  static const Color neonBlue = syntaxBlue;
  static const Color neonPurple = syntaxPurple;
  static const Color electricCyan = syntaxGreen;
  static const Color academicBlue = ideBackground;
  static const Color deepNavy = idePanel;
  static const Color knowledgeGold = syntaxYellow;
  static const Color darkBackground = ideBackground;
  static const Color deepSpace = idePanel;
  static const Color glassWhite = Color(0x0DFFFFFF); // Subtle white tint
  static const Color glassBorder = Color(0x1AFFFFFF); // Subtle border

  // Typography
  static TextStyle get headingStyle => GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textPrimary,
        letterSpacing: -0.5,
      );

  static TextStyle get codeStyle => GoogleFonts.robotoMono(
        fontSize: 14,
        color: textPrimary,
        height: 1.5,
      );

  static TextStyle get bodyStyle => GoogleFonts.inter(
        fontSize: 15,
        color: textPrimary.withValues(alpha: 0.8),
      );

  static TextStyle get buttonStyle => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );
}
