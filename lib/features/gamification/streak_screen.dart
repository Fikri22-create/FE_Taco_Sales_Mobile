import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taco_sales_insight/core/state/app_state.dart';
import 'package:taco_sales_insight/data/mock_data.dart';
import 'package:taco_sales_insight/shared/app_colors.dart';
import 'package:taco_sales_insight/shared/app_text_styles.dart';
import 'package:taco_sales_insight/shared/common_widgets.dart';
import 'package:taco_sales_insight/models/gamification.dart';

class StreakScreen extends StatefulWidget {
  const StreakScreen({super.key});

  @override
  State<StreakScreen> createState() => _StreakScreenState();
}

class _StreakScreenState extends State<StreakScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final streakData = MockData.streakData;
    final currentStreak = appState.user.currentStreak;
    final bestStreak = appState.user.bestStreak;

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
                  AppColors.accent.withValues(alpha: 0.08),
                  AppColors.success.withValues(alpha: 0.04),
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
                // Premium header with gradient
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.accent,
                        AppColors.accent.withValues(alpha: 0.85),
                        AppColors.success.withValues(alpha: 0.6),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.2),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TacoHeroHeader(
                          title: 'Streak',
                          subtitle: 'Maintain daily consistency',
                        ),
                        const SizedBox(height: 28),
                        // Fire icon with pulse
                        Center(
                          child: ScaleTransition(
                            scale: _pulseAnimation,
                            child: Text(
                              '🔥',
                              style: TextStyle(fontSize: 64),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Active streak card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.secondary.withValues(alpha: 0.12),
                              AppColors.secondary.withValues(alpha: 0.04),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.secondary.withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.secondary.withValues(alpha: 0.1),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Active Streak',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$currentStreak',
                              style: AppTextStyles.displayLarge.copyWith(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'days',
                              style: AppTextStyles.titleMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '${streakData.streakStarted}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Best streak & points
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatBox(
                              'Best Streak',
                              '$bestStreak days',
                              AppColors.primary,
                              Iconsax.cup_copy,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatBox(
                              'Points',
                              '${streakData.stats.totalPointsFromStreak}',
                              AppColors.gold,
                              Iconsax.award_copy,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Calendar
                      SectionHeader(
                        title: 'Streak Calendar',
                        subtitle: 'last 30 days',
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.surface,
                              AppColors.surfaceVariant.withValues(alpha: 0.3),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.border.withValues(alpha: 0.6),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildCalendarHeader(),
                            const SizedBox(height: 16),
                            _buildCalendarGrid(streakData),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Milestones
                      const SectionHeader(
                        title: 'Milestones',
                        subtitle: 'Target streak selanjutnya',
                      ),
                      const SizedBox(height: 12),
                      Column(
                        children: [
                          _buildMilestone(7, 'Weekly King', currentStreak >= 7),
                          const SizedBox(height: 10),
                          _buildMilestone(14, 'Fortnight Hero', currentStreak >= 14),
                          const SizedBox(height: 10),
                          _buildMilestone(30, 'Monthly Master', currentStreak >= 30),
                          const SizedBox(height: 10),
                          _buildMilestone(100, 'Century Club', currentStreak >= 100),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Benefits
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.success.withValues(alpha: 0.08),
                              AppColors.success.withValues(alpha: 0.03),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.success.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Iconsax.flash_copy,
                                  color: AppColors.success,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Streak Benefits',
                                  style: AppTextStyles.titleMedium.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildBenefitItem('+5 points', 'each day'),
                            const SizedBox(height: 10),
                            _buildBenefitItem('2x multiplier', 'on day 7'),
                            const SizedBox(height: 10),
                            _buildBenefitItem('3x multiplier', 'on day 30'),
                            const SizedBox(height: 10),
                            _buildBenefitItem('Exclusive badge', 'Consistency King'),
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

  Widget _buildStatBox(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.headlineSmall.copyWith(
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
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _DayLabel('M'),
        _DayLabel('T'),
        _DayLabel('W'),
        _DayLabel('T'),
        _DayLabel('F'),
        _DayLabel('S'),
        _DayLabel('S'),
      ],
    );
  }

  Widget _buildCalendarGrid(StreakData streakData) {
    final days = _getLast30Days();
    final today = DateTime.now();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final date = days[index];
        final hasReport = streakData.streakDays.any((streakDay) =>
            streakDay.date.year == date.year &&
            streakDay.date.month == date.month &&
            streakDay.date.day == date.day &&
            streakDay.completed);
        final isToday = date.year == today.year &&
            date.month == today.month &&
            date.day == today.day;

        return Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient: hasReport
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.secondary,
                      AppColors.secondary.withValues(alpha: 0.7),
                    ],
                  )
                : null,
            color: hasReport ? null : AppColors.surfaceVariant,
            shape: BoxShape.circle,
            border: isToday
                ? Border.all(color: AppColors.primary, width: 2)
                : null,
            boxShadow: hasReport
                ? [
                    BoxShadow(
                      color: AppColors.secondary.withValues(alpha: 0.2),
                      blurRadius: 8,
                    )
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              date.day.toString(),
              style: AppTextStyles.bodySmall.copyWith(
                color: hasReport ? Colors.white : AppColors.textSecondary,
                fontWeight: hasReport ? FontWeight.w700 : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMilestone(int days, String title, bool isAchieved) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: isAchieved
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.success.withValues(alpha: 0.08),
                  AppColors.success.withValues(alpha: 0.03),
                ],
              )
            : null,
        color: isAchieved ? null : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isAchieved
              ? AppColors.success.withValues(alpha: 0.15)
              : AppColors.border.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: isAchieved
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.success, AppColors.success.withValues(alpha: 0.7)],
                    )
                  : null,
              color: isAchieved ? null : AppColors.surfaceVariant,
              shape: BoxShape.circle,
              boxShadow: isAchieved
                  ? [
                      BoxShadow(
                        color: AppColors.success.withValues(alpha: 0.2),
                        blurRadius: 8,
                      )
                    ]
                  : null,
            ),
            child: Center(
              child: Icon(
                isAchieved ? Iconsax.tick_circle_copy : Iconsax.star_1_copy,
                color: isAchieved ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$days Hari',
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  title,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                isAchieved ? '✓ DONE' : '$days d',
                style: AppTextStyles.caption.copyWith(
                  color: isAchieved ? AppColors.success : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${days * 5} pts',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String main, String sub) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            Iconsax.check_copy,
            size: 14,
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                main,
                style: AppTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                sub,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<DateTime> _getLast30Days() {
    final now = DateTime.now();
    final List<DateTime> days = [];

    for (int i = 29; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      days.add(date);
    }

    return days;
  }
}

class _DayLabel extends StatelessWidget {
  final String label;
  const _DayLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
