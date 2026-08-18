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
        .map(
          (controller) => Tween<double>(begin: 0.2, end: 0.5).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeInOut),
          ),
        )
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
    final progressPercent = ((unlockedBadges.length / totalBadges) * 100)
        .toInt();

    return Scaffold(
      body: Container(
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TacoPremiumHeader(
                title: 'Badges',
                subtitle: 'Kumpulkan & Buka Prestasi',
                showBackButton: Navigator.canPop(context),
                trailing: GestureDetector(
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
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        children: List.generate(
                          unlockedBadges.length,
                          (index) => _buildBadgeCard(
                            unlockedBadges[index],
                            true,
                            _glowAnimations.isNotEmpty &&
                                    index < _glowAnimations.length
                                ? _glowAnimations[index]
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],

                    if (lockedBadges.isNotEmpty) ...[
                      const SectionHeader(
                        title: 'Badges Terkunci',
                        subtitle: 'Selesaikan misi untuk membuka',
                      ),
                      const SizedBox(height: 16),
                      ..._buildCategoryGroups(lockedBadges),
                      const SizedBox(height: 32),
                    ],

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
                          _buildHowToItem(
                            'First Step',
                            'Lakukan laporan pertama',
                          ),
                          const SizedBox(height: 12),
                          _buildHowToItem(
                            'Target Hunter',
                            'Lakukan 10 laporan pertama',
                          ),
                          const SizedBox(height: 12),
                          _buildHowToItem(
                            'Fast Mover',
                            'Buat 5 laporan dalam 24 jam',
                          ),
                          const SizedBox(height: 12),
                          _buildHowToItem(
                            'On Fire',
                            'Lakukan 50 laporan total',
                          ),
                          const SizedBox(height: 12),
                          _buildHowToItem(
                            'Unstoppable',
                            'Lakukan 100 laporan total',
                          ),
                          const SizedBox(height: 12),
                          _buildHowToItem(
                            'Consistency King',
                            'Lapor 7 hari berturut-turut',
                          ),
                          const SizedBox(height: 12),
                          _buildHowToItem(
                            'Voice Pro',
                            '100 laporan menggunakan voice',
                          ),
                          const SizedBox(height: 12),
                          _buildHowToItem(
                            'Perfect Run',
                            '100% accuracy 30 laporan berturut-turut',
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
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
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
      case 'First Step':
        return Iconsax.send;
      case 'Target Hunter':
        return Iconsax.direct_right;
      case 'Fast Mover':
        return Iconsax.flash_1_copy;
      case 'On Fire':
        return Iconsax.flash_copy;
      case 'Unstoppable':
        return Iconsax.flash_1;
      case 'Consistency King':
        return Iconsax.crown_copy;
      case 'Diamond Performer':
        return Iconsax.star_1_copy;
      case 'Rising Star':
        return Iconsax.arrow_up_3;
      case 'Top Performer':
        return Iconsax.medal_copy;
      case 'Podium Finisher':
        return Iconsax.cup_copy;
      case 'Report Master':
        return Iconsax.document_copy_copy;
      case 'Insight Seeker':
        return Iconsax.search_normal_1_copy;
      case 'Voice Pro':
        return Iconsax.microphone_2_copy;
      case 'Outlet Explorer':
        return Iconsax.location_copy;
      case 'Wide Reach':
        return Iconsax.global_copy;
      case 'Early Bird':
        return Iconsax.sun_1_copy;
      case 'Night Owl':
        return Iconsax.moon_copy;
      case 'Reliable':
        return Iconsax.tick_square_copy;
      case 'Perfect Run':
        return Iconsax.verify_copy;
      case 'TACO Legend':
        return Iconsax.star_1_copy;
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
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isUnlocked
                ? AppColors.secondary.withValues(alpha: 0.25)
                : AppColors.border.withValues(alpha: 0.4),
            width: 1.5,
          ),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: AppColors.secondary.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            children: [
              if (isUnlocked)
                Positioned(
                  top: -20,
                  right: -20,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.secondary.withValues(alpha: 0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  if (glowAnimation != null)
                    AnimatedBuilder(
                      animation: glowAnimation,
                      builder: (context, child) {
                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.secondary.withValues(
                                  alpha: glowAnimation.value * 0.6,
                                ),
                                blurRadius: 24,
                                spreadRadius: 4,
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
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      badge.name,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: isUnlocked
                            ? AppColors.textPrimary
                            : AppColors.textTertiary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Spacer(),
                  if (isUnlocked)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.success.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Iconsax.tick_circle_copy,
                            size: 14,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Terbuka',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: badge.progress / badge.requiredProgress,
                              minHeight: 4,
                              backgroundColor: AppColors.surfaceVariant,
                              valueColor: AlwaysStoppedAnimation(
                                AppColors.border,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${badge.progress} / ${badge.requiredProgress}',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.textTertiary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadgeIcon(Badge badge, bool isUnlocked) {
    return Container(
      width: 64,
      height: 64,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isUnlocked
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.secondary.withValues(alpha: 0.5),
                  AppColors.primary.withValues(alpha: 0.8),
                ],
              )
            : null,
        color: isUnlocked ? null : AppColors.surfaceVariant.withValues(alpha: 0.5),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isUnlocked ? Colors.white : AppColors.surface,
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: AppColors.secondary.withValues(alpha: 0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: isUnlocked
              ? ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.secondary, AppColors.primary],
                  ).createShader(bounds),
                  child: Icon(
                    _getBadgeIcon(badge),
                    color: Colors.white,
                    size: 28,
                  ),
                )
              : Icon(
                  Iconsax.lock_copy,
                  color: AppColors.textDisabled,
                  size: 24,
                ),
        ),
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
          child: Icon(Iconsax.check_copy, size: 14, color: AppColors.secondary),
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

  List<Widget> _buildCategoryGroups(List<Badge> badges) {
    final groupedByCategory = <BadgeCategory, List<Badge>>{};
    for (var badge in badges) {
      groupedByCategory.putIfAbsent(badge.category, () => []).add(badge);
    }

    final categoryLabels = {
      BadgeCategory.activity: 'Aktivitas',
      BadgeCategory.quality: 'Kualitas',
      BadgeCategory.consistency: 'Konsistensi',
      BadgeCategory.speed: 'Kecepatan',
      BadgeCategory.discovery: 'Eksplorasi',
      BadgeCategory.specialization: 'Spesialisasi',
      BadgeCategory.achievement: 'Pencapaian',
    };

    return groupedByCategory.entries.map((entry) {
      final category = entry.key;
      final categoryBadges = entry.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              categoryLabels[category] ?? category.name,
              style: AppTextStyles.titleSmall.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: categoryBadges.map((badge) {
              return _buildBadgeCard(badge, false, null);
            }).toList(),
          ),
          const SizedBox(height: 20),
        ],
      );
    }).toList();
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
              Text(badge.name, style: AppTextStyles.headlineSmall),
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
                Text(
                  '• Meningkatkan ranking leaderboard\n'
                  '• Memberikan bonus points\n'
                  '• Membuka fitur premium\n'
                  '• Meningkatkan SKI score',
                ),
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
