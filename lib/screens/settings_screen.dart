import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../services/local_storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'Python';
  final LocalStorageService _storage = LocalStorageService();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final lang = await _storage.getSelectedLanguage();
    if (lang != null) {
      setState(() {
        _selectedLanguage = lang;
      });
    }
  }

  Future<void> _saveLanguage(String lang) async {
    await _storage.saveSelectedLanguage(lang);
    setState(() {
      _selectedLanguage = lang;
    });
  }

  Future<void> _resetProgress() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.idePanel,
        title: const Text('Reset Progress?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'This will permanently delete your local and remote progress. This action cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('RESET', style: TextStyle(color: AppTheme.syntaxRed)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _storage.clearStoryProgress();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Progress reset successfully')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'TERMINAL SETTINGS',
          style: AppTheme.headingStyle.copyWith(fontSize: 18, letterSpacing: 2),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.neonBlue),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('PREFERENCES'),
            const SizedBox(height: 16),
            _buildSettingCard(
              title: 'Primary Core Language',
              subtitle: 'Select the primary language for your missions',
              trailing: DropdownButton<String>(
                value: _selectedLanguage,
                dropdownColor: AppTheme.idePanel,
                underline: const SizedBox(),
                items: ['Python', 'C'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) _saveLanguage(val);
                },
              ),
            ),
            const SizedBox(height: 32),
            _buildSectionHeader('SYSTEM MAINTENANCE'),
            const SizedBox(height: 16),
            _buildSettingCard(
              title: 'Reset Mission Progress',
              subtitle: 'Wipe all mission data and start over',
              isDestructive: true,
              onTap: _resetProgress,
            ),
            const SizedBox(height: 48),
            Center(
              child: Opacity(
                opacity: 0.5,
                child: Text(
                  'CodeQuest Terminal v1.2.0-stable\nSecure Link: Active',
                  textAlign: TextAlign.center,
                  style: AppTheme.bodyStyle.copyWith(fontSize: 10, height: 1.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTheme.bodyStyle.copyWith(
        color: AppTheme.neonPurple,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
        fontSize: 12,
      ),
    );
  }

  Widget _buildSettingCard({
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.idePanel.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDestructive 
              ? AppTheme.syntaxRed.withValues(alpha: 0.3) 
              : AppTheme.neonBlue.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.bodyStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDestructive ? AppTheme.syntaxRed : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTheme.bodyStyle.copyWith(
                      fontSize: 12,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing,
            if (onTap != null && !isDestructive) 
              const Icon(Icons.chevron_right, color: Colors.white24),
          ],
        ),
      ),
    );
  }
}
