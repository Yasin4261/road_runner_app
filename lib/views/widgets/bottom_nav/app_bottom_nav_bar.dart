import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:road_runner_app/core/theme/app_text_styles.dart';
import 'nav_item.dart';
import 'bottom_nav_style.dart';

/// Modern Custom Bottom Navigation Bar Widget
class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NavItem> items;
  final BottomNavStyle style;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.items = const [],
    this.style = const BottomNavStyle(),
  });

  factory AppBottomNavBar.withDefaults({
    Key? key,
    required int currentIndex,
    required ValueChanged<int> onTap,
    BottomNavStyle style = const BottomNavStyle(),
  }) {
    return AppBottomNavBar(
      key: key,
      currentIndex: currentIndex,
      onTap: onTap,
      items: AppNavItems.items,
      style: style,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive horizontal padding
    final horizontalPadding = screenWidth * 0.03;

    return Container(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding.clamp(8.0, 16.0),
        8,
        horizontalPadding.clamp(8.0, 16.0),
        bottomPadding + 12,
      ),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: style.backgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: style.shadowColor,
              blurRadius: 24,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            items.length,
            (index) => Expanded(
              child: _NavBarItem(
                item: items[index],
                isSelected: currentIndex == index,
                onTap: () => onTap(index),
                selectedColor: style.selectedItemColor,
                unselectedColor: style.unselectedItemColor,
                indicatorColor: style.indicatorColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatefulWidget {
  final NavItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final Color selectedColor;
  final Color unselectedColor;
  final Color indicatorColor;

  const _NavBarItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.selectedColor,
    required this.unselectedColor,
    required this.indicatorColor,
  });

  @override
  State<_NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<_NavBarItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  void _handleTap() {
    HapticFeedback.lightImpact();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SizedBox(
          height: 56,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.isSelected
                      ? widget.indicatorColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  widget.isSelected ? widget.item.activeIcon : widget.item.icon,
                  color: widget.isSelected
                      ? widget.selectedColor
                      : widget.unselectedColor,
                  size: 22,
                ),
              ),
              const SizedBox(height: 2),
              // Label
              Flexible(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: (widget.isSelected
                          ? AppTextStyles.navLabelSelected
                          : AppTextStyles.navLabelUnselected)
                      .copyWith(
                    color: widget.isSelected
                        ? widget.selectedColor
                        : widget.unselectedColor,
                  ),
                  child: Text(
                    widget.item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

