import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_pos_praktikum/praktikum4/redux/auth/auth_actions.dart';
import 'package:flutter_application_pos_praktikum/praktikum4/redux/auth/auth_reducer.dart';
import 'package:flutter_application_pos_praktikum/praktikum4/redux/auth/auth_state.dart';

void main() {
  group('AuthReducer Tests', () {
    test('initial state is unauthenticated', () {
      final state = AuthState.initial();
      expect(state.status, equals(AuthStatus.unauthenticated));
      expect(state.isAuthenticated, isFalse);
    });

    test('LoginRequestAction transitions state to loading', () {
      final initial = AuthState.initial();
      final updated = authReducer(initial, LoginRequestAction());

      expect(updated.status, equals(AuthStatus.loading));
      expect(updated.errorMessage, isNull);
    });

    test(
      'LoginSuccessAction sets authenticated state with email and token',
      () {
        final initial = AuthState.initial();
        final updated = authReducer(
          initial,
          LoginSuccessAction(
            email: 'praktikum@gmail.com',
            token: 'jwt_mock_token_123',
            isDummy: false,
          ),
        );

        expect(updated.status, equals(AuthStatus.authenticated));
        expect(updated.userEmail, equals('praktikum@gmail.com'));
        expect(updated.token, equals('jwt_mock_token_123'));
        expect(updated.isDummyMode, isFalse);
        expect(updated.isAuthenticated, isTrue);
      },
    );

    test('LoginFailureAction sets error state and message', () {
      final initial = AuthState.initial();
      final updated = authReducer(
        initial,
        LoginFailureAction('Email atau password salah'),
      );

      expect(updated.status, equals(AuthStatus.error));
      expect(updated.errorMessage, equals('Email atau password salah'));
      expect(updated.isAuthenticated, isFalse);
    });

    test('LogoutAction resets state to initial unauthenticated', () {
      const loggedInState = AuthState(
        status: AuthStatus.authenticated,
        userEmail: 'user@test.com',
        token: 'token123',
      );
      final updated = authReducer(loggedInState, LogoutAction());

      expect(updated.status, equals(AuthStatus.unauthenticated));
      expect(updated.userEmail, isNull);
      expect(updated.token, isNull);
      expect(updated.isAuthenticated, isFalse);
    });

    test('ClearAuthErrorAction clears error message', () {
      const errorState = AuthState(
        status: AuthStatus.error,
        errorMessage: 'Terjadi error',
      );
      final updated = authReducer(errorState, ClearAuthErrorAction());

      expect(updated.errorMessage, isNull);
    });
  });
}
