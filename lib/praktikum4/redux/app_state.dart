import 'auth/auth_state.dart';
import 'product/product_state.dart';

class AppState {
  final AuthState authState;
  final ProductState productState;

  const AppState({required this.authState, required this.productState});

  factory AppState.initial() => AppState(
    authState: AuthState.initial(),
    productState: ProductState.initial(),
  );

  AppState copyWith({AuthState? authState, ProductState? productState}) {
    return AppState(
      authState: authState ?? this.authState,
      productState: productState ?? this.productState,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          authState == other.authState &&
          productState == other.productState;

  @override
  int get hashCode => authState.hashCode ^ productState.hashCode;
}
