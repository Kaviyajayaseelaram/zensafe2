class UserProfile {
  final String id;
  final String name;
  final int age;
  final DateTime? dateJoined;
  final int xp;
  final int streak;
  final int level;
  final List<String> badges;
  final Map<String, dynamic> settings;

  const UserProfile({
    required this.id,
    required this.name,
    required this.age,
    this.dateJoined,
    this.xp = 0,
    this.streak = 0,
    this.level = 1,
    this.badges = const [],
    this.settings = const {},
  });

  UserProfile copyWith({
    String? id,
    String? name,
    int? age,
    DateTime? dateJoined,
    int? xp,
    int? streak,
    int? level,
    List<String>? badges,
    Map<String, dynamic>? settings,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      dateJoined: dateJoined ?? this.dateJoined,
      xp: xp ?? this.xp,
      streak: streak ?? this.streak,
      level: level ?? this.level,
      badges: badges ?? this.badges,
      settings: settings ?? this.settings,
    );
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String,
      name: (map['name'] ?? '') as String,
      age: (map['age'] ?? 0) as int,
      dateJoined: map['date_joined'] != null
          ? DateTime.tryParse(map['date_joined'] as String)
          : null,
      xp: (map['xp'] ?? 0) as int,
      streak: (map['streak'] ?? 0) as int,
      level: (map['level'] ?? 1) as int,
      badges: List<String>.from(map['badges'] ?? []),
      settings: Map<String, dynamic>.from(map['settings'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'date_joined': dateJoined?.toIso8601String(),
      'xp': xp,
      'streak': streak,
      'level': level,
      'badges': badges,
      'settings': settings,
    };
  }
}

