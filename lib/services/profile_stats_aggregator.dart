import 'package:shared_preferences/shared_preferences.dart';
import 'bytestar/reward_service.dart';
import '../services/local_storage_service.dart';
import '../services/story_state_service.dart';

class ProfileStats {
  final int totalXp;
  final int level;
  final double levelProgress;
  final int missionsCompleted;
  final Map<String, int> missionsPerStory;
  final Map<String, double> languageExperience; // 0.0 to 1.0 for Python vs C
  final List<String> badges;

  ProfileStats({
    required this.totalXp,
    required this.level,
    required this.levelProgress,
    required this.missionsCompleted,
    required this.missionsPerStory,
    required this.languageExperience,
    required this.badges,
  });
}

class ProfileStatsAggregator {
  final RewardService _rewardService = RewardService();
  final LocalStorageService _storage = LocalStorageService();

  Future<ProfileStats> aggregate() async {
    final prefs = await SharedPreferences.getInstance();
    
    // 1. Basic Stats from RewardService
    final totalXp = await _rewardService.getXp();
    final level = await _rewardService.getLevel();
    final levelProgress = await _rewardService.getXpProgress();
    final badges = await _rewardService.getBadges();

    // 2. Story Progress
    final storyService = StoryStateService();
    await storyService.init();
    
    // ByteStar missions (Max mission - 1 is a good estimate if it's sequential)
    final byteStarMissions = storyService.maxMission - 1;
    
    final missionsPerStory = {
      'ByteStar Arena': byteStarMissions,
      'Rune City': 0, // Still placeholder until integrated
    };

    // 3. Language Experience
    // Use actual XP to determine language weight if available
    final totalXpInStory = storyService.xp;
    
    final languageExperience = {
      'Python': totalXpInStory > 0 ? 0.9 : 0.1, // Placeholder logic but tied to real XP
      'C': 0.1,
    };

    return ProfileStats(
      totalXp: totalXp,
      level: level,
      levelProgress: levelProgress,
      missionsCompleted: byteStarMissions,
      missionsPerStory: missionsPerStory,
      languageExperience: languageExperience,
      badges: badges,
    );
  }
}
