import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  static final GeminiService _instance = GeminiService._internal();
  factory GeminiService() => _instance;
  GeminiService._internal();

  GenerativeModel? _model;
  ChatSession? _chatSession;

  // Initialize with API Key
  void init(String apiKey) {
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
    );
    _startChat();
  }

  void _startChat() {
    if (_model == null) return;
    _chatSession = _model!.startChat(history: [
      Content.text('You are NOVA, an advanced AI learning assistant for the ByteStar Arena game. '
          'Your goal is to help players learn C programming. '
          'Keep your answers concise, encouraging, and technically accurate. '
          'You are a female AI character with a helpful but slightly strict personality. '
          'Always stay in character.'),
    ]);
  }

  // Generate explanation for specific code concept
  Future<String> explainConcept(String concept) async {
    if (_model == null) return "I'm offline right now. Check your API connection.";
    
    try {
      final response = await _chatSession?.sendMessage(
        Content.text('Explain this programming concept briefly: $concept')
      );
      return response?.text ?? "I couldn't process that data.";
    } catch (e) {
      return "Error accessing data banks: $e";
    }
  }

  // Get hint for a specific task
  Future<String> getHint(String taskDescription, String currentCode) async {
    if (_model == null) return "I'm offline right now.";

    try {
      final response = await _chatSession?.sendMessage(
        Content.text('The user is stuck on this task: "$taskDescription".\n'
            'Their current code is:\n```c\n$currentCode\n```\n'
            'Give a helpful hint without giving away the direct answer.')
      );
      return response?.text ?? "I can't analyze the code right now.";
    } catch (e) {
      return "Analysis failed: $e";
    }
  }
  
  // Freeform chat
  Future<String> chat(String message) async {
    if (_model == null) return "I'm offline.";
     try {
      final response = await _chatSession?.sendMessage(Content.text(message));
      return response?.text ?? "...";
    } catch (e) {
      return "Connection error.";
    }
  }
}
