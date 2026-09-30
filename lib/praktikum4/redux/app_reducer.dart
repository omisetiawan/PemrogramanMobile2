import 'package:flutter_application_pos_praktikum/praktikum4/redux/app_state.dart';
import 'auth/auth_reducer.dart';
import 'product/product_reducer.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    authState: authReducer(state.authState, action),
    productState: productReducer(state.productState, action),
  );
}
