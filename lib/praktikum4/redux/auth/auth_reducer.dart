import 'auth_actions.dart';
import 'auth_state.dart';

AuthState authReducer(AuthState state, dynamic action) {
  if (action is LoginRequestAction) {
    return state.copyWith(status: AuthStatus.loading, clearError: true);
  }

  if (action is LoginSuccessAction) {
    return state.copyWith(
      status: AuthStatus.authenticated,
      userEmail: action.email,
      token: action.token,
      isDummyMode: action.isDummy,
      clearError: true,
    );
  }

  if (action is LoginFailureAction) {
    return state.copyWith(status: AuthStatus.error, errorMessage: action.error);
  }

  if (action is LogoutAction) {
    return AuthState.initial();
  }

  if (action is ClearAuthErrorAction) {
    return state.copyWith(clearError: true);
  }

  return state;
}
