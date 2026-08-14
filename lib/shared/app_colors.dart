import 'package:flutter/material.dart';

/// TACO Sales Insight - Original Brand Palette
///
/// Primary: #BE4826 (TACO Warm Brown)
/// Primary Dark: #8F341A (Deep Brown)
/// Primary Light: #F7ECE7 (Warm Cream)
/// Background: #F5F6F8 (Soft Gray)
/// Surface: #FFFFFF (Pure White)
/// Text Primary: #1A1A1A (Deep Black)
/// Text Secondary: #757575 (Medium Gray)
/// Border: #E0E0E0 (Light Gray)
/// Success: #2E7D32 (Green)
/// Error: #C62828 (Red)
/// Info: #1565C0 (Blue)
/// Warning/Accent: #F57F17 (Amber)
///
/// Design principles: Modern, premium, professional, clean, enterprise-ready
/// Visual quality: Layered backgrounds, card depth, smooth shadows, clear hierarchy,
/// modern typography, precise spacing, elegant floating navigation, smooth micro-animations
class AppColors {
  // TACO Brand primaries
  static const Color primary = Color(0xFFBE4826); // TACO Warm Brown
  static const Color primaryDark = Color(0xFF8F341A); // Deep Brown
  static const Color primaryLight = Color(0xFFF7ECE7); // Warm Cream
  static const Color secondary = Color(0xFF8F341A); // Secondary uses primary dark
  static const Color accent = Color(0xFFF57F17); // Amber Warning
  static const Color success = Color(0xFF2E7D32); // Green
  static const Color error = Color(0xFFC62828); // Red
  static const Color info = Color(0xFF1565C0); // Blue
  static const Color warning = Color(0xFFF57F17); // Amber

  // Surfaces & backgrounds
  static const Color background = Color(0xFFF5F6F8); // Soft Gray
  static const Color surface = Color(0xFFFFFFFF); // Pure White
  static const Color surfaceVariant = Color(0xFFF7ECE7); // Warm Cream variant
  static const Color surfaceDisabled = Color(0xFFE8E8E8); // Disabled surfaces

  // Text colors
  static const Color textPrimary = Color(0xFF1A1A1A); // Deep Black
  static const Color textSecondary = Color(0xFF757575); // Medium Gray
  static const Color textTertiary = Color(0xFFBDBDBD); // Light Gray
  static const Color textDisabled = Color(0xFFE0E0E0); // Disabled text
  static const Color textInverse = Color(0xFFFFFFFF); // White text on dark

  // Lines & borders
  static const Color border = Color(0xFFE0E0E0); // Light Gray border
  static const Color divider = Color(0xFFF0F0F0); // Subtle divider

  // Status tints (light variants)
  static const Color successLight = Color(0xFFE8F5E9); // Light green
  static const Color errorLight = Color(0xFFFFEBEE); // Light red
  static const Color warningLight = Color(0xFFFFF3E0); // Light amber
  static const Color infoLight = Color(0xFFE3F2FD); // Light blue

  // Gamification & ranking
  static const Color gold = Color(0xFFD4AF37); // Classic gold
  static const Color silver = Color(0xFFC0C0C0); // Silver
  static const Color bronze = Color(0xFFCD7F32); // Bronze
  static const Color streakActive = Color(0xFF2E7D32); // Active = success green
  static const Color streakInactive = Color(0xFFBDBDBD); // Inactive = light gray

  // Chart colors (brand-aware palette)
  static const Color chartBlue = Color(0xFF1565C0); // Info blue
  static const Color chartGreen = Color(0xFF2E7D32); // Success green
  static const Color chartYellow = Color(0xFFF57F17); // Amber/Warning
  static const Color chartPurple = Color(0xFF7B1FA2); // Purple
  static const Color chartPink = Color(0xFFC2185B); // Pink
  static const Color chartCyan = Color(0xFF00838F); // Teal

  // Loading & shimmer
  static const Color shimmerBase = Color(0xFFF5F6F8); // Background
  static const Color shimmerHighlight = Color(0xFFFFFFFF); // Surface

  // Overlays
  static const Color overlayDark = Color.fromRGBO(26, 26, 26, 0.5); // Semi-transparent black
  static const Color overlayLight = Color.fromRGBO(245, 246, 248, 0.8); // Semi-transparent background

  // Scrim for dialogs
  static const Color scrim = Color.fromRGBO(26, 26, 26, 0.5);

  // Brand aliases for clarity
  static const Color brandPrimary = primary;
  static const Color brandSecondary = secondary;
  static const Color brandAccent = accent;
  static const Color brandSuccess = success;

  // Extended color palette for flexibility
  static const Color warmCream = Color(0xFFF7ECE7); // Primary light
  static const Color softGray = Color(0xFFF5F6F8); // Background
  static const Color mediumGray = Color(0xFF9E9E9E); // Mid-tone gray
  static const Color lightGray = Color(0xFFF0F0F0); // Light gray
  static const Color veryLightGray = Color(0xFFFAFAFA); // Very light gray

  // Focus & interactive states
  static const Color focusRing = Color(0xFFBE4826); // Primary for focus rings
  static const Color focusRingLight = Color(0xFFF7ECE7); // Light variant for high contrast

  // Additional required colors for backward compatibility
  static const Color secondaryLight = Color(0xFFF7ECE7); // Light variant of secondary
  static const Color accentLight = Color(0xFFFFF3E0); // Light variant of accent/warning
  static const Color infoBorder = Color(0xFFBBDEFB); // Light blue border for info
  static const Color navySurface = Color(0xFF8F341A); // Navy surface = primary dark

  // Deprecated / Legacy (keeping for backward compatibility, but prefer new palette)
  static const Color purple = Color(0xFF7B1FA2);
  static const Color purpleLight = Color(0xFFF3E5F5);
  static const Color grayLight = Color(0xFFF5F6F8);

  // Utility function to get opacity variant
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  // Shadow colors (subtle, using primary dark)
  static const Color shadowColor = Color.fromRGBO(26, 26, 26, 0.08);
}
