import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/theme.dart';
import '../../models/multiplayer/room.dart';
import '../../models/multiplayer/game_state.dart';
import '../../models/multiplayer/quiz_question.dart';
import '../../services/multiplayer/quest_service.dart';
import 'results_screen.dart';

class QuizGameplayScreen extends StatefulWidget {
  final Room room;
  final String currentUserId;

  const QuizGameplayScreen({
    super.key,
    required this.room,
    required this.currentUserId,
  });

  @override
  State<QuizGameplayScreen> createState() => _QuizGameplayScreenState();
}

class _QuizGameplayScreenState extends State<QuizGameplayScreen> {
  final QuestService _questService = QuestService();
  GameState _gameState = GameState();
  List<QuizQuestion> _questions = [];
  int? _selectedAnswer;

  @override
  void initState() {
    super.initState();
    _listenToGameState();
  }

  void _listenToGameState() {
    _questService.gameStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _gameState = state;
          _questions = _questService.questions;
          
          // Reset selection for new question
          if (state.currentQuestionIndex != _gameState.currentQuestionIndex) {
            _selectedAnswer = null;
          }
        });

        // Navigate to results when game ends
        if (state.isEnded) {
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultsScreen(
                    room: widget.room,
                    gameState: _gameState,
                    currentUserId: widget.currentUserId,
                  ),
                ),
              );
            }
          });
        }
      }
    });
  }

  Future<void> _submitAnswer(int answerIndex) async {
    if (!_gameState.canAnswer || _selectedAnswer != null) return;

    setState(() => _selectedAnswer = answerIndex);

    await _questService.submitAnswer(
      answerIndex: answerIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty || _gameState.currentQuestionIndex >= _questions.length) {
      return const Scaffold(
        backgroundColor: AppTheme.darkBackground,
        body: Center(
          child: CircularProgressIndicator(color: AppTheme.neonBlue),
        ),
      );
    }

    final currentQuestion = _questions[_gameState.currentQuestionIndex];
    final progress = (_gameState.currentQuestionIndex + 1) / _gameState.totalQuestions;

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
                    // Question Progress
                    Text(
                      'Question ${_gameState.currentQuestionIndex + 1}/${_gameState.totalQuestions}',
                      style: AppTheme.bodyStyle.copyWith(
                        color: AppTheme.neonPurple,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    // Score
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.neonBlue.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.neonBlue),
                      ),
                      child: Text(
                        '${_gameState.playerScores[widget.currentUserId] ?? 0} pts',
                        style: AppTheme.bodyStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.neonBlue,
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(),

                const SizedBox(height: 16),

                // Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: AppTheme.idePanel,
                    valueColor: const AlwaysStoppedAnimation(AppTheme.neonPurple),
                  ),
                ).animate(delay: 200.ms).fadeIn(),

                const SizedBox(height: 32),

                // Timer
                Center(
                  child: _buildTimer(),
                ).animate(delay: 400.ms).fadeIn().scale(),

                const SizedBox(height: 32),

                // Question
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.idePanel.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.neonBlue.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    currentQuestion.question,
                    style: AppTheme.bodyStyle.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ).animate(delay: 600.ms).fadeIn().slideY(begin: -0.2),

                const SizedBox(height: 32),

                // Answer Options
                Expanded(
                  child: ListView.builder(
                    itemCount: currentQuestion.options.length,
                    itemBuilder: (context, index) {
                      return _buildAnswerButton(
                        currentQuestion.options[index],
                        index,
                        currentQuestion.correctAnswer,
                      ).animate(delay: Duration(milliseconds: 800 + (index * 100)))
                          .fadeIn()
                          .slideX(begin: 0.2);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimer() {
    final timeRemaining = _gameState.timeRemaining;
    final color = timeRemaining > 10
        ? AppTheme.syntaxGreen
        : timeRemaining > 5
            ? AppTheme.syntaxYellow
            : AppTheme.syntaxRed;

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 4),
        color: color.withValues(alpha: 0.1),
      ),
      child: Center(
        child: Text(
          timeRemaining.toString(),
          style: AppTheme.headingStyle.copyWith(
            fontSize: 40,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerButton(String text, int index, int correctIndex) {
    final isSelected = _selectedAnswer == index;
    final hasAnswered = _gameState.hasAnswered;
    final isCorrect = index == correctIndex;

    Color borderColor = AppTheme.neonBlue.withValues(alpha: 0.3);
    Color backgroundColor = AppTheme.idePanel.withValues(alpha: 0.5);

    if (hasAnswered) {
      if (isSelected) {
        if (isCorrect) {
          borderColor = AppTheme.syntaxGreen;
          backgroundColor = AppTheme.syntaxGreen.withValues(alpha: 0.2);
        } else {
          borderColor = AppTheme.syntaxRed;
          backgroundColor = AppTheme.syntaxRed.withValues(alpha: 0.2);
        }
      } else if (isCorrect) {
        borderColor = AppTheme.syntaxGreen;
        backgroundColor = AppTheme.syntaxGreen.withValues(alpha: 0.1);
      }
    } else if (isSelected) {
      borderColor = AppTheme.neonBlue;
      backgroundColor = AppTheme.neonBlue.withValues(alpha: 0.2);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton(
        onPressed: hasAnswered ? null : () => _submitAnswer(index),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: borderColor, width: 2),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: 2),
                color: isSelected ? borderColor.withValues(alpha: 0.3) : Colors.transparent,
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + index), // A, B, C, D
                  style: AppTheme.bodyStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: borderColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: AppTheme.bodyStyle.copyWith(
                  fontSize: 16,
                ),
              ),
            ),
            if (hasAnswered && isCorrect)
              const Icon(Icons.check_circle, color: AppTheme.syntaxGreen),
            if (hasAnswered && isSelected && !isCorrect)
              const Icon(Icons.cancel, color: AppTheme.syntaxRed),
          ],
        ),
      ),
    );
  }
}
