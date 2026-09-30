import 'package:flutter/foundation.dart';
import 'package:flutter_application_pos_praktikum/praktikum3/services/api_service.dart';
import 'package:flutter_application_pos_praktikum/praktikum4/redux/app_state.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'auth_actions.dart';
import '../product/product_thunks.dart';

/// Thunk untuk mengecek status auth yang tersimpan di storage lokal saat start
ThunkAction<AppState> initAuthThunk() {
  return (Store<AppState> store) async {
    final apiService = ApiService();
    await apiService.initSavedAuth();

    if (apiService.isLoggedIn && apiService.currentEmail != null) {
      store.dispatch(
        LoginSuccessAction(
          email: apiService.currentEmail!,
          token: 'persisted_session',
          isDummy: apiService.isDummyMode,
        ),
      );
      // Otomatis fetch data produk
      store.dispatch(fetchProductsThunk());
    }
  };
}

/// Thunk untuk login dengan email & password ke Directus BaaS
ThunkAction<AppState> loginThunk({
  required String email,
  required String password,
  VoidCallback? onSuccess,
  void Function(String error)? onError,
}) {
  return (Store<AppState> store) async {
    store.dispatch(LoginRequestAction());
    try {
      final apiService = ApiService();
      final success = await apiService.login(email: email, password: password);

      if (success) {
        store.dispatch(
          LoginSuccessAction(
            email: email.trim(),
            token: apiService.currentEmail ?? 'token_directus',
            isDummy: false,
          ),
        );
        // Sinkronisasi data katalog produk
        store.dispatch(fetchProductsThunk());
        onSuccess?.call();
      } else {
        const error = 'Login gagal: Email atau password tidak sesuai.';
        store.dispatch(LoginFailureAction(error));
        onError?.call(error);
      }
    } catch (e) {
      final errorMsg = e.toString();
      store.dispatch(LoginFailureAction(errorMsg));
      onError?.call(errorMsg);
    }
  };
}

/// Thunk untuk demonstrasi cepat (Mock / Dummy Mode)
ThunkAction<AppState> dummyLoginThunk({
  String email = 'praktikum@gmail.com',
  VoidCallback? onSuccess,
}) {
  return (Store<AppState> store) async {
    store.dispatch(LoginRequestAction());
    final apiService = ApiService();
    await apiService.dummyLogin(email: email);

    store.dispatch(
      LoginSuccessAction(
        email: email,
        token: 'dummy_token_preview_only',
        isDummy: true,
      ),
    );
    store.dispatch(fetchProductsThunk());
    onSuccess?.call();
  };
}

/// Thunk untuk logout
ThunkAction<AppState> logoutThunk({VoidCallback? onLoggedOut}) {
  return (Store<AppState> store) async {
    final apiService = ApiService();
    await apiService.logout();
    store.dispatch(LogoutAction());
    onLoggedOut?.call();
  };
}
