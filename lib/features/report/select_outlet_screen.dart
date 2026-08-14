import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:taco_sales_insight/data/mock_data.dart';
import 'package:taco_sales_insight/models/outlet.dart';
import 'package:taco_sales_insight/shared/app_colors.dart';
import 'package:taco_sales_insight/shared/app_text_styles.dart';
import 'package:taco_sales_insight/shared/common_widgets.dart';

class SelectOutletScreen extends StatefulWidget {
  const SelectOutletScreen({super.key});

  @override
  State<SelectOutletScreen> createState() => _SelectOutletScreenState();
}

class _CategoryOption {
  final String label;
  final OutletCategory? value;

  const _CategoryOption(this.label, this.value);
}

/// Distinct Iconsax glyph per outlet category so the list stays
/// scannable without relying on color alone.
IconData _categoryIcon(String category) {
  switch (category) {
    case 'supermarket':
      return Iconsax.shop;
    case 'minimarket':
      return Iconsax.shopping_bag;
    case 'traditionalMarket':
      return Iconsax.box_1;
    case 'restaurant':
      return Iconsax.cake;
    default:
      return Iconsax.shop;
  }
}

class _SelectOutletScreenState extends State<SelectOutletScreen> {
  static const List<_CategoryOption> _categoryOptions = [
    _CategoryOption('Semua', null),
    _CategoryOption('Supermarket', OutletCategory.supermarket),
    _CategoryOption('Minimarket', OutletCategory.minimarket),
    _CategoryOption('Pasar Tradisional', OutletCategory.traditionalMarket),
    _CategoryOption('Restoran', OutletCategory.restaurant),
  ];

  _CategoryOption _selectedCategory = _categoryOptions.first;
  String _searchQuery = '';

  List<Outlet> get _filteredOutlets {
    return MockData.outlets.where((outlet) {
      final matchesSearch = outlet.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          outlet.city.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          outlet.address.toLowerCase().contains(_searchQuery.toLowerCase());

      final selectedValue = _selectedCategory.value;
      final matchesCategory = selectedValue == null ||
          outlet.category == selectedValue.name;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredOutlets;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan'),
        automaticallyImplyLeading: false,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Iconsax.arrow_left_2),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      body: Column(
        children: [
          // Premium Hero Section with Gradient Kicker
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.primary.withValues(alpha: 0.85),
                  AppColors.secondary.withValues(alpha: 0.4),
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gradient Kicker
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.accent,
                          AppColors.accent.withValues(alpha: 0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'LAPORAN SALES',
                      style: AppTextStyles.overline.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Pilih Outlet',
                    style: AppTextStyles.displaySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pilih outlet tujuan untuk memulai laporan kunjungan Anda.',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Search & Filter Section
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Premium Search Input with Icon Badge
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TacoTextField(
                    label: '',
                    hintText: 'Cari outlet, alamat, atau kota...',
                    prefixIcon: Container(
                      padding: const EdgeInsets.all(10),
                      child: const Icon(
                        Iconsax.search_normal_1,
                        size: 20,
                        color: AppColors.secondary,
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Category Filter Chips with Animations
                Text(
                  'Kategori',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 42,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _categoryOptions.map((option) {
                      final isSelected = _selectedCategory.label == option.label;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? LinearGradient(
                                    colors: [
                                      AppColors.secondary,
                                      AppColors.secondary.withValues(alpha: 0.85),
                                    ],
                                  )
                                : null,
                            color: isSelected ? null : AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.secondary.withValues(alpha: 0.3)
                                  : AppColors.border,
                              width: 1.5,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.secondary.withValues(alpha: 0.15),
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
                                  _selectedCategory = option;
                                });
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                child: Center(
                                  child: Text(
                                    option.label,
                                    style: AppTextStyles.labelMedium.copyWith(
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.textPrimary,
                                      fontWeight:
                                          isSelected ? FontWeight.w700 : FontWeight.w600,
                                    ),
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
                const SizedBox(height: 20),
              ],
            ),
          ),

          // Outlet List
          Expanded(
            child: filtered.isEmpty
                ? const EmptyState(
                    title: 'Outlet Tidak Ditemukan',
                    subtitle: 'Coba cari dengan kata kunci lain atau pilih kategori yang berbeda.',
                    icon: Iconsax.shop,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 100),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final outlet = filtered[index];
                      return _buildPremiumOutletCard(outlet);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Premium outlet card with gradient avatar and depth shadow
  Widget _buildPremiumOutletCard(Outlet outlet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/report/outlet-detail',
                arguments: outlet,
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.border.withValues(alpha: 0.6),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  // Gradient Avatar
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.secondary,
                          AppColors.secondary.withValues(alpha: 0.7),
                          AppColors.primary.withValues(alpha: 0.5),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.secondary.withValues(alpha: 0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      _categoryIcon(outlet.category),
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          outlet.name,
                          style: AppTextStyles.titleSmall.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          outlet.address,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.accent.withValues(alpha: 0.15),
                                    AppColors.accent.withValues(alpha: 0.08),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: AppColors.accent.withValues(alpha: 0.3),
                                  width: 0.5,
                                ),
                              ),
                              child: Text(
                                outlet.city,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Icon(
                              Iconsax.activity,
                              size: 14,
                              color: AppColors.textTertiary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${outlet.visitCount}x',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Iconsax.arrow_right_3,
                      size: 16,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
