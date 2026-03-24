import '../models/user_profile.dart';

class GamificationService {
  static const int dailyTarget = 20;

  static const levelThresholds = [
    (1, 0, 300),
    (2, 300, 700),
    (3, 700, 1500),
    (4, 1500, 3000),
  ];

  static int calculateLevel(int xp) {
    for (final (level, min, max) in levelThresholds) {
      if (xp >= min && xp < max) return level;
    }
    return levelThresholds.last.$1;
  }

  static List<String> evaluateBadges({
    required int xp,
    required int streak,
    required bool completedSafetyLesson,
    required bool completedWellness,
  }) {
    final badges = <String>[];
    if (streak >= 3) badges.add('3-day streak');
    if (streak >= 7) badges.add('7-day streak');
    if (xp >= 1000) badges.add('1000 XP');
    if (completedSafetyLesson) badges.add('First safety lesson');
    if (completedWellness) badges.add('First wellness activity');
    return badges;
  }

  static UserProfile applyXp({
    required UserProfile profile,
    required int delta,
    required bool completedSafetyLesson,
    required bool completedWellness,
  }) {
    final updatedXp = profile.xp + delta;
    final level = calculateLevel(updatedXp);
    final badges = evaluateBadges(
      xp: updatedXp,
      streak: profile.streak,
      completedSafetyLesson: completedSafetyLesson,
      completedWellness: completedWellness,
    );

    return profile.copyWith(
      xp: updatedXp,
      level: level,
      badges: badges,
    );
  }
}

