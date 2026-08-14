import 'package:flutter/material.dart' hide Badge;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:taco_sales_insight/data/mock_data.dart';
import 'package:taco_sales_insight/models/gamification.dart';
import 'package:taco_sales_insight/shared/app_colors.dart';
import 'package:taco_sales_insight/shared/app_text_styles.dart';
import 'package:taco_sales_insight/shared/common_widgets.dart';

class BadgesScreen extends StatefulWidget {
  const BadgesScreen({super.key});

  @override
  State<BadgesScreen> createState() => _BadgesScreenState();
}

class _BadgesScreenState extends State<BadgesScreen>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _glowAnimations;

  @override
  void initState() {
    super.initState();
    final unlockedCount = MockData.unlockedBadges.length;
    _controllers = List.generate(
      unlockedCount,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
      )..repeat(),
    );
    _glowAnimations = _controllers
        .map((controller) =>
            Tween<double>(begin: 0.2, end: 0.5).animate(
              CurvedAnimation(parent: controller, curve: Curves.easeInOut),
            ))
        .toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unlockedBadges = MockData.unlockedBadges;
    final lockedBadges = MockData.lockedBadges;
    final totalBadges = MockData.badges.length;
    final progressPercent = ((unlockedBadges.length / totalBadges) * 100).toInt();

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
                // Premium header
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.secondary,
                        AppColors.secondary.withValues(alpha: 0.85),
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
                        color: AppColors.secondary.withValues(alpha: 0.2),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const TacoHeroHeader(
                          title: 'Badges',
                          subtitle: 'Kumpulkan & Buka Prestasi',
                        ),
                        GestureDetector(
                          onTap: () => _showBadgeInfo(context),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              Iconsax.info_circle_copy,
                              color: Colors.white,
                              size: 20,
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
                      // Premium stats cards
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Terbuka',
                              unlockedBadges.length.toString(),
                              AppColors.secondary,
                              Iconsax.unlock_copy,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              'Total',
                              totalBadges.toString(),
                              AppColors.accent,
                              Iconsax.award_copy,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              'Progress',
                              '$progressPercent%',
                              AppColors.primary,
                              Iconsax.activity_copy,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // Progress bar
                      Container(
                        padding: const EdgeInsets.all(20),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Koleksi Badges Anda',
                                  style: AppTextStyles.labelLarge.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  '$unlockedBadges/$totalBadges',
                                  style: AppTextStyles.labelMedium.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: unlockedBadges.length / totalBadges,
                                minHeight: 10,
                                backgroundColor: AppColors.surfaceVariant,
                                valueColor: AlwaysStoppedAnimation(
                                  progressPercent >= 75
                                      ? AppColors.success
                                      : progressPercent >= 50
                                          ? AppColors.secondary
                                          : AppColors.accent,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Dapatkan ${totalBadges - unlockedBadges.length} badge lagi untuk koleksi lengkap',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Unlocked Badges
                      if (unlockedBadges.isNotEmpty) ...[
                        const SectionHeader(
                          title: 'Badges Terbuka',
                          subtitle: 'Prestasi yang sudah Anda capai',
                        ),
                        const SizedBox(height: 16),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          childAspectRatio: 1.0,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          children: List.generate(
                            unlockedBadges.length,
                            (index) => _buildBadgeCard(
                              unlockedBadges[index],
                              true,
                              _glowAnimations.isNotEmpty && index < _glowAnimations.length
                                  ? _glowAnimations[index]
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],

                      // Locked Badges
                      if (lockedBadges.isNotEmpty) ...[
                        const SectionHeader(
                          title: 'Badges Terkunci',
                          subtitle: 'Selesaikan misi untuk membuka',
                        ),
                        const SizedBox(height: 16),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          childAspectRatio: 1.0,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          children: lockedBadges.map((badge) {
                            return _buildBadgeCard(badge, false, null);
                          }).toList(),
                        ),
                        const SizedBox(height: 32),
                      ],

                      // How to earn
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
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.secondary.withValues(alpha: 0.08),
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
                                Icon(
                                  Iconsax.star_1_copy,
                                  color: AppColors.secondary,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Cara Mendapatkan Badges',
                                  style: AppTextStyles.titleMedium.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildHowToItem('Pioneer', 'Lakukan 50 laporan pertama'),
                            const SizedBox(height: 12),
                            _buildHowToItem(
                                'Consistency King', 'Lapor 7 hari berturut-turut'),
                            const SizedBox(height: 12),
                            _buildHowToItem('Quality Expert',
                                '80% laporan dengan confidence tinggi'),
                            const SizedBox(height: 12),
                            _buildHowToItem('Voice Master', '100 laporan suara'),
                            const SizedBox(height: 12),
                            _buildHowToItem('Speed Demon', 'Laporan dalam <2 menit'),
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

  Widget _buildStatCard(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
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
        crossAxisAlignment: CrossAxisAlignment.center,
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
  
  IconData _getBadgeIcon(Badge badge) {
    switch (badge.name) {
      case 'Pioneer':
        return Iconsax.airplane;
      case 'Consistency King':
        return Iconsax.award_copy;
      case 'Quality Expert':
        return Iconsax.status_copy;
      case 'Voice Master':
        return Iconsax.microphone_copy;
      case 'Text Wizard':
        return Iconsax.document_text_1_copy;
      case 'Speed Demon':
        return Iconsax.flash_copy;
      default:
        return Iconsax.award_copy;
    }
  }

  Widget _buildBadgeCard(
    Badge badge,
    bool isUnlocked,
    Animation<double>? glowAnimation,
  ) {
    return GestureDetector(
      onTap: isUnlocked
          ? () {
              _showBadgeDetail(context, badge);
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          gradient: isUnlocked
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.surface,
                    AppColors.surface,
                    AppColors.surfaceVariant.withValues(alpha: 0.3),
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.surface,
                    AppColors.surfaceVariant,
                  ],
                ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnlocked
                ? AppColors.border.withValues(alpha: 0.6)
                : AppColors.border.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: AppColors.secondary.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Badge icon with glow effect
            if (glowAnimation != null)
              AnimatedBuilder(
                animation: glowAnimation,
                builder: (context, child) {
                  return Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.secondary.withValues(alpha: glowAnimation.value),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: child,
                  );
                },
                child: _buildBadgeIcon(badge, isUnlocked),
              )
            else
              _buildBadgeIcon(badge, isUnlocked),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                badge.name,
                style: AppTextStyles.labelLarge.copyWith(
                  color: isUnlocked ? AppColors.textPrimary : AppColors.textTertiary,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            if (isUnlocked)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Terbuka',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            else
              Column(
                children: [
                  Text(
                    badge.progress.toString(),
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '/ ${badge.requiredProgress}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeIcon(Badge badge, bool isUnlocked) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isUnlocked
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.secondary,
                  AppColors.secondary.withValues(alpha: 0.7),
                ],
              )
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.surfaceVariant,
                  AppColors.surfaceVariant.withValues(alpha: 0.6),
                ],
              ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            _getBadgeIcon(badge),
            color: isUnlocked ? Colors.white : AppColors.textDisabled,
            size: 32,
          ),
          if (!isUnlocked)
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withValues(alpha: 0.3),
              ),
              child: const Center(
                child: Icon(
                  Iconsax.lock_copy,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHowToItem(String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                description,
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

  void _showBadgeDetail(BuildContext context, Badge badge) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.secondary,
                      AppColors.secondary.withValues(alpha: 0.7),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondary.withValues(alpha: 0.25),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: Icon(
                  _getBadgeIcon(badge),
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                badge.name,
                style: AppTextStyles.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                badge.description,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TacoButton(
                text: 'Tutup',
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
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
                  'Badges adalah penghargaan yang Anda dapatkan dengan menyelesaikan berbagai misi dan mencapai milestone.',
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
                  'Klik badge terbuka untuk melihat detail lengkap.',
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