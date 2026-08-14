import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taco_sales_insight/core/state/app_state.dart';
import 'package:taco_sales_insight/models/outlet.dart';
import 'package:taco_sales_insight/models/report.dart';
import 'package:taco_sales_insight/shared/app_colors.dart';
import 'package:taco_sales_insight/shared/app_text_styles.dart';
import 'package:taco_sales_insight/shared/common_widgets.dart';

class AIConfirmationScreen extends StatefulWidget {
  final Outlet outlet;
  final String inputMode;
  final String text;

  const AIConfirmationScreen({
    super.key,
    required this.outlet,
    required this.inputMode,
    required this.text,
  });

  @override
  State<AIConfirmationScreen> createState() => _AIConfirmationScreenState();
}

class _AIConfirmationScreenState extends State<AIConfirmationScreen> {
  static const List<int> _allowedStockLevels = [20, 40, 60, 80, 100];

  late List<CompetitorSignal> _signals;
  bool _showWarning = false;
  String _warningMessage = '';

  // Controllers for editing
  final List<TextEditingController> _priceControllers = [];
  final List<TextEditingController> _promoControllers = [];
  final List<String> _stockLevels = [];

  @override
  void initState() {
    super.initState();
    _parseMockSignals();
  }

  int _snapStockLevel(int value) {
    var nearest = _allowedStockLevels.first;
    for (final level in _allowedStockLevels) {
      if ((level - value).abs() < (nearest - value).abs()) {
        nearest = level;
      }
    }
    return nearest;
  }

  void _parseMockSignals() {
    final txt = widget.text.toLowerCase();
    _signals = [];

    if (txt.contains('indomie')) {
      double price = 2500;
      if (txt.contains('2.500') || txt.contains('2500')) price = 2500;
      _signals.add(CompetitorSignal(
        brand: 'Indomie',
        product: 'Goreng',
        price: price,
        stockLevel: 85,
        promotion: txt.contains('promo') ? 'Diskon khusus' : 'Tidak ada',
        signalType: 'promo',
        confidence: 0.96,
      ));
    }

    if (txt.contains('sedaap')) {
      double price = 3000;
      if (txt.contains('3.000') || txt.contains('3000')) price = 3000;
      _signals.add(CompetitorSignal(
        brand: 'Sedaap',
        product: 'Kari Ayam',
        price: price,
        stockLevel: 70,
        promotion: txt.contains('naik') ? 'Harga naik Rp 300' : 'Tidak ada',
        signalType: 'price_increase',
        confidence: 0.89,
      ));
    }

    if (_signals.isEmpty) {
      _signals.add(CompetitorSignal(
        brand: 'Kompetitor Umum',
        product: 'Mie Instan',
        price: 2800,
        stockLevel: 60,
        promotion: 'Tidak ada',
        signalType: 'general',
        confidence: 0.72,
      ));
    }

    for (var signal in _signals) {
      _priceControllers.add(TextEditingController(text: signal.price?.toInt().toString() ?? '0'));
      _promoControllers.add(TextEditingController(text: signal.promotion));
      final rawStock = signal.stockLevel?.toInt() ?? 60;
      _stockLevels.add(_snapStockLevel(rawStock).toString());
    }

    for (var signal in _signals) {
      if (signal.confidence < 0.75) {
        _showWarning = true;
        _warningMessage = 'Sinyal dari "${signal.brand}" memiliki tingkat kepercayaan rendah. Silakan tinjau kembali data di bawah.';
      }
    }
  }

  void _validateAndSubmit() {
    bool hasValidationError = false;
    String errMsg = '';

    for (int i = 0; i < _signals.length; i++) {
      final priceVal = double.tryParse(_priceControllers[i].text) ?? 0;
      if (priceVal < 500 || priceVal > 15000) {
        hasValidationError = true;
        errMsg = 'Harga untuk ${_signals[i].brand} (Rp ${priceVal.toInt()}) mencurigakan (terlalu rendah/tinggi). Silakan verifikasi.';
        break;
      }
    }

    if (hasValidationError) {
      setState(() {
        _showWarning = true;
        _warningMessage = errMsg;
      });
      return;
    }

    final editedSignals = List.generate(_signals.length, (i) {
      final s = _signals[i];
      return CompetitorSignal(
        brand: s.brand,
        product: s.product,
        price: double.tryParse(_priceControllers[i].text) ?? s.price,
        stockLevel: double.tryParse(_stockLevels[i]) ?? s.stockLevel,
        promotion: _promoControllers[i].text,
        signalType: s.signalType,
        confidence: s.confidence,
      );
    });

    final appState = context.read<AppState>();
    final aiAnalysis = AIAnalysis(
      summary: 'Analisis dari ${editedSignals.length} sinyal kompetitor di ${widget.outlet.name}',
      keyFindings: editedSignals.map((s) => '${s.brand} ${s.product}: ${s.signalType}').toList(),
      recommendations: editedSignals.map((s) => 'Pantau ${s.brand} ${s.product}').toList(),
      structuredData: {'signal_count': editedSignals.length},
      overallScore: editedSignals.isEmpty
          ? 0.0
          : (editedSignals.map((s) => s.confidence).reduce((a, b) => a + b) /
                      editedSignals.length *
                      10)
                .clamp(0, 10)
                .toDouble(),
      sentiment: 'neutral',
      extractedEntities: editedSignals
          .map((s) => EntityExtraction(
                entity: s.brand,
                type: 'brand',
                value: s.product,
                confidence: s.confidence,
              ))
          .toList(),
    );
    final report = appState.addReport(
      outlet: widget.outlet,
      content: widget.text,
      inputType: widget.inputMode == 'voice' ? ReportInputType.voice : ReportInputType.text,
      signals: editedSignals,
      aiAnalysis: aiAnalysis,
    );

    Navigator.pushNamed(
      context,
      '/report/summary',
      arguments: {
        'outlet': widget.outlet,
        'inputMode': widget.inputMode,
        'text': widget.text,
        'signals': editedSignals,
        'reportId': report.id,
      },
    );
  }

  @override
  void dispose() {
    for (var controller in _priceControllers) {
      controller.dispose();
    }
    for (var controller in _promoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfirmasi Hasil AI'),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2),
          onPressed: () {
            Navigator.popUntil(context, (route) => route.settings.name == '/report/input-mode');
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_showWarning) ...[
              TacoCard(
                backgroundColor: AppColors.errorLight,
                borderSide: const BorderSide(color: AppColors.error),
                showBorder: true,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const TacoIconTile(
                          icon: Iconsax.danger,
                          color: AppColors.error,
                          backgroundColor: AppColors.surface,
                          size: 40,
                          iconSize: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Peringatan Validasi AI',
                            style: AppTextStyles.titleSmall.copyWith(color: AppColors.error, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _warningMessage,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TacoButton(
                          text: 'Abaikan & Lanjutkan',
                          size: ButtonSize.small,
                          customColor: AppColors.error,
                          isFullWidth: false,
                          onPressed: () {
                            setState(() {
                              _showWarning = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            const SectionHeader(
              title: 'Laporan Asli',
              subtitle: 'Transkripsi / teks laporan Anda',
            ),
            const SizedBox(height: 12),
            TacoCard(
              backgroundColor: AppColors.surfaceVariant,
              showBorder: false,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const TacoIconTile(
                        icon: Iconsax.document_text_1,
                        color: AppColors.textPrimary,
                        backgroundColor: AppColors.surface,
                        size: 36,
                        iconSize: 18,
                        borderRadius: 10,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        widget.inputMode == 'voice' ? 'Hasil Transkripsi' : 'Teks Laporan',
                        style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.text,
                    style: AppTextStyles.bodyMedium.copyWith(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const SectionHeader(
              title: 'Hasil Ekstraksi AI',
              subtitle: 'Tinjau dan sesuaikan parameter sinyal pasar berikut',
            ),
            const SizedBox(height: 12),

            // Form inputs for each signal
            ...List.generate(_signals.length, (index) {
              final signal = _signals[index];
              return TacoCard(
                showBorder: true,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            TacoIconTile(
                              icon: Iconsax.flash,
                              color: AppColors.primary,
                              backgroundColor: AppColors.primaryLight,
                              size: 40,
                              iconSize: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${signal.brand} - ${signal.product}',
                              style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        TacoBadge(
                          text: 'Keyakinan: ${(signal.confidence * 100).toInt()}%',
                          backgroundColor: signal.confidence >= 0.8 ? AppColors.successLight : AppColors.warningLight,
                          textColor: signal.confidence >= 0.8 ? AppColors.success : AppColors.warning,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Price Field
                    TacoTextField(
                      label: 'Harga (Rupiah)',
                      controller: _priceControllers[index],
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),

                    // Stock level Selector
                    Text(
                      'Tingkat Stok (1-100%)',
                      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _stockLevels[index],
                      items: const [
                        DropdownMenuItem(value: '20', child: Text('Sangat Rendah (20%)')),
                        DropdownMenuItem(value: '40', child: Text('Rendah (40%)')),
                        DropdownMenuItem(value: '60', child: Text('Cukup (60%)')),
                        DropdownMenuItem(value: '80', child: Text('Banyak (80%)')),
                        DropdownMenuItem(value: '100', child: Text('Penuh (100%)')),
                      ],
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.surface,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primary, width: 2),
                        ),
                      ),
                      onChanged: (val) {
                        if (val != null) {
                          _stockLevels[index] = val;
                        }
                      },
                    ),
                    const SizedBox(height: 12),

                    // Promo Info Field
                    TacoTextField(
                      label: 'Informasi Promosi / Catatan',
                      controller: _promoControllers[index],
                      hintText: 'Contoh: Diskon, display baru, dll.',
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: TacoButton(
                    text: 'Batal',
                    type: ButtonType.outline,
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.settings.name == '/report/input-mode');
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TacoButton(
                    text: 'Simpan & Selesai',
                    onPressed: _validateAndSubmit,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AIConfirmationScreenWrapper extends StatelessWidget {
  const AIConfirmationScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return AIConfirmationScreen(
      outlet: args['outlet'] as Outlet,
      inputMode: args['inputMode'] as String,
      text: args['text'] as String,
    );
  }
}