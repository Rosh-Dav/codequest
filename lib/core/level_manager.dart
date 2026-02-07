import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/level_model.dart';

class LevelManager extends ChangeNotifier {
  static final LevelManager _instance = LevelManager._internal();
  factory LevelManager() => _instance;
  LevelManager._internal();

  List<LevelModel> _levels = [
    LevelModel(id: 1, title: "First Signal", route: '/story/python/mission1', isUnlocked: true),
    LevelModel(id: 2, title: "Energy Labeling", route: '/story/python/mission2'),
    LevelModel(id: 3, title: "Signal Formats", route: '/story/python/mission3'),
    LevelModel(id: 4, title: "Command Receiver", route: '/story/python/mission4'),
    LevelModel(id: 5, title: "Data Converter", route: '/story/python/mission5'),
    LevelModel(id: 6, title: "Math Core", route: '/story/python/mission6'),
    LevelModel(id: 7, title: "Engineer Notes", route: '/story/python/mission7'),
    LevelModel(id: 8, title: "Alignment System", route: '/story/python/mission8'), 
    LevelModel(id: 9, title: "Decision Unit", route: '/story/python/mission9'),
    LevelModel(id: 10, title: "Auto-Repeater", route: '/story/python/mission10'),
    LevelModel(id: 11, title: "Continuous Monitor", route: '/story/python/mission11'),
  ];

  List<LevelModel> get levels => _levels;

  double get progress {
    int completed = _levels.where((l) => l.isCompleted).length;
    return completed / _levels.length;
  }

  Future<void> init() async {
    await _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    for (var level in _levels) {
      level.isUnlocked = prefs.getBool('level_${level.id}_unlocked') ?? (level.id == 1);
      level.isCompleted = prefs.getBool('level_${level.id}_completed') ?? false;
    }
    notifyListeners();
  }

  Future<void> completeLevel(int id) async {
    final index = _levels.indexWhere((l) => l.id == id);
    if (index == -1) return;

    _levels[index].isCompleted = true;
    
    // Unlock next level
    if (index + 1 < _levels.length) {
      _levels[index + 1].isUnlocked = true;
    }

    await _saveProgress();
    notifyListeners();
  }
  
  // Debug/Dev tool
  Future<void> unlockAll() async {
     for (var level in _levels) {
       level.isUnlocked = true;
     }
     await _saveProgress();
     notifyListeners();
  }
  
  Future<void> resetProgress() async {
     for (var level in _levels) {
       level.isUnlocked = (level.id == 1);
       level.isCompleted = false;
     }
     await _saveProgress();
     notifyListeners();
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    for (var level in _levels) {
      await prefs.setBool('level_${level.id}_unlocked', level.isUnlocked);
      await prefs.setBool('level_${level.id}_completed', level.isCompleted);
    }
  }
}
