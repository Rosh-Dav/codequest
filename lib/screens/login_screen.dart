import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    final user = FirebaseAuth.instance.currentUser;
    final username =
        user?.displayName ?? user?.email?.split('@').first ?? 'Coder';
    // Navigate to onboarding
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LanguageSelectionScreen(username: username),
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
