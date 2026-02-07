import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';

class TTSService {
  static final TTSService _instance = TTSService._internal();
  factory TTSService() => _instance;
  TTSService._internal();

  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setPitch(1.2); // Sci-fi higher pitch for NOVA
      await _flutterTts.setSpeechRate(0.55); // Slightly faster
      
      // Handle completion
      _flutterTts.setCompletionHandler(() {
        debugPrint("TTS Complete");
      });

      _isInitialized = true;
    } catch (e) {
      debugPrint("TTS Init Error: $e");
    }
  }

  Future<void> speak(String text) async {
    if (text.isEmpty) return;
    try {
      await _flutterTts.stop(); // Stop previous
      await _flutterTts.speak(text);
    } catch (e) {
      debugPrint("TTS Speak Error: $e");
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
}
