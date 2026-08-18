import 'package:flutter/foundation.dart';

import '../../data/mock_data.dart';
import '../../models/app_notification.dart';
import '../../models/gamification.dart';
import '../../models/outlet.dart';
import '../../models/report.dart';
import '../../models/user.dart';
import '../services/mock_api_service.dart';

class AppState extends ChangeNotifier {
  AppState() {
    _user = MockData.currentUser;
    _reports = List.of(MockData.reports);
    _notifications = List.of(MockData.notifications);
    _pointTransactions = List.of(MockData.pointTransactions);
    _preferences = AppNotificationPreferences(
      receiveReportNotifications: true,
      receiveAchievementNotifications: true,
      receiveStreakNotifications: true,
      receiveLeaderboardNotifications: true,
      receiveReminderNotifications: true,
      receiveAnnouncements: true,
      receiveAlerts: true,
      receiveFeedback: true,
      soundEnabled: true,
      vibrationEnabled: true,
      quietHours: const [],
      preferredChannels: const ['push'],
    );
    _leaderboard = List.of(MockData.leaderboardEntries);
  }

  late User _user;
  late List<Report> _reports;
  late List<AppNotification> _notifications;
  late List<PointTransaction> _pointTransactions;
  late AppNotificationPreferences _preferences;
  late List<LeaderboardEntry> _leaderboard;

  User get user => _user;

  List<Report> get reports {
    final sorted = List<Report>.of(_reports)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return List.unmodifiable(sorted);
  }

  List<AppNotification> get notifications {
    final sorted = List<AppNotification>.of(_notifications)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return List.unmodifiable(sorted);
  }

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  List<PointTransaction> get pointTransactions {
    final sorted = List<PointTransaction>.of(_pointTransactions)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return List.unmodifiable(sorted);
  }

  List<LeaderboardEntry> get leaderboardByPoints {
    final sorted = List<LeaderboardEntry>.of(_leaderboard)
      ..sort((a, b) => b.points.compareTo(a.points));
    return _ranked(sorted);
  }

  List<LeaderboardEntry> get leaderboardByQuality {
    final sorted = List<LeaderboardEntry>.of(_leaderboard)
      ..sort((a, b) => b.averageScore.compareTo(a.averageScore));
    return _ranked(sorted);
  }

  AppNotificationPreferences get preferences => _preferences;

  bool get isOfflineSimulated => MockApiService.simulateOffline;

  Report addReport({
    required Outlet outlet,
    required String content,
    required ReportInputType inputType,
    required List<CompetitorSignal> signals,
    required AIAnalysis aiAnalysis,
  }) {
    final now = DateTime.now();

    var reportNumber = _reports.length + 1;
    var reportId = 'report_${reportNumber.toString().padLeft(3, '0')}';
    while (_reports.any((r) => r.id == reportId)) {
      reportNumber++;
      reportId = 'report_${reportNumber.toString().padLeft(3, '0')}';
    }

    final confidenceScore = signals.isEmpty
        ? 0.0
        : signals.map((s) => s.confidence).reduce((a, b) => a + b) /
              signals.length;
    final pointsEarned = 15 + 5 * signals.length;
    final confidence = signals.any((s) => s.confidence >= 0.9)
        ? ReportConfidence.high
        : ReportConfidence.medium;

    final report = Report(
      id: reportId,
      userId: _user.id,
      userName: _user.name,
      outletId: outlet.id,
      outletName: outlet.name,
      inputType: inputType,
      content: content,
      extractedEntities: signals.map((s) => s.brand).toList(),
      competitorSignals: List.of(signals),
      aiAnalysis: aiAnalysis,
      status: ReportStatus.completed,
      confidence: confidence,
      confidenceScore: confidenceScore,
      createdAt: now,
      processedAt: now,
      confirmedAt: now,
      pointsEarned: pointsEarned,
      tags: signals.map((s) => s.signalType).toList(),
      attachments: const [],
      metadata: ReportMetadata(
        wordCount: content.split(RegExp(r'\s+')).length,
        characterCount: content.length,
        processingTimeSeconds: 45,
        validationWarnings: const [],
        isVerified: true,
        verificationDate: now,
        verifiedBy: 'ai_system',
      ),
    );

    _reports.insert(0, report);

    final stats = _user.stats;
    final wasActiveYesterday = _isYesterday(_user.lastActive);
    final newStreak = wasActiveYesterday
        ? _user.currentStreak + 1
        : _user.currentStreak;
    final isVoice = inputType == ReportInputType.voice;

    _user = _user.copyWith(
      totalPoints: _user.totalPoints + pointsEarned,
      currentStreak: newStreak,
      bestStreak: newStreak > _user.bestStreak ? newStreak : _user.bestStreak,
      totalReports: _user.totalReports + 1,
      lastActive: now,
      stats: UserStats(
        reportsThisWeek: stats.reportsThisWeek + 1,
        reportsThisMonth: stats.reportsThisMonth + 1,
        averageReportQuality: stats.averageReportQuality,
        averageResponseTime: stats.averageResponseTime,
        completedObjectives: stats.completedObjectives,
        totalObjectives: stats.totalObjectives,
        voiceReports: stats.voiceReports + (isVoice ? 1 : 0),
        textReports: stats.textReports + (isVoice ? 0 : 1),
        dailyProductivity: stats.dailyProductivity,
      ),
    );

    _pointTransactions.insert(
      0,
      PointTransaction(
        id: 'txn_${(_pointTransactions.length + 1).toString().padLeft(3, '0')}',
        amount: pointsEarned,
        type: PointTransactionType.report,
        description: 'Laporan ${outlet.name}',
        timestamp: now,
        relatedEntityId: report.id,
        relatedEntityType: 'report',
      ),
    );

    _notifications.insert(
      0,
      AppNotification(
        id: 'notif_${(_notifications.length + 1).toString().padLeft(3, '0')}',
        title: 'Laporan Diproses',
        subtitle: outlet.name,
        body:
            'Laporan Anda dari ${outlet.name} telah diproses dan mendapatkan $pointsEarned poin.',
        type: NotificationType.report,
        priority: NotificationPriority.medium,
        isRead: false,
        isActionable: true,
        timestamp: now,
        actionUrl: '/history',
        actionText: 'Lihat Riwayat',
        tags: const ['report', 'points'],
      ),
    );

    final leaderboardIndex = _leaderboard.indexWhere(
      (e) => e.userId == _user.id,
    );
    if (leaderboardIndex != -1) {
      final entry = _leaderboard[leaderboardIndex];
      final existingWeekCount = entry.reportsThisWeek;
      final newQuality = (report.confidenceScore ?? 0.0) * 10;
      final newAverageScore = existingWeekCount > 0
          ? (entry.averageScore * existingWeekCount + newQuality) /
                (existingWeekCount + 1)
          : newQuality;
      _leaderboard[leaderboardIndex] = LeaderboardEntry(
        userId: entry.userId,
        userName: _user.name,
        avatarUrl: _user.avatarUrl,
        rank: entry.rank,
        points: entry.points + pointsEarned,
        reportsThisWeek: existingWeekCount + 1,
        averageScore: newAverageScore,
        streakDays: entry.streakDays,
        region: entry.region,
        activeBadges: entry.activeBadges,
        isCurrentUser: true,
      );
    }

    notifyListeners();
    return report;
  }

  void markNotificationRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index == -1 || _notifications[index].isRead) return;
    _notifications[index] = _copyNotification(
      _notifications[index],
      isRead: true,
    );
    notifyListeners();
  }

  void markAllNotificationsRead() {
    if (_notifications.every((n) => n.isRead)) return;
    _notifications = _notifications
        .map((n) => n.isRead ? n : _copyNotification(n, isRead: true))
        .toList();
    notifyListeners();
  }

  void clearNotifications() {
    if (_notifications.isEmpty) return;
    _notifications.clear();
    notifyListeners();
  }

  void updatePreferences(AppNotificationPreferences prefs) {
    _preferences = prefs;
    notifyListeners();
  }

  void updateProfile({
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
  }) {
    _user = _user.copyWith(
      name: name,
      email: email,
      phone: phone,
      avatarUrl: avatarUrl,
    );
    notifyListeners();
  }

  void setOfflineSimulation(bool value) {
    if (MockApiService.simulateOffline == value) return;
    MockApiService.simulateOffline = value;
    notifyListeners();
  }

  List<LeaderboardEntry> _ranked(List<LeaderboardEntry> entries) {
    return List.unmodifiable(
      List.generate(entries.length, (i) => _withRank(entries[i], i + 1)),
    );
  }

  LeaderboardEntry _withRank(LeaderboardEntry entry, int rank) {
    return LeaderboardEntry(
      userId: entry.userId,
      userName: entry.userName,
      avatarUrl: entry.avatarUrl,
      rank: rank,
      points: entry.points,
      reportsThisWeek: entry.reportsThisWeek,
      averageScore: entry.averageScore,
      streakDays: entry.streakDays,
      region: entry.region,
      activeBadges: entry.activeBadges,
      isCurrentUser: entry.isCurrentUser,
    );
  }

  AppNotification _copyNotification(AppNotification n, {bool? isRead}) {
    return AppNotification(
      id: n.id,
      title: n.title,
      subtitle: n.subtitle,
      body: n.body,
      type: n.type,
      priority: n.priority,
      isRead: isRead ?? n.isRead,
      isActionable: n.isActionable,
      timestamp: n.timestamp,
      expiresAt: n.expiresAt,
      actionUrl: n.actionUrl,
      actionText: n.actionText,
      metadata: n.metadata,
      senderId: n.senderId,
      senderName: n.senderName,
      tags: n.tags,
      actionData: n.actionData,
    );
  }

  bool _isYesterday(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final other = DateTime(date.year, date.month, date.day);
    return today.difference(other).inDays == 1;
  }
}
