import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 57,
    height: 1.12,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    color: AppColors.textPrimary,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 45,
    height: 1.16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 36,
    height: 1.22,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 32,
    height: 1.25,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 28,
    height: 1.29,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 24,
    height: 1.33,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 22,
    height: 1.27,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    height: 1.33,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    height: 1.43,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    height: 1.43,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    height: 1.33,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    height: 1.43,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    height: 1.33,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    color: AppColors.textPrimary,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 10,
    height: 1.2,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    color: AppColors.textPrimary,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    height: 1.33,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    color: AppColors.textSecondary,
  );

  static const TextStyle overline = TextStyle(
    fontFamily: 'Inter',
    fontSize: 10,
    height: 1.2,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.6,
    color: AppColors.textTertiary,
  );

  static TextStyle get displayLargeLight =>
      displayLarge.copyWith(fontWeight: FontWeight.w400);

  static TextStyle get headlineMediumSecondary =>
      headlineMedium.copyWith(color: AppColors.textSecondary);

  static TextStyle get titleMediumAccent =>
      titleMedium.copyWith(color: AppColors.accent);

  static TextStyle get bodyMediumSuccess =>
      bodyMedium.copyWith(color: AppColors.success);

  static TextStyle get bodyMediumError =>
      bodyMedium.copyWith(color: AppColors.error);

  static TextStyle get captionTertiary =>
      caption.copyWith(color: AppColors.textTertiary);

  static TextStyle get labelMediumWhite =>
      labelMedium.copyWith(color: AppColors.textInverse);

  static TextStyle get kicker =>
      overline.copyWith(color: AppColors.accent, fontWeight: FontWeight.w700);

  static TextStyle get overlinePrimary =>
      overline.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600);

  static TextStyle get bodyMediumSecondary =>
      bodyMedium.copyWith(color: AppColors.textSecondary);

  static TextStyle get bodySmallSecondary =>
      bodySmall.copyWith(color: AppColors.textSecondary);

  static TextStyle get bodySmallTertiary =>
      bodySmall.copyWith(color: AppColors.textTertiary);

  static TextStyle get labelSmallSecondary =>
      labelSmall.copyWith(color: AppColors.textSecondary);

  static TextStyle get titleSmallPrimary =>
      titleSmall.copyWith(color: AppColors.primary);

  static const double lineHeightTight = 1.2;
  static const double lineHeightNormal = 1.5;
  static const double lineHeightLoose = 1.8;

  static const double scaleFactorLarge = 1.25;
  static const double scaleFactorMedium = 1.0;
  static const double scaleFactorSmall = 0.875;
}
