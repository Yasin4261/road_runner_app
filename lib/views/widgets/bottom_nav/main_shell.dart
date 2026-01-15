import 'package:flutter/material.dart';
import 'package:road_runner_app/views/widgets/bottom_nav/bottom_nav.dart';

/// Main Shell - Wraps pages with bottom navigation
///
/// Usage:
/// ```dart
/// MainShell(
///   pages: [
///     HomeScreen(),
///     PackagesScreen(),
///     ShiftsScreen(),
///     ProfileScreen(),
///   ],
/// )
/// ```
class MainShell extends StatefulWidget {
  /// Pages to display for each navigation item
  final List<Widget> pages;

  /// Optional custom navigation items (defaults to AppNavItems)
  final List<NavItem>? navItems;

  /// Optional custom style
  final BottomNavStyle? style;

  /// Initial selected index
  final int initialIndex;

  const MainShell({
    super.key,
    required this.pages,
    this.navItems,
    this.style,
    this.initialIndex = 0,
  }) : assert(pages.length >= 2, 'At least 2 pages required');

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    if (index == _currentIndex) return;
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.navItems ?? AppNavItems.items;
    final style = widget.style ?? BottomNavStyle.light;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: widget.pages,
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: items,
        style: style,
      ),
    );
  }
}

