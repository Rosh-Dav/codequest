import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/theme.dart';
import '../../widgets/navigation/global_sidebar.dart';
import '../../services/local_storage_service.dart';

class MultiplayerPlaceholderScreen extends StatefulWidget {
  const MultiplayerPlaceholderScreen({super.key});

  @override
  State<MultiplayerPlaceholderScreen> createState() => _MultiplayerPlaceholderScreenState();
}

class _MultiplayerPlaceholderScreenState extends State<MultiplayerPlaceholderScreen> {
  String _username = 'Coder';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final username = await LocalStorageService().getUsername() ?? 'Coder';
    setState(() => _username = username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.ideBackground,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'MULTIPLAYER HUB',
          style: AppTheme.headingStyle.copyWith(fontSize: 18, letterSpacing: 2),
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: AppTheme.syntaxYellow),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: GlobalSidebar(username: _username),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.syntaxYellow, width: 2),
                boxShadow: [
                  BoxShadow(color: AppTheme.syntaxYellow.withValues(alpha: 0.2), blurRadius: 30, spreadRadius: 5),
                ],
              ),
              child: const Icon(Icons.groups, size: 80, color: AppTheme.syntaxYellow),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
             .scale(duration: 2.seconds, begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1)),
            
            const SizedBox(height: 40),
            
            Text(
              'PVP BATTLES COMING SOON',
              style: AppTheme.headingStyle.copyWith(color: AppTheme.syntaxYellow, letterSpacing: 2),
            ).animate().fadeIn(duration: 800.ms),
            
            const SizedBox(height: 16),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Prepare your algorithms. Real-time competitive coding is arriving in the next major patch.',
                style: AppTheme.bodyStyle.copyWith(color: AppTheme.syntaxComment),
                textAlign: TextAlign.center,
              ),
            ).animate().fadeIn(delay: 400.ms),
            
            const SizedBox(height: 60),
            
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.syntaxYellow.withValues(alpha: 0.1),
                side: const BorderSide(color: AppTheme.syntaxYellow),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: Text(
                'RETURN TO DASHBOARD',
                style: AppTheme.codeStyle.copyWith(color: AppTheme.syntaxYellow, fontWeight: FontWeight.bold),
              ),
            ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.2, end: 0),
          ],
        ),
      ),
    );
  }
}
