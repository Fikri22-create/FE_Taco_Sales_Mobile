class Badge {
  final String id;
  final String name;
  final String description;
  final String icon;
  final BadgeCategory category;
  final BadgeTier tier;
  final int requiredProgress;
  final int progress;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final List<BadgeRequirement> requirements;

  Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.category,
    required this.tier,
    required this.requiredProgress,
    required this.progress,
    required this.isUnlocked,
    this.unlockedAt,
    required this.requirements,
  });

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      category: BadgeCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => BadgeCategory.activity,
      ),
      tier: BadgeTier.values.firstWhere(
        (e) => e.name == json['tier'],
        orElse: () => BadgeTier.bronze,
      ),
      requiredProgress: json['requiredProgress'],
      progress: json['progress'],
      isUnlocked: json['isUnlocked'],
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'])
          : null,
      requirements: (json['requirements'] as List)
          .map((item) => BadgeRequirement.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'category': category.name,
      'tier': tier.name,
      'requiredProgress': requiredProgress,
      'progress': progress,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'requirements': requirements.map((e) => e.toJson()).toList(),
    };
  }
}

class BadgeRequirement {
  final String metric;
  final int targetValue;
  final int currentValue;
  final String unit;
  final DateTime? completedAt;

  BadgeRequirement({
    required this.metric,
    required this.targetValue,
    required this.currentValue,
    required this.unit,
    this.completedAt,
  });

  factory BadgeRequirement.fromJson(Map<String, dynamic> json) {
    return BadgeRequirement(
      metric: json['metric'],
      targetValue: json['targetValue'],
      currentValue: json['currentValue'],
      unit: json['unit'],
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'metric': metric,
      'targetValue': targetValue,
      'currentValue': currentValue,
      'unit': unit,
      'completedAt': completedAt?.toIso8601String(),
    };
  }
}

class StreakData {
  final int currentStreak;
  final int bestStreak;
  final List<StreakDay> streakDays;
  final String streakType;
  final DateTime streakStarted;
  final DateTime? streakBrokenAt;
  final StreakStats stats;

  StreakData({
    required this.currentStreak,
    required this.bestStreak,
    required this.streakDays,
    required this.streakType,
    required this.streakStarted,
    this.streakBrokenAt,
    required this.stats,
  });

  factory StreakData.fromJson(Map<String, dynamic> json) {
    return StreakData(
      currentStreak: json['currentStreak'],
      bestStreak: json['bestStreak'],
      streakDays: (json['streakDays'] as List)
          .map((item) => StreakDay.fromJson(item))
          .toList(),
      streakType: json['streakType'],
      streakStarted: DateTime.parse(json['streakStarted']),
      streakBrokenAt: json['streakBrokenAt'] != null
          ? DateTime.parse(json['streakBrokenAt'])
          : null,
      stats: StreakStats.fromJson(json['stats']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentStreak': currentStreak,
      'bestStreak': bestStreak,
      'streakDays': streakDays.map((e) => e.toJson()).toList(),
      'streakType': streakType,
      'streakStarted': streakStarted.toIso8601String(),
      'streakBrokenAt': streakBrokenAt?.toIso8601String(),
      'stats': stats.toJson(),
    };
  }
}

class StreakDay {
  final DateTime date;
  final bool completed;
  final int pointsEarned;
  final String? activityType;

  StreakDay({
    required this.date,
    required this.completed,
    required this.pointsEarned,
    this.activityType,
  });

  factory StreakDay.fromJson(Map<String, dynamic> json) {
    return StreakDay(
      date: DateTime.parse(json['date']),
      completed: json['completed'],
      pointsEarned: json['pointsEarned'],
      activityType: json['activityType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'completed': completed,
      'pointsEarned': pointsEarned,
      'activityType': activityType,
    };
  }
}

class StreakStats {
  final int totalDaysWithActivity;
  final int totalPointsFromStreak;
  final double averageDailyActivity;
  final List<String> streakMilestones;

  StreakStats({
    required this.totalDaysWithActivity,
    required this.totalPointsFromStreak,
    required this.averageDailyActivity,
    required this.streakMilestones,
  });

  factory StreakStats.fromJson(Map<String, dynamic> json) {
    return StreakStats(
      totalDaysWithActivity: json['totalDaysWithActivity'],
      totalPointsFromStreak: json['totalPointsFromStreak'],
      averageDailyActivity: (json['averageDailyActivity'] as num).toDouble(),
      streakMilestones: List<String>.from(json['streakMilestones']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalDaysWithActivity': totalDaysWithActivity,
      'totalPointsFromStreak': totalPointsFromStreak,
      'averageDailyActivity': averageDailyActivity,
      'streakMilestones': streakMilestones,
    };
  }
}

class LeaderboardEntry {
  final String userId;
  final String userName;
  final String? avatarUrl;
  final int rank;
  final int points;
  final int reportsThisWeek;
  final double averageScore;
  final int streakDays;
  final String region;
  final List<String> activeBadges;
  final bool isCurrentUser;

  LeaderboardEntry({
    required this.userId,
    required this.userName,
    this.avatarUrl,
    required this.rank,
    required this.points,
    required this.reportsThisWeek,
    required this.averageScore,
    required this.streakDays,
    required this.region,
    required this.activeBadges,
    required this.isCurrentUser,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      userId: json['userId'],
      userName: json['userName'],
      avatarUrl: json['avatarUrl'],
      rank: json['rank'],
      points: json['points'],
      reportsThisWeek: json['reportsThisWeek'],
      averageScore: (json['averageScore'] as num).toDouble(),
      streakDays: json['streakDays'],
      region: json['region'],
      activeBadges: List<String>.from(json['activeBadges']),
      isCurrentUser: json['isCurrentUser'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'avatarUrl': avatarUrl,
      'rank': rank,
      'points': points,
      'reportsThisWeek': reportsThisWeek,
      'averageScore': averageScore,
      'streakDays': streakDays,
      'region': region,
      'activeBadges': activeBadges,
      'isCurrentUser': isCurrentUser,
    };
  }
}

class PointTransaction {
  final String id;
  final int amount;
  final PointTransactionType type;
  final String description;
  final DateTime timestamp;
  final String? relatedEntityId;
  final String? relatedEntityType;

  PointTransaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.description,
    required this.timestamp,
    this.relatedEntityId,
    this.relatedEntityType,
  });

  factory PointTransaction.fromJson(Map<String, dynamic> json) {
    return PointTransaction(
      id: json['id'],
      amount: json['amount'],
      type: PointTransactionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => PointTransactionType.report,
      ),
      description: json['description'],
      timestamp: DateTime.parse(json['timestamp']),
      relatedEntityId: json['relatedEntityId'],
      relatedEntityType: json['relatedEntityType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'type': type.name,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'relatedEntityId': relatedEntityId,
      'relatedEntityType': relatedEntityType,
    };
  }
}

enum BadgeCategory {
  activity,
  quality,
  consistency,
  speed,
  discovery,
  specialization,
  achievement,
}

enum BadgeTier {
  bronze,
  silver,
  gold,
  platinum,
  diamond,
}

enum PointTransactionType {
  report,
  streak,
  badge,
  bonus,
  achievement,
  referral,
  correction,
}