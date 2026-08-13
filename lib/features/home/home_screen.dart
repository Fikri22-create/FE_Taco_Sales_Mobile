import 'package:flutter/material.dart';
import 'package:taco_sales_insight/data/mock_data.dart';
import 'package:taco_sales_insight/shared/app_colors.dart';
import 'package:taco_sales_insight/shared/app_text_styles.dart';
import 'package:taco_sales_insight/shared/common_widgets.dart';
import 'package:taco_sales_insight/models/intel_card.dart';
import 'package:taco_sales_insight/models/report.dart';
import 'package:taco_sales_insight/models/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User _currentUser;
  late List<IntelCard> _intelCards;

  @override
  void initState() {
    super.initState();
    _currentUser = MockData.currentUser;
    _intelCards = MockData.intelCards;
  }

  void _refreshData() {
    setState(() {
      // In a real app, this would fetch new data
      _intelCards = MockData.intelCards;
    });
  }

  void _navigateToReport() {
    Navigator.pushNamed(context, '/report/text-input',
        arguments: MockData.outlets.first);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          _refreshData();
          return Future.delayed(const Duration(milliseconds: 500));
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Header with Greeting
              _buildHeader(),
              const SizedBox(height: 24),

              // Quick Stats Row
              _buildQuickStats(),
              const SizedBox(height: 24),

              // Intel Cards Grid
              _buildIntelCardsGrid(),
              const SizedBox(height: 24),

              // Recent Activity
              _buildRecentActivity(),
              const SizedBox(height: 24),

              // Performance Summary
              _buildPerformanceSummary(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToReport,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  Widget _buildHeader() {
    final time = DateTime.now().hour;
    String greeting;
    if (time < 12) {
      greeting = 'Selamat Pagi';
    } else if (time < 15) {
      greeting = 'Selamat Siang';
    } else if (time < 19) {
      greeting = 'Selamat Sore';
    } else {
      greeting = 'Selamat Malam';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting,',
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _currentUser.name,
          style: AppTextStyles.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Sales Code: ${_currentUser.salesCode} | ${_currentUser.region}',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: TacoCard(
            onTap: () => Navigator.pushNamed(context, '/profile/points'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Points',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: AppColors.textTertiary,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${_currentUser.totalPoints}',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '+25 this week',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TacoCard(
            onTap: () => Navigator.pushNamed(context, '/profile/streak'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Streak',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: AppColors.textTertiary,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${_currentUser.currentStreak} days',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.streakActive,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Best: ${_currentUser.bestStreak} days',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIntelCardsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Insights',
          subtitle: 'Ringkasan aktivitas Anda',
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.1,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: _intelCards
              .where((card) =>
                  card.type != IntelCardType.quickAction &&
                  card.type != IntelCardType.notification)
              .map((card) => _buildIntelCard(card))
              .toList(),
        ),
        const SizedBox(height: 16),

        // Quick Action & Notification Cards
        Row(
          children: [
            Expanded(
              child: _buildIntelCard(_intelCards
                  .firstWhere((card) => card.type == IntelCardType.quickAction)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildIntelCard(_intelCards
                  .firstWhere((card) => card.type == IntelCardType.notification)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIntelCard(IntelCard card) {
    Color getCardColor(IntelCardColorScheme scheme) {
      switch (scheme) {
        case IntelCardColorScheme.blue:
          return AppColors.chartBlue.withOpacity(0.1);
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

    return TacoCard(
      onTap: card.isInteractive ? () {
        if (card.actionRoute != null) {
          Navigator.pushNamed(context, card.actionRoute!);
        }
      } : null,
      backgroundColor: getCardColor(card.colorScheme),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                card.icon,
                style: const TextStyle(fontSize: 24),
              ),
              if (card.change != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: getTextColor(card.colorScheme).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    card.change!,
                    style: AppTextStyles.caption.copyWith(
                      color: getTextColor(card.colorScheme),
                      fontWeight: FontWeight.w600,
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
                  color: getTextColor(card.colorScheme),
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (card.subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  card.subtitle!,
                  style: AppTextStyles.caption.copyWith(
                    color: getTextColor(card.colorScheme).withOpacity(0.7),
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                card.value,
                style: AppTextStyles.headlineSmall.copyWith(
                  color: getTextColor(card.colorScheme),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    final recentReports = MockData.reports.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Aktivitas Terkini',
          subtitle: 'Laporan Anda yang terbaru',
          trailing: TacoBadge.info(text: '3 items'),
        ),
        const SizedBox(height: 16),
        if (recentReports.isEmpty)
          const EmptyState(
            title: 'Belum ada laporan',
            subtitle: 'Mulai dengan membuat laporan pertama Anda',
            actionText: 'Buat Laporan',
            onAction: null, // Will be handled by FAB
          )
        else
          Column(
            children: recentReports.map((report) {
              return TacoListItem(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      report.inputType == ReportInputType.voice
                          ? Icons.mic
                          : Icons.text_fields,
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
                          text: '${report.pointsEarned} points',
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
                onTap: () {
                  // Navigate to report detail
                },
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildPerformanceSummary() {
    return TacoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Ringkasan Performa',
            subtitle: 'Statistik minggu ini',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '${_currentUser.stats.reportsThisWeek}',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      'Laporan',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '${_currentUser.stats.averageReportQuality.toStringAsFixed(1)}',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                    Text(
                      'Rata-rata Kualitas',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '${_currentUser.stats.dailyProductivity.toStringAsFixed(0)}%',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                    Text(
                      'Produktivitas',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ProgressBar(
            value: _currentUser.stats.completedObjectives /
                _currentUser.stats.totalObjectives,
            backgroundColor: AppColors.surfaceVariant,
            progressColor: AppColors.primary,
            height: 8,
            margin: const EdgeInsets.symmetric(vertical: 8),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Objectives',
                style: AppTextStyles.bodySmall,
              ),
              Text(
                '${_currentUser.stats.completedObjectives}/${_currentUser.stats.totalObjectives}',
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
}