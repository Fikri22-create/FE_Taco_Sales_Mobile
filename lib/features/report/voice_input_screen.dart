import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:taco_sales_insight/core/services/mock_api_service.dart';
import 'package:taco_sales_insight/models/outlet.dart';
import 'package:taco_sales_insight/shared/app_colors.dart';
import 'package:taco_sales_insight/shared/app_text_styles.dart';
import 'package:taco_sales_insight/shared/common_widgets.dart';

class VoiceInputScreen extends StatefulWidget {
  final Outlet outlet;

  const VoiceInputScreen({super.key, required this.outlet});

  @override
  State<VoiceInputScreen> createState() => _VoiceInputScreenState();
}

class _VoiceInputScreenState extends State<VoiceInputScreen> {
  bool _isRecording = false;
  bool _hasRecorded = false;
  int _seconds = 0;
  Timer? _timer;
  List<double> _waveHeights = List.filled(25, 4.0);
  final Random _random = Random();

  final List<Map<String, dynamic>> _mockTranscripts = [
    {'time': 2, 'text': 'Hari ini saya di outlet Supermarket Mega Jaya...'},
    {
      'time': 5,
      'text':
          'Melihat Indomie goreng sedang ada promo seharga Rp 2.500 per bungkus.',
    },
    {
      'time': 9,
      'text': 'Stok di rak utama masih cukup melimpah, sekitar 50 bungkus.',
    },
    {
      'time': 13,
      'text':
          'Sementara Sedaap kari ayam mengalami kenaikan harga menjadi Rp 3.000.',
    },
    {
      'time': 18,
      'text':
          'Juga ada display baru dari produk kompetitor Sarimi dekat area kasir.',
    },
  ];

  List<String> _currentTranscriptLines = [];

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        if (timer.tick % 10 == 0) {
          _seconds++;
          _updateTranscript();
        }
        _updateWaveform();
      });
    });
  }

  void _updateWaveform() {
    if (_isRecording) {
      _waveHeights = List.generate(
        25,
        (index) => _random.nextDouble() * 40.0 + 4.0,
      );
    } else {
      _waveHeights = List.filled(25, 4.0);
    }
  }

  void _updateTranscript() {
    List<String> lines = [];
    for (var item in _mockTranscripts) {
      if (_seconds >= item['time']) {
        lines.add(item['text']);
      }
    }
    _currentTranscriptLines = lines;
  }

  void _toggleRecording() {
    setState(() {
      if (_isRecording) {
        _isRecording = false;
        _timer?.cancel();
      } else {
        _isRecording = true;
        _hasRecorded = true;
        _startTimer();
      }
    });
  }

  void _resetRecording() {
    setState(() {
      _isRecording = false;
      _hasRecorded = false;
      _seconds = 0;
      _timer?.cancel();
      _waveHeights = List.filled(25, 4.0);
      _currentTranscriptLines = [];
    });
  }

  void _submitVoiceReport() {
    _timer?.cancel();
    if (MockApiService.simulateOffline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Koneksi offline. Periksa koneksi internet Anda dan coba lagi.',
          ),
        ),
      );
      return;
    }
    final fullText = _currentTranscriptLines.isNotEmpty
        ? _currentTranscriptLines.join(' ')
        : 'Indomie goreng sedang promo Rp 2.500 di Supermarket Mega Jaya. Sedaap kari ayam naik menjadi Rp 3.000.';

    Navigator.pushNamed(
      context,
      '/report/processing',
      arguments: {
        'outlet': widget.outlet,
        'inputMode': 'voice',
        'text': fullText,
      },
    );
  }

  String _formatDuration(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TacoPremiumHeader(
            title: 'Laporan Suara',
            subtitle: 'Rekam laporan Anda dengan mudah',
            showBackButton: Navigator.canPop(context),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primaryLight, AppColors.surface],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.secondary,
                                AppColors.secondary.withValues(alpha: 0.75),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: const Icon(
                            Iconsax.shop,
                            size: 22,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.outlet.name,
                                style: AppTextStyles.titleSmall.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${widget.outlet.city} • ${widget.outlet.address}',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),

                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      _formatDuration(_seconds),
                      style: AppTextStyles.displayLarge.copyWith(
                        color: _isRecording
                            ? AppColors.error
                            : AppColors.primary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: _isRecording
                          ? AppColors.error
                          : AppColors.textSecondary,
                      fontWeight: _isRecording
                          ? FontWeight.w700
                          : FontWeight.w600,
                    ),
                    child: Text(
                      _isRecording
                          ? 'Merekam suara...'
                          : (_seconds > 0
                                ? 'Perekaman dijeda'
                                : 'Ketuk mikrofon untuk mulai'),
                    ),
                  ),
                  const SizedBox(height: 40),

                  Container(
                    height: 70,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(25, (index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 100),
                          width: 3,
                          height: max(3.0, _waveHeights[index]),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                (_isRecording
                                        ? AppColors.error
                                        : AppColors.secondary)
                                    .withValues(alpha: 0.8),
                                _isRecording
                                    ? AppColors.error
                                    : AppColors.secondary,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(1.5),
                          ),
                        );
                      }),
                    ),
                  ),
                  const Spacer(),

                  if (_hasRecorded) ...[
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.secondaryLight, AppColors.surface],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.secondary.withValues(alpha: 0.2),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.secondary.withValues(alpha: 0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColors.secondary.withValues(
                                      alpha: 0.2,
                                    ),
                                    width: 1,
                                  ),
                                ),
                                child: const Icon(
                                  Iconsax.document_text_1,
                                  size: 18,
                                  color: AppColors.secondary,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Transkripsi AI Langsung',
                                style: AppTextStyles.titleSmall.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            height: 100,
                            width: double.infinity,
                            child: _currentTranscriptLines.isEmpty
                                ? Center(
                                    child: Text(
                                      'Mulai berbicara...',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.textTertiary,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _currentTranscriptLines.length,
                                    itemBuilder: (context, i) {
                                      final text = _currentTranscriptLines[i];
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        child: Text(
                                          text,
                                          style: AppTextStyles.bodySmall
                                              .copyWith(
                                                color: AppColors.textPrimary,
                                                height: 1.4,
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_hasRecorded)
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            shape: const CircleBorder(),
                            child: InkWell(
                              onTap: _resetRecording,
                              customBorder: const CircleBorder(),
                              child: const SizedBox(
                                width: 56,
                                height: 56,
                                child: Icon(
                                  Iconsax.refresh,
                                  color: AppColors.textPrimary,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 56),

                      const SizedBox(width: 28),

                      GestureDetector(
                        onTap: _toggleRecording,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                (_isRecording
                                        ? AppColors.error
                                        : AppColors.secondary)
                                    .withValues(alpha: 0.12),
                                (_isRecording
                                        ? AppColors.error
                                        : AppColors.secondary)
                                    .withValues(alpha: 0.06),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    (_isRecording
                                            ? AppColors.error
                                            : AppColors.secondary)
                                        .withValues(alpha: 0.15),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: _toggleRecording,
                              splashColor:
                                  (_isRecording
                                          ? AppColors.error
                                          : AppColors.secondary)
                                      .withValues(alpha: 0.1),
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      _isRecording
                                          ? AppColors.error
                                          : AppColors.secondary,
                                      (_isRecording
                                              ? AppColors.error
                                              : AppColors.secondary)
                                          .withValues(alpha: 0.85),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          (_isRecording
                                                  ? AppColors.error
                                                  : AppColors.secondary)
                                              .withValues(alpha: 0.25),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    _isRecording
                                        ? Iconsax.pause
                                        : Iconsax.microphone,
                                    color: Colors.white,
                                    size: 36,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 28),

                      if (_hasRecorded && !_isRecording)
                        Container(
                          decoration: BoxDecoration(
                            color: _seconds >= 2
                                ? AppColors.successLight
                                : AppColors.surfaceDisabled,
                            shape: BoxShape.circle,
                            boxShadow: _seconds >= 2
                                ? [
                                    BoxShadow(
                                      color: AppColors.success.withValues(
                                        alpha: 0.15,
                                      ),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            shape: const CircleBorder(),
                            child: InkWell(
                              onTap: _seconds >= 2 ? _submitVoiceReport : null,
                              customBorder: const CircleBorder(),
                              child: SizedBox(
                                width: 56,
                                height: 56,
                                child: Icon(
                                  Iconsax.tick_circle,
                                  color: _seconds >= 2
                                      ? AppColors.success
                                      : AppColors.textDisabled,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 56),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VoiceInputScreenWrapper extends StatelessWidget {
  const VoiceInputScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final outlet = ModalRoute.of(context)!.settings.arguments as Outlet;
    return VoiceInputScreen(outlet: outlet);
  }
}
