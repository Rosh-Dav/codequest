import 'package:flutter/material.dart';
import '../utils/theme.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'FIELD MANUAL',
          style: AppTheme.headingStyle.copyWith(fontSize: 18, letterSpacing: 2),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.neonBlue),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildHelpCard(
            'THE MISSION',
            'You are a Netrunner tasked with infiltrating the most secure systems in the sector. Use your coding skills to bypass firewalls and recover lost data shards.',
            Icons.explore_outlined,
          ),
          _buildHelpCard(
            'XP & RANK',
            'Complete missions to earn XP. As you gain XP, your clearance level increases, unlocking dangerous but high-reward sectors.',
            Icons.workspace_premium_outlined,
          ),
          _buildHelpCard(
            'TERMINAL ACCESS',
            'The terminal is your primary tool. Write clean, efficient code to succeed. If you get stuck, consult your AI mentor.',
            Icons.terminal_outlined,
          ),
          _buildHelpCard(
            'REAL-TIME SYNC',
            'Your progress is automatically synced with the global grid. Access your profile from any terminal in the network.',
            Icons.sync_outlined,
          ),
          const SizedBox(height: 32),
          _buildContactCard(),
        ],
      ),
    );
  }

  Widget _buildHelpCard(String title, String description, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.idePanel.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.neonBlue.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.neonBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.neonBlue, size: 24),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.bodyStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.neonBlue,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: AppTheme.bodyStyle.copyWith(
                    fontSize: 13,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.neonPurple.withValues(alpha: 0.2),
            AppTheme.neonBlue.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.neonPurple.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          const Icon(Icons.support_agent, color: AppTheme.neonPurple, size: 32),
          const SizedBox(height: 12),
          Text(
            'TECH SUPPORT',
            style: AppTheme.bodyStyle.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Need further assistance?\nContact command at support@codequest.io',
            textAlign: TextAlign.center,
            style: AppTheme.bodyStyle.copyWith(fontSize: 12, color: Colors.white60),
          ),
        ],
      ),
    );
  }
}
