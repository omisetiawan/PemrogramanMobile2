// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_pos_praktikum/main.dart';
import 'package:flutter_application_pos_praktikum/praktikum4/praktikum4_root.dart';
import 'package:flutter_application_pos_praktikum/praktikum4/redux/app_state.dart';
import 'package:flutter_application_pos_praktikum/praktikum4/redux/auth/auth_state.dart';
import 'package:flutter_application_pos_praktikum/praktikum4/redux/product/product_state.dart';
import 'package:flutter_application_pos_praktikum/praktikum4/redux/store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Portal menu renders smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Portal Praktikum Mobile 2'), findsOneWidget);
    expect(find.text('Review PM1 - State & Data Management'), findsOneWidget);
    expect(find.text('Advance State Management - Redux'), findsOneWidget);
  });

  testWidgets(
    'Navigate to Praktikum 4 from Portal renders without StoreProvider error',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final modul4Card = find.text('Advance State Management - Redux');
      await tester.scrollUntilVisible(modul4Card, 100);
      expect(modul4Card, findsOneWidget);

      await tester.tap(modul4Card);
      await tester.pumpAndSettle();

      // Verify it renders Praktikum4Root and LoginReduxScreen with StoreProvider successfully
      expect(find.byType(Praktikum4Root), findsOneWidget);
      expect(find.text('Redux State Management'), findsOneWidget);
    },
  );

  testWidgets('Praktikum4Root renders Dashboard when authenticated', (
    WidgetTester tester,
  ) async {
    final authenticatedState = AppState(
      authState: const AuthState(
        status: AuthStatus.authenticated,
        userEmail: 'test@example.com',
        token: 'mock_jwt_token',
      ),
      productState: ProductState.initial(),
    );
    final store = createReduxStore(initialState: authenticatedState);

    await tester.pumpWidget(MyApp(store: store));

    final modul4Card = find.text('Advance State Management - Redux');
    await tester.scrollUntilVisible(modul4Card, 100);
    await tester.tap(modul4Card);
    await tester.pumpAndSettle();

    expect(find.text('Dashboard Redux'), findsOneWidget);
    expect(find.text('test@example.com'), findsOneWidget);
  });
}
