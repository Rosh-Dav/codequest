import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/phase1_theme.dart';
import '../../models/level_model.dart';

class LevelCard extends StatelessWidget {
  final LevelModel level;
  final VoidCallback onTap;

  const LevelCard({super.key, required this.level, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          border: Border.all(
            color: level.isUnlocked 
              ? (level.isCompleted ? Phase1Theme.successGreen : Phase1Theme.cyanGlow) 
              : Colors.grey.withValues(alpha: 0.3),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: level.isUnlocked 
              ? [BoxShadow(color: Phase1Theme.cyanGlow.withValues(alpha: 0.2), blurRadius: 10)] 
              : [],
        ),
        child: Stack(
          children: [
             // Content
             Center(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   // Icon
                   Icon(
                     level.isCompleted ? Icons.star : (level.isUnlocked ? Icons.play_arrow : Icons.lock),
                     color: level.isUnlocked 
                       ? (level.isCompleted ? Phase1Theme.successGreen : Phase1Theme.cyanGlow)
                       : Colors.grey,
                     size: 32,
                   ),
                   const SizedBox(height: 8),
                   // Number
                   Text(
                     "LEVEL ${level.id}",
                     style: Phase1Theme.codeFont.copyWith(
                       color: level.isUnlocked ? Colors.white : Colors.grey,
                       fontSize: 12,
                     ),
                   ),
                   const SizedBox(height: 4),
                   // Title
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
                     child: Text(
                       level.title.toUpperCase(),
                       textAlign: TextAlign.center,
                       style: Phase1Theme.alertFont.copyWith(
                         color: level.isUnlocked ? Phase1Theme.cyanGlow : Colors.grey,
                         fontSize: 10,
                       ),
                       maxLines: 2,
                       overflow: TextOverflow.ellipsis,
                     ),
                   ),
                 ],
               ),
             ),
             
             // Completed Badge overlay
             if (level.isCompleted)
               Positioned(
                 top: 8,
                 right: 8,
                 child: Icon(Icons.check_circle, color: Phase1Theme.successGreen, size: 16)
                    .animate().scale(duration: 500.ms, curve: Curves.elasticOut),
               ),
          ],
        ),
      ).animate(target: level.isUnlocked ? 1 : 0)
       .shimmer(duration: 2.seconds, color: Colors.white10)
       .scale(begin: const Offset(0.95, 0.95), end: const Offset(1.0, 1.0), duration: 200.ms),
    );
  }
}
