import 'package:flutter/material.dart';
import '../../utils/theme.dart';
import '../../screens/bytestar/profile_screen.dart';
import '../../screens/multiplayer/multiplayer_placeholder_screen.dart';

class GlobalSidebar extends StatelessWidget {
  final String username;

  const GlobalSidebar({
    super.key,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.ideBackground,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: AppTheme.syntaxBlue.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
        ),
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildMenuItem(
                    context,
                    icon: Icons.dashboard_outlined,
                    title: 'Dashboard',
                    onTap: () => Navigator.pushReplacementNamed(context, '/onboarding/language'),
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.person_outline,
                    title: 'Profile',
                    onTap: () {
                      Navigator.pop(context); // Close drawer
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    context,
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.help_outline,
                    title: 'Help & Docs',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/help');
                    },
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    context,
                    icon: Icons.groups_outlined,
                    title: 'Multiplayer',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MultiplayerPlaceholderScreen()),
                      );
                    },
                    isPremium: true,
                  ),
                ],
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: AppTheme.idePanel.withValues(alpha: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.syntaxBlue, width: 2),
            ),
            child: const Icon(Icons.code, color: AppTheme.syntaxBlue, size: 32),
          ),
          const SizedBox(height: 12),
          Text(
            'CODEQUEST',
            style: AppTheme.headingStyle.copyWith(
              fontSize: 20,
              letterSpacing: 2,
              color: AppTheme.syntaxBlue,
            ),
          ),
          Text(
            'Terminal Access: Active',
            style: AppTheme.bodyStyle.copyWith(
              fontSize: 10,
              color: AppTheme.syntaxComment,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isPremium = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: isPremium ? AppTheme.syntaxYellow : Colors.white70),
      title: Text(
        title,
        style: AppTheme.bodyStyle.copyWith(
          color: isPremium ? AppTheme.syntaxYellow : Colors.white,
          fontWeight: isPremium ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isPremium 
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.syntaxYellow.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppTheme.syntaxYellow, width: 0.5),
            ),
            child: const Text(
              'PRO',
              style: TextStyle(color: AppTheme.syntaxYellow, fontSize: 8, fontWeight: FontWeight.bold),
            ),
          )
        : null,
      onTap: onTap,
      hoverColor: AppTheme.syntaxBlue.withValues(alpha: 0.1),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: AppTheme.syntaxBlue.withValues(alpha: 0.1),
      indent: 16,
      endIndent: 16,
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'v1.2.0-stable',
        style: AppTheme.bodyStyle.copyWith(
          fontSize: 10,
          color: AppTheme.syntaxComment,
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature mode coming soon!'),
        backgroundColor: AppTheme.syntaxBlue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
