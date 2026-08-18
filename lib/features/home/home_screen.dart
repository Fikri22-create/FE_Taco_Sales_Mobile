import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:taco_sales_insight/core/state/app_state.dart';
import 'package:taco_sales_insight/data/mock_data.dart';
import 'package:taco_sales_insight/models/intel_card.dart';
import 'package:taco_sales_insight/models/report.dart';
import 'package:taco_sales_insight/models/user.dart';
import 'package:taco_sales_insight/shared/app_colors.dart';
import 'package:taco_sales_insight/shared/app_text_styles.dart';
import 'package:taco_sales_insight/shared/common_widgets.dart';
import 'package:taco_sales_insight/shared/report_detail_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.onCreateReport});

  final VoidCallback? onCreateReport;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _refresh() {
    return Future.delayed(const Duration(milliseconds: 300));
  }

  void _openCreateReport() {
    if (widget.onCreateReport != null) {
      widget.onCreateReport!();
    } else {
      Navigator.pushNamed(context, '/report/select-outlet');
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final user = appState.user;
    final reports = appState.reports;

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final reportsToday = reports
        .where((report) => !report.createdAt.isBefore(todayStart))
        .length;
    final weekStart = now.subtract(const Duration(days: 7));
    final weeklyPoints = appState.pointTransactions
        .where((transaction) => !transaction.timestamp.isBefore(weekStart))
        .fold<int>(0, (sum, transaction) => sum + transaction.amount);
    final intelCards = _buildIntelCardsList(
      user,
      appState.unreadCount,
      reportsToday,
      weeklyPoints,
    );

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
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, user, appState.unreadCount),
                const SizedBox(height: 24),
                _buildHeroCard(user, weeklyPoints),
                const SizedBox(height: 24),
                _buildIntelCardsGrid(context, intelCards),
                const SizedBox(height: 24),
                _buildRecentActivity(context, reports),
                const SizedBox(height: 24),
                _buildPerformanceSummary(user),
                const SizedBox(height: 24),
                _buildCreateReportButton(),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, User user, int unreadCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset('assets/images/taco_logo.png', width: 40, height: 40),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: SizedBox.shrink(),
          ),
        ),
        _buildNotificationBell(context, unreadCount),
      ],
    );
  }

  Widget _buildNotificationBell(BuildContext context, int unreadCount) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: AppColors.surfaceVariant,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => Navigator.pushNamed(context, '/notifications'),
            child: const SizedBox(
              width: 44,
              height: 44,
              child: Icon(
                Iconsax.notification_copy,
                size: 22,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
        if (unreadCount > 0)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              constraints: const BoxConstraints(minWidth: 18),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: AppColors.surface, width: 1.5),
              ),
              child: Text(
                '$unreadCount',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHeroCard(User user, int weeklyPoints) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.secondary.withValues(alpha: 0.8),
            AppColors.primary.withValues(alpha: 0.6),
            AppColors.secondary.withValues(alpha: 0.4),
          ],
          stops: const [0, 0.3, 0.7, 1.0],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Saldo Poin',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${user.totalPoints}',
                        style: AppTextStyles.displaySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Iconsax.star_1_copy,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.3),
                    Colors.white.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Minggu Ini',
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '+$weeklyPoints',
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Streak Aktif',
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${user.currentStreak} days',
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: Colors.white,
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
    );
  }

  List<IntelCard> _buildIntelCardsList(
    User user,
    int unreadCount,
    int reportsToday,
    int weeklyPoints,
  ) {
    return MockData.intelCards.map((card) {
      String? value;
      String? subtitle;
      String? change;

      switch (card.id) {
        case 'card_001':
          value = '$reportsToday';
          break;
        case 'card_002':
          value = '${user.currentStreak}';
          subtitle = '${user.currentStreak} hari berturut-turut';
          change = null;
          break;
        case 'card_003':
          value = '$weeklyPoints';
          break;
        case 'card_004':
          value = user.stats.averageReportQuality.toStringAsFixed(1);
          change = null;
          break;
        case 'card_006':
          value = '$unreadCount';
          subtitle = unreadCount > 0
              ? '$unreadCount notifikasi baru'
              : 'Semua notifikasi sudah dibaca';
          break;
      }

      if (value == null) return card;

      return IntelCard(
        id: card.id,
        title: card.title,
        subtitle: subtitle ?? card.subtitle,
        value: value,
        change: change ?? card.change,
        type: card.type,
        trend: card.trend,
        icon: card.icon,
        colorScheme: card.colorScheme,
        isInteractive: card.isInteractive,
        actionRoute: card.actionRoute,
        actionParams: card.actionParams,
        timestamp: card.timestamp,
        priority: card.priority,
        tags: card.tags,
        status: card.status,
      );
    }).toList();
  }

  Widget _buildIntelCardsGrid(BuildContext context, List<IntelCard> cards) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Wawasan',
          subtitle: 'Ringkasan metrik utama Anda',
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.1,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: cards
              .where(
                (card) =>
                    card.type != IntelCardType.quickAction &&
                    card.type != IntelCardType.notification,
              )
              .map((card) => _buildIntelCard(context, card))
              .toList(),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildIntelCard(
                context,
                cards.firstWhere(
                  (card) => card.type == IntelCardType.quickAction,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildIntelCard(
                context,
                cards.firstWhere(
                  (card) => card.type == IntelCardType.notification,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIntelCard(BuildContext context, IntelCard card) {
    Color getCardColor(IntelCardColorScheme scheme) {
      switch (scheme) {
        case IntelCardColorScheme.blue:
          return AppColors.chartBlue.withValues(alpha: 0.1);
        case IntelCardColorScheme.green:
          return AppColors.successLight;
        case IntelCardColorScheme.yellow:
          return AppColors.warningLight;
        case IntelCardColorScheme.red:
          return AppColors.errorLight;
        case IntelCardColorScheme.purple:
          return const Color(0xFFF3E8FF);
        case IntelCardColorScheme.pink:
          return const Color(0xFFFCE7F3);
        case IntelCardColorScheme.cyan:
          return const Color(0xFFCFFAFE);
        case IntelCardColorScheme.gray:
          return AppColors.surfaceVariant;
        case IntelCardColorScheme.indigo:
          return const Color(0xFFE0E7FF);
        case IntelCardColorScheme.teal:
          return const Color(0xFFD1FAE5);
        case IntelCardColorScheme.orange:
          return AppColors.warningLight;
      }
    }

    Color getTextColor(IntelCardColorScheme scheme) {
      switch (scheme) {
        case IntelCardColorScheme.blue:
          return AppColors.chartBlue;
        case IntelCardColorScheme.green:
          return AppColors.success;
        case IntelCardColorScheme.yellow:
          return AppColors.warning;
        case IntelCardColorScheme.red:
          return AppColors.error;
        case IntelCardColorScheme.purple:
          return const Color(0xFF8B5CF6);
        case IntelCardColorScheme.pink:
          return const Color(0xFFEC4899);
        case IntelCardColorScheme.cyan:
          return const Color(0xFF06B6D4);
        case IntelCardColorScheme.gray:
          return AppColors.textPrimary;
        case IntelCardColorScheme.indigo:
          return const Color(0xFF4F46E5);
        case IntelCardColorScheme.teal:
          return const Color(0xFF0D9488);
        case IntelCardColorScheme.orange:
          return AppColors.warning;
      }
    }

    IconData getCardIcon(String rawIcon) {
      switch (rawIcon) {
        case '📊':
          return Iconsax.chart_copy;
        case '🔥':
          return Iconsax.flash_copy;
        case '⭐':
          return Iconsax.star_copy;
        case '🎯':
          return Iconsax.status_copy;
        case '➕':
          return Iconsax.add_copy;
        case '🔔':
          return Iconsax.notification_copy;
        default:
          return Iconsax.info_circle_copy;
      }
    }

    final textColor = getTextColor(card.colorScheme);

    return TacoCard(
      onTap: card.isInteractive
          ? () {
              if (card.type == IntelCardType.quickAction) {
                _openCreateReport();
              } else if (card.actionRoute != null) {
                Navigator.pushNamed(context, card.actionRoute!);
              }
            }
          : null,
      backgroundColor: getCardColor(card.colorScheme),
      padding: const EdgeInsets.all(16),
      borderSide: BorderSide(
        color: textColor.withValues(alpha: 0.15),
        width: 1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: textColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: textColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Icon(getCardIcon(card.icon), color: textColor, size: 20),
              ),
              if (card.change != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: textColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: textColor.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    card.change!,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                card.title,
                style: AppTextStyles.titleSmall.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (card.subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  card.subtitle!,
                  style: AppTextStyles.caption.copyWith(
                    color: textColor.withValues(alpha: 0.7),
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 8),
              Text(
                card.value,
                style: AppTextStyles.headlineSmall.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context, List<Report> reports) {
    final recentReports = reports.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Aktivitas Terbaru',
          subtitle: 'Laporan dan kiriman terbaru Anda',
          trailing: TacoBadge.info(text: '${recentReports.length} Laporan'),
        ),
        const SizedBox(height: 16),
        if (recentReports.isEmpty)
          EmptyState(
            title: 'Belum Ada Laporan',
            subtitle: 'Buat laporan pertama Anda untuk memulai',
            actionText: 'Buat Laporan',
            onAction: _openCreateReport,
          )
        else
          Column(
            children: recentReports.map((report) {
              return TacoListItem(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      report.inputType == ReportInputType.voice
                          ? Iconsax.microphone_copy
                          : Iconsax.document_text_1_copy,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                ),
                title: Text(
                  report.outletName,
                  style: AppTextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.content.length > 60
                          ? '${report.content.substring(0, 60)}...'
                          : report.content,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        TacoBadge(
                          text: '${report.pointsEarned} Poin',
                          backgroundColor: AppColors.successLight,
                          textColor: AppColors.success,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${report.createdAt.day}/${report.createdAt.month}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                onTap: () => showReportDetailSheet(context, report),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildPerformanceSummary(User user) {
    final progressValue = user.stats.totalObjectives > 0
        ? user.stats.completedObjectives / user.stats.totalObjectives
        : 0.0;

    return TacoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Ringkasan Performa',
            subtitle: 'Ringkasan performa mingguan Anda',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '${user.stats.reportsThisWeek}',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    Text('Laporan', style: AppTextStyles.caption),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      user.stats.averageReportQuality.toStringAsFixed(1),
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                    Text('Kualitas Rata-rata', style: AppTextStyles.caption),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '${user.stats.dailyProductivity.toStringAsFixed(0)}%',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                    Text('Produktivitas', style: AppTextStyles.caption),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ProgressBar(
            value: progressValue,
            backgroundColor: AppColors.surfaceVariant,
            progressColor: AppColors.primary,
            height: 8,
            margin: const EdgeInsets.symmetric(vertical: 8),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Progres Target', style: AppTextStyles.bodySmall),
              Text(
                '${user.stats.completedObjectives}/${user.stats.totalObjectives}',
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCreateReportButton() {
    return TacoButton(
      text: 'Buat Laporan',
      size: ButtonSize.large,
      icon: const Icon(Iconsax.add_copy, size: 18, color: Colors.white),
      onPressed: _openCreateReport,
    );
  }
}
