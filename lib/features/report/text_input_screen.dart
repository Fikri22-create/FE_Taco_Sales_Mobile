import 'package:flutter/material.dart';
import 'package:taco_sales_insight/shared/app_colors.dart';
import 'package:taco_sales_insight/shared/app_text_styles.dart';
import 'package:taco_sales_insight/shared/common_widgets.dart';
import 'package:taco_sales_insight/models/outlet.dart';

class TextInputScreen extends StatefulWidget {
  final Outlet outlet;
  
  const TextInputScreen({super.key, required this.outlet});

  @override
  State<TextInputScreen> createState() => _TextInputScreenState();
}

class _TextInputScreenState extends State<TextInputScreen> {
  final TextEditingController _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  
  int get _wordCount {
    final text = _textController.text.trim();
    if (text.isEmpty) return 0;
    return text.split(RegExp(r'\s+')).length;
  }
  
  int get _characterCount {
    return _textController.text.length;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Input'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Outlet Info
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
                            widget.outlet.name,
                            style: AppTextStyles.titleMedium,
                          ),
                          Text(
                            widget.outlet.city,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Instructions
              const Text(
                'Tulis laporan Anda',
                style: AppTextStyles.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Jelaskan apa yang Anda lihat di outlet ini. Sebutkan brand, harga, promosi, atau informasi kompetitor lainnya.',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              
              // Text Input
              TextFormField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: 'Isi laporan',
                  hintText: 'Contoh: Hari ini saya melihat Indomie goreng sedang promo di outlet ini dengan harga Rp 2.500 per bungkus. Stok masih cukup banyak. Sedaap kari ayam mengalami kenaikan harga menjadi Rp 3.000.',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                maxLines: 10,
                minLines: 6,
                onChanged: (value) {
                  setState(() {});
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Laporan tidak boleh kosong';
                  }
                  final words = value.trim().split(RegExp(r'\s+')).length;
                  if (words < 5) {
                    return 'Minimal 5 kata (saat ini: $words kata)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Character/Word Count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Kata: $_wordCount/5 minimum',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: _wordCount >= 5 ? AppColors.success : AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Karakter: $_characterCount',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Tips
              TacoCard(
                backgroundColor: AppColors.infoLight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tips Menulis Laporan',
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Sebutkan brand dan jenis mie\n'
                      '• Cantumkan harga jika ada\n'
                      '• Informasikan stok (cukup/terbatas/habis)\n'
                      '• Sebutkan promosi atau diskon\n'
                      '• Bandingkan dengan kompetitor\n'
                      '• Gunakan bahasa yang jelas dan deskriptif',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Example
              TacoCard(
                backgroundColor: AppColors.surfaceVariant,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contoh Laporan Berkualitas',
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Indomie goreng sedang promo Rp 2.500 (normal Rp 2.800) dengan stok sekitar 50 bungkus. Sedaap kari ayam mengalami kenaikan harga menjadi Rp 3.000 dari sebelumnya Rp 2.700. Terlihat ada display baru dari Sarimi di area checkout.',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: TacoButton(
                      text: 'Batal',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      type: ButtonType.outline,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TacoButton(
                      text: _isSubmitting ? 'Mengirim...' : 'Submit',
                      onPressed: _isSubmitting
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                _submitReport();
                              }
                            },
                      type: ButtonType.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
  
  void _submitReport() {
    setState(() {
      _isSubmitting = true;
    });
    
    // Simulate submission
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pushNamed(
          context,
          '/report/processing',
          arguments: {
            'outlet': widget.outlet,
            'inputMode': 'text',
            'text': _textController.text,
          },
        );
      }
    });
  }
  
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

// Helper function to get arguments
class TextInputScreenWrapper extends StatelessWidget {
  const TextInputScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final outlet = ModalRoute.of(context)!.settings.arguments as Outlet;
    return TextInputScreen(outlet: outlet);
  }
}