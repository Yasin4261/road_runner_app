import 'package:flutter/material.dart';
import 'package:road_runner_app/core/theme/app_theme.dart';
import 'package:road_runner_app/views/screens/home/home_screen.dart';
import 'package:road_runner_app/views/screens/packages/packages_screen.dart';
import 'package:road_runner_app/views/screens/shifts/shifts_screen.dart';
import 'package:road_runner_app/views/screens/profile/profile_screen.dart';
import 'package:road_runner_app/views/widgets/bottom_nav/bottom_nav.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Road Runner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: MainShell(
        pages: [
          const HomeScreen(),
          const PackagesScreen(),
          const ShiftsScreen(),
          const ProfileScreen(),
        ],
      ),
    );
  }
}

