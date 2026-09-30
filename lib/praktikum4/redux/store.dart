import 'package:flutter_application_pos_praktikum/praktikum4/redux/app_state.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'app_reducer.dart';

/// Singleton atau factory pembuat Store Redux
Store<AppState> createReduxStore({AppState? initialState}) {
  return Store<AppState>(
    appReducer,
    initialState: initialState ?? AppState.initial(),
    middleware: [thunkMiddleware],
  );
}
