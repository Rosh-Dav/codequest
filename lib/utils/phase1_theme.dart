import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Phase1Theme {
  // Colors
  static const Color cyanGlow = Color(0xFF00E5FF);
  static const Color purpleGlow = Color(0xFF7C4DFF);
  static const Color errorRed = Color(0xFFFF4C4C);
  static const Color successGreen = Color(0xFF00FF88);
  static const Color deepSpaceBlue = Color(0xFF0A0E21);
  static const Color purplish = Color(0xFF9D50BB);

  
  // Gradients
  static const LinearGradient coreGradient = LinearGradient(
    colors: [cyanGlow, purpleGlow],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Text Styles
  static TextStyle get sciFiFont => GoogleFonts.shareTechMono(
    color: cyanGlow,
    shadows: [
      Shadow(color: cyanGlow.withValues(alpha: 0.6), blurRadius: 8),
    ],
  );

  static TextStyle get dialogueFont => GoogleFonts.exo2(
    color: Colors.white.withValues(alpha: 0.9),
    fontSize: 16,
    height: 1.5,
  );

  static TextStyle get alertFont => GoogleFonts.orbitron(
    color: errorRed,
    fontWeight: FontWeight.bold,
    letterSpacing: 2,
  );

  static TextStyle get codeFont => GoogleFonts.firaCode(
    color: cyanGlow,
    fontSize: 14,
    height: 1.5,
  );

  // Decorations
  static BoxDecoration get glassPanel => BoxDecoration(
    color: Colors.white.withValues(alpha: 0.05),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: cyanGlow.withValues(alpha: 0.3),
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: cyanGlow.withValues(alpha: 0.1),
        blurRadius: 20,
        spreadRadius: 0,
      ),
    ],
  );

  static BoxDecoration get hologramCard => BoxDecoration(
    color: const Color(0xFF0A0E21).withValues(alpha: 0.8),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: purpleGlow.withValues(alpha: 0.5)),
    boxShadow: [
      BoxShadow(
        color: purpleGlow.withValues(alpha: 0.2),
        blurRadius: 15,
      ),
    ],
  );
}
