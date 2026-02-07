import 'dart:async';
import 'dart:collection';
import 'package:flutter_tts/flutter_tts.dart';

class DialogueQueue {
  final FlutterTts _tts;
  final Queue<String> _queue = Queue<String>();
  bool _isPlaying = false;
  Completer<void>? _currentCompleter;
  
  DialogueQueue(this._tts);

  void add(String text) {
    _queue.add(text);
    if (!_isPlaying) {
      _playNext();
    }
  }
  
  void clear() {
    _queue.clear();
    _tts.stop();
    _isPlaying = false;
    if (_currentCompleter != null && !_currentCompleter!.isCompleted) {
        _currentCompleter!.complete();
    }
    _currentCompleter = null;
  }

  Future<void> _playNext() async {
    if (_queue.isEmpty) {
      _isPlaying = false;
      return;
    }
    
    _isPlaying = true;
    final text = _queue.removeFirst();
    _currentCompleter = Completer<void>();
    
    // Set completion handler for THIS utterance
    _tts.setCompletionHandler(() {
      if (_currentCompleter != null && !_currentCompleter!.isCompleted) {
        _currentCompleter!.complete();
      }
    });

    await _tts.speak(text);
    
    // Wait for completion handler
    await _currentCompleter!.future;
    
    _playNext();
  }
  
  bool get isPlaying => _isPlaying;
}
