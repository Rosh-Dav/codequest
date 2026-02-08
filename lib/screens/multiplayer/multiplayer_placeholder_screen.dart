import 'package:flutter/material.dart';
import 'quest_home_screen.dart';

class MultiplayerPlaceholderScreen extends StatelessWidget {
  const MultiplayerPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Redirect to Quest Home Screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const QuestHomeScreen()),
      );
    });

    return const Scaffold(
      backgroundColor: Color(0xFF0D1117),
      body: Center(
        child: CircularProgressIndicator(color: Color(0xFF58A6FF)),
      ),
    );
  }
}
