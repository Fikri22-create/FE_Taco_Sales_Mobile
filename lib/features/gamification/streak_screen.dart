import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taco_sales_insight/core/state/app_state.dart';
import 'package:taco_sales_insight/data/mock_data.dart';
import 'package:taco_sales_insight/shared/app_colors.dart';
import 'package:taco_sales_insight/shared/app_text_styles.dart';
import 'package:taco_sales_insight/shared/common_widgets.dart';
import 'package:taco_sales_insight/shared/ui_helpers.dart';
import 'package:taco_sales_insight/models/gamification.dart';

const Color _flameOrange = Color(0xFFFF6D00);
const Color _flameRed = Color(0xFFE53935);
const Color _flameYellow = Color(0xFFFFD54F);

class StreakScreen extends StatefulWidget {
  const StreakScreen({super.key});

  @override
  State<StreakScreen> createState() => _StreakScreenState();
}

class _StreakScreenState extends State<StreakScreen> {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final streakData = MockData.streakData;
    final currentStreak = appState.user.currentStreak;
    final bestStreak = appState.user.bestStreak;
    final level = UIHelpers.getStreakLevel(currentStreak);
    final levelColor = UIHelpers.getStreakColor(currentStreak);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.secondary.withValues(alpha: 0.08),
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
                TacoPremiumHeader(
                  title: 'Streak',
                  subtitle: 'Jaga konsistensi harian',
                  showBackButton: Navigator.canPop(context),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            const _AnimatedFlame(),
                            const SizedBox(height: 8),
                            _buildLevelBadge(level, levelColor),
                            const SizedBox(height: 28),
                            _buildStreakCard(currentStreak, streakData),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatBox(
                              'Streak Terbaik',
                              '$bestStreak hari',
                              AppColors.primary,
                              Iconsax.cup_copy,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatBox(
                              'Poin',
                              '${streakData.stats.totalPointsFromStreak}',
                              AppColors.gold,
                              Iconsax.award_copy,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      const SectionHeader(
                        title: 'Kalender Streak',
                        subtitle: '30 hari terakhir',
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
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.06),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
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
                      const SectionHeader(
                        title: 'Milestone',
                        subtitle: 'Target streak selanjutnya',
                      ),
                      const SizedBox(height: 16),
                      Column(
                        children: [
                          _buildMilestone(7, 'Weekly King', currentStreak >= 7),
                          const SizedBox(height: 12),
                          _buildMilestone(
                            14,
                            'Fortnight Hero',
                            currentStreak >= 14,
                          ),
                          const SizedBox(height: 12),
                          _buildMilestone(
                            30,
                            'Monthly Master',
                            currentStreak >= 30,
                          ),
                          const SizedBox(height: 12),
                          _buildMilestone(
                            100,
                            'Century Club',
                            currentStreak >= 100,
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
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
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.success.withValues(alpha: 0.08),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Iconsax.flash_copy,
                                  color: AppColors.success,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Manfaat Streak',
                                  style: AppTextStyles.titleMedium.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildBenefitItem('+5 poin', 'setiap hari'),
                            const SizedBox(height: 12),
                            _buildBenefitItem('2x multiplier', 'hari ke-7'),
                            const SizedBox(height: 12),
                            _buildBenefitItem('3x multiplier', 'hari ke-30'),
                            const SizedBox(height: 12),
                            _buildBenefitItem(
                              'Badge eksklusif',
                              'Consistency King',
                            ),
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

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  Widget _buildLevelBadge(String level, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Iconsax.crown_1, color: color, size: 15),
          const SizedBox(width: 6),
          Text(
            level,
            style: AppTextStyles.labelLarge.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard(int currentStreak, StreakData streakData) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.accent.withValues(alpha: 0.14),
            AppColors.warning.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.25),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Streak Aktif',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          ShaderMask(
            shaderCallback: (bounds) {
              return const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.accent, _flameOrange],
              ).createShader(bounds);
            },
            child: Text(
              '$currentStreak',
              style: AppTextStyles.displayLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Text(
            'hari',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _formatDate(streakData.streakStarted),
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
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
        _DayLabel('S'),
        _DayLabel('S'),
        _DayLabel('R'),
        _DayLabel('K'),
        _DayLabel('J'),
        _DayLabel('S'),
        _DayLabel('M'),
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
        final hasReport = streakData.streakDays.any(
          (streakDay) =>
              streakDay.date.year == date.year &&
              streakDay.date.month == date.month &&
              streakDay.date.day == date.day &&
              streakDay.completed,
        );
        final isToday =
            date.year == today.year &&
            date.month == today.month &&
            date.day == today.day;

        return Center(
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: hasReport
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.accent, _flameOrange],
                    )
                  : null,
              color: hasReport ? null : AppColors.surfaceVariant,
              shape: BoxShape.circle,
              border: isToday
                  ? Border.all(color: AppColors.accent, width: 2)
                  : null,
              boxShadow: hasReport
                  ? [
                      BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.25),
                        blurRadius: 8,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                date.day.toString(),
                style: AppTextStyles.bodySmall.copyWith(
                  color: hasReport ? Colors.white : AppColors.textSecondary,
                  fontWeight: hasReport ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMilestone(int days, String title, bool isAchieved) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isAchieved
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.success.withValues(alpha: 0.12),
                  AppColors.success.withValues(alpha: 0.04),
                ],
              )
            : null,
        color: isAchieved ? null : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isAchieved
              ? AppColors.success.withValues(alpha: 0.2)
              : AppColors.border.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: isAchieved
            ? [
                BoxShadow(
                  color: AppColors.success.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
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
                      colors: [
                        AppColors.success,
                        AppColors.success.withValues(alpha: 0.7),
                      ],
                    )
                  : null,
              color: isAchieved ? null : AppColors.surfaceVariant,
              shape: BoxShape.circle,
              boxShadow: isAchieved
                  ? [
                      BoxShadow(
                        color: AppColors.success.withValues(alpha: 0.2),
                        blurRadius: 8,
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              isAchieved ? Iconsax.tick_circle_copy : Iconsax.star_1_copy,
              color: isAchieved ? Colors.white : AppColors.textSecondary,
              size: 22,
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
                '$days hr',
                style: AppTextStyles.caption.copyWith(
                  color: isAchieved
                      ? AppColors.success
                      : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${days * 5} poin',
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
          child: const Icon(
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

class _AnimatedFlame extends StatefulWidget {
  const _AnimatedFlame();

  @override
  State<_AnimatedFlame> createState() => _AnimatedFlameState();
}

class _AnimatedFlameState extends State<_AnimatedFlame>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flameController;
  late final Animation<double> _flicker;
  late final Animation<double> _sway;

  @override
  void initState() {
    super.initState();
    _flameController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _flicker = CurvedAnimation(
      parent: _flameController,
      curve: Curves.easeInOut,
    );
    _sway = CurvedAnimation(
      parent: _flameController,
      curve: Curves.easeInOutSine,
    );
  }

  @override
  void dispose() {
    _flameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _flameController,
        builder: (context, _) {
          return CustomPaint(
            size: const Size(150, 190),
            painter: _FlamePainter(flicker: _flicker.value, sway: _sway.value),
          );
        },
      ),
    );
  }
}

class _FlamePainter extends CustomPainter {
  final double flicker;
  final double sway;

  _FlamePainter({required this.flicker, required this.sway});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final baseY = size.height * 0.90;
    final w = size.width * 0.78;
    final h = size.height * 0.84;

    final wave1 = math.sin(math.pi * flicker);
    final wave2 = math.sin(2 * math.pi * flicker);
    final swayWave = math.sin(2 * math.pi * sway);

    final scale = 1.0 + 0.06 * (0.7 * wave1 + 0.3 * wave2);
    final swayPx = 4.0 * swayWave;

    final innerHeight = 0.65 + 0.15 * math.sin(math.pi * flicker * 1.5);

    canvas.save();
    canvas.translate(cx + swayPx, baseY);
    canvas.scale(scale);
    canvas.translate(-cx, -baseY);

    _fillFlame(canvas, _flamePath(cx, baseY, w, h), _flameOrange);

    _fillFlame(canvas, _flamePath(cx, baseY, w * 0.68, h * 0.76), _flameRed);

    _fillFlame(
      canvas,
      _flamePath(cx, baseY, w * 0.40, h * 0.52 * innerHeight),
      _flameYellow,
    );

    canvas.restore();
  }

  Path _flamePath(double cx, double baseY, double w, double h) {
    final left = cx - w / 2;
    final right = cx + w / 2;
    return Path()
      ..moveTo(cx, baseY)
      ..cubicTo(
        left,
        baseY - h * 0.22,
        left - w * 0.06,
        baseY - h * 0.48,
        cx - w * 0.18,
        baseY - h * 0.78,
      )
      ..cubicTo(
        cx - w * 0.04,
        baseY - h * 0.92,
        cx + w * 0.04,
        baseY - h * 0.92,
        cx + w * 0.14,
        baseY - h * 0.80,
      )
      ..cubicTo(
        right + w * 0.02,
        baseY - h * 0.50,
        right - w * 0.02,
        baseY - h * 0.24,
        cx + w * 0.04,
        baseY,
      )
      ..close();
  }

  void _fillFlame(Canvas canvas, Path path, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _FlamePainter oldDelegate) {
    return oldDelegate.flicker != flicker || oldDelegate.sway != sway;
  }
}
