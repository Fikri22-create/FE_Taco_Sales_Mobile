import 'package:flutter/material.dart';
import 'package:taco_sales_insight/data/mock_data.dart';
import 'package:taco_sales_insight/shared/app_colors.dart';
import 'package:taco_sales_insight/shared/app_text_styles.dart';
import 'package:taco_sales_insight/shared/common_widgets.dart';
import 'package:taco_sales_insight/models/report.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final List<String> _filterOptions = ['Semua', 'Minggu Ini', 'Bulan Ini', 'Voice', 'Text'];
  String _selectedFilter = 'Semua';
  String _searchQuery = '';
  bool _isLoading = false;

  List<Report> get _filteredReports {
    List<Report> reports = MockData.reports;

    if (_searchQuery.isNotEmpty) {
      reports = reports.where((report) {
        return report.outletName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          report.content.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    if (_selectedFilter == 'Voice') {
      reports = reports.where((report) => report.inputType == ReportInputType.voice).toList();
    } else if (_selectedFilter == 'Text') {
      reports = reports.where((report) => report.inputType == ReportInputType.text).toList();
    }

    return reports;
  }

  void _refreshData() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Filter Laporan',
                  style: AppTextStyles.titleMedium,
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: AppColors.divider,
              ),
              ..._filterOptions.map((filter) {
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedFilter = filter;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              filter,
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: _selectedFilter == filter
                                    ? AppColors.primary
                                    : AppColors.textPrimary,
                                fontWeight: _selectedFilter == filter
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (_selectedFilter == filter)
                            const Icon(
                              Icons.check,
                              color: AppColors.primary,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReportStatusBadge(Report report) {
    switch (report.status) {
      case ReportStatus.completed:
        return TacoBadge.success(text: 'Selesai');
      case ReportStatus.confirmed:
        return TacoBadge.success(text: 'Dikonfirmasi');
      case ReportStatus.processing:
        return TacoBadge.info(text: 'Diproses');
      case ReportStatus.draft:
        return TacoBadge.warning(text: 'Draf');
      case ReportStatus.needsConfirmation:
        return TacoBadge.warning(text: 'Perlu Konfirmasi');
      case ReportStatus.failed:
        return TacoBadge.error(text: 'Gagal');
      default:
        return TacoBadge(text: report.status.name);
    }
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
        color: color.withOpacity(0.1),
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Detail Laporan',
                        style: AppTextStyles.titleLarge,
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, thickness: 1, color: AppColors.divider), 
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TacoCard(
                        child: Row(
                          children: [
                            Icon(
                              Icons.store,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    report.outletName,
                                    style: AppTextStyles.titleMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    report.createdAt.toString(),
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _buildReportStatusBadge(report),
                          const SizedBox(width: 8),
                          _buildConfidenceBadge(report),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 14,
                                  color: AppColors.accent,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${report.pointsEarned} points',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Isi Laporan',
                            style: AppTextStyles.titleSmall.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            report.content,
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      TacoCard(
                        backgroundColor: AppColors.surfaceVariant,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Informasi Laporan',
                              style: AppTextStyles.titleSmall.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        '${report.metadata.wordCount}',
                                        style: AppTextStyles.titleMedium.copyWith(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      Text(
                                        'Kata',
                                        style: AppTextStyles.caption,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        report.inputType == ReportInputType.voice
                                            ? 'Voice'
                                            : 'Text',
                                        style: AppTextStyles.titleMedium.copyWith(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      Text(
                                        'Input Type',
                                        style: AppTextStyles.caption,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        report.metadata.processingTimeSeconds.toString(),
                                        style: AppTextStyles.titleMedium.copyWith(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      Text(
                                        'Detik',
                                        style: AppTextStyles.caption,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (report.aiAnalysis != null) ...[
                        TacoCard(
                          backgroundColor: AppColors.infoLight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Analisis AI',
                                style: AppTextStyles.titleSmall.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                report.aiAnalysis!.summary,
                                style: AppTextStyles.bodyMedium,
                              ),
                              const SizedBox(height: 12),
                              if (report.aiAnalysis!.keyFindings.isNotEmpty) ...[
                                Text(
                                  'Key Findings:',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                ...report.aiAnalysis!.keyFindings.map((finding) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      '• $finding',
                                      style: AppTextStyles.bodySmall,
                                    ),
                                  );
                                }),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      Row(
                        children: [
                          Expanded(
                            child: TacoButton(
                              text: 'Tutup',
                              onPressed: () => Navigator.pop(context),
                              type: ButtonType.outline,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TacoButton(
                              text: 'Edit',
                              onPressed: () {
                              },
                              type: ButtonType.secondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredReports = _filteredReports;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Laporan'),
        actions: [
          IconButton(
            onPressed: _refreshData,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TacoTextField(
                  label: 'Cari laporan',
                  hintText: 'Cari berdasarkan outlet atau isi laporan...',
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  prefixIcon: const Icon(Icons.search, size: 20),
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
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = selected ? filter : 'Semua';
                            });
                          },
                          backgroundColor: AppColors.surfaceVariant,
                          selectedColor: AppColors.primary.withOpacity(0.1),
                          labelStyle: AppTextStyles.bodySmall.copyWith(
                            color: isSelected ? AppColors.primary : AppColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected ? AppColors.primary : AppColors.border,
                              width: 1,
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
          Divider(height: 1, thickness: 1, color: AppColors.divider),
          Expanded(
            child: _isLoading
                ? const LoadingIndicator(message: 'Memuat laporan...')
                : filteredReports.isEmpty
                    ? EmptyState(
                        title: 'Tidak ada laporan',
                        subtitle: _searchQuery.isNotEmpty
                            ? 'Tidak ada laporan yang cocok dengan pencarian Anda'
                            : 'Mulai dengan membuat laporan pertama Anda',
                        actionText: 'Buat Laporan',
                        onAction: () {
                        },
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          _refreshData();
                          return Future.delayed(const Duration(milliseconds: 500));
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 80),
                          itemCount: filteredReports.length,
                          itemBuilder: (context, index) {
                            final report = filteredReports[index];
                            return TacoListItem(
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: report.inputType == ReportInputType.voice
                                      ? AppColors.secondary.withOpacity(0.1)
                                      : AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Icon(
                                    report.inputType == ReportInputType.voice
                                        ? Icons.mic
                                        : Icons.text_fields,
                                    color: report.inputType == ReportInputType.voice
                                        ? AppColors.secondary
                                        : AppColors.primary,
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
                                  const SizedBox(height: 4),
                                  Text(
                                    report.content.length > 80
                                        ? '${report.content.substring(0, 80)}...'
                                        : report.content,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      _buildReportStatusBadge(report),
                                      const SizedBox(width: 8),
                                      _buildConfidenceBadge(report),
                                      const Spacer(),
                                      Text(
                                        '${report.createdAt.day}/${report.createdAt.month}/${report.createdAt.year}',
                                        style: AppTextStyles.caption.copyWith(
                                          color: AppColors.textTertiary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.accent.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      size: 12,
                                      color: AppColors.accent,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${report.pointsEarned}',
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.accent,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () => _viewReportDetails(report),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}