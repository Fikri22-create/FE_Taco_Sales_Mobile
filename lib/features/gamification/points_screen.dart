import 'package:flutter/material.dart';
import 'package:taco_sales_insight/data/mock_data.dart';
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
  final List<String> _filterOptions = ['Semua', 'Hari Ini', 'Minggu Ini', 'Bulan Ini'];
  String _selectedFilter = 'Semua';
  List<PointTransaction> _filteredTransactions = [];

  @override
  void initState() {
    super.initState();
    _filteredTransactions = _getMockTransactions();
  }

  List<PointTransaction> _getMockTransactions() {
    return [
      PointTransaction(
        id: 'txn_001',
        amount: 25,
        type: PointTransactionType.report,
        description: 'Laporan Supermarket Mega Jaya',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        relatedEntityId: 'report_001',
        relatedEntityType: 'report',
      ),
      PointTransaction(
        id: 'txn_002',
        amount: 10,
        type: PointTransactionType.streak,
        description: 'Maintain 7-day streak',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        relatedEntityId: 'streak_001',
        relatedEntityType: 'streak',
      ),
      PointTransaction(
        id: 'txn_003',
        amount: 15,
        type: PointTransactionType.badge,
        description: 'Unlocked Consistency King badge',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        relatedEntityId: 'badge_002',
        relatedEntityType: 'badge',
      ),
      PointTransaction(
        id: 'txn_004',
        amount: 20,
        type: PointTransactionType.report,
        description: 'Laporan Minimarket Sejahtera',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        relatedEntityId: 'report_002',
        relatedEntityType: 'report',
      ),
      PointTransaction(
        id: 'txn_005',
        amount: 50,
        type: PointTransactionType.bonus,
        description: 'Weekly achievement bonus',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        relatedEntityId: 'bonus_001',
        relatedEntityType: 'bonus',
      ),
      PointTransaction(
        id: 'txn_006',
        amount: 10,
        type: PointTransactionType.streak,
        description: 'Maintain 6-day streak',
        timestamp: DateTime.now().subtract(const Duration(days: 4)),
        relatedEntityId: 'streak_001',
        relatedEntityType: 'streak',
      ),
      PointTransaction(
        id: 'txn_007',
        amount: 15,
        type: PointTransactionType.report,
        description: 'Laporan Pasar Tradisional Menteng',
        timestamp: DateTime.now().subtract(const Duration(days: 5)),
        relatedEntityId: 'report_003',
        relatedEntityType: 'report',
      ),
    ];
  }

  void _filterTransactions() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekAgo = now.subtract(const Duration(days: 7));
    final monthAgo = now.subtract(const Duration(days: 30));

    List<PointTransaction> filtered = _getMockTransactions();

    switch (_selectedFilter) {
      case 'Hari Ini':
        filtered = filtered.where((txn) => txn.timestamp.isAfter(today)).toList();
        break;
      case 'Minggu Ini':
        filtered = filtered.where((txn) => txn.timestamp.isAfter(weekAgo)).toList();
        break;
      case 'Bulan Ini':
        filtered = filtered.where((txn) => txn.timestamp.isAfter(monthAgo)).toList();
        break;
      // 'Semua' - no filtering needed
    }

    setState(() {
      _filteredTransactions = filtered;
    });
  }

  String _getTransactionTypeLabel(PointTransactionType type) {
    switch (type) {
      case PointTransactionType.report:
        return 'Laporan';
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
        return 'Koreksi';
    }
  }

  IconData _getTransactionTypeIcon(PointTransactionType type) {
    switch (type) {
      case PointTransactionType.report:
        return Icons.description;
      case PointTransactionType.streak:
        return Icons.local_fire_department;
      case PointTransactionType.badge:
        return Icons.workspace_premium;
      case PointTransactionType.bonus:
        return Icons.card_giftcard;
      case PointTransactionType.achievement:
        return Icons.emoji_events;
      case PointTransactionType.referral:
        return Icons.group_add;
      case PointTransactionType.correction:
        return Icons.edit;
    }
  }

  Color _getTransactionTypeColor(PointTransactionType type) {
    switch (type) {
      case PointTransactionType.report:
        return AppColors.primary;
      case PointTransactionType.streak:
        return AppColors.streakActive;
      case PointTransactionType.badge:
        return AppColors.secondary;
      case PointTransactionType.bonus:
        return AppColors.accent;
      case PointTransactionType.achievement:
        return AppColors.gold;
      case PointTransactionType.referral:
        return AppColors.chartPurple;
      case PointTransactionType.correction:
        return AppColors.warning;
    }
  }

  Widget _buildPointsSummary() {
    final user = MockData.currentUser;
    final weeklyTotal = _getMockTransactions()
        .where((txn) => txn.timestamp.isAfter(DateTime.now().subtract(const Duration(days: 7))))
        .fold(0, (sum, txn) => sum + txn.amount);
    
    final monthlyTotal = _getMockTransactions()
        .where((txn) => txn.timestamp.isAfter(DateTime.now().subtract(const Duration(days: 30))))
        .fold(0, (sum, txn) => sum + txn.amount);

    return TacoCard(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  'Total Points',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${user.totalPoints}',
                  style: AppTextStyles.displaySmall.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.trending_up,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '+$weeklyTotal minggu ini',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '$weeklyTotal',
                            style: AppTextStyles.headlineSmall.copyWith(
                              color: AppColors.success,
                            ),
                          ),
                          Text(
                            'Minggu Ini',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '$monthlyTotal',
                            style: AppTextStyles.headlineSmall.copyWith(
                              color: AppColors.secondary,
                            ),
                          ),
                          Text(
                            'Bulan Ini',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${_filteredTransactions.length}',
                            style: AppTextStyles.headlineSmall.copyWith(
                              color: AppColors.accent,
                            ),
                          ),
                          Text(
                            'Transaksi',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
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
                  _filterTransactions();
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
    );
  }

  Widget _buildTransactionItem(PointTransaction transaction) {
    final color = _getTransactionTypeColor(transaction.type);
    final icon = _getTransactionTypeIcon(transaction.type);
    final typeLabel = _getTransactionTypeLabel(transaction.type);
    
    final formattedTime = _formatTimeAgo(transaction.timestamp);

    return TacoListItem(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: color,
          size: 20,
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              transaction.description,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: transaction.amount > 0 
                  ? AppColors.success.withOpacity(0.1)
                  : AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  transaction.amount > 0 ? Icons.add : Icons.remove,
                  size: 12,
                  color: transaction.amount > 0 ? AppColors.success : AppColors.error,
                ),
                const SizedBox(width: 4),
                Text(
                  '${transaction.amount.abs()}',
                  style: AppTextStyles.caption.copyWith(
                    color: transaction.amount > 0 ? AppColors.success : AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Row(
            children: [
              TacoBadge(
                text: typeLabel,
                backgroundColor: color.withOpacity(0.1),
                textColor: color,
              ),
              const Spacer(),
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
      onTap: () {
      },
    );
  }

  String _formatTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    } else if (difference.inDays < 30) {
      return '${difference.inDays ~/ 7} minggu lalu';
    } else {
      return '${difference.inDays ~/ 30} bulan lalu';
    }
  }

  Widget _buildInfoSection() {
    return TacoCard(
      backgroundColor: AppColors.infoLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cara Mendapatkan Points',
            style: AppTextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '• Laporan berkualitas: 15-25 points\n'
            '• Maintain daily streak: 10 points/hari\n'
            '• Unlock badges: 15-50 points\n'
            '• Weekly achievements: bonus points\n'
            '• Referrals: 100 points/orang\n'
            '• Special events: bonus points',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 16),
          Text(
            'Tingkatkan Kualitas Laporan',
            style: AppTextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '• Deskripsi detail: +5 points\n'
            '• Foto pendukung: +10 points\n'
            '• Competitor signals: +15 points\n'
            '• Voice reports: +5 points',
            style: AppTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Points & Rewards'),
        actions: [
          IconButton(
            onPressed: () {
              // Show points info
            },
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPointsSummary(),
            const SizedBox(height: 24),

            const SectionHeader(
              title: 'Riwayat Transaksi',
              subtitle: 'Track your points earnings',
            ),
            const SizedBox(height: 16),
            _buildFilterChips(),
            const SizedBox(height: 24),

            if (_filteredTransactions.isEmpty)
              const EmptyState(
                title: 'Tidak ada transaksi',
                subtitle: 'Belum ada transaksi points untuk periode ini',
              )
            else
              Column(
                children: _filteredTransactions
                    .map((transaction) => _buildTransactionItem(transaction))
                    .toList(),
              ),

            const SizedBox(height: 32),
            _buildInfoSection(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}