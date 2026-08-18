import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:taco_sales_insight/core/services/mock_api_service.dart';
import 'package:taco_sales_insight/models/outlet.dart';
import 'package:taco_sales_insight/shared/app_colors.dart';
import 'package:taco_sales_insight/shared/app_text_styles.dart';
import 'package:taco_sales_insight/shared/common_widgets.dart';

class ProcessingScreen extends StatefulWidget {
  final Outlet outlet;
  final String inputMode;
  final String text;

  const ProcessingScreen({
    super.key,
    required this.outlet,
    required this.inputMode,
    required this.text,
  });

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

enum _ProcessingStatus { processing, error }

class _ProcessingScreenState extends State<ProcessingScreen> {
  int _currentStep = 0;
  Timer? _timer;
  _ProcessingStatus _status = _ProcessingStatus.processing;
  String _errorMessage = '';
  bool _cancelled = false;

  final List<String> _steps = [
    'Mengunggah data laporan...',
    'Menganalisis teks dengan AI (NLP)...',
    'Mengekstrak brand dan sinyal kompetitor...',
    'Memvalidasi data & menghitung skor...',
  ];

  @override
  void initState() {
    super.initState();
    _startProcessing();
  }

  Future<void> _startProcessing() async {
    setState(() {
      _status = _ProcessingStatus.processing;
      _currentStep = 0;
      _errorMessage = '';
      _cancelled = false;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 650), (timer) {
      if (!mounted || _cancelled) return;
      if (_currentStep < _steps.length - 1) {
        setState(() {
          _currentStep++;
        });
      }
    });

    try {
      await MockApiService.fetch<int>(
        () => _steps.length,
        delay: const Duration(milliseconds: 2600),
      );
      _timer?.cancel();
      if (!mounted || _cancelled) return;
      _navigateToConfirmation();
    } on MockApiException catch (e) {
      _timer?.cancel();
      if (!mounted || _cancelled) return;
      setState(() {
        _status = _ProcessingStatus.error;
        _errorMessage = e.message;
      });
    }
  }

  void _navigateToConfirmation() {
    Navigator.pushNamed(
      context,
      '/report/ai-confirmation',
      arguments: {
        'outlet': widget.outlet,
        'inputMode': widget.inputMode,
        'text': widget.text,
      },
    );
  }

  void _cancel() {
    _cancelled = true;
    _timer?.cancel();
    Navigator.popUntil(
      context,
      (route) => route.settings.name == '/report/input-mode',
    );
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
            title: 'Pemrosesan Laporan',
            subtitle: 'AI sedang menganalisis laporan Anda',
            showBackButton: false,
          ),

          Expanded(
            child: _status == _ProcessingStatus.error
                ? ErrorState(
                    title: 'Gagal Memproses Laporan',
                    subtitle: _errorMessage,
                    retryText: 'Coba Lagi',
                    onRetry: _startProcessing,
                  )
                : Stack(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.primaryLight,
                                      AppColors.primaryLight.withValues(
                                        alpha: 0.5,
                                      ),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.2,
                                    ),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.15,
                                      ),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 36),

                              Text(
                                'AI Sedang Memproses Laporan',
                                style: AppTextStyles.headlineMedium.copyWith(
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Harap tunggu sebentar, NLP engine sedang menganalisis sinyal pasar dari laporan Anda.',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: AppColors.textSecondary,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 48),

                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.surface,
                                      AppColors.surfaceVariant.withValues(
                                        alpha: 0.3,
                                      ),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: AppColors.border.withValues(
                                      alpha: 0.8,
                                    ),
                                    width: 1.2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.05,
                                      ),
                                      blurRadius: 16,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: List.generate(_steps.length, (
                                    index,
                                  ) {
                                    final isDone = index < _currentStep;
                                    final isActive = index == _currentStep;

                                    Color iconColor = AppColors.textDisabled;
                                    IconData iconData = Iconsax.minus;

                                    if (isDone) {
                                      iconColor = AppColors.success;
                                      iconData = Iconsax.tick_circle;
                                    } else if (isActive) {
                                      iconColor = AppColors.secondary;
                                      iconData = Iconsax.refresh;
                                    }

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 14,
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: isActive
                                                ? _SpinningIcon(
                                                    icon: iconData,
                                                    color: iconColor,
                                                    size: 24,
                                                  )
                                                : Icon(
                                                    iconData,
                                                    color: iconColor,
                                                    size: 24,
                                                  ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Text(
                                              _steps[index],
                                              style: AppTextStyles.bodyMedium
                                                  .copyWith(
                                                    color: isActive
                                                        ? AppColors.textPrimary
                                                        : (isDone
                                                              ? AppColors
                                                                    .textSecondary
                                                              : AppColors
                                                                    .textDisabled),
                                                    fontWeight: isActive
                                                        ? FontWeight.w700
                                                        : FontWeight.w600,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 16,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.border,
                              width: 1,
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _cancel,
                              borderRadius: BorderRadius.circular(10),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Iconsax.close_circle,
                                      size: 16,
                                      color: AppColors.textSecondary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Batalkan',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _SpinningIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double size;

  const _SpinningIcon({
    required this.icon,
    required this.color,
    this.size = 20,
  });

  @override
  State<_SpinningIcon> createState() => _SpinningIconState();
}

class _SpinningIconState extends State<_SpinningIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Icon(widget.icon, color: widget.color, size: widget.size),
    );
  }
}

class ProcessingScreenWrapper extends StatelessWidget {
  const ProcessingScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return ProcessingScreen(
      outlet: args['outlet'] as Outlet,
      inputMode: args['inputMode'] as String,
      text: args['text'] as String,
    );
  }
}
