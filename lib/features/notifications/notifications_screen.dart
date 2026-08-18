import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taco_sales_insight/core/services/mock_api_service.dart';
import 'package:taco_sales_insight/core/state/app_state.dart';
import 'package:taco_sales_insight/models/app_notification.dart';
import 'package:taco_sales_insight/shared/app_colors.dart';
import 'package:taco_sales_insight/shared/app_text_styles.dart';
import 'package:taco_sales_insight/shared/common_widgets.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

enum _LoadStatus { loading, loaded, error }

class _NotificationsScreenState extends State<NotificationsScreen> {
  _LoadStatus _status = _LoadStatus.loading;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (_status != _LoadStatus.loading) {
      setState(() {
        _status = _LoadStatus.loading;
        _errorMessage = null;
      });
    }
    try {
      await MockApiService.fetch(() {});
      if (!mounted) return;
      setState(() {
        _status = _LoadStatus.loaded;
      });
    } on MockApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _status = _LoadStatus.error;
        _errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final unreadCount = appState.unreadCount;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.background,
              AppColors.background.withValues(alpha: 0.5),
              Colors.white,
              AppColors.primary.withValues(alpha: 0.02),
            ],
            stops: const [0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Column(
          children: [
            _buildHeader(context, unreadCount),
            Expanded(child: _buildBody(appState)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int unreadCount) {
    return TacoPremiumHeader(
      title: 'Notifikasi',
      subtitle: unreadCount > 0
          ? '$unreadCount belum dibaca'
          : 'Semua sudah dibaca',
      showBackButton: Navigator.canPop(context),
      trailing: unreadCount > 0
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.25),
                  width: 1,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _markAllAsRead,
                  borderRadius: BorderRadius.circular(12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Iconsax.tick_circle,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Tandai Semua Dibaca',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildBody(AppState appState) {
    switch (_status) {
      case _LoadStatus.loading:
        return LoadingIndicator(message: 'Memuat notifikasi...');
      case _LoadStatus.error:
        if (appState.isOfflineSimulated) {
          return OfflineState(onRetry: _load);
        }
        return ErrorState(
          title: 'Gagal memuat notifikasi',
          subtitle: _errorMessage,
          onRetry: _load,
        );
      case _LoadStatus.loaded:
        if (appState.isOfflineSimulated) {
          return OfflineState(onRetry: _load);
        }
        return _buildLoadedBody(appState);
    }
  }

  Widget _buildLoadedBody(AppState appState) {
    final notifications = appState.notifications;
    final unreadCount = appState.unreadCount;
    final prefs = appState.preferences;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total',
                  '${notifications.length}',
                  AppColors.primary,
                  Iconsax.notification_copy,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Belum Dibaca',
                  '$unreadCount',
                  AppColors.error,
                  Iconsax.notification_bing_copy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SectionHeader(
            title: 'Notifikasi',
            subtitle: 'Ikuti pesan terbaru Anda',
          ),
          const SizedBox(height: 16),
          if (notifications.isEmpty)
            EmptyState(
              title: 'Belum Ada Notifikasi',
              subtitle: 'Semuanya sudah dibaca',
            )
          else
            Column(
              children: notifications.map(_buildNotificationItem).toList(),
            ),
          if (notifications.isNotEmpty) ...[
            const SizedBox(height: 24),
            TacoButton(
              text: 'Hapus Semua',
              onPressed: _showClearConfirmation,
              type: ButtonType.outline,
              isFullWidth: true,
              icon: const Icon(Iconsax.trash, size: 18),
            ),
          ],
          const SizedBox(height: 24),
          _buildSettingsSection(prefs),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.15), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.headlineMedium.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(AppNotification notification) {
    final data = _iconForType(notification.type);
    final isUnread = !notification.isRead;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: isUnread
              ? data.color.withValues(alpha: 0.05)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnread
                ? data.color.withValues(alpha: 0.15)
                : AppColors.border.withValues(alpha: 0.5),
            width: 1,
          ),
          boxShadow: [
            if (isUnread)
              BoxShadow(
                color: data.color.withValues(alpha: 0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            else
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _handleNotificationTap(notification),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [data.color, data.color.withValues(alpha: 0.7)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Icon(data.icon, size: 24, color: Colors.white),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                notification.title,
                                style: AppTextStyles.titleSmall.copyWith(
                                  fontWeight: isUnread
                                      ? FontWeight.w700
                                      : FontWeight.w600,
                                  color: isUnread
                                      ? data.color
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),
                            if (isUnread) ...[
                              const SizedBox(width: 8),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: data.color,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: data.color.withValues(alpha: 0.4),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (notification.subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            notification.subtitle!,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                        if (notification.body != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            notification.body!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Iconsax.clock,
                                  size: 12,
                                  color: AppColors.textTertiary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _formatTime(notification.timestamp),
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                            if (notification.isActionable &&
                                notification.actionText != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.2,
                                    ),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  notification.actionText!,
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _toggleReadStatus(notification),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isUnread
                            ? data.color.withValues(alpha: 0.1)
                            : AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isUnread
                              ? data.color.withValues(alpha: 0.2)
                              : AppColors.border.withValues(alpha: 0.5),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        isUnread ? Iconsax.message_tick : Iconsax.message_notif,
                        size: 16,
                        color: isUnread ? data.color : AppColors.textTertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ({IconData icon, Color color}) _iconForType(NotificationType type) {
    switch (type) {
      case NotificationType.report:
        return (icon: Iconsax.document_text_1, color: AppColors.primary);
      case NotificationType.streak:
        return (icon: Iconsax.flash, color: AppColors.streakActive);
      case NotificationType.achievement:
      case NotificationType.badge:
        return (icon: Iconsax.award, color: AppColors.secondary);
      case NotificationType.leaderboard:
        return (icon: Iconsax.chart, color: AppColors.primary);
      case NotificationType.reminder:
        return (icon: Iconsax.clock, color: AppColors.warning);
      case NotificationType.system:
      case NotificationType.announcement:
      case NotificationType.alert:
        return (icon: Iconsax.info_circle, color: AppColors.info);
      case NotificationType.point:
        return (icon: Iconsax.star, color: AppColors.accent);
      case NotificationType.feedback:
        return (icon: Iconsax.message, color: AppColors.info);
      case NotificationType.actionData:
        return (icon: Iconsax.notification, color: AppColors.primary);
    }
  }

  Widget _buildSettingsSection(AppNotificationPreferences prefs) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.08),
                    AppColors.secondary.withValues(alpha: 0.04),
                  ],
                ),
                border: Border(
                  bottom: BorderSide(color: AppColors.divider, width: 1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Iconsax.setting_2_copy,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pengaturan Notifikasi',
                              style: AppTextStyles.titleMedium.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Kelola preferensi notifikasi Anda',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ..._buildPreferenceRows(prefs),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPreferenceRows(AppNotificationPreferences prefs) {
    final items = [
      (
        'Laporan Diproses',
        prefs.receiveReportNotifications,
        (bool v) => _updatePreference(prefs, receiveReportNotifications: v),
      ),
      (
        'Pencapaian',
        prefs.receiveAchievementNotifications,
        (bool v) =>
            _updatePreference(prefs, receiveAchievementNotifications: v),
      ),
      (
        'Streak',
        prefs.receiveStreakNotifications,
        (bool v) => _updatePreference(prefs, receiveStreakNotifications: v),
      ),
      (
        'Leaderboard',
        prefs.receiveLeaderboardNotifications,
        (bool v) =>
            _updatePreference(prefs, receiveLeaderboardNotifications: v),
      ),
      (
        'Sistem',
        prefs.receiveAnnouncements,
        (bool v) => _updatePreference(prefs, receiveAnnouncements: v),
      ),
      (
        'Pengingat',
        prefs.receiveReminderNotifications,
        (bool v) => _updatePreference(prefs, receiveReminderNotifications: v),
      ),
    ];

    final List<Widget> widgets = [];
    for (int i = 0; i < items.length; i++) {
      final (title, value, onChanged) = items[i];
      widgets.add(
        _buildPreferenceRow(title: title, value: value, onChanged: onChanged),
      );
      if (i < items.length - 1) {
        widgets.add(
          Divider(
            height: 1,
            color: AppColors.divider,
            indent: 16,
            endIndent: 16,
          ),
        );
      }
    }

    widgets.add(
      Divider(height: 1, color: AppColors.divider, indent: 0, endIndent: 0),
    );

    final soundAndVibrItems = [
      (
        'Suara',
        prefs.soundEnabled,
        (bool v) => _updatePreference(prefs, soundEnabled: v),
      ),
      (
        'Getar',
        prefs.vibrationEnabled,
        (bool v) => _updatePreference(prefs, vibrationEnabled: v),
      ),
    ];

    for (int i = 0; i < soundAndVibrItems.length; i++) {
      final (title, value, onChanged) = soundAndVibrItems[i];
      widgets.add(
        _buildPreferenceRow(title: title, value: value, onChanged: onChanged),
      );
      if (i < soundAndVibrItems.length - 1) {
        widgets.add(
          Divider(
            height: 1,
            color: AppColors.divider,
            indent: 16,
            endIndent: 16,
          ),
        );
      }
    }

    return widgets;
  }

  Widget _buildPreferenceRow({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChanged(!value),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: value ? AppColors.primary : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                ),
                width: 52,
                height: 28,
                padding: const EdgeInsets.all(2),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 200),
                  alignment: value
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updatePreference(
    AppNotificationPreferences prefs, {
    bool? receiveReportNotifications,
    bool? receiveAchievementNotifications,
    bool? receiveStreakNotifications,
    bool? receiveLeaderboardNotifications,
    bool? receiveReminderNotifications,
    bool? receiveAnnouncements,
    bool? soundEnabled,
    bool? vibrationEnabled,
  }) {
    context.read<AppState>().updatePreferences(
      AppNotificationPreferences(
        receiveReportNotifications:
            receiveReportNotifications ?? prefs.receiveReportNotifications,
        receiveAchievementNotifications:
            receiveAchievementNotifications ??
            prefs.receiveAchievementNotifications,
        receiveStreakNotifications:
            receiveStreakNotifications ?? prefs.receiveStreakNotifications,
        receiveLeaderboardNotifications:
            receiveLeaderboardNotifications ??
            prefs.receiveLeaderboardNotifications,
        receiveReminderNotifications:
            receiveReminderNotifications ?? prefs.receiveReminderNotifications,
        receiveAnnouncements:
            receiveAnnouncements ?? prefs.receiveAnnouncements,
        receiveAlerts: prefs.receiveAlerts,
        receiveFeedback: prefs.receiveFeedback,
        soundEnabled: soundEnabled ?? prefs.soundEnabled,
        vibrationEnabled: vibrationEnabled ?? prefs.vibrationEnabled,
        quietHours: prefs.quietHours,
        preferredChannels: prefs.preferredChannels,
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} mnt lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam lalu';
    } else if (difference.inDays == 1) {
      return 'Kemarin';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hr lalu';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  void _handleNotificationTap(AppNotification notification) {
    if (!notification.isRead) {
      context.read<AppState>().markNotificationRead(notification.id);
    }
    if (notification.isActionable && notification.actionUrl != null) {
      Navigator.pushNamed(context, notification.actionUrl!);
    }
  }

  void _toggleReadStatus(AppNotification notification) {
    if (!notification.isRead) {
      context.read<AppState>().markNotificationRead(notification.id);
    }
  }

  void _markAllAsRead() {
    context.read<AppState>().markAllNotificationsRead();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Ditandai sudah dibaca')));
  }

  Future<void> _showClearConfirmation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Semua Notifikasi'),
          content: const Text(
            'Apakah Anda yakin ingin menghapus semua notifikasi? '
            'Tindakan ini tidak dapat dibatalkan.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Batal'),
            ),
            TacoButton(
              text: 'Hapus',
              onPressed: () => Navigator.pop(dialogContext, true),
              type: ButtonType.danger,
              isFullWidth: false,
              size: ButtonSize.small,
            ),
          ],
        );
      },
    );
    if (confirmed == true && mounted) {
      context.read<AppState>().clearNotifications();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua notifikasi telah dihapus')),
      );
    }
  }
}
