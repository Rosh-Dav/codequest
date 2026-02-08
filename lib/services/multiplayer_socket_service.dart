import 'package:socket_io_client/socket_io_client.dart' as IO;

class MultiplayerSocketService {
  IO.Socket? _socket;
  bool _isConnected = false;
  
  // Callbacks for events
  Function()? onConnect;
  Function(dynamic)? onPlayerJoined;
  Function(dynamic)? onPlayerLeft;
  Function(dynamic)? onGameStarted;
  Function(dynamic)? onQuestionSent;
  Function(dynamic)? onTimerUpdate;
  Function(dynamic)? onAnswerReceived;
  Function(dynamic)? onScoreUpdate;
  Function(dynamic)? onGameFinished;
  Function(String)? onError;
  
  bool get isConnected => _isConnected;
  
  void connect(String token) {
    if (_socket != null && _isConnected) {
      print('Socket already connected');
      return;
    }
    
    _socket = IO.io(
      'http://localhost:8000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .build(),
    );
    
    _setupEventListeners();
    _socket!.connect();
  }
  
  void _setupEventListeners() {
    _socket!.onConnect((_) {
      print('✅ Connected to Socket.IO server');
      _isConnected = true;
      onConnect?.call();
    });
    
    _socket!.onDisconnect((_) {
      print('❌ Disconnected from Socket.IO server');
      _isConnected = false;
    });
    
    _socket!.on('connect_error', (data) {
      print('❌ Connection error: $data');
      onError?.call('Connection error: $data');
    });
    
    _socket!.on('error', (data) {
      print('❌ Socket error: $data');
      onError?.call('Socket error: $data');
    });
    
    // Game events
    _socket!.on('player_joined', (data) {
      print('👤 Player joined: $data');
      onPlayerJoined?.call(data);
    });
    
    _socket!.on('player_left', (data) {
      print('👋 Player left: $data');
      onPlayerLeft?.call(data);
    });
    
    _socket!.on('game_started', (data) {
      print('🎮 Game started: $data');
      onGameStarted?.call(data);
    });
    
    _socket!.on('question_sent', (data) {
      print('❓ Question sent: $data');
      onQuestionSent?.call(data);
    });
    
    _socket!.on('timer_update', (data) {
      print('⏱️ Timer update: $data');
      onTimerUpdate?.call(data);
    });
    
    _socket!.on('answer_received', (data) {
      print('✅ Answer received: $data');
      onAnswerReceived?.call(data);
    });
    
    _socket!.on('score_update', (data) {
      print('🏆 Score update: $data');
      onScoreUpdate?.call(data);
    });
    
    _socket!.on('game_finished', (data) {
      print('🎉 Game finished: $data');
      onGameFinished?.call(data);
    });
  }
  
  // Emit events to server
  void joinRoom(String roomId, String token) {
    if (!_isConnected) {
      print('❌ Cannot join room: Not connected');
      return;
    }
    
    print('📤 Joining room: $roomId');
    _socket!.emit('join_room', {
      'room_id': roomId,
      'token': token,
    });
  }
  
  void leaveRoom(String roomId) {
    if (!_isConnected) {
      print('❌ Cannot leave room: Not connected');
      return;
    }
    
    print('📤 Leaving room: $roomId');
    _socket!.emit('leave_room', {
      'room_id': roomId,
    });
  }
  
  void submitAnswer({
    required String gameId,
    required String questionId,
    required int answer,
    required double timeTaken,
  }) {
    if (!_isConnected) {
      print('❌ Cannot submit answer: Not connected');
      return;
    }
    
    print('📤 Submitting answer: Q$questionId = $answer (${timeTaken}s)');
    _socket!.emit('submit_answer', {
      'game_id': gameId,
      'question_id': questionId,
      'answer': answer,
      'time_taken': timeTaken,
    });
  }
  
  void disconnect() {
    if (_socket != null) {
      print('🔌 Disconnecting socket');
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
      _isConnected = false;
    }
  }
  
  // Clear all callbacks
  void clearCallbacks() {
    onConnect = null;
    onPlayerJoined = null;
    onPlayerLeft = null;
    onGameStarted = null;
    onQuestionSent = null;
    onTimerUpdate = null;
    onAnswerReceived = null;
    onScoreUpdate = null;
    onGameFinished = null;
    onError = null;
  }
}
