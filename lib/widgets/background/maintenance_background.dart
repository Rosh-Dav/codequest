import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MaintenanceBackground extends StatelessWidget {
  final bool isClean; // True = Organized/Bright, False = Messy/Dim
  const MaintenanceBackground({super.key, required this.isClean});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base
        Container(color: const Color(0xFF101015)),
        
        // Floating Text
        ...List.generate(10, (index) {
          final align = isClean 
             ? Alignment(0, -0.8 + (index * 0.15)) // Aligned list
             : Alignment((index % 2 == 0 ? -0.8 : 0.8), -0.8 + (index * 0.2) + (index % 3 * 0.05)); // Scattered
             
          final opacity = isClean ? 0.3 : 0.1;
             
          return AnimatedAlign(
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
            alignment: align,
            child: Text(
              isClean ? "# System Log Entry $index: OK" : "ERROR 0x0$index... # MISSING DOCS",
              style: GoogleFonts.firaCode(
                color: (isClean ? Colors.green : Colors.grey).withValues(alpha: opacity),
                fontSize: 12,
              ),
            ),
          );
        }),
        
        // Dust/Overlay
        if (!isClean)
          Container(
            color: Colors.black.withValues(alpha: 0.5),
          ),
      ],
    );
  }
}
