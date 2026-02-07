class StoryState {
  final bool storyStarted;
  final int currentPhase;
  final int currentMission;
  final List<String> completedMissions;

  StoryState({
    this.storyStarted = false,
    this.currentPhase = 1,
    this.currentMission = 1,
    this.completedMissions = const [],
  });

  StoryState copyWith({
    bool? storyStarted,
    int? currentPhase,
    int? currentMission,
    List<String>? completedMissions,
  }) {
    return StoryState(
      storyStarted: storyStarted ?? this.storyStarted,
      currentPhase: currentPhase ?? this.currentPhase,
      currentMission: currentMission ?? this.currentMission,
      completedMissions: completedMissions ?? this.completedMissions,
    );
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'storyStarted': storyStarted,
      'currentPhase': currentPhase,
      'currentMission': currentMission,
      'completedMissions': completedMissions,
    };
  }

  // Create from JSON
  factory StoryState.fromJson(Map<String, dynamic> json) {
    return StoryState(
      storyStarted: json['storyStarted'] ?? false,
      currentPhase: json['currentPhase'] ?? 1,
      currentMission: json['currentMission'] ?? 1,
      completedMissions: List<String>.from(json['completedMissions'] ?? []),
    );
  }
}
