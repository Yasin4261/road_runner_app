import 'package:flutter/material.dart';

/// Navigation item model - Single Responsibility Principle
class NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const NavItem({
    required this.label,
    required this.icon,
    IconData? activeIcon,
  }) : activeIcon = activeIcon ?? icon;
}

/// Default navigation items for the app
class AppNavItems {
  AppNavItems._();

  static const List<NavItem> items = [
    NavItem(
      label: 'Ana Sayfa',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
    ),
    NavItem(
      label: 'Paketlerim',
      icon: Icons.inventory_2_outlined,
      activeIcon: Icons.inventory_2,
    ),
    NavItem(
      label: 'Vardiyalar',
      icon: Icons.schedule_outlined,
      activeIcon: Icons.schedule,
    ),
    NavItem(
      label: 'Profil',
      icon: Icons.person_outline,
      activeIcon: Icons.person,
    ),
  ];
}

