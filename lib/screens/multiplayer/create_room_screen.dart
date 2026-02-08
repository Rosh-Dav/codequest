import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/theme.dart';
import '../../services/multiplayer/quest_service.dart';
import '../../services/local_storage_service.dart';
import 'lobby_screen.dart';

class CreateRoomScreen extends StatefulWidget {
  final String difficulty;

  const CreateRoomScreen({
    super.key,
    required this.difficulty,
  });

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final QuestService _questService = QuestService();
  final LocalStorageService _storage = LocalStorageService();
  
  int _maxPlayers = 6;
  bool _isCreating = false;

  @override
  void initState() {
    super.initState();
    // Initialize quest service with user auth in _createRoom
  }

  Future<void> _createRoom() async {
    setState(() => _isCreating = true);

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

      final room = await _questService.createRoom(
        mode: widget.difficulty,
        maxPlayers: _maxPlayers,
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create room: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCreating = false);
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
                  'CREATE ROOM',
                  style: AppTheme.headingStyle.copyWith(
                    fontSize: 40,
                    letterSpacing: 3,
                  ),
                ).animate().fadeIn().slideY(begin: -0.2),

                const SizedBox(height: 8),

                Text(
                  'Set up your multiplayer quiz room',
                  style: AppTheme.bodyStyle.copyWith(
                    color: AppTheme.syntaxComment,
                  ),
                ).animate(delay: 200.ms).fadeIn(),

                const SizedBox(height: 40),

                // Difficulty Display
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.idePanel.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getDifficultyColor().withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.speed,
                        color: _getDifficultyColor(),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'DIFFICULTY',
                            style: AppTheme.bodyStyle.copyWith(
                              fontSize: 11,
                              color: Colors.white60,
                            ),
                          ),
                          Text(
                            widget.difficulty.toUpperCase(),
                            style: AppTheme.bodyStyle.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: _getDifficultyColor(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).animate(delay: 400.ms).fadeIn().slideX(begin: -0.2),

                const SizedBox(height: 32),

                // Max Players Slider
                Text(
                  'MAX PLAYERS',
                  style: AppTheme.bodyStyle.copyWith(
                    color: AppTheme.neonPurple,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontSize: 12,
                  ),
                ).animate(delay: 600.ms).fadeIn(),

                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.idePanel.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.neonBlue.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '2',
                            style: AppTheme.bodyStyle.copyWith(
                              color: Colors.white60,
                            ),
                          ),
                          Text(
                            _maxPlayers.toString(),
                            style: AppTheme.headingStyle.copyWith(
                              fontSize: 32,
                              color: AppTheme.neonBlue,
                            ),
                          ),
                          Text(
                            '6',
                            style: AppTheme.bodyStyle.copyWith(
                              color: Colors.white60,
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: _maxPlayers.toDouble(),
                        min: 2,
                        max: 6,
                        divisions: 4,
                        activeColor: AppTheme.neonBlue,
                        inactiveColor: AppTheme.neonBlue.withValues(alpha: 0.2),
                        onChanged: (value) {
                          setState(() => _maxPlayers = value.toInt());
                        },
                      ),
                    ],
                  ),
                ).animate(delay: 800.ms).fadeIn().slideX(begin: 0.2),

                const Spacer(),

                // Create Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isCreating ? null : _createRoom,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.neonBlue.withValues(alpha: 0.2),
                      foregroundColor: AppTheme.neonBlue,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: AppTheme.neonBlue, width: 2),
                      ),
                    ),
                    child: _isCreating
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppTheme.neonBlue,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.rocket_launch, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'CREATE ROOM',
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

  Color _getDifficultyColor() {
    switch (widget.difficulty) {
      case 'easy':
        return AppTheme.syntaxGreen;
      case 'hard':
        return AppTheme.syntaxRed;
      default:
        return AppTheme.syntaxYellow;
    }
  }
}
