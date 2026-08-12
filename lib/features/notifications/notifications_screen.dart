import 'package:flutter/material.dart';
import 'package:taco_sales_insight/data/mock_data.dart';
import 'package:taco_sales_insight/shared/app_colors.dart';
import 'package:taco_sales_insight/shared/app_text_styles.dart';
import 'package:taco_sales_insight/shared/common_widgets.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    final notifications = MockData.notifications;
    final unreadCount = MockData.unreadNotificationsCount;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text('Mark All Read'),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats
            Row(
              children: [
                Expanded(
                  child: TacoCard(
                    child: Column(
                      children: [
                        Text(
                          'Total',
                          style: AppTextStyles.caption,
                        ),
                        Text(
                          notifications.length.toString(),
                          style: AppTextStyles.displaySmall,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TacoCard(
                    child: Column(
                      children: [
                        Text(
                          'Unread',
                          style: AppTextStyles.caption,
                        ),
                        Text(
                          unreadCount.toString(),
                          style: AppTextStyles.displaySmall.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TacoCard(
                    onTap: () {
                      setState(() {
                        // Filter only unread
                      });
                    },
                    child: Column(
                      children: [
                        Text(
                          'Today',
                          style: AppTextStyles.caption,
                        ),
                        Text(
                          notifications
                              .where((n) =>
                                  n.dateTime.day == DateTime.now().day)
                              .length
                              .toString(),
                          style: AppTextStyles.displaySmall.copyWith(
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Notifications List
            if (notifications.isEmpty)
              const EmptyState(
                title: 'Tidak ada notifikasi',
                description: 'Semua notifikasi sudah dibaca',
                icon: Icons.notifications_none,
              )
            else
              Column(
                children: notifications.map((notification) {
                  return _buildNotificationCard(notification);
                }).toList(),
              ),
            const SizedBox(height: 32),
            
            // Notification Settings
            TacoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pengaturan Notifikasi',
                    style: AppTextStyles.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  _buildNotificationSetting('Points Earned', true),
                  _buildNotificationSetting('Badge Unlocked', true),
                  _buildNotificationSetting('Streak Updates', true),
                  _buildNotificationSetting('System Announcements', false),
                  _buildNotificationSetting('Daily Reminders', true),
                  _buildNotificationSetting('Weekly Leaderboard', true),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Clear All Button
            TacoButton(
              text: 'Hapus Semua Notifikasi',
              onPressed: notifications.isEmpty
                  ? null
                  : _showClearConfirmation,
              type: ButtonType.outline,
              isFullWidth: true,
              icon: Icons.delete_outline,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
  
  Widget _buildNotificationCard(Notification notification) {
    Color notificationColor;
    IconData notificationIcon;
    
    switch (notification.type) {
      case NotificationType.point:
        notificationColor = AppColors.success;
        notificationIcon = Icons.emoji_events;
        break;
      case NotificationType.badge:
        notificationColor = AppColors.secondary;
        notificationIcon = Icons.badge;
        break;
      case NotificationType.streak:
        notificationColor = AppColors.warning;
        notificationIcon = Icons.local_fire_department;
        break;
      case NotificationType.system:
        notificationColor = AppColors.info;
        notificationIcon = Icons.info;
        break;
      case NotificationType.reminder:
      default:
        notificationColor = AppColors.primary;
        notificationIcon = Icons.notifications;
    }
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TacoCard(
        backgroundColor: notification.isRead
            ? AppColors.surface
            : AppColors.primary.withOpacity(0.05),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: notificationColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                notificationIcon,
                size: 20,
                color: notificationColor,
              ),
            ),
            const SizedBox(width: 12),
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
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatTime(notification.dateTime),
                        style: AppTextStyles.caption,
                      ),
                      const Spacer(),
                      if (notification.actionData != null)
                        TextButton(
                          onPressed: () {
                            _handleNotificationAction(notification);
                          },
                          child: Text(
                            'View',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                notification.isRead
                    ? Icons.mark_email_unread
                    : Icons.mark_email_read,
                size: 20,
                color: AppColors.textTertiary,
              ),
              onPressed: () {
                _toggleReadStatus(notification);
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildNotificationSetting(String title, bool isEnabled) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.bodyMedium,
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: (value) {
              // Handle setting change
            },
          ),
        ],
      ),
    );
  }
  
  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inSeconds < 60) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam lalu';
    } else if (difference.inDays == 1) {
      return 'Kemarin';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
  
  void _toggleReadStatus(Notification notification) {
    // In a real app, this would update the notification status
    setState(() {
      // This is just for UI demonstration
      // In reality, you'd update the data model
    });
  }
  
  void _markAllAsRead() {
    // In a real app, this would mark all notifications as read
    setState(() {
      // This is just for UI demonstration
      // In reality, you'd update the data model
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Semua notifikasi telah ditandai sebagai dibaca'),
      ),
    );
  }
  
  void _handleNotificationAction(Notification notification) {
    if (notification.actionData != null) {
      // Handle navigation based on actionData
      if (notification.actionData!.contains('badge')) {
        Navigator.pushNamed(context, '/profile/badges');
      }
    }
  }
  
  void _showClearConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Semua Notifikasi'),
          content: const Text('Apakah Anda yakin ingin menghapus semua notifikasi? Tindakan ini tidak dapat dibatalkan.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            TacoButton(
              text: 'Hapus',
              onPressed: () {
                Navigator.pop(context);
                // Clear all notifications
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Semua notifikasi telah dihapus'),
                  ),
                );
              },
              isFullWidth: false,
              type: ButtonType.error,
            ),
          ],
        );
      },
    );
  }
}