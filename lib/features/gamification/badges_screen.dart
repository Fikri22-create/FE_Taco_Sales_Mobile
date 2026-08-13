import 'package:flutter/material.dart' hide Badge;
import 'package:taco_sales_insight/data/mock_data.dart';
import 'package:taco_sales_insight/models/gamification.dart';
import 'package:taco_sales_insight/shared/app_colors.dart';
import 'package:taco_sales_insight/shared/app_text_styles.dart';
import 'package:taco_sales_insight/shared/common_widgets.dart';

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final unlockedBadges = MockData.unlockedBadges;
    final lockedBadges = MockData.lockedBadges;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Badges'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showBadgeInfo(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats
            Row(
              children: [
                Expanded(
                  child: TacoCard(
                    child: Column(
                      children: [
                        Text(
                          'Unlocked',
                          style: AppTextStyles.caption,
                        ),
                        Text(
                          unlockedBadges.length.toString(),
                          style: AppTextStyles.displaySmall.copyWith(
                            color: AppColors.secondary,
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
                          'Total',
                          style: AppTextStyles.caption,
                        ),
                        Text(
                          MockData.badges.length.toString(),
                          style: AppTextStyles.displaySmall,
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
                          'Progress',
                          style: AppTextStyles.caption,
                        ),
                        Text(
                          '${((unlockedBadges.length / MockData.badges.length) * 100).toInt()}%',
                          style: AppTextStyles.displaySmall.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Unlocked Badges
            if (unlockedBadges.isNotEmpty) ...[
              const SectionHeader(
                title: 'Badges Terbuka',
                subtitle: 'Badges yang sudah Anda dapatkan',
              ),
              const SizedBox(height: 12),
              
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: unlockedBadges.map((badge) {
                  return _buildBadgeCard(badge, true);
                }).toList(),
              ),
              const SizedBox(height: 32),
            ],
            
            // Locked Badges
            if (lockedBadges.isNotEmpty) ...[
              const SectionHeader(
                title: 'Badges Terkunci',
                subtitle: 'Selesaikan misi untuk mendapatkan badges',
              ),
              const SizedBox(height: 12),
              
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: lockedBadges.map((badge) {
                  return _buildBadgeCard(badge, false);
                }).toList(),
              ),
              const SizedBox(height: 32),
            ],
            
            // Info
            TacoCard(
              backgroundColor: AppColors.infoLight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cara Mendapatkan Badges',
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• Pioneer: Lakukan 50 laporan pertama\n'
                    '• Consistency King: Lapor 7 hari berturut-turut\n'
                    '• Quality Expert: 80% laporan dengan confidence tinggi\n'
                    '• Voice Master: 100 laporan menggunakan voice\n'
                    '• Text Wizard: 50 laporan menggunakan text\n'
                    '• Market Expert: Temukan 50 signal kompetitor\n'
                    '• Speed Demon: Buat laporan dalam <2 menit',
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
  
  Widget _buildBadgeCard(Badge badge, bool isUnlocked) {
    return TacoCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: isUnlocked 
                      ? AppColors.secondary.withOpacity(0.1)
                      : AppColors.surfaceVariant,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    badge.icon,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
              if (!isUnlocked)
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.lock,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            badge.name,
            style: AppTextStyles.titleSmall.copyWith(
              color: isUnlocked ? AppColors.textPrimary : AppColors.textTertiary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          if (isUnlocked)
            Text(
              badge.description,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          if (!isUnlocked)
            Text(
              'Progress: ${badge.progress}/${badge.requiredProgress}',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
        ],
      ),
    );
  }
  
  void _showBadgeInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tentang Badges'),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Badges adalah penghargaan yang Anda dapatkan dengan menyelesaikan berbagai misi dan mencapai milestone dalam aplikasi.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Manfaat Badges:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('• Meningkatkan ranking leaderboard\n'
                     '• Memberikan bonus points\n'
                     '• Membuka fitur premium\n'
                     '• Meningkatkan SKI score'),
                SizedBox(height: 16),
                Text(
                  'Setiap badge memiliki progress yang dapat Anda lihat. Klik badge untuk melihat detail.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          actions: [
            TacoButton(
              text: 'Mengerti',
              onPressed: () {
                Navigator.pop(context);
              },
              isFullWidth: false,
            ),
          ],
        );
      },
    );
  }
}