import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_pos_praktikum/praktikum3/models/product_api_model.dart';

void main() {
  group('Praktikum 3 - ProductApi Model & Directus JSON Test', () {
    test(
      'ProductApi.fromJson handles Directus response format with String price',
      () {
        final json = {
          'id': 'f03b6219-8f6d-4e43-a2e5-092ebe8ddea9',
          'status': 'draft',
          'name': 'Plushie Kaela Kovalskia',
          'price': '250000',
          'image_url': '2338b6d6-9adb-4f4d-8107-ee2c55a96f59',
          'category': 'Merchandise',
          'description': 'Boneka',
          'quantity': null,
        };

        final product = ProductApi.fromJson(json);

        expect(product.id, 'f03b6219-8f6d-4e43-a2e5-092ebe8ddea9');
        expect(product.name, 'Plushie Kaela Kovalskia');
        expect(product.price, 250000.0);
        expect(product.quantity, 0); // null converted to 0
        expect(product.category, 'Merchandise');
        expect(
          product.fullImageUrl,
          'https://pos.cicd.web.id/assets/2338b6d6-9adb-4f4d-8107-ee2c55a96f59',
        );
      },
    );

    test('ProductApi.toJson creates valid payload for Directus POST/PATCH', () {
      final product = ProductApi(
        id: 'new-uuid',
        name: 'Tes POSTMAN',
        price: 10000.0,
        quantity: 2,
        category: 'tes posman',
        description: 'posman',
      );

      final map = product.toJson();

      expect(map['name'], 'Tes POSTMAN');
      expect(map['price'], '10000');
      expect(map['quantity'], '2');
      expect(map['category'], 'tes posman');
      expect(map['description'], 'posman');
    });
  });
}
