enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final String? userEmail;
  final String? token;
  final String? errorMessage;
  final bool isDummyMode;

  const AuthState({
    required this.status,
    this.userEmail,
    this.token,
    this.errorMessage,
    this.isDummyMode = false,
  });

  factory AuthState.initial() => const AuthState(
    status: AuthStatus.unauthenticated,
    userEmail: null,
    token: null,
    errorMessage: null,
    isDummyMode: false,
  );

  AuthState copyWith({
    AuthStatus? status,
    String? userEmail,
    String? token,
    String? errorMessage,
    bool? isDummyMode,
    bool clearError = false,
    bool clearToken = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      userEmail: userEmail ?? this.userEmail,
      token: clearToken ? null : (token ?? this.token),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isDummyMode: isDummyMode ?? this.isDummyMode,
    );
  }

  bool get isAuthenticated =>
      status == AuthStatus.authenticated && token != null && token!.isNotEmpty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthState &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          userEmail == other.userEmail &&
          token == other.token &&
          errorMessage == other.errorMessage &&
          isDummyMode == other.isDummyMode;

  @override
  int get hashCode =>
      status.hashCode ^
      userEmail.hashCode ^
      token.hashCode ^
      errorMessage.hashCode ^
      isDummyMode.hashCode;
}
