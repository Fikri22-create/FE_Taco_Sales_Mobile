import 'package:flutter/material.dart';
import 'package:taco_sales_insight/data/mock_data.dart';
import 'package:taco_sales_insight/models/user.dart';
import 'package:taco_sales_insight/shared/app_colors.dart';
import 'package:taco_sales_insight/shared/app_text_styles.dart';
import 'package:taco_sales_insight/shared/common_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final User _currentUser;
  bool _isEditing = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _currentUser = MockData.currentUser;
    _nameController.text = _currentUser.name;
    _emailController.text = _currentUser.email;
    _phoneController.text = _currentUser.phone;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    if (_isEditing) {
      // Save changes
      if (_formKey.currentState!.validate()) {
        setState(() {
          // In a real app, this would update the user data
          _isEditing = false;
        });
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil berhasil diperbarui'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } else {
      setState(() {
        _isEditing = true;
      });
    }
  }

  Widget _buildProfileHeader() {
    return TacoCard(
      child: Column(
        children: [
          // Avatar & Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                    width: 2,
                  ),
                  image: const DecorationImage(
                    image: NetworkImage(
                        'https://ui-avatars.com/api/?name=Budi+Santoso&background=172554&color=fff'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!_isEditing) ...[
                      Text(
                        _currentUser.name,
                        style: AppTextStyles.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _currentUser.email,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _currentUser.phone,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ] else ...[
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TacoTextField(
                              label: 'Nama',
                              controller: _nameController,
                              isRequired: true,
                            ),
                            const SizedBox(height: 12),
                            TacoTextField(
                              label: 'Email',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              isRequired: true,
                            ),
                            const SizedBox(height: 12),
                            TacoTextField(
                              label: 'Telepon',
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              isRequired: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    TacoBadge.info(text: _currentUser.region),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Stats Row
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '${_currentUser.totalReports}',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      'Total Laporan',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.divider,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '${_currentUser.totalPoints}',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.accent,
                      ),
                    ),
                    Text(
                      'Total Points',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.divider,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '${_currentUser.currentStreak}',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.streakActive,
                      ),
                    ),
                    Text(
                      'Current Streak',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Edit Button
          TacoButton(
            text: _isEditing ? 'Simpan Perubahan' : 'Edit Profil',
            onPressed: _toggleEditMode,
            icon: Icon(
              _isEditing ? Icons.save : Icons.edit,
              size: 18,
            ),
            type: _isEditing ? ButtonType.primary : ButtonType.outline,
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceSection() {
    return TacoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Performa',
            subtitle: 'Statistik kinerja Anda',
          ),
          const SizedBox(height: 16),
          
          // Performance Metrics
          Column(
            children: [
              _buildMetricItem(
                label: 'Rata-rata Kualitas Laporan',
                value: '${_currentUser.stats.averageReportQuality.toStringAsFixed(1)}',
                progress: _currentUser.stats.averageReportQuality / 10,
                color: AppColors.success,
              ),
              const SizedBox(height: 12),
              _buildMetricItem(
                label: 'Produktivitas Harian',
                value: '${_currentUser.stats.dailyProductivity.toStringAsFixed(0)}%',
                progress: _currentUser.stats.dailyProductivity / 100,
                color: AppColors.secondary,
              ),
              const SizedBox(height: 12),
              _buildMetricItem(
                label: 'Waktu Respon Rata-rata',
                value: '${_currentUser.stats.averageResponseTime.toStringAsFixed(1)} menit',
                progress: (10 - _currentUser.stats.averageResponseTime) / 10,
                color: AppColors.primary,
                invertProgress: true,
              ),
              const SizedBox(height: 12),
              _buildMetricItem(
                label: 'Objectives',
                value: '${_currentUser.stats.completedObjectives}/${_currentUser.stats.totalObjectives}',
                progress: _currentUser.stats.completedObjectives / _currentUser.stats.totalObjectives,
                color: AppColors.accent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required String label,
    required String value,
    required double progress,
    required Color color,
    bool invertProgress = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.bodyMedium,
            ),
            Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ProgressBar(
          value: invertProgress ? 1.0 - progress : progress,
          backgroundColor: AppColors.surfaceVariant,
          progressColor: color,
          height: 6,
        ),
      ],
    );
  }

  Widget _buildActivityBreakdown() {
    return TacoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Breakdown Aktivitas',
            subtitle: 'Distribusi jenis laporan Anda',
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.mic,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_currentUser.stats.voiceReports}',
                              style: AppTextStyles.titleSmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Voice Reports',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [AppColors.accent, AppColors.warning],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.text_fields,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_currentUser.stats.textReports}',
                              style: AppTextStyles.titleSmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Text Reports',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [AppColors.success, AppColors.chartGreen],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.timeline,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_currentUser.stats.reportsThisWeek}',
                              style: AppTextStyles.titleSmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This Week',
                      style: AppTextStyles.caption,
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

  Widget _buildGamificationSection() {
    return TacoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Gamification',
            subtitle: 'Capai milestones dan dapatkan rewards',
          ),
          const SizedBox(height: 16),
          
          // Quick Access Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildGamificationCard(
                title: 'Points',
                subtitle: 'Track your earnings',
                icon: Icons.star,
                iconColor: AppColors.accent,
                backgroundColor: AppColors.accent.withOpacity(0.1),
                route: '/profile/points',
              ),
              _buildGamificationCard(
                title: 'Badges',
                subtitle: 'Your achievements',
                icon: Icons.workspace_premium,
                iconColor: AppColors.secondary,
                backgroundColor: AppColors.secondary.withOpacity(0.1),
                route: '/profile/badges',
              ),
              _buildGamificationCard(
                title: 'Streak',
                subtitle: 'Daily consistency',
                icon: Icons.local_fire_department,
                iconColor: AppColors.streakActive,
                backgroundColor: AppColors.streakActive.withOpacity(0.1),
                route: '/profile/streak',
              ),
              _buildGamificationCard(
                title: 'Leaderboard',
                subtitle: 'Compete with peers',
                icon: Icons.leaderboard,
                iconColor: AppColors.primary,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                route: '/profile/leaderboard',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGamificationCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String route,
  }) {
    return TacoCard(
      onTap: () => Navigator.pushNamed(context, route),
      backgroundColor: backgroundColor,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.titleSmall.copyWith(
                  color: iconColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyles.caption.copyWith(
                  color: iconColor.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return TacoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Pengaturan',
            subtitle: 'Personalize your experience',
          ),
          const SizedBox(height: 16),
          
          Column(
            children: [
              _buildSettingItem(
                icon: Icons.notifications,
                label: 'Notifikasi',
                value: 'On',
                onTap: () => Navigator.pushNamed(context, '/notifications'),
              ),
              Divider(height: 1, thickness: 1, color: AppColors.divider),
              _buildSettingItem(
                icon: Icons.security,
                label: 'Privasi & Keamanan',
                value: 'Manage',
                onTap: () {},
              ),
              Divider(height: 1, thickness: 1, color: AppColors.divider),
              _buildSettingItem(
                icon: Icons.help,
                label: 'Bantuan & Support',
                value: 'Contact',
                onTap: () {},
              ),
              Divider(height: 1, thickness: 1, color: AppColors.divider),
              _buildSettingItem(
                icon: Icons.info,
                label: 'Tentang Aplikasi',
                value: 'v1.0.0',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.bodyLarge,
                ),
              ),
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            onPressed: () {
              // Logout action
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildProfileHeader(),
            const SizedBox(height: 16),
            _buildPerformanceSection(),
            const SizedBox(height: 16),
            _buildActivityBreakdown(),
            const SizedBox(height: 16),
            _buildGamificationSection(),
            const SizedBox(height: 16),
            _buildSettingsSection(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}