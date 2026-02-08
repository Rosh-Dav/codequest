import 'dart:async';
import 'dart:math';
import '../../models/multiplayer/room.dart';
import '../../models/multiplayer/quiz_question.dart';

/// Mock API service for multiplayer Quest mode
/// Simulates backend REST API calls with delays
class MockQuestApi {
  static final MockQuestApi _instance = MockQuestApi._internal();
  factory MockQuestApi() => _instance;
  MockQuestApi._internal();

  final Random _random = Random();
  final Map<String, Room> _rooms = {};

  /// Generate a random 6-character room code
  String _generateRoomCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    return List.generate(6, (_) => chars[_random.nextInt(chars.length)]).join();
  }

  /// Create a new room
  Future<Room> createRoom({
    required String hostId,
    required String hostName,
    required String mode,
    int maxPlayers = 6,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay

    final roomCode = _generateRoomCode();
    final host = Player(
      id: hostId,
      name: hostName,
      isHost: true,
      isReady: true,
    );

    final room = Room(
      id: roomCode,
      hostId: hostId,
      mode: mode,
      status: 'waiting',
      players: [host],
      maxPlayers: maxPlayers,
      createdAt: DateTime.now(),
    );

    _rooms[roomCode] = room;
    return room;
  }

  /// Join an existing room
  Future<Room> joinRoom({
    required String roomCode,
    required String playerId,
    required String playerName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final room = _rooms[roomCode];
    if (room == null) {
      throw Exception('Room not found');
    }

    if (room.isFull) {
      throw Exception('Room is full');
    }

    if (room.status != 'waiting') {
      throw Exception('Game already started');
    }

    final player = Player(
      id: playerId,
      name: playerName,
      isHost: false,
      isReady: false,
    );

    final updatedPlayers = [...room.players, player];
    final updatedRoom = room.copyWith(players: updatedPlayers);
    _rooms[roomCode] = updatedRoom;

    return updatedRoom;
  }

  /// Leave a room
  Future<void> leaveRoom({
    required String roomCode,
    required String playerId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final room = _rooms[roomCode];
    if (room == null) return;

    final updatedPlayers = room.players.where((p) => p.id != playerId).toList();
    
    if (updatedPlayers.isEmpty) {
      _rooms.remove(roomCode);
    } else {
      _rooms[roomCode] = room.copyWith(players: updatedPlayers);
    }
  }

  /// Get room details
  Future<Room?> getRoom(String roomCode) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _rooms[roomCode];
  }

  /// Start the game
  Future<Room> startGame(String roomCode) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final room = _rooms[roomCode];
    if (room == null) {
      throw Exception('Room not found');
    }

    if (!room.canStart) {
      throw Exception('Cannot start game');
    }

    final updatedRoom = room.copyWith(status: 'active');
    _rooms[roomCode] = updatedRoom;

    return updatedRoom;
  }

  /// Fetch quiz questions
  Future<List<QuizQuestion>> getQuestions({
    required String mode,
    int count = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    return _getMockQuestions(mode: mode, count: count);
  }

  /// Submit an answer
  Future<Map<String, dynamic>> submitAnswer({
    required String roomCode,
    required String playerId,
    required String questionId,
    required int answer,
    required double timeTaken,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    // Calculate score based on time
    int points = 0;
    if (timeTaken <= 5) {
      points = 100;
    } else if (timeTaken <= 10) {
      points = 70;
    } else if (timeTaken <= 15) {
      points = 40;
    }

    return {
      'correct': true, // Mock - always correct for now
      'points': points,
      'timeTaken': timeTaken,
    };
  }

  /// Get mock questions based on difficulty
  List<QuizQuestion> _getMockQuestions({
    required String mode,
    required int count,
  }) {
    final questions = <QuizQuestion>[];
    
    for (int i = 0; i < count; i++) {
      if (mode == 'easy') {
        questions.add(_getEasyQuestion(i));
      } else if (mode == 'medium') {
        questions.add(_getMediumQuestion(i));
      } else {
        questions.add(_getHardQuestion(i));
      }
    }

    return questions;
  }

  QuizQuestion _getEasyQuestion(int index) {
    final easyQuestions = [
      QuizQuestion(
        id: 'easy_$index',
        question: 'What is the output of print(2 + 2)?',
        options: ['3', '4', '22', 'Error'],
        correctAnswer: 1,
        difficulty: 'easy',
        category: 'python',
      ),
      QuizQuestion(
        id: 'easy_${index}_2',
        question: 'Which keyword is used to define a function in Python?',
        options: ['func', 'def', 'function', 'define'],
        correctAnswer: 1,
        difficulty: 'easy',
        category: 'python',
      ),
      QuizQuestion(
        id: 'easy_${index}_3',
        question: 'What is the correct file extension for Python files?',
        options: ['.pt', '.py', '.python', '.pyt'],
        correctAnswer: 1,
        difficulty: 'easy',
        category: 'python',
      ),
    ];
    return easyQuestions[index % easyQuestions.length];
  }

  QuizQuestion _getMediumQuestion(int index) {
    final mediumQuestions = [
      QuizQuestion(
        id: 'medium_$index',
        question: 'What is the time complexity of binary search?',
        options: ['O(n)', 'O(log n)', 'O(n²)', 'O(1)'],
        correctAnswer: 1,
        difficulty: 'medium',
        category: 'general',
      ),
      QuizQuestion(
        id: 'medium_${index}_2',
        question: 'Which data structure uses LIFO?',
        options: ['Queue', 'Stack', 'Array', 'Tree'],
        correctAnswer: 1,
        difficulty: 'medium',
        category: 'general',
      ),
    ];
    return mediumQuestions[index % mediumQuestions.length];
  }

  QuizQuestion _getHardQuestion(int index) {
    final hardQuestions = [
      QuizQuestion(
        id: 'hard_$index',
        question: 'What is the space complexity of merge sort?',
        options: ['O(1)', 'O(log n)', 'O(n)', 'O(n log n)'],
        correctAnswer: 2,
        difficulty: 'hard',
        category: 'general',
      ),
      QuizQuestion(
        id: 'hard_${index}_2',
        question: 'Which algorithm is used for finding shortest path in weighted graphs?',
        options: ['BFS', 'DFS', 'Dijkstra', 'Binary Search'],
        correctAnswer: 2,
        difficulty: 'hard',
        category: 'general',
      ),
    ];
    return hardQuestions[index % hardQuestions.length];
  }
}
