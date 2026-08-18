import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taco_sales_insight/core/state/app_state.dart';
import 'package:taco_sales_insight/models/report.dart';
import 'package:taco_sales_insight/shared/app_colors.dart';
import 'package:taco_sales_insight/shared/app_text_styles.dart';
import 'package:taco_sales_insight/shared/common_widgets.dart';
import 'package:taco_sales_insight/shared/report_detail_sheet.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key, this.onCreateReport});

  final VoidCallback? onCreateReport;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final List<String> _filterKeys = [
    'Semua',
    '7 Hari Terakhir',
    'Bulan Ini',
    'Suara',
    'Teks',
  ];
  String _selectedFilterKey = 'Semua';
  String _searchQuery = '';
  bool _isLoading = false;
  String? _errorMessage;

  List<Report> _filterReports(List<Report> reports) {
    final query = _searchQuery.trim().toLowerCase();
    final now = DateTime.now();

    return reports.where((report) {
      if (query.isNotEmpty) {
        final matchesQuery =
            report.outletName.toLowerCase().contains(query) ||
            report.content.toLowerCase().contains(query);
        if (!matchesQuery) return false;
      }

      switch (_selectedFilterKey) {
        case '7 Hari Terakhir':
          final weekAgo = now.subtract(const Duration(days: 7));
          if (report.createdAt.isBefore(weekAgo)) return false;
          break;
        case 'Bulan Ini':
          if (report.createdAt.year != now.year ||
              report.createdAt.month != now.month) {
            return false;
          }
          break;
        case 'Suara':
          if (report.inputType != ReportInputType.voice) return false;
          break;
        case 'Teks':
          if (report.inputType != ReportInputType.text) return false;
          break;
      }

      return true;
    }).toList();
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await Future.delayed(const Duration(milliseconds: 800));
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage =
            'Terjadi kesalahan saat memuat laporan. Silakan coba lagi.';
      });
      return;
    }

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildConfidenceBadge(Report report) {
    Color color;
    String text;

    switch (report.confidence) {
      case ReportConfidence.veryHigh:
        color = AppColors.success;
        text = 'Sangat Tinggi';
      case ReportConfidence.high:
        color = AppColors.success;
        text = 'Tinggi';
      case ReportConfidence.medium:
        color = AppColors.warning;
        text = 'Sedang';
      case ReportConfidence.low:
        color = AppColors.error;
        text = 'Rendah';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _viewReportDetails(Report report) {
    showReportDetailSheet(context, report);
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final filteredReports = _filterReports(appState.reports);
    final isOffline = appState.isOfflineSimulated;

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
        child: Column(
          children: [
            _buildHeader(context, filteredReports.length),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                children: [
                  TacoTextField(
                    label: 'Cari',
                    hintText: 'Cari laporan berdasarkan nama outlet atau isi',
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    prefixIcon: const Icon(
                      Iconsax.search_normal_1_copy,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _filterKeys.map((filterKey) {
                        final isSelected = _selectedFilterKey == filterKey;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? LinearGradient(
                                      colors: [
                                        AppColors.primary,
                                        AppColors.secondary.withValues(
                                          alpha: 0.8,
                                        ),
                                      ],
                                    )
                                  : null,
                              color: isSelected
                                  ? null
                                  : AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.transparent
                                    : AppColors.border,
                                width: 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.2,
                                        ),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedFilterKey = filterKey;
                                  });
                                },
                                borderRadius: BorderRadius.circular(20),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  child: Text(
                                    filterKey,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.textPrimary,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildBody(filteredReports, isOffline)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int reportCount) {
    return TacoPremiumHeader(
      title: 'Riwayat Laporan',
      subtitle: '$reportCount Laporan',
      showBackButton: Navigator.canPop(context),
      trailing: IconButton(
        onPressed: _refreshData,
        icon: const Icon(Iconsax.refresh_copy, color: Colors.white),
        style: IconButton.styleFrom(
          backgroundColor: Colors.white.withValues(alpha: 0.15),
        ),
      ),
    );
  }

  Widget _buildBody(List<Report> filteredReports, bool isOffline) {
    if (_isLoading) {
      return LoadingIndicator(message: 'Memuat laporan...');
    }

    if (_errorMessage != null) {
      return ErrorState(
        title: 'Gagal memuat laporan',
        subtitle: _errorMessage,
        retryText: 'Coba Lagi',
        onRetry: _refreshData,
      );
    }

    if (isOffline) {
      return OfflineState(
        subtitle: 'Anda sedang offline',
        retryText: 'Coba Lagi',
        onRetry: _refreshData,
      );
    }

    if (filteredReports.isEmpty) {
      return EmptyState(
        title: 'Belum Ada Laporan',
        subtitle: _searchQuery.isNotEmpty
            ? 'Tidak ada laporan yang cocok dengan pencarian Anda'
            : 'Belum ada laporan',
        actionText: 'Buat Laporan',
        onAction: () {
          if (widget.onCreateReport != null) {
            widget.onCreateReport!();
          } else {
            Navigator.pushNamed(context, '/report/select-outlet');
          }
        },
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 100),
        itemCount: filteredReports.length,
        itemBuilder: (context, index) {
          final report = filteredReports[index];
          final isVoice = report.inputType == ReportInputType.voice;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.border.withValues(alpha: 0.5),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _viewReportDetails(report),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isVoice
                                      ? [
                                          AppColors.secondary,
                                          AppColors.secondary.withValues(
                                            alpha: 0.7,
                                          ),
                                        ]
                                      : [
                                          AppColors.primary,
                                          AppColors.primary.withValues(
                                            alpha: 0.7,
                                          ),
                                        ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        (isVoice
                                                ? AppColors.secondary
                                                : AppColors.primary)
                                            .withValues(alpha: 0.15),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                isVoice
                                    ? Iconsax.microphone_2_copy
                                    : Iconsax.document_text_1_copy,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    report.outletName,
                                    style: AppTextStyles.titleSmall.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
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
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Divider(
                          height: 1,
                          color: AppColors.divider.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  StatusBadge(status: report.status),
                                  const SizedBox(width: 8),
                                  _buildConfidenceBadge(report),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.accent,
                                    AppColors.accent.withValues(alpha: 0.8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Iconsax.star_1_copy,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${report.pointsEarned}',
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${report.createdAt.day}/${report.createdAt.month}/${report.createdAt.year}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
