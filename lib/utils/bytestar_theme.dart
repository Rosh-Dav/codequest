import 'package:flutter/material.dart';

class ByteStarTheme {
  static const Color primary = Color(0xFF0D1B2A);
  static const Color secondary = Color(0xFF1B263B);
  static const Color accent = Color(0xFF00F5FF);
  static const Color highlight = Color(0xFF7B61FF);
  static const Color warning = Color(0xFFFF4D6D);
  static const Color success = Color(0xFF00FF9C);
  static const Color cardBg = Color(0xFF1B263B);
  
  static const TextStyle heading = TextStyle(
    fontFamily: 'Orbitron', // Assuming font is available or fall back
    color: accent,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    shadows: [
      Shadow(color: accent, blurRadius: 10),
    ],
  );

  static const TextStyle body = TextStyle(
    fontFamily: 'Exo 2',
    color: Colors.white,
    fontSize: 16,
  );

  static const TextStyle code = TextStyle(
    fontFamily: 'Fira Code',
    color: success,
    fontSize: 14,
  );
}
