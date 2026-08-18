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
      _itemControllers[oldWidget.selectedIndex].reverse();
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
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 56,
        child: Center(
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              final progress = CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ).value;

              final iconColor = Color.lerp(
                AppColors.textTertiary,
                Colors.white,
                progress,
              )!;

              final baseColor = AppColors.surfaceVariant.withValues(alpha: 0.6);

              return Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.lerp(baseColor, AppColors.primary, progress)!,
                      Color.lerp(
                        baseColor,
                        AppColors.secondary.withValues(alpha: 0.85),
                        progress,
                      )!,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Color.lerp(
                      AppColors.border.withValues(alpha: 0.3),
                      Colors.white.withValues(alpha: 0.2),
                      progress,
                    )!,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(
                        alpha: 0.25 * progress,
                      ),
                      blurRadius: 16 * progress,
                      offset: Offset(0, 6 * progress),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Transform.scale(
                      scale: 1.0 + (0.15 * progress),
                      child: Icon(
                        progress > 0.5 ? item.activeIcon : item.icon,
                        size: 20,
                        color: iconColor,
                      ),
                    ),
                    ClipRect(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Transform.translate(
                            offset: Offset(-10 * (1 - progress), 0),
                            child: Opacity(
                              opacity: progress,
                              child: Text(
                                item.label,
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
