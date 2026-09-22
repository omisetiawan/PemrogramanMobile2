import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_pos_praktikum/praktikum3/services/api_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ApiService Dummy Mode Tests', () {
    late ApiService apiService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      apiService = ApiService();
      await apiService.dummyLogin(email: 'test@example.com');
    });

    test('dummyLogin sets isDummyMode and currentEmail', () {
      expect(apiService.isDummyMode, isTrue);
      expect(apiService.isLoggedIn, isTrue);
      expect(apiService.currentEmail, equals('test@example.com'));
    });

    test('getProducts in dummy mode returns dummy list', () async {
      final products = await apiService.getProducts();
      expect(products.isNotEmpty, isTrue);
      expect(products.length, greaterThanOrEqualTo(4));
    });

    test('search query in dummy mode filters products', () async {
      final results = await apiService.getProducts(searchQuery: 'espresso');
      expect(results.length, equals(1));
      expect(results.first.name.toLowerCase(), contains('espresso'));
    });

    test('createProduct in dummy mode adds a product to top of list', () async {
      final newProduct = await apiService.createProduct(
        name: 'Teh Tarik Aceh',
        price: 15000,
        quantity: 20,
        category: 'Minuman',
        description: 'Teh tarik khas Aceh dengan buih melimpah.',
      );

      expect(newProduct.name, equals('Teh Tarik Aceh'));
      expect(newProduct.id, startsWith('dummy-'));

      final allProducts = await apiService.getProducts();
      expect(allProducts.first.name, equals('Teh Tarik Aceh'));
    });

    test('updateProduct in dummy mode modifies the product', () async {
      final updated = await apiService.updateProduct(
        id: 'dummy-1',
        name: 'Kopi Espresso Arabika Premium',
        price: 24000,
      );

      expect(updated.name, equals('Kopi Espresso Arabika Premium'));
      expect(updated.price, equals(24000));
    });

    test('deleteProduct in dummy mode removes the product', () async {
      final success = await apiService.deleteProduct('dummy-2');
      expect(success, isTrue);

      final allProducts = await apiService.getProducts();
      expect(allProducts.any((p) => p.id == 'dummy-2'), isFalse);
    });

    test('logout resets auth and dummy state', () async {
      await apiService.logout();
      expect(apiService.isLoggedIn, isFalse);
      expect(apiService.isDummyMode, isFalse);
      expect(apiService.currentEmail, isNull);
    });
  });
}
