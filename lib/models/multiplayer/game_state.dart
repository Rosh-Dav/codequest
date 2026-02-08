enum GameStatus {
  waiting,
  starting,
  inProgress,
  questionTransition,
  ended,
}

class GameState {
  final GameStatus status;
  final int currentQuestionIndex;
  final int totalQuestions;
  final int timeRemaining; // seconds
  final bool hasAnswered;
  final int? selectedAnswer;
  final Map<String, int> playerScores;

  GameState({
    this.status = GameStatus.waiting,
    this.currentQuestionIndex = 0,
    this.totalQuestions = 10,
    this.timeRemaining = 15,
    this.hasAnswered = false,
    this.selectedAnswer,
    this.playerScores = const {},
  });

  bool get isActive => status == GameStatus.inProgress;
  bool get isEnded => status == GameStatus.ended;
  bool get canAnswer => isActive && !hasAnswered && timeRemaining > 0;
  
  double get progress => totalQuestions > 0 
      ? currentQuestionIndex / totalQuestions 
      : 0.0;

  GameState copyWith({
    GameStatus? status,
    int? currentQuestionIndex,
    int? totalQuestions,
    int? timeRemaining,
    bool? hasAnswered,
    int? selectedAnswer,
    Map<String, int>? playerScores,
  }) {
    return GameState(
      status: status ?? this.status,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      hasAnswered: hasAnswered ?? this.hasAnswered,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      playerScores: playerScores ?? this.playerScores,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.toString(),
      'currentQuestionIndex': currentQuestionIndex,
      'totalQuestions': totalQuestions,
      'timeRemaining': timeRemaining,
      'hasAnswered': hasAnswered,
      'selectedAnswer': selectedAnswer,
      'playerScores': playerScores,
    };
  }

  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      status: GameStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => GameStatus.waiting,
      ),
      currentQuestionIndex: json['currentQuestionIndex'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 10,
      timeRemaining: json['timeRemaining'] ?? 15,
      hasAnswered: json['hasAnswered'] ?? false,
      selectedAnswer: json['selectedAnswer'],
      playerScores: Map<String, int>.from(json['playerScores'] ?? {}),
    );
  }
}
