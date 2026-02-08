class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswer; // 0-3 index
  final String difficulty; // 'easy', 'medium', 'hard'
  final String category; // 'python', 'c', 'general'

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.difficulty,
    this.category = 'general',
  });

  bool isCorrect(int selectedIndex) => selectedIndex == correctAnswer;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'difficulty': difficulty,
      'category': category,
    };
  }

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correctAnswer'],
      difficulty: json['difficulty'],
      category: json['category'] ?? 'general',
    );
  }
}
