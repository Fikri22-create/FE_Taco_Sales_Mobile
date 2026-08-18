class AppNotification {
  final String id;
  final String title;
  final String? subtitle;
  final String? body;
  final NotificationType type;
  final NotificationPriority priority;
  final bool isRead;
  final bool isActionable;
  final DateTime timestamp;
  final DateTime? expiresAt;
  final String? actionUrl;
  final String? actionText;
  final Map<String, dynamic>? metadata;
  final String? senderId;
  final String? senderName;
  final List<String> tags;
  final String? actionData;

  AppNotification({
    required this.id,
    required this.title,
    this.subtitle,
    this.body,
    required this.type,
    required this.priority,
    required this.isRead,
    required this.isActionable,
    required this.timestamp,
    this.expiresAt,
    this.actionUrl,
    this.actionText,
    this.metadata,
    this.senderId,
    this.actionData,
    this.senderName,
    required this.tags,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      body: json['body'],
      type: NotificationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NotificationType.system,
      ),
      priority: NotificationPriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => NotificationPriority.medium,
      ),
      isRead: json['isRead'],
      isActionable: json['isActionable'],
      timestamp: DateTime.parse(json['timestamp']),
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'])
          : null,
      actionUrl: json['actionUrl'],
      actionText: json['actionText'],
      metadata: json['metadata'] != null
          ? Map<String, dynamic>.from(json['metadata'])
          : null,
      senderId: json['senderId'],
      senderName: json['senderName'],
      tags: List<String>.from(json['tags']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'body': body,
      'type': type.name,
      'priority': priority.name,
      'isRead': isRead,
      'isActionable': isActionable,
      'timestamp': timestamp.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'actionUrl': actionUrl,
      'actionText': actionText,
      'metadata': metadata,
      'senderId': senderId,
      'senderName': senderName,
      'tags': tags,
    };
  }
}

class AppNotificationSummary {
  final int totalNotifications;
  final int unreadCount;
  final AppNotification? latestNotification;
  final Map<NotificationType, int> countsByType;
  final DateTime lastChecked;

  AppNotificationSummary({
    required this.totalNotifications,
    required this.unreadCount,
    this.latestNotification,
    required this.countsByType,
    required this.lastChecked,
  });

  factory AppNotificationSummary.fromJson(Map<String, dynamic> json) {
    return AppNotificationSummary(
      totalNotifications: json['totalNotifications'],
      unreadCount: json['unreadCount'],
      latestNotification: json['latestNotification'] != null
          ? AppNotification.fromJson(json['latestNotification'])
          : null,
      countsByType: Map<NotificationType, int>.from(
        (json['countsByType'] as Map).map(
          (k, v) => MapEntry(
            NotificationType.values.firstWhere(
              (e) => e.name == k,
              orElse: () => NotificationType.system,
            ),
            v as int,
          ),
        ),
      ),
      lastChecked: DateTime.parse(json['lastChecked']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalNotifications': totalNotifications,
      'unreadCount': unreadCount,
      'latestNotification': latestNotification?.toJson(),
      'countsByType': countsByType.map((k, v) => MapEntry(k.name, v)),
      'lastChecked': lastChecked.toIso8601String(),
    };
  }
}

enum NotificationType {
  system,
  report,
  achievement,
  streak,
  leaderboard,
  reminder,
  announcement,
  alert,
  feedback,
  badge,
  point,
  actionData,
}

enum NotificationPriority { low, medium, high, critical }

class AppNotificationPreferences {
  final bool receiveReportNotifications;
  final bool receiveAchievementNotifications;
  final bool receiveStreakNotifications;
  final bool receiveLeaderboardNotifications;
  final bool receiveReminderNotifications;
  final bool receiveAnnouncements;
  final bool receiveAlerts;
  final bool receiveFeedback;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final List<String> quietHours;
  final List<String> preferredChannels;

  AppNotificationPreferences({
    required this.receiveReportNotifications,
    required this.receiveAchievementNotifications,
    required this.receiveStreakNotifications,
    required this.receiveLeaderboardNotifications,
    required this.receiveReminderNotifications,
    required this.receiveAnnouncements,
    required this.receiveAlerts,
    required this.receiveFeedback,
    required this.soundEnabled,
    required this.vibrationEnabled,
    required this.quietHours,
    required this.preferredChannels,
  });

  factory AppNotificationPreferences.fromJson(Map<String, dynamic> json) {
    return AppNotificationPreferences(
      receiveReportNotifications: json['receiveReportNotifications'],
      receiveAchievementNotifications: json['receiveAchievementNotifications'],
      receiveStreakNotifications: json['receiveStreakNotifications'],
      receiveLeaderboardNotifications: json['receiveLeaderboardNotifications'],
      receiveReminderNotifications: json['receiveReminderNotifications'],
      receiveAnnouncements: json['receiveAnnouncements'],
      receiveAlerts: json['receiveAlerts'],
      receiveFeedback: json['receiveFeedback'],
      soundEnabled: json['soundEnabled'],
      vibrationEnabled: json['vibrationEnabled'],
      quietHours: List<String>.from(json['quietHours']),
      preferredChannels: List<String>.from(json['preferredChannels']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'receiveReportNotifications': receiveReportNotifications,
      'receiveAchievementNotifications': receiveAchievementNotifications,
      'receiveStreakNotifications': receiveStreakNotifications,
      'receiveLeaderboardNotifications': receiveLeaderboardNotifications,
      'receiveReminderNotifications': receiveReminderNotifications,
      'receiveAnnouncements': receiveAnnouncements,
      'receiveAlerts': receiveAlerts,
      'receiveFeedback': receiveFeedback,
      'soundEnabled': soundEnabled,
      'vibrationEnabled': vibrationEnabled,
      'quietHours': quietHours,
      'preferredChannels': preferredChannels,
    };
  }
}
