import 'package:flutter/material.dart';

class AppRouter {
  static const String splash = '/';
  static const String home = '/home';
  // TODO: Add more routes as needed

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        // return MaterialPageRoute(builder: (_) => SplashScreen());
      case home:
        // return MaterialPageRoute(builder: (_) => HomeScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}

