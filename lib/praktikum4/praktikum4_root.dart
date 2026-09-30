import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_application_pos_praktikum/praktikum4/redux/app_state.dart';
import 'screens/dashboard_redux_screen.dart';
import 'screens/login_redux_screen.dart';

class Praktikum4Root extends StatelessWidget {
  final Store<AppState>? store;

  const Praktikum4Root({super.key, this.store});

  @override
  Widget build(BuildContext context) {
    final body = StoreConnector<AppState, bool>(
      distinct: true,
      converter: (s) => s.state.authState.isAuthenticated,
      builder: (context, isAuthenticated) {
        if (isAuthenticated) {
          return const DashboardReduxScreen();
        }
        return const LoginReduxScreen();
      },
    );

    if (store != null) {
      return StoreProvider<AppState>(store: store!, child: body);
    }

    return body;
  }
}
