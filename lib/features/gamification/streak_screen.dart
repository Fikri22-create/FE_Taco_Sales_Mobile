import 'package:flutter/material.dart';
import 'package:taco_sales_insight/data/mock_data.dart';
import 'package:taco_sales_insight/shared/app_colors.dart';
import 'package:taco_sales_insight/shared/app_text_styles.dart';
import 'package:taco_sales_insight/shared/common_widgets.dart';

class StreakScreen extends StatelessWidget {
  const StreakScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final streakData = MockData.streakData;
    final currentStreak = streakData.currentStreak;
    final longestStreak = streakData.longestStreak;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Streak'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Streak Card
            TacoCard(
              child: Column(
                children: [
                  Text(
                    'Current Streak',
                    style: AppTextStyles.caption,
                  ),
                  Text(
                    '$currentStreak hari',
                    style: AppTextStyles.displayLarge.copyWith(
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Dimulai ${_formatDate(streakData.streakStartDate)}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Stats
            Row(
              children: [
                Expanded(
                  child: TacoCard(
                    child: Column(
                      children: [
                        Text(
                          'Longest Streak',
                          style: AppTextStyles.caption,
                        ),
                        Text(
                          '$longestStreak hari',
                          style: AppTextStyles.displaySmall.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TacoCard(
                    child: Column(
                      children: [
                        Text(
                          'Points Earned',
                          style: AppTextStyles.caption,
                        ),
                        Text(
                          '${currentStreak * 5}',
                          style: AppTextStyles.displaySmall.copyWith(
                            color: AppColors.gold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Streak Calendar
            const SectionHeader(
              title: 'Kalender Streak',
              subtitle: '30 hari terakhir',
            ),
            const SizedBox(height: 12),
            
            TacoCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildCalendarHeader(),
                  const SizedBox(height: 16),
                  _buildCalendarGrid(streakData),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Milestones
            const SectionHeader(
              title: 'Milestones',
              subtitle: 'Target streak selanjutnya',
            ),
            const SizedBox(height: 12),
            
            Column(
              children: [
                _buildMilestone(7, 'Weekly King', currentStreak >= 7),
                _buildMilestone(14, 'Fortnight Hero', currentStreak >= 14),
                _buildMilestone(30, 'Monthly Master', currentStreak >= 30),
                _buildMilestone(100, 'Century Club', currentStreak >= 100),
              ],
            ),
            const SizedBox(height: 32),
            
            // Streak Benefits
            TacoCard(
              backgroundColor: AppColors.successLight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Manfaat Streak',
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• +5 points bonus setiap hari streak\n'
                    '• 2x points pada hari ke-7\n'
                    '• 3x points pada hari ke-30\n'
                    '• Unlock badge "Consistency King"\n'
                    '• Prioritas di leaderboard',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Tips
            TacoCard(
              backgroundColor: AppColors.infoLight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tips Menjaga Streak',
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• Buat laporan sebelum tengah malam\n'
                    '• Aktifkan notifikasi pengingat\n'
                    '• Gunakan voice input untuk lebih cepat\n'
                    '• Backup laporan di offline mode\n'
                    '• Jangan tunggu sampai deadline',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCalendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text('M', style: TextStyle(fontWeight: FontWeight.w600)),
        Text('S', style: TextStyle(fontWeight: FontWeight.w600)),
        Text('S', style: TextStyle(fontWeight: FontWeight.w600)),
        Text('R', style: TextStyle(fontWeight: FontWeight.w600)),
        Text('K', style: TextStyle(fontWeight: FontWeight.w600)),
        Text('J', style: TextStyle(fontWeight: FontWeight.w600)),
        Text('S', style: TextStyle(fontWeight: FontWeight.w600)),
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
        final hasReport = streakData.dailyProgress[date] ?? false;
        final isToday = date.year == today.year &&
                        date.month == today.month &&
                        date.day == today.day;
        
        return Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: hasReport ? AppColors.secondary : AppColors.surfaceVariant,
            shape: BoxShape.circle,
            border: isToday
                ? Border.all(color: AppColors.primary, width: 2)
                : null,
          ),
          child: Center(
            child: Text(
              date.day.toString(),
              style: AppTextStyles.bodySmall.copyWith(
                color: hasReport ? Colors.white : AppColors.textSecondary,
                fontWeight: hasReport ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildMilestone(int days, String title, bool isAchieved) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TacoCard(
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isAchieved ? AppColors.secondary : AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  isAchieved ? Icons.check : Icons.star_border,
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
                    '$days Hari Streak',
                    style: AppTextStyles.titleSmall,
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
                  isAchieved ? 'TERCAPAI' : '${days} days',
                  style: AppTextStyles.caption.copyWith(
                    color: isAchieved ? AppColors.success : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  isAchieved ? '${days * 5} points' : '${days * 5} points',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ],
        ),
      ),
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
  
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}