import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:taco_sales_insight/models/report.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Shared TACO design foundation.
///
/// Conventions enforced here:
///   • Containers use restrained 8–12px radii and hairline borders.
///   • Icon tiles are 40px tinted rounded squares ([TacoIconTile]).
///   • Section spacing is 24px; card padding is 16–20px.
///   • Buttons are flat (no shadows) with crisp ink ripples.
///   • Status/badges use 8px radius pills, not full capsules.

// ---------------------------------------------------------------------------
// Card
// ---------------------------------------------------------------------------

class TacoCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final double? borderRadius;
  final double? elevation;
  final bool showBorder;
  final VoidCallback? onTap;
  final BorderSide? borderSide;

  const TacoCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.elevation,
    this.showBorder = true,
    this.onTap,
    this.borderSide,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? 12;
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: BorderRadius.circular(radius),
        elevation: elevation ?? 0,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius),
          child: Container(
            padding: padding ?? const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              border: showBorder
                  ? Border.all(
                      color: borderSide?.color ?? AppColors.border,
                      width: borderSide?.width ?? 1,
                    )
                  : null,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section header
// ---------------------------------------------------------------------------

/// Section heading with the signature amber tick motif.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final EdgeInsets? padding;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 4,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.titleLarge.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    subtitle!,
                    style: AppTextStyles.bodyMediumSecondary,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 12),
            trailing!,
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Button
// ---------------------------------------------------------------------------

enum ButtonType {
  primary,
  secondary,
  outline,
  text,
  danger,
}

enum ButtonSize {
  small,
  medium,
  large,
}

class TacoButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonSize size;
  final Widget? icon;
  final bool isLoading;
  final bool isFullWidth;
  final Color? customColor;
  final EdgeInsets? padding;

  const TacoButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.customColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;

    Color backgroundColor;
    Color textColor;
    Color borderColor;
    Color splashColor;

    switch (type) {
      case ButtonType.primary:
        backgroundColor = customColor ?? AppColors.primary;
        textColor = AppColors.textInverse;
        borderColor = Colors.transparent;
        splashColor = AppColors.primary.withValues(alpha: 0.25);
      case ButtonType.secondary:
        backgroundColor = AppColors.surfaceVariant;
        textColor = AppColors.textPrimary;
        borderColor = Colors.transparent;
        splashColor = AppColors.primary.withValues(alpha: 0.12);
      case ButtonType.outline:
        backgroundColor = AppColors.surface;
        textColor = AppColors.textPrimary;
        borderColor = AppColors.border;
        splashColor = AppColors.primary.withValues(alpha: 0.12);
      case ButtonType.text:
        backgroundColor = Colors.transparent;
        textColor = AppColors.primary;
        borderColor = Colors.transparent;
        splashColor = AppColors.primary.withValues(alpha: 0.12);
      case ButtonType.danger:
        backgroundColor = AppColors.error;
        textColor = AppColors.textInverse;
        borderColor = Colors.transparent;
        splashColor = AppColors.error.withValues(alpha: 0.25);
    }

    if (isDisabled) {
      backgroundColor = AppColors.surfaceDisabled;
      textColor = AppColors.textDisabled;
      borderColor = AppColors.surfaceDisabled;
      splashColor = Colors.transparent;
    }

    double verticalPadding;
    double horizontalPadding;
    TextStyle textStyle;

    switch (size) {
      case ButtonSize.small:
        verticalPadding = 8;
        horizontalPadding = 16;
        textStyle = AppTextStyles.labelMedium;
      case ButtonSize.medium:
        verticalPadding = 12;
        horizontalPadding = 20;
        textStyle = AppTextStyles.labelLarge;
      case ButtonSize.large:
        verticalPadding = 16;
        horizontalPadding = 24;
        textStyle = AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600);
    }

    final child = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(textColor),
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: textStyle.copyWith(color: textColor),
              ),
            ],
          );

    final button = Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onPressed,
          splashColor: splashColor,
          highlightColor: splashColor,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: padding ??
                EdgeInsets.symmetric(
                  vertical: verticalPadding,
                  horizontal: horizontalPadding,
                ),
            alignment: Alignment.center,
            child: child,
          ),
        ),
      ),
    );

    return isFullWidth
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }
}

// ---------------------------------------------------------------------------
// Text field
// ---------------------------------------------------------------------------

class TacoTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool isRequired;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? minLines;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;
  final EdgeInsets? contentPadding;

  const TacoTextField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.isRequired = false,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.minLines = 1,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label${isRequired ? ' *' : ''}',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          minLines: minLines,
          onChanged: onChanged,
          validator: validator,
          enabled: enabled,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.surface,
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
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
            contentPadding: contentPadding ??
                const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
            errorText: errorText,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Badge
// ---------------------------------------------------------------------------

class TacoBadge extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final double? borderRadius;
  final EdgeInsets? padding;

  const TacoBadge({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.borderRadius,
    this.padding,
  });

  factory TacoBadge.success({required String text}) {
    return TacoBadge(
      text: text,
      backgroundColor: AppColors.successLight,
      textColor: AppColors.success,
    );
  }

  factory TacoBadge.warning({required String text}) {
    return TacoBadge(
      text: text,
      backgroundColor: AppColors.warningLight,
      textColor: AppColors.warning,
    );
  }

  factory TacoBadge.error({required String text}) {
    return TacoBadge(
      text: text,
      backgroundColor: AppColors.errorLight,
      textColor: AppColors.error,
    );
  }

  factory TacoBadge.info({required String text}) {
    return TacoBadge(
      text: text,
      backgroundColor: AppColors.infoLight,
      textColor: AppColors.info,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 12,
              color: textColor ?? AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: textColor ?? AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Loading
// ---------------------------------------------------------------------------

class LoadingIndicator extends StatelessWidget {
  final String? message;
  final Color? color;

  const LoadingIndicator({
    super.key,
    this.message,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 36,
              height: 36,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation(color ?? AppColors.primary),
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message!,
                style: AppTextStyles.bodyMediumSecondary,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// State views (empty / error / offline)
// ---------------------------------------------------------------------------

/// Shared state-view scaffold: a soft icon tile + headline + optional
/// supporting text. Keeps EmptyState / ErrorState / OfflineState consistent.
class _StateView extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;

  const _StateView({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, size: 32, color: iconColor),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: AppTextStyles.bodyMediumSecondary,
                textAlign: TextAlign.center,
              ),
            ],
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 24),
              TacoButton(
                text: actionText!,
                onPressed: onAction,
                type: ButtonType.primary,
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;
  final IconData? icon;

  const EmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return _StateView(
      icon: icon ?? Iconsax.document_copy,
      iconColor: AppColors.textTertiary,
      iconBackground: AppColors.surfaceVariant,
      title: title,
      subtitle: subtitle,
      actionText: actionText,
      onAction: onAction,
    );
  }
}

class ErrorState extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String retryText;
  final VoidCallback? onRetry;

  const ErrorState({
    super.key,
    required this.title,
    this.subtitle,
    this.retryText = 'Coba Lagi',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return _StateView(
      icon: Iconsax.danger_copy,
      iconColor: AppColors.error,
      iconBackground: AppColors.errorLight,
      title: title,
      subtitle: subtitle,
      actionText: retryText,
      onAction: onRetry,
    );
  }
}

class OfflineState extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String retryText;
  final VoidCallback? onRetry;

  const OfflineState({
    super.key,
    this.title = 'Tidak Ada Koneksi',
    this.subtitle,
    this.retryText = 'Coba Lagi',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return _StateView(
      icon: Iconsax.wifi,
      iconColor: AppColors.textSecondary,
      iconBackground: AppColors.surfaceVariant,
      title: title,
      subtitle: subtitle ?? 'Periksa koneksi internet Anda, lalu coba lagi.',
      actionText: retryText,
      onAction: onRetry,
    );
  }
}

// ---------------------------------------------------------------------------
// Status badge
// ---------------------------------------------------------------------------

/// Maps a [ReportStatus] to a compact colored pill with an Iconsax icon.
class StatusBadge extends StatelessWidget {
  final ReportStatus status;

  const StatusBadge({super.key, required this.status});

  ({String label, Color color, Color background, IconData icon}) get _data {
    switch (status) {
      case ReportStatus.completed:
        return (
          label: 'Selesai',
          color: AppColors.success,
          background: AppColors.successLight,
          icon: Iconsax.tick_circle,
        );
      case ReportStatus.processing:
        return (
          label: 'Diproses',
          color: AppColors.info,
          background: AppColors.infoLight,
          icon: Iconsax.refresh_2,
        );
      case ReportStatus.needsConfirmation:
        return (
          label: 'Perlu Konfirmasi',
          color: AppColors.warning,
          background: AppColors.warningLight,
          icon: Iconsax.warning_2,
        );
      case ReportStatus.failed:
        return (
          label: 'Gagal',
          color: AppColors.error,
          background: AppColors.errorLight,
          icon: Iconsax.close_circle,
        );
      case ReportStatus.draft:
        return (
          label: 'Draf',
          color: AppColors.textSecondary,
          background: AppColors.grayLight,
          icon: Iconsax.document_text_1,
        );
      case ReportStatus.submitted:
        return (
          label: 'Dikirim',
          color: AppColors.secondary,
          background: AppColors.infoLight,
          icon: Iconsax.send_2,
        );
      case ReportStatus.aiReview:
        return (
          label: 'Review AI',
          color: AppColors.purple,
          background: AppColors.purpleLight,
          icon: Iconsax.status,
        );
      case ReportStatus.confirmed:
        return (
          label: 'Terkonfirmasi',
          color: AppColors.success,
          background: AppColors.successLight,
          icon: Iconsax.verify,
        );
      case ReportStatus.archived:
        return (
          label: 'Arsip',
          color: AppColors.textTertiary,
          background: AppColors.grayLight,
          icon: Iconsax.archive_1,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _data;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: data.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(data.icon, size: 14, color: data.color),
          const SizedBox(width: 6),
          Text(
            data.label,
            style: AppTextStyles.caption.copyWith(
              color: data.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// List item
// ---------------------------------------------------------------------------

class TacoListItem extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final bool showDivider;

  const TacoListItem({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.padding,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: padding ?? const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  leading,
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        title,
                        if (subtitle != null) ...[
                          const SizedBox(height: 4),
                          subtitle!,
                        ],
                      ],
                    ),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(width: 16),
                    trailing!,
                  ],
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.divider,
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Progress bar
// ---------------------------------------------------------------------------

class ProgressBar extends StatelessWidget {
  final double value;
  final double height;
  final Color? backgroundColor;
  final Color? progressColor;
  final double borderRadius;
  final EdgeInsets? margin;

  const ProgressBar({
    super.key,
    required this.value,
    this.height = 8,
    this.backgroundColor,
    this.progressColor,
    this.borderRadius = 3,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: value.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: progressColor ?? AppColors.primary,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// NEW — signature shared widgets
// ---------------------------------------------------------------------------

/// The app's standard icon container: a 40px tinted rounded square with a
/// crisp Iconsax glyph. Used for list leading icons, stat tiles and any
/// "icon + label" row across the app.
class TacoIconTile extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final Color? backgroundColor;
  final double size;
  final double iconSize;
  final double borderRadius;

  const TacoIconTile({
    super.key,
    required this.icon,
    this.color,
    this.backgroundColor,
    this.size = 40,
    this.iconSize = 20,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Icon(
        icon,
        size: iconSize,
        color: color ?? AppColors.textSecondary,
      ),
    );
  }
}

/// Compact "TACO" brand wordmark — the app's signature mark.
///
/// Deep navy letterset with a single amber dot. Use [isLight] on navy
/// hero surfaces.
class TacoWordmark extends StatelessWidget {
  final bool isLight;
  final double fontSize;
  final bool showDot;

  const TacoWordmark({
    super.key,
    this.isLight = false,
    this.fontSize = 15,
    this.showDot = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'TACO',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: fontSize,
            height: 1.2,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.4,
            color: isLight ? AppColors.textInverse : AppColors.primary,
          ),
        ),
        if (showDot) ...[
          const SizedBox(width: 2),
          Container(
            width: fontSize * 0.55,
            height: fontSize * 0.55,
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ],
    );
  }
}

/// Hero page header: optional amber kicker + strong title + quiet subtitle,
/// with an optional trailing action. The refined "hero" treatment for
/// screen headers.
class TacoHeroHeader extends StatelessWidget {
  final String? kicker;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;

  const TacoHeroHeader({
    super.key,
    this.kicker,
    required this.title,
    this.subtitle,
    this.trailing,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (kicker != null) ...[
                  Text(kicker!, style: AppTextStyles.kicker),
                  const SizedBox(height: 6),
                ],
                Text(
                  title,
                  style: AppTextStyles.headlineMedium,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    subtitle!,
                    style: AppTextStyles.bodyMediumSecondary,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 12),
            trailing!,
          ],
        ],
      ),
    );
  }
}

/// Deep-navy hero band with a soft rounded bottom — used at the top of
/// flow screens to give the app its premium B2B identity.
///
/// Renders white text on [AppColors.navySurface]. Wrap the screen body
/// with this above the scrollable content; screens handle their own
/// status-bar padding.
class TacoHeroBand extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;

  const TacoHeroBand({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ??
          const EdgeInsets.fromLTRB(20, 20, 20, 28),
      decoration: const BoxDecoration(
        color: AppColors.navySurface,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.textInverse,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    subtitle!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textInverse.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 12),
            trailing!,
          ],
        ],
      ),
    );
  }
}