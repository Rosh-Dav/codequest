import 'package:flutter/material.dart';

class PythonByteStarTheme {
  static const Color primary = Color(0xFF00E5FF); // Cyan glow
  static const Color accent = Color(0xFF7C4DFF);  // Purple glow
  static const Color secondary = Color(0xFF1B263B); // Dark Blue-Grey (Added for compatibility)
  static const Color error = Color(0xFFFF4C4C);   // Red alert
  static const Color success = Color(0xFF00FF88); // Green glow
  static const Color background = Color(0xFF050510); // Deep space dark
  static const Color surface = Color(0xFF1E1E2C);    // Surface color
  static const Color glassPanel = Color(0x3300E5FF); // Semi-transparent cyan

  static const TextStyle heading = TextStyle(
    fontFamily: 'Orbitron', 
    color: primary,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    shadows: [
      Shadow(color: primary, blurRadius: 10),
    ],
  );

  static const TextStyle body = TextStyle(
    fontFamily: 'Exo 2',
    color: Colors.white,
    fontSize: 16,
  );

  static const TextStyle terminal = TextStyle(
    fontFamily: 'Fira Code',
    color: primary,
    fontSize: 14,
  );
  
  static BoxDecoration glassDecoration = BoxDecoration(
    color: background.withOpacity(0.7),
    border: Border.all(color: primary.withOpacity(0.5)),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: primary.withOpacity(0.2),
        blurRadius: 15,
        spreadRadius: 2,
      ),
    ],
  );
}
