import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFBE4826);
  static const Color primaryDark = Color(0xFF8F341A);
  static const Color primaryLight = Color(0xFFF7ECE7);
  static const Color secondary = Color(0xFF8F341A);
  static const Color accent = Color(0xFFF57F17);
  static const Color success = Color(0xFF2E7D32);
  static const Color error = Color(0xFFC62828);
  static const Color info = Color(0xFF1565C0);
  static const Color warning = Color(0xFFF57F17);

  static const Color background = Color(0xFFF5F6F8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF7ECE7);
  static const Color surfaceDisabled = Color(0xFFE8E8E8);

  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textTertiary = Color(0xFFBDBDBD);
  static const Color textDisabled = Color(0xFFE0E0E0);
  static const Color textInverse = Color(0xFFFFFFFF);

  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFF0F0F0);

  static const Color successLight = Color(0xFFE8F5E9);
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color warningLight = Color(0xFFFFF3E0);
  static const Color infoLight = Color(0xFFE3F2FD);

  static const Color gold = Color(0xFFD4AF37);
  static const Color silver = Color(0xFFC0C0C0);
  static const Color bronze = Color(0xFFCD7F32);
  static const Color streakActive = Color(0xFF2E7D32);
  static const Color streakInactive = Color(0xFFBDBDBD);

  static const Color chartBlue = Color(0xFF1565C0);
  static const Color chartGreen = Color(0xFF2E7D32);
  static const Color chartYellow = Color(0xFFF57F17);
  static const Color chartPurple = Color(0xFF7B1FA2);
  static const Color chartPink = Color(0xFFC2185B);
  static const Color chartCyan = Color(0xFF00838F);

  static const Color shimmerBase = Color(0xFFF5F6F8);
  static const Color shimmerHighlight = Color(0xFFFFFFFF);

  static const Color overlayDark = Color.fromRGBO(26, 26, 26, 0.5);
  static const Color overlayLight = Color.fromRGBO(245, 246, 248, 0.8);

  static const Color scrim = Color.fromRGBO(26, 26, 26, 0.5);

  static const Color brandPrimary = primary;
  static const Color brandSecondary = secondary;
  static const Color brandAccent = accent;
  static const Color brandSuccess = success;

  static const Color warmCream = Color(0xFFF7ECE7);
  static const Color softGray = Color(0xFFF5F6F8);
  static const Color mediumGray = Color(0xFF9E9E9E);
  static const Color lightGray = Color(0xFFF0F0F0);
  static const Color veryLightGray = Color(0xFFFAFAFA);

  static const Color focusRing = Color(0xFFBE4826);
  static const Color focusRingLight = Color(0xFFF7ECE7);

  static const Color secondaryLight = Color(0xFFF7ECE7);
  static const Color accentLight = Color(0xFFFFF3E0);
  static const Color infoBorder = Color(0xFFBBDEFB);
  static const Color navySurface = Color(0xFF8F341A);

  static const Color purple = Color(0xFF7B1FA2);
  static const Color purpleLight = Color(0xFFF3E5F5);
  static const Color grayLight = Color(0xFFF5F6F8);

  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  static const Color shadowColor = Color.fromRGBO(26, 26, 26, 0.08);
}
