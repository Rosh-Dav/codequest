import 'package:flutter/material.dart';
import '../../widgets/background/code_background.dart';
import '../../widgets/auth/auth_panel.dart';
import 'onboarding/language_selection_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void _onLoginSuccess() {
    // Navigate to onboarding
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const LanguageSelectionScreen(
          username: 'Coder', // TODO: Get actual username from form
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const CodeBackground(),
          AuthPanel(onLoginSuccess: _onLoginSuccess),
        ],
      ),
    );
  }
}
