import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class FloatingNavigationDock extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  final List<NavItem> items;

  const FloatingNavigationDock({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.items,
  });

  @override
  State<FloatingNavigationDock> createState() => _FloatingNavigationDockState();
}

class _FloatingNavigationDockState extends State<FloatingNavigationDock>
    with TickerProviderStateMixin {
  late List<AnimationController> _itemControllers;

  @override
  void initState() {
    super.initState();
    _itemControllers = List.generate(
      widget.items.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 220),
        vsync: this,
      ),
    );

    // Initialize active state
    for (int i = 0; i < _itemControllers.length; i++) {
      if (i == widget.selectedIndex) {
        _itemControllers[i].forward();
      }
    }
  }

  @override
  void didUpdateWidget(FloatingNavigationDock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      // Animate previous active item to inactive
      _itemControllers[oldWidget.selectedIndex].reverse();
      // Animate new active item to active
      _itemControllers[widget.selectedIndex].forward();
    }
  }

  @override
  void dispose() {
    for (var controller in _itemControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: AppColors.border.withValues(alpha: 0.6),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.12),
                blurRadius: 32,
                offset: const Offset(0, 12),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(widget.items.length, (index) {
              return AnimatedNavItem(
                animation: _itemControllers[index],
                item: widget.items[index],
                onTap: () => widget.onItemTapped(index),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class AnimatedNavItem extends AnimatedWidget {
  final NavItem item;
  final VoidCallback onTap;

  const AnimatedNavItem({
    super.key,
    required Animation<double> animation,
    required this.item,
    required this.onTap,
  }) : super(listenable: animation);

  Animation<double> get animation => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    final isActive = animation.value > 0.5;
    final progress = animation.value;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 56,
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            if (isActive) {
              return _buildActiveItem(progress);
            } else {
              return _buildInactiveItem(progress);
            }
          },
        ),
      ),
    );
  }

  Widget _buildActiveItem(double progress) {
    // Scale animation for active state
    final scaleValue = 0.85 + (progress * 0.15);
    
    return Transform.scale(
      scale: scaleValue,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.secondary.withValues(alpha: 0.85),
            ],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.25 * progress),
              blurRadius: 16 * progress,
              offset: Offset(0, 6 * progress),
            ),
            BoxShadow(
              color: AppColors.secondary.withValues(alpha: 0.1 * progress),
              blurRadius: 8 * progress,
              offset: Offset(0, 2 * progress),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with rotation animation
            Transform.rotate(
              angle: progress * 0.1,
              child: Icon(
                item.activeIcon,
                size: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            // Label with fade-in animation
            Opacity(
              opacity: progress,
              child: Text(
                item.label,
                style: AppTextStyles.labelMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInactiveItem(double progress) {
    // Fade out animation for inactive state
    final opacityValue = 1.0 - (progress * 0.4);

    return Opacity(
      opacity: opacityValue,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.border.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Icon(
          item.icon,
          size: 18,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }
}
