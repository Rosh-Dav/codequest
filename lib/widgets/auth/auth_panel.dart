import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/theme.dart';
import 'neon_input.dart';
import 'gaming_button.dart';
import '../../services/auth_service.dart';

class AuthPanel extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const AuthPanel({super.key, required this.onLoginSuccess});

  @override
  State<AuthPanel> createState() => _AuthPanelState();
}

class _AuthPanelState extends State<AuthPanel> {
  bool _isLogin = true;
  bool _isLoading = false;
  final _authService = AuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _error;


  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailAuth() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final username = _usernameController.text.trim();

    if (email.isEmpty || password.isEmpty || (!_isLogin && username.isEmpty)) {
      _showError('Please fill in all required fields.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      if (_isLogin) {
        await _authService.signInWithEmail(email: email, password: password);
      } else {
        await _authService.signUpWithEmail(
          email: email,
          password: password,
          username: username,
        );
      }
      widget.onLoginSuccess();
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }


  String _cleanError(String message) {
    return message.replaceAll(RegExp(r'\[.*?\]\s*'), '').replaceAll('Exception:', '').trim();
  }

  void _showError(String message) {
    setState(() => _error = _cleanError(message));
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) setState(() => _error = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 420,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: AppTheme.idePanel.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppTheme.syntaxBlue.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.6),
              blurRadius: 40,
              spreadRadius: 5,
            ),
            BoxShadow(
              color: AppTheme.syntaxBlue.withValues(alpha: 0.1),
              blurRadius: 60,
              spreadRadius: -10,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            Text(
              _isLogin ? 'Welcome Back' : 'Join CodeQuest',
              style: AppTheme.headingStyle.copyWith(fontSize: 32),
              textAlign: TextAlign.center,
            ).animate().fadeIn().slideY(begin: -0.2, end: 0),
            
            const SizedBox(height: 12),
            Text(
              _isLogin 
                ? 'Sign in to continue your coding journey'
                : 'Start your learning adventure today',
              style: AppTheme.bodyStyle.copyWith(
                color: AppTheme.syntaxComment,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 200.ms),

            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.redAccent.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _error!,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().shake(duration: 400.ms).fadeIn(),
              ),

            const SizedBox(height: 40),

            // Form Fields
            if (!_isLogin)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: NeonInput(
                  hintText: 'Username',
                  prefixIcon: Icons.person_outline,
                  controller: _usernameController,
                ).animate().fadeIn().slideX(begin: -0.1, end: 0),
              ),

            NeonInput(
              hintText: 'Email',
              prefixIcon: Icons.email_outlined,
              controller: _emailController,
            ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.1, end: 0),

            const SizedBox(height: 20),

            NeonInput(
              hintText: 'Password',
              prefixIcon: Icons.lock_outline,
              obscureText: true,
              controller: _passwordController,
            ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1, end: 0),

            const SizedBox(height: 32),

            // Login Button
            GamingButton(
              text: _isLogin ? 'Start Learning' : 'Create Account',
              onPressed: _isLoading ? null : () => _handleEmailAuth(),
              isLoading: _isLoading,
            ).animate().fadeIn(delay: 600.ms).scale(),

            const SizedBox(height: 20),

            // Toggle Button
            TextButton(
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin;
                });
              },
              child: RichText(
                text: TextSpan(
                  style: AppTheme.bodyStyle.copyWith(fontSize: 14),
                  children: [
                    TextSpan(
                      text: _isLogin 
                        ? "Don't have an account? "
                        : 'Already have an account? ',
                      style: TextStyle(color: AppTheme.syntaxComment),
                    ),
                    TextSpan(
                      text: _isLogin ? 'Sign Up' : 'Sign In',
                      style: TextStyle(
                        color: AppTheme.accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 700.ms),
          ],
        ),
      ),
    );
  }
}
