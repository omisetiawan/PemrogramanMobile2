import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_pos_praktikum/praktikum3/models/product_api_model.dart';
import 'package:flutter_application_pos_praktikum/praktikum4/redux/product/product_actions.dart';
import 'package:flutter_application_pos_praktikum/praktikum4/redux/product/product_reducer.dart';
import 'package:flutter_application_pos_praktikum/praktikum4/redux/product/product_state.dart';

void main() {
  group('ProductReducer Tests', () {
    final sampleProduct1 = ProductApi(
      id: 'p-1',
      name: 'Kopi Tubruk',
      category: 'Minuman',
      price: 10000,
      quantity: 20,
      description: 'Kopi hitam khas Nusantara',
    );

    final sampleProduct2 = ProductApi(
      id: 'p-2',
      name: 'Pisang Goreng Keju',
      category: 'Makanan',
      price: 15000,
      quantity: 10,
      description: 'Pisang goreng manis topping keju',
    );

    test('initial state is empty and initial status', () {
      final state = ProductState.initial();
      expect(state.status, equals(ProductListStatus.initial));
      expect(state.products, isEmpty);
      expect(state.filteredProducts, isEmpty);
      expect(state.searchQuery, isEmpty);
    });

    test('FetchProductsRequestAction sets status to loading', () {
      final initial = ProductState.initial();
      final updated = productReducer(initial, FetchProductsRequestAction());
      expect(updated.status, equals(ProductListStatus.loading));
    });

    test('FetchProductsSuccessAction sets products and success status', () {
      final initial = ProductState.initial();
      final updated = productReducer(
        initial,
        FetchProductsSuccessAction([sampleProduct1, sampleProduct2]),
      );

      expect(updated.status, equals(ProductListStatus.success));
      expect(updated.products.length, equals(2));
      expect(updated.filteredProducts.length, equals(2));
    });

    test('FetchProductsSuccessAction with empty list sets empty status', () {
      final initial = ProductState.initial();
      final updated = productReducer(initial, FetchProductsSuccessAction([]));

      expect(updated.status, equals(ProductListStatus.empty));
      expect(updated.products, isEmpty);
    });

    test('FetchProductsFailureAction sets error status and message', () {
      final initial = ProductState.initial();
      final updated = productReducer(
        initial,
        FetchProductsFailureAction('Koneksi terputus'),
      );

      expect(updated.status, equals(ProductListStatus.error));
      expect(updated.errorMessage, equals('Koneksi terputus'));
    });

    test('SearchProductAction filters products reactively', () {
      final loadedState = ProductState(
        status: ProductListStatus.success,
        products: [sampleProduct1, sampleProduct2],
      );

      // Cari 'kopi'
      final searchState = productReducer(
        loadedState,
        SearchProductAction('kopi'),
      );

      expect(searchState.searchQuery, equals('kopi'));
      expect(searchState.filteredProducts.length, equals(1));
      expect(searchState.filteredProducts.first.name, equals('Kopi Tubruk'));

      // Cari 'goreng'
      final searchState2 = productReducer(
        loadedState,
        SearchProductAction('goreng'),
      );
      expect(searchState2.filteredProducts.length, equals(1));
      expect(
        searchState2.filteredProducts.first.name,
        equals('Pisang Goreng Keju'),
      );
    });

    test('ProductCreatedAction inserts product at top of state', () {
      final loadedState = ProductState(
        status: ProductListStatus.success,
        products: [sampleProduct1],
      );

      final updated = productReducer(
        loadedState,
        ProductCreatedAction(sampleProduct2),
      );

      expect(updated.products.length, equals(2));
      expect(updated.products.first.id, equals('p-2'));
    });

    test('ProductUpdatedAction updates existing product in state', () {
      final loadedState = ProductState(
        status: ProductListStatus.success,
        products: [sampleProduct1],
      );

      final editedProduct = sampleProduct1.copyWith(
        name: 'Kopi Tubruk Spesial',
        price: 12000,
      );

      final updated = productReducer(
        loadedState,
        ProductUpdatedAction(editedProduct),
      );

      expect(updated.products.first.name, equals('Kopi Tubruk Spesial'));
      expect(updated.products.first.price, equals(12000));
    });

    test('ProductDeletedAction removes product from state', () {
      final loadedState = ProductState(
        status: ProductListStatus.success,
        products: [sampleProduct1, sampleProduct2],
      );

      final updated = productReducer(loadedState, ProductDeletedAction('p-1'));

      expect(updated.products.length, equals(1));
      expect(updated.products.first.id, equals('p-2'));
    });
  });
}
