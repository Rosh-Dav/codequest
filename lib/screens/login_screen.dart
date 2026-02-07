import 'package:flutter/material.dart';
import '../../widgets/background/animated_background.dart';
import '../../widgets/auth/auth_panel.dart';
import '../../widgets/ai/ai_bot_overlay.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _showAIBot = false;

  void _onLoginSuccess() {
    setState(() {
      _showAIBot = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AnimatedBackground(),
          
          AnimatedOpacity(
            opacity: _showAIBot ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 500),
            child: PointerInterceptor(
              intercepting: _showAIBot,
               child: AuthPanel(onLoginSuccess: _onLoginSuccess),
            ),
          ),

          if (_showAIBot)
            const AIBotOverlay(),
        ],
      ),
    );
  }
}

class PointerInterceptor extends StatelessWidget {
    final bool intercepting;
    final Widget child;
    const PointerInterceptor({super.key, required this.intercepting, required this.child});

    @override
    Widget build(BuildContext context) {
        return IgnorePointer(ignoring: intercepting, child: child);
    }
}
