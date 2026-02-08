class Room {
  final String id;
  final String hostId;
  final String mode; // 'easy', 'medium', 'hard'
  final String status; // 'waiting', 'active', 'ended'
  final List<Player> players;
  final int maxPlayers;
  final DateTime createdAt;

  Room({
    required this.id,
    required this.hostId,
    required this.mode,
    required this.status,
    required this.players,
    this.maxPlayers = 6,
    required this.createdAt,
  });

  bool get isFull => players.length >= maxPlayers;
  bool get canStart => players.length >= 2 && status == 'waiting';

  Room copyWith({
    String? id,
    String? hostId,
    String? mode,
    String? status,
    List<Player>? players,
    int? maxPlayers,
    DateTime? createdAt,
  }) {
    return Room(
      id: id ?? this.id,
      hostId: hostId ?? this.hostId,
      mode: mode ?? this.mode,
      status: status ?? this.status,
      players: players ?? this.players,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hostId': hostId,
      'mode': mode,
      'status': status,
      'players': players.map((p) => p.toJson()).toList(),
      'maxPlayers': maxPlayers,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      // Handle both camelCase (frontend) and snake_case (backend)
      hostId: json['hostId'] ?? json['host_id'],
      mode: json['mode'],
      status: json['status'],
      players: (json['players'] as List)
          .map((p) => Player.fromJson(p))
          .toList(),
      maxPlayers: json['maxPlayers'] ?? json['max_players'] ?? 6,
      createdAt: DateTime.parse(json['createdAt'] ?? json['created_at']),
    );
  }

}

class Player {
  final String id;
  final String name;
  final int score;
  final bool isReady;
  final bool isHost;

  Player({
    required this.id,
    required this.name,
    this.score = 0,
    this.isReady = false,
    this.isHost = false,
  });

  Player copyWith({
    String? id,
    String? name,
    int? score,
    bool? isReady,
    bool? isHost,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      score: score ?? this.score,
      isReady: isReady ?? this.isReady,
      isHost: isHost ?? this.isHost,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'score': score,
      'isReady': isReady,
      'isHost': isHost,
    };
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      score: json['score'] ?? 0,
      // Handle both camelCase (frontend) and snake_case (backend)
      isReady: json['isReady'] ?? json['is_ready'] ?? false,
      isHost: json['isHost'] ?? json['is_host'] ?? false,
    );
  }

}
