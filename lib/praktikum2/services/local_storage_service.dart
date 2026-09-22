import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/dummy_product.dart';
import '../models/product_model.dart';

class LocalStorageService {
  static const String _productsKey = 'praktikum2_products';

  /// Memuat list produk dari SharedPreferences.
  /// Jika belum ada data tersimpan, gunakan dummyProducts sebagai data awal.
  Future<List<Product>> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? productsJsonString = prefs.getString(_productsKey);

    if (productsJsonString == null || productsJsonString.isEmpty) {
      // Data pertama kali: simpan dummyProducts ke storage
      await saveProducts(dummyProducts);
      return List.from(dummyProducts);
    }

    try {
      final List<dynamic> decodedList =
          jsonDecode(productsJsonString) as List<dynamic>;
      return decodedList
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Jika terjadi error parsing, kembalikan dummyProducts
      return List.from(dummyProducts);
    }
  }

  /// Menyimpan seluruh list produk ke SharedPreferences dalam bentuk JSON String.
  Future<bool> saveProducts(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> mapList = products
        .map((p) => p.toJson())
        .toList();
    final String jsonString = jsonEncode(mapList);
    return prefs.setString(_productsKey, jsonString);
  }

  /// Reset data kembali ke dummyProducts
  Future<void> resetToDefault() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_productsKey);
  }
}
