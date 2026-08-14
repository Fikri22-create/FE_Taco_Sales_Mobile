import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taco_sales_insight/core/state/app_state.dart';
import 'package:taco_sales_insight/shared/app_colors.dart';
import 'package:taco_sales_insight/shared/app_text_styles.dart';
import 'package:taco_sales_insight/shared/common_widgets.dart';
import 'package:taco_sales_insight/models/gamification.dart';

class PointsScreen extends StatefulWidget {
  const PointsScreen({super.key});

  @override
  State<PointsScreen> createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
  final List<String> _filterOptions = ['All', 'Today', 'This Week', 'This Month'];
  String _selectedFilter = 'All';

  List<PointTransaction> _filterTransactions(List<PointTransaction> transactions) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekAgo = now.subtract(const Duration(days: 7));
    final monthAgo = now.subtract(const Duration(days: 30));

    List<PointTransaction> filtered = List.of(transactions);

    switch (_selectedFilter) {
      case 'Today':
        filtered = filtered.where((txn) => txn.timestamp.isAfter(today)).toList();
        break;
      case 'This Week':
        filtered = filtered.where((txn) => txn.timestamp.isAfter(weekAgo)).toList();
        break;
      case 'This Month':
        filtered = filtered.where((txn) => txn.timestamp.isAfter(monthAgo)).toList();
        break;
    }

    return filtered;
  }

  String _getTransactionTypeLabel(PointTransactionType type) {
    switch (type) {
      case PointTransactionType.report:
        return 'Report';
      case PointTransactionType.streak:
        return 'Streak';
      case PointTransactionType.badge:
        return 'Badge';
      case PointTransactionType.bonus:
        return 'Bonus';
      case PointTransactionType.achievement:
        return 'Achievement';
      case PointTransactionType.referral:
        return 'Referral';
      case PointTransactionType.correction:
        return 'Correction';
    }
  }

  IconData _getTransactionTypeIcon(PointTransactionType type) {
    switch (type) {
      case PointTransactionType.report:
        return Iconsax.document_text_1_copy;
      case PointTransactionType.streak:
        return Iconsax.flash_copy;
      case PointTransactionType.badge:
        return Iconsax.award_copy;
      case PointTransactionType.bonus:
        return Iconsax.award_copy;
      case PointTransactionType.achievement:
        return Iconsax.cup_copy;
      case PointTransactionType.referral:
        return Iconsax.user_add_copy;
      case PointTransactionType.correction:
        return Iconsax.edit_copy;
    }
  }

  Color _getTransactionTypeColor(PointTransactionType type) {
    switch (type) {
      case PointTransactionType.report:
        return AppColors.primary;
      case PointTransactionType.streak:
        return AppColors.success;
      case PointTransactionType.badge:
        return AppColors.secondary;
      case PointTransactionType.bonus:
        return AppColors.accent;
      case PointTransactionType.achievement:
        return AppColors.gold;
      case PointTransactionType.referral:
        return AppColors.secondary;
      case PointTransactionType.correction:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final filteredTransactions = _filterTransactions(appState.pointTransactions);
    final user = appState.user;
    final now = DateTime.now();

    final weeklyTotal = appState.pointTransactions
        .where((txn) => txn.timestamp.isAfter(now.subtract(const Duration(days: 7))))
        .fold(0, (sum, txn) => sum + txn.amount);

    final monthlyTotal = appState.pointTransactions
        .where((txn) => txn.timestamp.isAfter(now.subtract(const Duration(days: 30))))
        .fold(0, (sum, txn) => sum + txn.amount);

    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withValues(alpha: 0.08),
                  AppColors.accent.withValues(alpha: 0.04),
                  AppColors.background,
                ],
                stops: const [0.0, 0.3, 1.0],
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Premium header
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withValues(alpha: 0.85),
                        AppColors.accent.withValues(alpha: 0.6),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: TacoHeroHeader(
                      title: 'Points & Rewards',
                      subtitle: 'Track your point earnings',
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Total points card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.primary,
                              AppColors.primary.withValues(alpha: 0.8),
                              AppColors.secondary.withValues(alpha: 0.5),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.25),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total Points',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: Colors.white.withValues(alpha: 0.9),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      user.totalPoints.toString(),
                                      style: AppTextStyles.displayMedium.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Icon(
                                    Iconsax.award_copy,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Iconsax.trend_up_copy,
                                    size: 16,
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '+$weeklyTotal this week',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: Colors.white.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Quick stats
                      Row(
                        children: [
                          Expanded(
                            child: _buildQuickStat(
                              'This Week',
                              '$weeklyTotal',
                              AppColors.success,
                              Iconsax.calendar_1_copy,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildQuickStat(
                              'This Month',
                              '$monthlyTotal',
                              AppColors.secondary,
                              Iconsax.chart_copy,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // Filter
                      const SectionHeader(
                        title: 'Transaction History',
                        subtitle: 'Track your point earnings',
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 40,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: _filterOptions.map((filter) {
                            final isSelected = _selectedFilter == filter;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedFilter = filter;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 220),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    gradient: isSelected
                                        ? LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              AppColors.primary,
                                              AppColors.secondary,
                                            ],
                                          )
                                        : null,
                                    color: isSelected ? null : AppColors.surfaceVariant,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.transparent
                                          : AppColors.border,
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    filter,
                                    style: AppTextStyles.labelMedium.copyWith(
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.textPrimary,
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Transactions or empty state
                      if (filteredTransactions.isEmpty)
                        const EmptyState(
                          title: 'No transactions',
                          subtitle: 'No point transactions for this period',
                        )
                      else
                        Column(
                          children: List.generate(
                            filteredTransactions.length,
                            (index) {
                              final txn = filteredTransactions[index];
                              final color = _getTransactionTypeColor(txn.type);
                              final icon = _getTransactionTypeIcon(txn.type);
                              final formattedTime = _formatTimeAgo(txn.timestamp);

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        AppColors.surface,
                                        AppColors.surfaceVariant.withValues(alpha: 0.3),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.border.withValues(alpha: 0.5),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: color.withValues(alpha: 0.06),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: color.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: color.withValues(alpha: 0.2),
                                            width: 1,
                                          ),
                                        ),
                                        child: Icon(
                                          icon,
                                          color: color,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              txn.description,
                                              style: AppTextStyles.labelMedium.copyWith(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: color.withValues(alpha: 0.12),
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  child: Text(
                                                    _getTransactionTypeLabel(txn.type),
                                                    style: AppTextStyles.caption.copyWith(
                                                      color: color,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  formattedTime,
                                                  style: AppTextStyles.caption.copyWith(
                                                    color: AppColors.textTertiary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: txn.amount > 0
                                              ? AppColors.success.withValues(alpha: 0.15)
                                              : AppColors.error.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: txn.amount > 0
                                                ? AppColors.success.withValues(alpha: 0.2)
                                                : AppColors.error.withValues(alpha: 0.2),
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          '${txn.amount > 0 ? '+' : ''}${txn.amount}',
                                          style: AppTextStyles.labelSmall.copyWith(
                                            color: txn.amount > 0
                                                ? AppColors.success
                                                : AppColors.error,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: 32),

                      // Info section
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.secondary.withValues(alpha: 0.08),
                              AppColors.secondary.withValues(alpha: 0.03),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.secondary.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Iconsax.star_1_copy,
                                  color: AppColors.secondary,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'How to Get Points',
                                  style: AppTextStyles.titleMedium.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            _buildInfoItem('Quality reports', '15-25 points'),
                            const SizedBox(height: 10),
                            _buildInfoItem('Daily streak', '10 points/day'),
                            const SizedBox(height: 10),
                            _buildInfoItem('Unlock badges', '15-50 points'),
                            const SizedBox(height: 10),
                            _buildInfoItem('Weekly achievement', 'bonus points'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.12),
            color.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.headlineSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            Iconsax.check_copy,
            size: 14,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                value,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${(difference.inDays / 7).floor()}w';
    }
  }
}
