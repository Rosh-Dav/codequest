import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/theme.dart';
import 'neon_input.dart';
import 'gaming_button.dart';
import 'dart:ui';

class AuthPanel extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const AuthPanel({super.key, required this.onLoginSuccess});

  @override
  State<AuthPanel> createState() => _AuthPanelState();
}

class _AuthPanelState extends State<AuthPanel> {
  bool _isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
           // Main Glass Panel
           ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: 380,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppTheme.glassWhite,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppTheme.glassBorder,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Text(
                      _isLogin ? 'SYSTEM LOGIN' : 'NEW PLAYER',
                      style: AppTheme.headingStyle,
                    ).animate().fadeIn().slideY(begin: -0.5, end: 0),
                    
                    const SizedBox(height: 8),
                    Text(
                      _isLogin 
                        ? 'Enter credentials to access the arena'
                        : 'Register your identity to begin training',
                      style: AppTheme.bodyStyle,
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 200.ms),

                    const SizedBox(height: 32),

                    // Form Fields
                    if (!_isLogin)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: NeonInput(
                          hintText: 'CODENAME (USERNAME)',
                          prefixIcon: Icons.person_outline,
                        ).animate().fadeIn().slideX(begin: -0.2, end: 0),
                      ),

                    NeonInput(
                      hintText: 'EMAIL ADDRESS',
                      prefixIcon: Icons.alternate_email,
                    ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.2, end: 0),

                    const SizedBox(height: 16),

                    NeonInput(
                      hintText: 'ACCESS KEY (PASSWORD)',
                      prefixIcon: Icons.lock_outline,
                      obscureText: true,
                    ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.2, end: 0),

                    const SizedBox(height: 32),

                    // Buttons
                    GamingButton(
                      text: _isLogin ? 'ENTER ARENA' : 'INITIATE',
                      onPressed: widget.onLoginSuccess,
                    ).animate().fadeIn(delay: 600.ms).scale(),

                    const SizedBox(height: 16),

                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin 
                          ? 'CREATE ACCOUNT'
                          : 'ALREADY REGISTERED?',
                        style: AppTheme.bodyStyle.copyWith(
                          color: AppTheme.electricCyan,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ).animate().fadeIn(delay: 700.ms),
                  ],
                ),
              ),
            ),
          ),
          
          // Tactical Corner Brackets
          Positioned(
            top: 0, left: 0,
            child: _CornerBracket(color: AppTheme.electricCyan),
          ),
          Positioned(
            top: 0, right: 0,
            child: Transform.rotate(angle: 1.57, child: _CornerBracket(color: AppTheme.electricCyan)),
          ),
          Positioned(
            bottom: 0, right: 0,
            child: Transform.rotate(angle: 3.14, child: _CornerBracket(color: AppTheme.neonPurple)),
          ),
          Positioned(
            bottom: 0, left: 0,
            child: Transform.rotate(angle: 4.71, child: _CornerBracket(color: AppTheme.neonPurple)),
          ),
        ],
      ),
    );
  }
}

class _CornerBracket extends StatelessWidget {
    final Color color;
    const _CornerBracket({required this.color});

    @override
    Widget build(BuildContext context) {
        return Container(
            width: 30, height: 30,
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: color, width: 3),
                    left: BorderSide(color: color, width: 3),
                )
            ),
        );
    }
}
