import 'package:flutter/material.dart';
import 'app_colors.dart';

class UIHelpers {
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 19) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  static Color getGreetingColor() {
    final hour = DateTime.now().hour;
    if (hour < 12) return AppColors.success;
    if (hour < 15) return AppColors.accent;
    if (hour < 19) return Color(0xFFE67E22);
    return AppColors.primary;
  }

  static IconData getGreetingIcon() {
    final hour = DateTime.now().hour;
    if (hour < 12) return Icons.wb_sunny;
    if (hour < 15) return Icons.light_mode;
    if (hour < 19) return Icons.cloud;
    return Icons.nights_stay;
  }

  static String formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  static String formatDate(DateTime dateTime) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}';
  }

  static String getStreakLevel(int days) {
    if (days < 4) return 'Bronze';
    if (days < 11) return 'Silver';
    if (days < 31) return 'Gold';
    if (days < 101) return 'Platinum';
    return 'Diamond';
  }

  static Color getStreakColor(int days) {
    if (days < 4) return AppColors.bronze;
    if (days < 11) return AppColors.silver;
    if (days < 31) return AppColors.gold;
    if (days < 101) return Color(0xFF60A5FA);
    return Color(0xFFA78BFA);
  }
}
