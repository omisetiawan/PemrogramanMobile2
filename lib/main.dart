import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_application_pos_praktikum/praktikum4/redux/app_state.dart';
import 'package:flutter_application_pos_praktikum/praktikum4/redux/auth/auth_thunks.dart';
import 'package:flutter_application_pos_praktikum/praktikum4/redux/store.dart';
import 'screens/portal_menu_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final store = createReduxStore();
  store.dispatch(initAuthThunk());
  runApp(MyApp(store: store));
}

class MyApp extends StatefulWidget {
  final Store<AppState>? store;

  const MyApp({super.key, this.store});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final Store<AppState> _store;

  @override
  void initState() {
    super.initState();
    _store = widget.store ?? createReduxStore();
    if (widget.store == null) {
      _store.dispatch(initAuthThunk());
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: _store,
      child: MaterialApp(
        title: 'POS Praktikum App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(centerTitle: true),
        ),
        home: const PortalMenuScreen(),
      ),
    );
  }
}
