import 'dart:async';
import '../../models/multiplayer/room.dart';
import '../../models/multiplayer/quiz_question.dart';
import '../../models/multiplayer/game_state.dart';
import '../multiplayer_api_service.dart';
import '../multiplayer_socket_service.dart';
import '../local_storage_service.dart';


/// Quest service - coordinates game logic between real backend API and Socket.IO
class QuestService {
  static final QuestService _instance = QuestService._internal();
  factory QuestService() => _instance;
  QuestService._internal();

  final MultiplayerApiService _api = MultiplayerApiService();
  final MultiplayerSocketService _socket = MultiplayerSocketService();

  Room? _currentRoom;
  List<QuizQuestion> _questions = [];
  GameState _gameState = GameState();
  String? _currentGameId;
  String? _currentUserId;

  Room? get currentRoom => _currentRoom;
  List<QuizQuestion> get questions => _questions;
  GameState get gameState => _gameState;

  final StreamController<Room> _roomController =
      StreamController<Room>.broadcast();
  final StreamController<GameState> _gameStateController =
      StreamController<GameState>.broadcast();

  Stream<Room> get roomStream => _roomController.stream;
  Stream<GameState> get gameStateStream => _gameStateController.stream;

  /// Initialize the service with user authentication
  Future<void> init(String userId, String token) async {
    _currentUserId = userId;
    _api.setToken(token);
    _socket.connect(token);
    _setupSocketListeners();
  }

  /// Setup Socket.IO event listeners
  void _setupSocketListeners() {
    _socket.onConnect = () {
      print('✅ Quest Service: Socket connected');
    };

    _socket.onPlayerJoined = (data) {
      print('👤 Player joined: $data');
      if (_currentRoom != null) {
        final player = Player.fromJson(data['player']);
        _currentRoom = _currentRoom!.copyWith(
          players: [..._currentRoom!.players, player],
        );
        _roomController.add(_currentRoom!);
      }
    };

    _socket.onPlayerLeft = (data) {
      print('👋 Player left: $data');
      if (_currentRoom != null) {
        final playerId = data['player_id'];
        _currentRoom = _currentRoom!.copyWith(
          players: _currentRoom!.players.where((p) => p.id != playerId).toList(),
        );
        _roomController.add(_currentRoom!);
      }
    };

    _socket.onGameStarted = (data) {
      print('🎮 Game started: $data');
      _currentGameId = data['game_id'];
      _gameState = _gameState.copyWith(
        status: GameStatus.starting,
        totalQuestions: data['total_questions'] ?? 10,
      );
      _gameStateController.add(_gameState);
    };

    _socket.onQuestionSent = (data) {
      print('❓ Question received: $data');
      final questionIndex = data['question_index'];
      final questionData = data['question'];
      final timeLimit = data['time_limit'] ?? 15;

      // Add question to list if not already there
      if (questionIndex >= _questions.length) {
        _questions.add(QuizQuestion.fromJson(questionData));
      }

      _gameState = _gameState.copyWith(
        status: GameStatus.inProgress,
        currentQuestionIndex: questionIndex,
        timeRemaining: timeLimit,
        hasAnswered: false,
        selectedAnswer: null,
      );
      _gameStateController.add(_gameState);
    };

    _socket.onTimerUpdate = (data) {
      final timeRemaining = data['time_remaining'];
      _gameState = _gameState.copyWith(timeRemaining: timeRemaining);
      _gameStateController.add(_gameState);
    };

    _socket.onAnswerReceived = (data) {
      print('✅ Answer acknowledged: $data');
      // Server acknowledged our answer
    };

    _socket.onScoreUpdate = (data) {
      print('🏆 Score update: $data');
      final scores = Map<String, int>.from(data['scores']);
      _gameState = _gameState.copyWith(playerScores: scores);
      _gameStateController.add(_gameState);
    };

    _socket.onGameFinished = (data) {
      print('🎉 Game finished: $data');
      final scores = Map<String, int>.from(data['final_scores']);
      final winner = data['winner'];
      
      _gameState = _gameState.copyWith(
        status: GameStatus.ended,
        playerScores: scores,
      );
      _gameStateController.add(_gameState);
    };

    _socket.onError = (error) {
      print('❌ Socket error: $error');
    };
  }

  /// Create a new room
  Future<Room> createRoom({
    required String mode,
    int maxPlayers = 6,
  }) async {
    try {
      final response = await _api.createRoom(mode, maxPlayers);
      _currentRoom = Room.fromJson(response);
      
      // Join the room via socket
      _socket.joinRoom(_currentRoom!.id, _api.token!);
      
      _roomController.add(_currentRoom!);
      return _currentRoom!;
    } catch (e) {
      print('❌ Failed to create room: $e');
      rethrow;
    }
  }

  /// Join an existing room
  Future<Room> joinRoom({
    required String roomCode,
  }) async {
    try {
      final response = await _api.joinRoom(roomCode);
      _currentRoom = Room.fromJson(response);
      
      // Join the room via socket
      _socket.joinRoom(_currentRoom!.id, _api.token!);
      
      _roomController.add(_currentRoom!);
      return _currentRoom!;
    } catch (e) {
      print('❌ Failed to join room: $e');
      rethrow;
    }
  }

  /// Leave the current room
  Future<void> leaveRoom() async {
    if (_currentRoom == null) return;

    try {
      await _api.leaveRoom(_currentRoom!.id);
      _socket.leaveRoom(_currentRoom!.id);
      
      _currentRoom = null;
      _questions = [];
      _gameState = GameState();
      _currentGameId = null;
    } catch (e) {
      print('❌ Failed to leave room: $e');
      rethrow;
    }
  }

  /// Start the game (host only)
  Future<void> startGame() async {
    if (_currentRoom == null) return;

    try {
      final response = await _api.startGame(_currentRoom!.id);
      _currentGameId = response['game_id'];
      
      // The server will send game_started event via socket
      // which will be handled by the socket listener
    } catch (e) {
      print('❌ Failed to start game: $e');
      rethrow;
    }
  }

  /// Submit an answer
  Future<void> submitAnswer({
    required int answerIndex,
  }) async {
    if (!_gameState.canAnswer || _currentGameId == null) return;

    final timeTaken = 15 - _gameState.timeRemaining.toDouble();
    final question = _questions[_gameState.currentQuestionIndex];

    // Mark as answered locally to prevent double submission
    _gameState = _gameState.copyWith(
      hasAnswered: true,
      selectedAnswer: answerIndex,
    );
    _gameStateController.add(_gameState);

    // Submit to server
    _socket.submitAnswer(
      gameId: _currentGameId!,
      questionId: question.id,
      answer: answerIndex,
      timeTaken: timeTaken,
    );
  }

  /// Dispose the service
  void dispose() {
    _roomController.close();
    _gameStateController.close();
    _socket.disconnect();
    _socket.clearCallbacks();
  }
}
