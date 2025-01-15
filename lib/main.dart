import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Import your screens
import 'package:road_runner_app/views/home_screen.dart';
import 'package:road_runner_app/views/login_screen.dart';
import 'package:road_runner_app/constants/app_theme.dart';
import 'package:road_runner_app/views/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define your routes using GoRouter
    final GoRouter _router = GoRouter(
      initialLocation: '/login', // Default route
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) =>
              const RegisterScreen(), // Replace with your actual RegisterScreen
        ),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Kurye App',
      theme: AppTheme.theme,
      routerConfig: _router, // Use the router configuration
    );
  }
}
