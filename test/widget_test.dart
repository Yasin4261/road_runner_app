// Smoke test for the Road Runner courier app.
//
// Boots the real [App] widget end-to-end with mocked plugins and verifies that
// an unauthenticated launch wires up dependency injection and lands on the
// login screen. This is a "does the app start at all" guard — not a feature
// test. If DI, theming, or the initial auth/routing flow break, this goes red.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:road_runner_app/app.dart';
import 'package:road_runner_app/core/di/service_locator.dart';
import 'package:road_runner_app/views/screens/login/login_screen.dart';

void main() {
  setUp(() async {
    // No stored JWT → AuthStorage.isLoggedIn() is false → boot to login screen.
    SharedPreferences.setMockInitialValues({});
    // Register dependencies fresh for each test; setupLocator() throws if a
    // type is already registered, so reset first.
    await locator.reset();
    await setupLocator();
  });

  tearDown(() async {
    await locator.reset();
  });

  testWidgets('boots to the login screen when no session is stored',
      (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    // The first frame is a loading spinner while AuthStorage reads
    // SharedPreferences. Pump until that async check resolves and the app
    // rebuilds into the login screen (avoid pumpAndSettle — the spinner never
    // "settles").
    await tester.pump(); // let the auth-check future complete
    await tester.pump(const Duration(milliseconds: 200)); // settle the rebuild

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Road Runner'), findsOneWidget);
    expect(find.text('Kurye Girişi'), findsOneWidget);
  });
}
