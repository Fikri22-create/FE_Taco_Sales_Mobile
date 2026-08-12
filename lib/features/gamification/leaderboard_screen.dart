import 'package:flutter/material.dart';
import 'package:taco_sales_insight/data/mock_data.dart';
import 'package:taco_sales_insight/shared/app_colors.dart';
import 'package:taco_sales_insight/shared/app_text_styles.dart';
import 'package:taco_sales_insight/shared/common_widgets.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  String _selectedLeaderboard = 'consistency'; // consistency or quality
  int _currentUserRank = 3; // User rank in consistency leaderboard
  
  List<dynamic> get _selectedList {
    return _selectedLeaderboard == 'consistency'
        ? MockData.consistencyLeaderboard
        : MockData.qualityLeaderboard;
  }
  
  String get _leaderboardTitle {
    return _selectedLeaderboard == 'consistency'
        ? 'Konsistensi'
        : 'Kualitas Insight';
  }
  
  String get _leaderboardDescription {
    return _selectedLeaderboard == 'consistency'
        ? 'Berdasarkan jumlah laporan yang dibuat'
        : 'Berdasarkan kualitas dan nilai signal yang ditemukan';
  }
  
  @override
  Widget build(BuildContext context) {
    final selectedList = _selectedList;
    final currentUser = _selectedLeaderboard == 'consistency'
        ? MockData.consistencyLeaderboard.firstWhere(
            (user) => user.isCurrentUser,
            orElse: () => MockData.consistencyLeaderboard[2])
        : MockData.qualityLeaderboard.firstWhere(
            (user) => user.isCurrentUser,
            orElse: () => MockData.qualityLeaderboard[2]);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showLeaderboardInfo(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period Selector
            Row(
              children: [
                Expanded(
                  child: TacoButton(
                    text: 'Konsistensi',
                    onPressed: () {
                      setState(() {
                        _selectedLeaderboard = 'consistency';
                      });
                    },
                    type: _selectedLeaderboard == 'consistency'
                        ? ButtonType.primary
                        : ButtonType.outline,
                    isFullWidth: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TacoButton(
                    text: 'Kualitas',
                    onPressed: () {
                      setState(() {
                        _selectedLeaderboard = 'quality';
                      });
                    },
                    type: _selectedLeaderboard == 'quality'
                        ? ButtonType.primary
                        : ButtonType.outline,
                    isFullWidth: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Leaderboard Info
            TacoCard(
              child: Column(
                children: [
                  Text(
                    _leaderboardTitle,
                    style: AppTextStyles.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _leaderboardDescription,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Update: Mingguan',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Top 3
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 2nd Place
                _buildTopThreeCard(selectedList[1], 2),
                const SizedBox(width: 8),
                
                // 1st Place
                _buildTopThreeCard(selectedList[0], 1, isFirst: true),
                const SizedBox(width: 8),
                
                // 3rd Place
                _buildTopThreeCard(selectedList[2], 3),
              ],
            ),
            const SizedBox(height: 32),
            
            // User Position
            TacoCard(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        currentUser.rank.toString(),
                        style: AppTextStyles.titleMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentUser.name,
                          style: AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Anda',
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
                        currentUser.score.toString(),
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _buildRankChange(currentUser),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Full Leaderboard
            const SectionHeader(
              title: 'Full Leaderboard',
              subtitle: 'Peringkat 4-10',
            ),
            const SizedBox(height: 12),
            
            Column(
              children: selectedList.sublist(3).map((user) {
                return _buildLeaderboardItem(user);
              }).toList(),
            ),
            const SizedBox(height: 32),
            
            // Rewards
            TacoCard(
              backgroundColor: AppColors.successLight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hadiah Leaderboard',
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• Peringkat 1: 500 points + Gold Badge\n'
                    '• Peringkat 2-3: 300 points + Silver Badge\n'
                    '• Peringkat 4-10: 100 points + Bronze Badge\n'
                    '• Weekly reset dengan rewards baru\n'
                    '• Special recognition di profil',
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
                    'Tips Naik Peringkat',
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• Konsisten lapor setiap hari\n'
                    '• Gunakan voice untuk lebih cepat\n'
                    '• Fokus pada signal berkualitas tinggi\n'
                    '• Jawab pertanyaan klarifikasi AI\n'
                    '• Aktif di semua fitur gamification',
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
  
  Widget _buildTopThreeCard(dynamic user, int rank, {bool isFirst = false}) {
    Color rankColor;
    double size;
    double elevation;
    
    switch (rank) {
      case 1:
        rankColor = AppColors.gold;
        size = 120;
        elevation = 8;
        break;
      case 2:
        rankColor = AppColors.silver;
        size = 100;
        elevation = 4;
        break;
      case 3:
      default:
        rankColor = AppColors.bronze;
        size = 100;
        elevation = 4;
    }
    
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: rankColor.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: rankColor,
              width: isFirst ? 3 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: rankColor.withOpacity(0.3),
                blurRadius: elevation,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: (size - 20) / 2,
                backgroundImage: NetworkImage(user.avatarUrl),
              ),
              Positioned(
                top: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: rankColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '#$rank',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          user.name,
          style: AppTextStyles.titleSmall.copyWith(
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          user.score.toString(),
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
  
  Widget _buildLeaderboardItem(dynamic user) {
    final isCurrentUser = user.isCurrentUser;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TacoCard(
        backgroundColor: isCurrentUser
            ? AppColors.primary.withOpacity(0.05)
            : AppColors.surface,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isCurrentUser ? AppColors.primary : AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  user.rank.toString(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isCurrentUser ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(user.avatarUrl),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildRankChange(user),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  user.score.toString(),
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (isCurrentUser)
                  Text(
                    'Anda',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRankChange(dynamic user) {
    final rankChange = user.previousRank - user.rank;
    
    if (rankChange > 0) {
      return Row(
        children: [
          Icon(
            Icons.arrow_upward,
            size: 12,
            color: AppColors.success,
          ),
          const SizedBox(width: 2),
          Text(
            '+$rankChange',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    } else if (rankChange < 0) {
      return Row(
        children: [
          Icon(
            Icons.arrow_downward,
            size: 12,
            color: AppColors.error,
          ),
          const SizedBox(width: 2),
          Text(
            rankChange.toString(),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    } else {
      return Text(
        'No change',
        style: AppTextStyles.caption.copyWith(
          color: AppColors.textTertiary,
        ),
      );
    }
  }
  
  void _showLeaderboardInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tentang Leaderboard'),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Leaderboard menampilkan peringkat pengguna berdasarkan performa.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Konsistensi Leaderboard:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('• Berdasarkan jumlah laporan harian\n'
                     '• Mengukur kedisiplinan dan rutinitas\n'
                     '• Peringkat diupdate setiap hari'),
                SizedBox(height: 16),
                Text(
                  'Kualitas Leaderboard:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('• Berdasarkan kualitas signal yang ditemukan\n'
                     '• Mengukur akurasi dan nilai insight\n'
                     '• Peringkat diupdate setiap minggu'),
                SizedBox(height: 16),
                Text(
                  'Peringkat direset setiap minggu dengan rewards baru.',
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