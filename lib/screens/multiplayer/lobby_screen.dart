import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/theme.dart';
import '../../models/multiplayer/room.dart';
import '../../services/multiplayer/quest_service.dart';
import 'quiz_gameplay_screen.dart';

class LobbyScreen extends StatefulWidget {
  final Room room;
  final String currentUserId;

  const LobbyScreen({
    super.key,
    required this.room,
    required this.currentUserId,
  });

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  final QuestService _questService = QuestService();
  late Room _currentRoom;
  bool _isStarting = false;

  @override
  void initState() {
    super.initState();
    _currentRoom = widget.room;
    _listenToRoomUpdates();
  }

  void _listenToRoomUpdates() {
    _questService.roomStream.listen((room) {
      if (mounted && room.id == _currentRoom.id) {
        setState(() => _currentRoom = room);
        
        // Navigate to game if started
        if (room.status == 'active' && !_isStarting) {
          _navigateToGame();
        }
      }
    });
  }

  void _navigateToGame() {
    setState(() => _isStarting = true);
    
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => QuizGameplayScreen(
              room: _currentRoom,
              currentUserId: widget.currentUserId,
            ),
          ),
        );
      }
    });
  }

  Future<void> _startGame() async {
    if (!_isHost || _currentRoom.players.length < 2) return;

    setState(() => _isStarting = true);

    try {
      await _questService.startGame();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to start game: $e')),
        );
        setState(() => _isStarting = false);
      }
    }
  }

  Future<void> _leaveRoom() async {
    await _questService.leaveRoom();
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _copyRoomCode() {
    Clipboard.setData(ClipboardData(text: _currentRoom.id));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Room code copied to clipboard!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  bool get _isHost => widget.currentUserId == _currentRoom.hostId;

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
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'LOBBY',
                      style: AppTheme.headingStyle.copyWith(
                        fontSize: 32,
                        letterSpacing: 3,
                      ),
                    ).animate().fadeIn(),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppTheme.syntaxRed),
                      onPressed: _leaveRoom,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Room Code Display
                GestureDetector(
                  onTap: _copyRoomCode,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.idePanel.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.neonBlue.withValues(alpha: 0.5),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ROOM CODE',
                              style: AppTheme.bodyStyle.copyWith(
                                fontSize: 11,
                                color: Colors.white60,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _currentRoom.id,
                              style: AppTheme.headingStyle.copyWith(
                                fontSize: 28,
                                letterSpacing: 4,
                                color: AppTheme.neonBlue,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.copy,
                          color: AppTheme.neonBlue,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ).animate(delay: 200.ms).fadeIn().slideX(begin: -0.2),

                const SizedBox(height: 24),

                // Players Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'PLAYERS (${_currentRoom.players.length}/${_currentRoom.maxPlayers})',
                      style: AppTheme.bodyStyle.copyWith(
                        color: AppTheme.neonPurple,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        fontSize: 12,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getDifficultyColor().withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _getDifficultyColor(),
                        ),
                      ),
                      child: Text(
                        _currentRoom.mode.toUpperCase(),
                        style: AppTheme.bodyStyle.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _getDifficultyColor(),
                        ),
                      ),
                    ),
                  ],
                ).animate(delay: 400.ms).fadeIn(),

                const SizedBox(height: 16),

                // Players List
                Expanded(
                  child: ListView.builder(
                    itemCount: _currentRoom.players.length,
                    itemBuilder: (context, index) {
                      final player = _currentRoom.players[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.idePanel.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: player.isHost
                                ? AppTheme.neonBlue.withValues(alpha: 0.5)
                                : Colors.white10,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Avatar
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppTheme.neonBlue.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppTheme.neonBlue,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  player.name[0].toUpperCase(),
                                  style: AppTheme.headingStyle.copyWith(
                                    fontSize: 20,
                                    color: AppTheme.neonBlue,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Name
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    player.name,
                                    style: AppTheme.bodyStyle.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  if (player.isHost)
                                    Text(
                                      'HOST',
                                      style: AppTheme.bodyStyle.copyWith(
                                        fontSize: 11,
                                        color: AppTheme.neonBlue,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            // Ready indicator
                            if (player.isReady)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.syntaxGreen.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'READY',
                                  style: AppTheme.bodyStyle.copyWith(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.syntaxGreen,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ).animate(delay: Duration(milliseconds: 600 + (index * 100)))
                          .fadeIn()
                          .slideX(begin: 0.2);
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Start/Wait Button
                if (_isHost)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (_currentRoom.canStart && !_isStarting)
                          ? _startGame
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.neonBlue.withValues(alpha: 0.2),
                        foregroundColor: AppTheme.neonBlue,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: AppTheme.neonBlue, width: 2),
                        ),
                        disabledBackgroundColor: Colors.white10,
                        disabledForegroundColor: Colors.white30,
                      ),
                      child: _isStarting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppTheme.neonBlue,
                              ),
                            )
                          : Text(
                              _currentRoom.players.length < 2
                                  ? 'WAITING FOR PLAYERS...'
                                  : 'START GAME',
                              style: AppTheme.bodyStyle.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 1.5,
                              ),
                            ),
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      color: AppTheme.idePanel.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.neonPurple.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      _isStarting
                          ? 'STARTING GAME...'
                          : 'WAITING FOR HOST TO START...',
                      textAlign: TextAlign.center,
                      style: AppTheme.bodyStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: 1.5,
                        color: AppTheme.neonPurple,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getDifficultyColor() {
    switch (_currentRoom.mode) {
      case 'easy':
        return AppTheme.syntaxGreen;
      case 'hard':
        return AppTheme.syntaxRed;
      default:
        return AppTheme.syntaxYellow;
    }
  }
}
