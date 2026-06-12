import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:road_runner_app/core/di/service_locator.dart';
import 'package:road_runner_app/core/events/auth_events.dart';
import 'package:road_runner_app/core/theme/app_theme.dart';
import 'package:road_runner_app/data/models/assignment_notification.dart';
import 'package:road_runner_app/data/services/auth_storage.dart';
import 'package:road_runner_app/viewmodels/active_delivery_viewmodel.dart';
import 'package:road_runner_app/viewmodels/assignment_viewmodel.dart';
import 'package:road_runner_app/views/screens/delivery/active_delivery_screen.dart';
import 'package:road_runner_app/views/screens/home/home_screen.dart';
import 'package:road_runner_app/views/screens/login/login_screen.dart';
import 'package:road_runner_app/views/screens/packages/packages_screen.dart';
import 'package:road_runner_app/views/screens/shifts/shifts_screen.dart';
import 'package:road_runner_app/views/screens/profile/profile_screen.dart';
import 'package:road_runner_app/views/widgets/bottom_nav/bottom_nav.dart';
import 'package:road_runner_app/views/widgets/dialogs/new_assignment_dialog.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool? _isLoggedIn;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> _messengerKey =
      GlobalKey<ScaffoldMessengerState>();
  StreamSubscription<void>? _sessionExpiredSub;

  @override
  void initState() {
    super.initState();
    _checkAuth();
    _sessionExpiredSub =
        AuthEvents.instance.onSessionExpired.listen((_) => _onSessionExpired());
  }

  @override
  void dispose() {
    _sessionExpiredSub?.cancel();
    super.dispose();
  }

  Future<void> _checkAuth() async {
    final loggedIn = await AuthStorage.isLoggedIn();
    setState(() => _isLoggedIn = loggedIn);
    if (loggedIn) {
      _afterLogin();
    }
  }

  void _onLoginSuccess() {
    setState(() => _isLoggedIn = true);
    _afterLogin();
  }

  /// Login sonrasi: bekleyen atamalari yukle + devam eden aktif siparisi geri yukle
  void _afterLogin() {
    locator<AssignmentViewModel>().loadPendingFromApi();
    locator<ActiveDeliveryViewModel>().restoreActiveOrder();
  }

  void _onSessionExpired() {
    if (!mounted) return;
    if (_isLoggedIn == false) return;
    setState(() => _isLoggedIn = false);
    _messengerKey.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(
        content: Text('Oturum sureniz doldu, lutfen tekrar giris yapin.'),
        duration: Duration(seconds: 4),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AssignmentViewModel>.value(
          value: locator<AssignmentViewModel>(),
        ),
        ChangeNotifierProvider<ActiveDeliveryViewModel>.value(
          value: locator<ActiveDeliveryViewModel>(),
        ),
      ],
      child: MaterialApp(
        title: 'Road Runner',
        debugShowCheckedModeBanner: false,
        navigatorKey: _navigatorKey,
        scaffoldMessengerKey: _messengerKey,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        builder: (context, child) {
          return _AssignmentListener(
            navigatorKey: _navigatorKey,
            isLoggedIn: _isLoggedIn == true,
            child: child ?? const SizedBox.shrink(),
          );
        },
        home: _buildHome(),
      ),
    );
  }

  Widget _buildHome() {
    if (_isLoggedIn == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_isLoggedIn == false) {
      return LoginScreen(onLoginSuccess: _onLoginSuccess);
    }
    return MainShell(
      pages: [
        const HomeScreen(),
        const PackagesScreen(),
        const ShiftsScreen(),
        const ProfileScreen(),
      ],
    );
  }
}

/// Yeni atama geldiginde dialog gosteren global dinleyici.
class _AssignmentListener extends StatefulWidget {
  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;
  final bool isLoggedIn;

  const _AssignmentListener({
    required this.child,
    required this.navigatorKey,
    required this.isLoggedIn,
  });

  @override
  State<_AssignmentListener> createState() => _AssignmentListenerState();
}

class _AssignmentListenerState extends State<_AssignmentListener> {
  int? _shownAssignmentId;
  bool _dialogOpen = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AssignmentViewModel>(
      builder: (context, vm, child) {
        final latest = vm.latestAssignment;
        if (widget.isLoggedIn &&
            latest != null &&
            latest.assignmentId != _shownAssignmentId &&
            !_dialogOpen) {
          _shownAssignmentId = latest.assignmentId;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showAssignmentDialog(vm, latest);
          });
        }
        return child!;
      },
      child: widget.child,
    );
  }

  Future<void> _showAssignmentDialog(
    AssignmentViewModel vm,
    AssignmentNotification assignment,
  ) async {
    final navContext = widget.navigatorKey.currentContext;
    if (navContext == null) return;

    _dialogOpen = true;
    final decision = await NewAssignmentDialog.show(navContext, assignment);
    _dialogOpen = false;

    if (decision == AssignmentDecision.accept) {
      final orderId = await vm.acceptAssignment(assignment.assignmentId);
      if (orderId != null) {
        final active = locator<ActiveDeliveryViewModel>();
        await active.loadOrder(orderId);
        final ctx = widget.navigatorKey.currentContext;
        if (ctx != null && ctx.mounted) {
          Navigator.of(ctx).push(
            MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider.value(
                value: active,
                child: const ActiveDeliveryScreen(),
              ),
            ),
          );
        }
      } else {
        _toast(vm.errorMessage.isEmpty ? 'Kabul edilemedi' : vm.errorMessage);
      }
    } else if (decision == AssignmentDecision.reject) {
      await vm.rejectAssignment(assignment.assignmentId);
      _toast('Siparis reddedildi');
    } else {
      vm.clearLatest();
    }
  }

  void _toast(String msg) {
    final ctx = widget.navigatorKey.currentContext;
    if (ctx == null) return;
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(msg)));
  }
}

