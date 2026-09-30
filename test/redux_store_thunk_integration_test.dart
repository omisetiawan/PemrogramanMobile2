import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_pos_praktikum/praktikum4/redux/auth/auth_state.dart';
import 'package:flutter_application_pos_praktikum/praktikum4/redux/auth/auth_thunks.dart';
import 'package:flutter_application_pos_praktikum/praktikum4/redux/product/product_state.dart';
import 'package:flutter_application_pos_praktikum/praktikum4/redux/product/product_thunks.dart';
import 'package:flutter_application_pos_praktikum/praktikum4/redux/store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Redux Store & Thunk Integration Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('Redux Store initializes with default AppState', () {
      final store = createReduxStore();

      expect(store.state.authState.status, equals(AuthStatus.unauthenticated));
      expect(
        store.state.productState.status,
        equals(ProductListStatus.initial),
      );
      expect(store.state.productState.products, isEmpty);
    });

    test(
      'dummyLoginThunk authenticates and fetches products into Store',
      () async {
        final store = createReduxStore();

        bool callbackCalled = false;
        await store.dispatch(
          dummyLoginThunk(
            email: 'praktikum@redux.com',
            onSuccess: () {
              callbackCalled = true;
            },
          ),
        );

        expect(callbackCalled, isTrue);
        expect(store.state.authState.status, equals(AuthStatus.authenticated));
        expect(store.state.authState.userEmail, equals('praktikum@redux.com'));
        expect(store.state.authState.isDummyMode, isTrue);

        // Tunggu hingga Thunk fetchProducts selesai
        await Future.delayed(const Duration(milliseconds: 300));
        expect(
          store.state.productState.status,
          equals(ProductListStatus.success),
        );
        expect(store.state.productState.products.isNotEmpty, isTrue);
      },
    );

    test(
      'createProductThunk dispatches and appends item to store in dummy mode',
      () async {
        final store = createReduxStore();
        await store.dispatch(dummyLoginThunk());
        await Future.delayed(const Duration(milliseconds: 300));

        final initialCount = store.state.productState.products.length;

        await store.dispatch(
          createProductThunk(
            name: 'Kopi Susu Redux',
            price: 18000,
            quantity: 12,
            category: 'Minuman',
            description:
                'Kopi susu dengan cita rasa Redux Single Source of Truth',
          ),
        );

        expect(
          store.state.productState.products.length,
          equals(initialCount + 1),
        );
        expect(
          store.state.productState.products.first.name,
          equals('Kopi Susu Redux'),
        );
      },
    );

    test('updateProductThunk modifies product in store', () async {
      final store = createReduxStore();
      await store.dispatch(dummyLoginThunk());
      await Future.delayed(const Duration(milliseconds: 300));

      final firstProduct = store.state.productState.products.first;

      await store.dispatch(
        updateProductThunk(
          id: firstProduct.id,
          name: '${firstProduct.name} (Updated via Redux)',
          price: 35000,
        ),
      );

      final updated = store.state.productState.products.firstWhere(
        (p) => p.id == firstProduct.id,
      );
      expect(updated.name, contains('(Updated via Redux)'));
      expect(updated.price, equals(35000));
    });

    test('deleteProductThunk removes product from store', () async {
      final store = createReduxStore();
      await store.dispatch(dummyLoginThunk());
      await Future.delayed(const Duration(milliseconds: 300));

      final firstProduct = store.state.productState.products.first;
      final targetId = firstProduct.id;

      await store.dispatch(deleteProductThunk(id: targetId));

      final exists = store.state.productState.products.any(
        (p) => p.id == targetId,
      );
      expect(exists, isFalse);
    });

    test('logoutThunk clears auth in store', () async {
      final store = createReduxStore();
      await store.dispatch(dummyLoginThunk());

      expect(store.state.authState.isAuthenticated, isTrue);

      await store.dispatch(logoutThunk());

      expect(store.state.authState.isAuthenticated, isFalse);
      expect(store.state.authState.userEmail, isNull);
    });
  });
}
