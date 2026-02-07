class LevelModel {
  final int id;
  final String title;
  final String route;
  bool isUnlocked;
  bool isCompleted;

  LevelModel({
    required this.id,
    required this.title,
    required this.route,
    this.isUnlocked = false,
    this.isCompleted = false,
  });

  // Serialization for saving/loading if needed (though we might just save IDs)
  Map<String, dynamic> toJson() => {
    'id': id,
    'isUnlocked': isUnlocked,
    'isCompleted': isCompleted,
  };
}
