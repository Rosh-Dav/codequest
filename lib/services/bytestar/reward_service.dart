import 'package:shared_preferences/shared_preferences.dart';

class RewardService {
  static const String _xpKey = 'bytestar_xp';
  static const String _badgesKey = 'bytestar_badges';
  static const String _integrityKey = 'bytestar_integrity';

  Future<int> getXp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_xpKey) ?? 0;
  }

  Future<void> addXp(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    final currentXp = prefs.getInt(_xpKey) ?? 0;
    await prefs.setInt(_xpKey, currentXp + amount);
  }

  // Leveling Logic
  Future<int> getLevel() async {
    final xp = await getXp();
    return (xp / 500).floor() + 1;
  }

  Future<double> getXpProgress() async {
    final xp = await getXp();
    final xpInCurrentLevel = xp % 500;
    return xpInCurrentLevel / 500.0;
  }

  Future<int> getXpNeededForNextLevel() async {
    final xp = await getXp();
    return 500 - (xp % 500);
  }

  Future<List<String>> getBadges() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_badgesKey) ?? [];
  }

  Future<bool> unlockBadge(String badgeId) async {
    final prefs = await SharedPreferences.getInstance();
    final badges = prefs.getStringList(_badgesKey) ?? [];
    if (!badges.contains(badgeId)) {
      badges.add(badgeId);
      await prefs.setStringList(_badgesKey, badges);
      return true; // New badge unlocked
    }
    return false; // Already unlocked
  }

  Future<double> getShipIntegrity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_integrityKey) ?? 100.0;
  }
  
  Future<void> updateShipIntegrity(double value) async {
     final prefs = await SharedPreferences.getInstance();
     await prefs.setDouble(_integrityKey, value);
  }

  Future<void> resetRewards() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_xpKey);
    await prefs.remove(_badgesKey);
    await prefs.remove(_integrityKey);
  }
}

class BadgeData {
  final String id;
  final String name;
  final String description;
  final String iconAsset;

  const BadgeData({
    required this.id,
    required this.name,
    required this.description,
    required this.iconAsset,
  });

  static const List<BadgeData> allBadges = [
    BadgeData(id: 'first_steps', name: 'Cadet', description: 'Complete Mission 1', iconAsset: 'assets/badges/cadet.png'),
    BadgeData(id: 'syntax_survivor', name: 'Syntax Survivor', description: 'Complete 3 Missions without syntax errors', iconAsset: 'assets/badges/syntax.png'),
    BadgeData(id: 'loop_master', name: 'Loop Master', description: 'Master the loops', iconAsset: 'assets/badges/loop.png'),
    BadgeData(id: 'system_architect', name: 'System Architect', description: 'Complete all ByteStar Missions', iconAsset: 'assets/badges/architect.png'),
  ];
}
