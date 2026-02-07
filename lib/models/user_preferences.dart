class UserPreferences {
  final String? selectedLanguage;
  final String? selectedStoryMode;
  final bool onboardingCompleted;
  final String? username;

  UserPreferences({
    this.selectedLanguage,
    this.selectedStoryMode,
    this.onboardingCompleted = false,
    this.username,
  });

  UserPreferences copyWith({
    String? selectedLanguage,
    String? selectedStoryMode,
    bool? onboardingCompleted,
    String? username,
  }) {
    return UserPreferences(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      selectedStoryMode: selectedStoryMode ?? this.selectedStoryMode,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      username: username ?? this.username,
    );
  }
}
