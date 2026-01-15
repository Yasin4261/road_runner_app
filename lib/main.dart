import 'package:flutter/material.dart';
import 'package:road_runner_app/app.dart';
import 'package:road_runner_app/core/di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup dependency injection
  await setupLocator();

  runApp(App());
}
