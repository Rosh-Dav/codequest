import 'dart:async';
import '../../models/multiplayer/room.dart';

/// Mock Socket service for real-time multiplayer events
/// Simulates WebSocket/Socket.IO functionality
class MockSocketService {
  static final MockSocketService _instance = MockSocketService._internal();
  factory MockSocketService() => _instance;
  MockSocketService._internal();

  final StreamController<SocketEvent> _eventController =
      StreamController<SocketEvent>.broadcast();

  Stream<SocketEvent> get events => _eventController.stream;

  bool _connected = false;
  bool get isConnected => _connected;

  /// Connect to the socket server
  Future<void> connect() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _connected = true;
    _emitEvent(SocketEvent(type: SocketEventType.connected, data: {}));
  }

  /// Disconnect from the socket server
  Future<void> disconnect() async {
    _connected = false;
    _emitEvent(SocketEvent(type: SocketEventType.disconnected, data: {}));
  }

  /// Join a room
  void joinRoom(String roomCode) {
    _emitEvent(SocketEvent(
      type: SocketEventType.roomJoined,
      data: {'roomCode': roomCode},
    ));
  }

  /// Leave a room
  void leaveRoom(String roomCode) {
    _emitEvent(SocketEvent(
      type: SocketEventType.roomLeft,
      data: {'roomCode': roomCode},
    ));
  }

  /// Simulate player joining
  void simulatePlayerJoined(Player player) {
    _emitEvent(SocketEvent(
      type: SocketEventType.playerJoined,
      data: {'player': player.toJson()},
    ));
  }

  /// Simulate player leaving
  void simulatePlayerLeft(String playerId) {
    _emitEvent(SocketEvent(
      type: SocketEventType.playerLeft,
      data: {'playerId': playerId},
    ));
  }

  /// Simulate game starting
  void simulateGameStarted() {
    _emitEvent(SocketEvent(
      type: SocketEventType.gameStarted,
      data: {'message': 'Game is starting!'},
    ));
  }

  /// Simulate question sent
  void simulateQuestionSent(Map<String, dynamic> question) {
    _emitEvent(SocketEvent(
      type: SocketEventType.questionSent,
      data: question,
    ));
  }

  /// Simulate timer update
  void simulateTimerUpdate(int timeRemaining) {
    _emitEvent(SocketEvent(
      type: SocketEventType.timerUpdate,
      data: {'timeRemaining': timeRemaining},
    ));
  }

  /// Simulate answer received
  void simulateAnswerReceived(String playerId, bool correct) {
    _emitEvent(SocketEvent(
      type: SocketEventType.answerReceived,
      data: {'playerId': playerId, 'correct': correct},
    ));
  }

  /// Simulate score update
  void simulateScoreUpdate(Map<String, int> scores) {
    _emitEvent(SocketEvent(
      type: SocketEventType.scoreUpdated,
      data: {'scores': scores},
    ));
  }

  /// Simulate game finished
  void simulateGameFinished(Map<String, dynamic> results) {
    _emitEvent(SocketEvent(
      type: SocketEventType.gameFinished,
      data: results,
    ));
  }

  /// Emit an event to all listeners
  void _emitEvent(SocketEvent event) {
    if (!_eventController.isClosed) {
      _eventController.add(event);
    }
  }

  /// Dispose the service
  void dispose() {
    _eventController.close();
  }
}

/// Socket event types
enum SocketEventType {
  connected,
  disconnected,
  roomJoined,
  roomLeft,
  playerJoined,
  playerLeft,
  gameStarted,
  questionSent,
  timerUpdate,
  answerReceived,
  scoreUpdated,
  gameFinished,
  error,
}

/// Socket event model
class SocketEvent {
  final SocketEventType type;
  final Map<String, dynamic> data;

  SocketEvent({
    required this.type,
    required this.data,
  });
}
