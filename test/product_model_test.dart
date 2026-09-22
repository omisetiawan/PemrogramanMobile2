import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_pos_praktikum/praktikum2/models/product_model.dart';

void main() {
  group('Praktikum 2 - Product Model & JSON Test', () {
    test('Product.fromJson parses correctly', () {
      final json = {
        'id': '101',
        'name': 'Laptop Asus ROG',
        'price': 15000000.0,
        'quantity': 3,
        'description': 'Laptop gaming untuk development',
        'category': 'Elektronik',
      };

      final product = Product.fromJson(json);

      expect(product.id, '101');
      expect(product.name, 'Laptop Asus ROG');
      expect(product.price, 15000000.0);
      expect(product.quantity, 3);
      expect(product.category, 'Elektronik');
    });

    test('Product.toJson converts back to map accurately', () {
      final product = Product(
        id: '202',
        name: 'Headset Wireless',
        price: 350000.0,
        quantity: 10,
        description: 'Noise cancelling headset',
        category: 'Aksesoris',
      );

      final json = product.toJson();

      expect(json['id'], '202');
      expect(json['name'], 'Headset Wireless');
      expect(json['price'], 350000.0);
      expect(json['quantity'], 10);
    });
  });
}
