import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taco_sales_insight/core/state/app_state.dart';
import 'package:taco_sales_insight/models/user.dart';
import 'package:taco_sales_insight/shared/app_colors.dart';
import 'package:taco_sales_insight/shared/app_text_styles.dart';
import 'package:taco_sales_insight/shared/common_widgets.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late String _selectedAvatarUrl;

  static const List<String> _avatarPalette = [
    '172554',
    'BE4826',
    '2563EB',
    '10B981',
    'F59E0B',
    '8B5CF6',
    'EC4899',
    '06B6D4',
  ];

  @override
  void initState() {
    super.initState();
    final user = context.read<AppState>().user;
    _nameController = TextEditingController(text: user.name);
    _emailController = TextEditingController(text: user.email);
    _selectedAvatarUrl = user.avatarUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppState>().user;

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TacoPremiumHeader(
                title: 'Edit Profil',
                subtitle: 'Perbarui foto & informasi profil',
                showBackButton: Navigator.canPop(context),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAvatarSection(user),
                    const SizedBox(height: 32),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TacoTextField(
                            label: 'Nama',
                            isRequired: true,
                            controller: _nameController,
                            prefixIcon: Icon(
                              Iconsax.user,
                              size: 20,
                              color: AppColors.textSecondary,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Nama tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TacoTextField(
                            label: 'Email',
                            isRequired: true,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icon(
                              Iconsax.direct_normal,
                              size: 20,
                              color: AppColors.textSecondary,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Email tidak boleh kosong';
                              }
                              if (!value.contains('@')) {
                                return 'Email tidak valid';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 32),
                          TacoButton(
                            text: 'Simpan Perubahan',
                            onPressed: _save,
                            icon: const Icon(
                              Iconsax.tick_circle,
                              size: 18,
                              color: AppColors.textInverse,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection(User user) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 112,
            height: 112,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.secondary],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface,
              ),
              child: ClipOval(
                child: Image.network(
                  _selectedAvatarUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildInitialsAvatar(user.name),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TacoButton(
            text: 'Ganti Foto',
            type: ButtonType.outline,
            isFullWidth: false,
            icon: const Icon(
              Iconsax.camera,
              size: 18,
              color: AppColors.primary,
            ),
            onPressed: _showAvatarPicker,
          ),
          const SizedBox(height: 8),
          Text(
            'Pilih foto profil dari koleksi yang tersedia',
            style: AppTextStyles.bodySmallSecondary,
          ),
        ],
      ),
    );
  }

  Future<void> _showAvatarPicker() async {
    final user = context.read<AppState>().user;
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => _AvatarPickerSheet(
        currentUrl: _selectedAvatarUrl,
        palette: _avatarPalette,
        userName: user.name,
      ),
    );

    if (selected != null && selected != _selectedAvatarUrl) {
      setState(() => _selectedAvatarUrl = selected);
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    context.read<AppState>().updateProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      avatarUrl: _selectedAvatarUrl,
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profil berhasil diperbarui')));
    Navigator.pop(context);
  }
}

class _AvatarPickerSheet extends StatelessWidget {
  final String currentUrl;
  final List<String> palette;
  final String userName;

  const _AvatarPickerSheet({
    required this.currentUrl,
    required this.palette,
    required this.userName,
  });

  String _urlFor(String background) =>
      'https://ui-avatars.com/api/?name=${userName.replaceAll(' ', '+')}'
      '&background=$background&color=fff&size=256';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Ganti Foto Profil',
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Pilih salah satu avatar untuk profil Anda',
              style: AppTextStyles.bodyMediumSecondary,
            ),
            const SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemCount: palette.length,
              itemBuilder: (context, index) {
                final url = _urlFor(palette[index]);
                final isSelected = url == currentUrl;
                return GestureDetector(
                  onTap: () => Navigator.pop(context, url),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isSelected
                          ? const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [AppColors.primary, AppColors.secondary],
                            )
                          : null,
                      border: isSelected
                          ? null
                          : Border.all(color: AppColors.border, width: 1),
                    ),
                    padding: const EdgeInsets.all(2),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surface,
                      ),
                      child: ClipOval(
                        child: Image.network(
                          url,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildInitialsAvatar(userName),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            TacoButton(
              text: 'Batal',
              type: ButtonType.secondary,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildInitialsAvatar(String name) {
  return Container(
    color: AppColors.surfaceVariant,
    alignment: Alignment.center,
    child: Text(
      _initialsOf(name),
      style: AppTextStyles.titleMedium.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

String _initialsOf(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList();
  if (parts.isEmpty) return '?';
  if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
  return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
      .toUpperCase();
}
