import 'package:flutter/material.dart';

//import 'package:road_runner_app/views/home_screen.dart';
import 'fast_code.dart';

import 'package:road_runner_app/constants/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kurye App',
      theme: AppTheme.theme,
      home: HomeScreen(),
    );
  }
}
