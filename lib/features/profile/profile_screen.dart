import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taco_sales_insight/core/state/app_state.dart';
import 'package:taco_sales_insight/models/user.dart';
import 'package:taco_sales_insight/shared/app_colors.dart';
import 'package:taco_sales_insight/shared/app_text_styles.dart';
import 'package:taco_sales_insight/shared/common_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppState>().user;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.background,
              AppColors.background.withValues(alpha: 0.4),
              Colors.white,
              AppColors.secondary.withValues(alpha: 0.02),
            ],
            stops: const [0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 110),
          child: Column(
            children: [
              // Premium Hero Section
              _buildHeroSection(user, context),
              const SizedBox(height: 24),
              
              // Stats Bar
              _buildStatsBar(user),
              const SizedBox(height: 24),
              
              // Menu Items - Gamification Section
              _buildMenuSection(
                title: 'Gamification',
                items: [
                  _MenuItem(
                    icon: Iconsax.star,
                    title: 'Points',
                    subtitle: 'Track your earnings',
                    description: '${user.totalPoints} Points',
                    iconColor: AppColors.accent,
                    backgroundColor: AppColors.accent.withValues(alpha: 0.1),
                    route: '/profile/points',
                  ),
                  _MenuItem(
                    icon: Iconsax.award,
                    title: 'Badges',
                    subtitle: 'Your Achievements',
                    description: '5 badges unlocked',
                    iconColor: AppColors.secondary,
                    backgroundColor: AppColors.secondary.withValues(alpha: 0.1),
                    route: '/profile/badges',
                  ),
                  _MenuItem(
                    icon: Iconsax.flash_1,
                    title: 'Streak',
                    subtitle: 'Daily Consistency',
                    description: '${user.currentStreak} consecutive days',
                    iconColor: AppColors.streakActive,
                    backgroundColor: AppColors.streakActive.withValues(alpha: 0.1),
                    route: '/profile/streak',
                  ),
                  _MenuItem(
                    icon: Iconsax.chart,
                    title: 'Leaderboard',
                    subtitle: 'Compare with friends',
                    description: 'Rank #${_getRank(context)}',
                    iconColor: AppColors.primary,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    route: '/profile/leaderboard',
                  ),
                ],
                context: context,
              ),
              const SizedBox(height: 24),
              
              // Settings Section
              _buildMenuSection(
                title: 'Application',
                items: [
                  _MenuItem(
                    icon: Iconsax.setting,
                    title: 'Settings',
                    subtitle: 'Manage preferences',
                    description: 'Language, notifications, etc',
                    iconColor: AppColors.primary,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    route: '/settings',
                  ),
                ],
                context: context,
              ),
              const SizedBox(height: 24),
              
              // Logout Button
              _buildLogoutButton(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(User user, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.05),
            AppColors.secondary.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar with glow effect - LEFT SIDE
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.secondary,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface,
              ),
              child: _buildAvatar(user),
            ),
          ),
          const SizedBox(width: 20),
          
          // User info - RIGHT SIDE
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.name,
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  user.email,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                TacoBadge.info(text: user.region),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsBar(User user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              value: '${user.totalReports}',
              label: 'Reports',
              color: AppColors.primary,
            ),
          ),
          Container(
            width: 1,
            height: 48,
            color: AppColors.divider,
          ),
          Expanded(
            child: _buildStatItem(
              value: '${user.totalPoints}',
              label: 'Points',
              color: AppColors.accent,
            ),
          ),
          Container(
            width: 1,
            height: 48,
            color: AppColors.divider,
          ),
          Expanded(
            child: _buildStatItem(
              value: '${user.currentStreak}',
              label: 'Streak',
              color: AppColors.streakActive,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.titleLarge.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection({
    required String title,
    required List<_MenuItem> items,
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: List.generate(items.length, (index) {
            final item = items[index];
            return _buildMenuItem(item, context, index == items.length - 1);
          }),
        ),
      ],
    );
  }

  Widget _buildMenuItem(_MenuItem item, BuildContext context, bool isLast) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, item.route),
      child: Container(
        margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: item.backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: item.iconColor.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: item.iconColor.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                item.icon,
                color: item.iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Iconsax.arrow_right_3,
              color: item.iconColor.withValues(alpha: 0.5),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _confirmLogout(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.error.withValues(alpha: 0.1),
          foregroundColor: AppColors.error,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: AppColors.error.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.logout, size: 20),
            SizedBox(width: 8),
            Text(
              'Logout',
              style: AppTextStyles.labelLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(User user) {
    return ClipOval(
      child: Image.network(
        user.avatarUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _buildInitialsAvatar(user),
      ),
    );
  }

  Widget _buildInitialsAvatar(User user) {
    return Container(
      color: AppColors.surfaceVariant,
      alignment: Alignment.center,
      child: Text(
        _initialsOf(user.name),
        style: AppTextStyles.titleMedium.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  String _initialsOf(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  void _confirmLogout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout from account?'),
        content: const Text('Are you sure you want to logout from this account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('You have logout from account (demo)'),
                ),
              );
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  int _getRank(BuildContext context) {
    final appState = context.read<AppState>();
    final leaderboard = appState.leaderboardByPoints;
    final index = leaderboard.indexWhere((e) => e.isCurrentUser);
    return index != -1 ? index + 1 : 0;
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final Color iconColor;
  final Color backgroundColor;
  final String route;

  _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.iconColor,
    required this.backgroundColor,
    required this.route,
  });
}
