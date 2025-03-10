import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:road_runner_app/constants/app_theme.dart';

import 'package:road_runner_app/views/home_screen.dart';
import 'package:road_runner_app/views/login_screen.dart';
import 'package:road_runner_app/views/profile_screen.dart';
import 'package:road_runner_app/views/register_screen.dart';

import 'package:road_runner_app/providers/courier_status_provider.dart';

import 'package:road_runner_app/services/socket_service.dart';

import 'package:road_runner_app/viewmodels/shift_viewmodel.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final socketService = SocketService();
  socketService.initializeSocket();

  runApp(MyApp(socketService: socketService));
}

class MyApp extends StatelessWidget {
  final SocketService socketService;

  MyApp({Key? key, required this.socketService}) : super(key: key);

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CourierStatusProvider()),
        ChangeNotifierProvider(create: (_) => ShiftViewModel()),
        Provider.value(value: socketService),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Kurye App',
        theme: AppTheme.theme,
        routerConfig: _router,
      ),
    );
  }
}
