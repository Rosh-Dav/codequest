import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color academicBlue = Color(0xFF0A192F); // Deep specialized blue
  static const Color deepNavy = Color(0xFF020c1b); // Darker base
  static const Color knowledgeGold = Color(0xFFFFD700); // Ideas/Sparks
  static const Color syntaxGreen = Color(0xFF64FFDA); // Code elements
  
  static const Color neonBlue = Color(0xFF00F0FF);
  static const Color neonPurple = Color(0xFFBD00FF);
  static const Color electricCyan = Color(0xFF00FFFF);
  static const Color darkBackground = Color(0xFF050510);
  static const Color deepSpace = Color(0xFF0A0A1E);
  static const Color gridLine = Color(0x3300F0FF);
  static const Color glassWhite = Color(0x1AFFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);

  static TextStyle get headingStyle => GoogleFonts.orbitron(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: [
          Shadow(
            color: neonBlue,
            blurRadius: 10,
          ),
        ],
      );

  static TextStyle get bodyStyle => GoogleFonts.robotoMono(
        fontSize: 14,
        color: Colors.white70,
      );

  static TextStyle get buttonStyle => GoogleFonts.orbitron(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      );
}
