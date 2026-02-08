import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/theme.dart';
import '../../services/multiplayer/quest_service.dart';
import '../../services/local_storage_service.dart';
import 'lobby_screen.dart';

class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final QuestService _questService = QuestService();
  final LocalStorageService _storage = LocalStorageService();
  final TextEditingController _roomCodeController = TextEditingController();
  
  bool _isJoining = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Initialize quest service with user auth in _joinRoom
  }

  @override
  void dispose() {
    _roomCodeController.dispose();
    super.dispose();
  }

  Future<void> _joinRoom() async {
    final roomCode = _roomCodeController.text.trim().toUpperCase();
    
    if (roomCode.length != 6) {
      setState(() => _errorMessage = 'Room code must be 6 characters');
      return;
    }

    setState(() {
      _isJoining = true;
      _errorMessage = null;
    });

    try {
      // Get Firebase user and ID token
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        throw Exception('Not logged in. Please log in first.');
      }
      
      final idToken = await firebaseUser.getIdToken();
      if (idToken == null) {
        throw Exception('Failed to get authentication token');
      }
      
      final userId = firebaseUser.uid;
      
      // Initialize quest service with Firebase token
      await _questService.init(userId, idToken);

      final room = await _questService.joinRoom(
        roomCode: roomCode,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LobbyScreen(
              room: room,
              currentUserId: userId,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() => _isJoining = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.darkBackground,
              AppTheme.neonPurple.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppTheme.neonBlue),
                  onPressed: () => Navigator.pop(context),
                ).animate().fadeIn(),

                const SizedBox(height: 20),

                // Title
                Text(
                  'JOIN ROOM',
                  style: AppTheme.headingStyle.copyWith(
                    fontSize: 40,
                    letterSpacing: 3,
                  ),
                ).animate().fadeIn().slideY(begin: -0.2),

                const SizedBox(height: 8),

                Text(
                  'Enter the room code to join',
                  style: AppTheme.bodyStyle.copyWith(
                    color: AppTheme.syntaxComment,
                  ),
                ).animate(delay: 200.ms).fadeIn(),

                const SizedBox(height: 60),

                // Room Code Input
                Text(
                  'ROOM CODE',
                  style: AppTheme.bodyStyle.copyWith(
                    color: AppTheme.neonPurple,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontSize: 12,
                  ),
                ).animate(delay: 400.ms).fadeIn(),

                const SizedBox(height: 16),

                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.idePanel.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _errorMessage != null
                          ? AppTheme.syntaxRed
                          : AppTheme.neonBlue.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: TextField(
                    controller: _roomCodeController,
                    textAlign: TextAlign.center,
                    maxLength: 6,
                    textCapitalization: TextCapitalization.characters,
                    style: AppTheme.headingStyle.copyWith(
                      fontSize: 32,
                      letterSpacing: 8,
                      color: AppTheme.neonBlue,
                    ),
                    decoration: InputDecoration(
                      hintText: 'A9F3X2',
                      hintStyle: AppTheme.bodyStyle.copyWith(
                        fontSize: 32,
                        letterSpacing: 8,
                        color: Colors.white24,
                      ),
                      border: InputBorder.none,
                      counterText: '',
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 16,
                      ),
                    ),
                    onChanged: (value) {
                      if (_errorMessage != null) {
                        setState(() => _errorMessage = null);
                      }
                    },
                    onSubmitted: (_) => _joinRoom(),
                  ),
                ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.2),

                if (_errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AppTheme.syntaxRed,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _errorMessage!,
                        style: AppTheme.bodyStyle.copyWith(
                          color: AppTheme.syntaxRed,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ).animate().shake(),
                ],

                const SizedBox(height: 32),

                // Info Box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.idePanel.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.neonBlue.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppTheme.neonBlue,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Ask the host for the 6-character room code',
                          style: AppTheme.bodyStyle.copyWith(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate(delay: 800.ms).fadeIn(),

                const Spacer(),

                // Join Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isJoining ? null : _joinRoom,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.neonPurple.withValues(alpha: 0.2),
                      foregroundColor: AppTheme.neonPurple,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: AppTheme.neonPurple, width: 2),
                      ),
                    ),
                    child: _isJoining
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppTheme.neonPurple,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.login, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'JOIN ROOM',
                                style: AppTheme.bodyStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                  ),
                ).animate(delay: 1000.ms).fadeIn().slideY(begin: 0.3),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
