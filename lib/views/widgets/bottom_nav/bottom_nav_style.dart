import 'package:flutter/material.dart';
import 'package:road_runner_app/core/theme/app_colors.dart';

/// Bottom navigation bar style configuration
class BottomNavStyle {
  final Color backgroundColor;
  final Color selectedItemColor;
  final Color unselectedItemColor;
  final Color indicatorColor;
  final Color shadowColor;

  const BottomNavStyle({
    this.backgroundColor = AppColors.navBarBackground,
    this.selectedItemColor = AppColors.navBarSelected,
    this.unselectedItemColor = AppColors.navBarUnselected,
    this.indicatorColor = AppColors.navBarIndicator,
    this.shadowColor = AppColors.navBarShadow,
  });

  /// Default light theme style
  static const BottomNavStyle light = BottomNavStyle();

  /// Dark theme style
  static const BottomNavStyle dark = BottomNavStyle(
    backgroundColor: AppColors.navBarBackgroundDark,
    selectedItemColor: AppColors.navBarSelectedDark,
    unselectedItemColor: AppColors.navBarUnselectedDark,
    indicatorColor: Color(0x1FBB86FC),
    shadowColor: Color(0x29000000),
  );

  /// Copy with method for customization
  BottomNavStyle copyWith({
    Color? backgroundColor,
    Color? selectedItemColor,
    Color? unselectedItemColor,
    Color? indicatorColor,
    Color? shadowColor,
  }) {
    return BottomNavStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      selectedItemColor: selectedItemColor ?? this.selectedItemColor,
      unselectedItemColor: unselectedItemColor ?? this.unselectedItemColor,
      indicatorColor: indicatorColor ?? this.indicatorColor,
      shadowColor: shadowColor ?? this.shadowColor,
    );
  }
}

