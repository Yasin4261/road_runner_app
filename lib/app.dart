import 'package:flutter/material.dart';
import 'package:road_runner_app/core/theme/app_theme.dart';
import 'package:road_runner_app/data/services/auth_storage.dart';
import 'package:road_runner_app/views/screens/home/home_screen.dart';
import 'package:road_runner_app/views/screens/login/login_screen.dart';
import 'package:road_runner_app/views/screens/packages/packages_screen.dart';
import 'package:road_runner_app/views/screens/shifts/shifts_screen.dart';
import 'package:road_runner_app/views/screens/profile/profile_screen.dart';
import 'package:road_runner_app/views/widgets/bottom_nav/bottom_nav.dart';
class App extends StatefulWidget {
  const App({super.key});
  @override
  State<App> createState() => _AppState();
}
class _AppState extends State<App> {
  bool? _isLoggedIn;
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }
  Future<void> _checkAuth() async {
    final loggedIn = await AuthStorage.isLoggedIn();
    setState(() => _isLoggedIn = loggedIn);
  }
  void _onLoginSuccess() {
    setState(() => _isLoggedIn = true);
  }
  void _onLogout() {
    setState(() => _isLoggedIn = false);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Road Runner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: _buildHome(),
    );
  }
  Widget _buildHome() {
    // Henüz kontrol edilmedi
    if (_isLoggedIn == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    // Login gerekli
    if (_isLoggedIn == false) {
      return LoginScreen(onLoginSuccess: _onLoginSuccess);
    }
    // Ana ekran
    return MainShell(
      pages: const [
        HomeScreen(),
        PackagesScreen(),
        ShiftsScreen(),
        ProfileScreen(),
      ],
    );
  }
}
