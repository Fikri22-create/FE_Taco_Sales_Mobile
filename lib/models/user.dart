class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final String region;
  final String salesCode;
  final int totalPoints;
  final int currentStreak;
  final int bestStreak;
  final int totalReports;
  final DateTime joinedDate;
  final DateTime lastActive;
  final UserStats stats;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.region,
    required this.salesCode,
    required this.totalPoints,
    required this.currentStreak,
    required this.bestStreak,
    required this.totalReports,
    required this.joinedDate,
    required this.lastActive,
    required this.stats,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      avatarUrl: json['avatarUrl'],
      region: json['region'],
      salesCode: json['salesCode'],
      totalPoints: json['totalPoints'],
      currentStreak: json['currentStreak'],
      bestStreak: json['bestStreak'],
      totalReports: json['totalReports'],
      joinedDate: DateTime.parse(json['joinedDate']),
      lastActive: DateTime.parse(json['lastActive']),
      stats: UserStats.fromJson(json['stats']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'region': region,
      'salesCode': salesCode,
      'totalPoints': totalPoints,
      'currentStreak': currentStreak,
      'bestStreak': bestStreak,
      'totalReports': totalReports,
      'joinedDate': joinedDate.toIso8601String(),
      'lastActive': lastActive.toIso8601String(),
      'stats': stats.toJson(),
    };
  }
}

class UserStats {
  final int reportsThisWeek;
  final int reportsThisMonth;
  final double averageReportQuality;
  final double averageResponseTime;
  final int completedObjectives;
  final int totalObjectives;
  final int voiceReports;
  final int textReports;
  final double dailyProductivity;

  UserStats({
    required this.reportsThisWeek,
    required this.reportsThisMonth,
    required this.averageReportQuality,
    required this.averageResponseTime,
    required this.completedObjectives,
    required this.totalObjectives,
    required this.voiceReports,
    required this.textReports,
    required this.dailyProductivity,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      reportsThisWeek: json['reportsThisWeek'],
      reportsThisMonth: json['reportsThisMonth'],
      averageReportQuality: (json['averageReportQuality'] as num).toDouble(),
      averageResponseTime: (json['averageResponseTime'] as num).toDouble(),
      completedObjectives: json['completedObjectives'],
      totalObjectives: json['totalObjectives'],
      voiceReports: json['voiceReports'],
      textReports: json['textReports'],
      dailyProductivity: (json['dailyProductivity'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reportsThisWeek': reportsThisWeek,
      'reportsThisMonth': reportsThisMonth,
      'averageReportQuality': averageReportQuality,
      'averageResponseTime': averageResponseTime,
      'completedObjectives': completedObjectives,
      'totalObjectives': totalObjectives,
      'voiceReports': voiceReports,
      'textReports': textReports,
      'dailyProductivity': dailyProductivity,
    };
  }
}