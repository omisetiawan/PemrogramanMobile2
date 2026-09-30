class LoginRequestAction {}

class LoginSuccessAction {
  final String email;
  final String token;
  final bool isDummy;

  LoginSuccessAction({
    required this.email,
    required this.token,
    this.isDummy = false,
  });
}

class LoginFailureAction {
  final String error;
  LoginFailureAction(this.error);
}

class LogoutAction {}

class ClearAuthErrorAction {}
