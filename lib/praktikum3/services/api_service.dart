import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_api_model.dart';

class ApiService {
  static const String baseUrl = 'https://pos.cicd.web.id';
  static const String _tokenKey = 'praktikum3_auth_token';
  static const String _userEmailKey = 'praktikum3_user_email';

  late final Dio _dio;
  String? _accessToken;
  String? _currentUserEmail;

  // Singleton instance
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Request & Error Interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_accessToken != null && _accessToken!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $_accessToken';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
    );
  }

  String? get currentEmail => _currentUserEmail;
  bool get isLoggedIn => _accessToken != null && _accessToken!.isNotEmpty;
  bool get isDummyMode => _accessToken == 'dummy_token_preview_only';

  static final List<ProductApi> _initialDummyProducts = [
    ProductApi(
      id: 'dummy-1',
      name: 'Kopi Espresso Robusta',
      category: 'Minuman',
      price: 18000,
      quantity: 25,
      description:
          'Espresso robusta mantap dengan aroma pekat dan crema tebal.',
      dateCreated: DateTime.now().toIso8601String(),
    ),
    ProductApi(
      id: 'dummy-2',
      name: 'Roti Bakar Keju Spesial',
      category: 'Makanan',
      price: 22000,
      quantity: 15,
      description: 'Roti bakar empuk isi keju lumer dan mentega gurih.',
      dateCreated: DateTime.now()
          .subtract(const Duration(hours: 2))
          .toIso8601String(),
    ),
    ProductApi(
      id: 'dummy-3',
      name: 'Matcha Green Tea Latte',
      category: 'Minuman',
      price: 25000,
      quantity: 30,
      description: 'Teh hijau Jepang asli berpadu dengan susu segar lembut.',
      dateCreated: DateTime.now()
          .subtract(const Duration(hours: 5))
          .toIso8601String(),
    ),
    ProductApi(
      id: 'dummy-4',
      name: 'Keripik Kentang Balado',
      category: 'Snack',
      price: 12000,
      quantity: 50,
      description:
          'Camilan keripik kentang gurih renyah dengan bumbu balado spesial.',
      dateCreated: DateTime.now()
          .subtract(const Duration(days: 1))
          .toIso8601String(),
    ),
  ];

  List<ProductApi> _dummyProducts = List.from(_initialDummyProducts);

  /// Inisialisasi token tersimpan dari SharedPreferences saat aplikasi dibuka
  Future<void> initSavedAuth() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString(_tokenKey);
    _currentUserEmail = prefs.getString(_userEmailKey);
  }

  /// Login ke BaaS Directus dengan email & password
  Future<bool> login({required String email, required String password}) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email.trim(), 'password': password.trim()},
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'];
        _accessToken = data['access_token']?.toString();
        _currentUserEmail = email.trim();

        // Simpan token ke SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        if (_accessToken != null) {
          await prefs.setString(_tokenKey, _accessToken!);
        }
        await prefs.setString(_userEmailKey, _currentUserEmail!);
        return true;
      }
      return false;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Dummy Login untuk pengujian tanpa server atau demonstrasi cepat
  Future<void> dummyLogin({String email = 'praktikum@gmail.com'}) async {
    _accessToken = 'dummy_token_preview_only';
    _currentUserEmail = email;
    _dummyProducts = List.from(_initialDummyProducts);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, _accessToken!);
    await prefs.setString(_userEmailKey, _currentUserEmail!);
  }

  /// Logout dan hapus token dari memori & storage
  Future<void> logout() async {
    _accessToken = null;
    _currentUserEmail = null;
    _dummyProducts = List.from(_initialDummyProducts);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userEmailKey);
  }

  /// GET /items/products — Mengambil daftar produk dari Directus
  Future<List<ProductApi>> getProducts({String? searchQuery}) async {
    // Jika dalam Mode Dummy, layani dengan data dummy lokal (bebas dari error 401 & CORS)
    if (isDummyMode) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final q = searchQuery.toLowerCase();
        return _dummyProducts.where((p) {
          final matchName = p.name.toLowerCase().contains(q);
          final matchCat = p.category.toLowerCase().contains(q);
          final matchDesc = p.description.toLowerCase().contains(q);
          return matchName || matchCat || matchDesc;
        }).toList();
      }
      return List.from(_dummyProducts);
    }

    try {
      final queryParams = <String, dynamic>{
        'sort': '-date_created', // Urutkan dari yang terbaru
      };

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        queryParams['search'] = searchQuery.trim();
      }

      final response = await _dio.get(
        '/items/products',
        queryParameters: queryParams,
      );

      if (response.data != null && response.data['data'] is List) {
        final List listData = response.data['data'];
        return listData
            .map((item) => ProductApi.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      return [];
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// POST /items/products — Menambahkan produk baru ke Directus
  Future<ProductApi> createProduct({
    required String name,
    required double price,
    required int quantity,
    required String category,
    required String description,
    String? imageUrl,
  }) async {
    if (isDummyMode) {
      await Future.delayed(const Duration(milliseconds: 200));
      final newProd = ProductApi(
        id: 'dummy-${DateTime.now().millisecondsSinceEpoch}',
        name: name.trim(),
        price: price,
        quantity: quantity,
        category: category.trim(),
        description: description.trim(),
        imageUrl: imageUrl?.trim(),
        dateCreated: DateTime.now().toIso8601String(),
      );
      _dummyProducts.insert(0, newProd);
      return newProd;
    }

    try {
      final payload = {
        'name': name.trim(),
        'price': price.toStringAsFixed(0),
        'quantity': quantity.toString(),
        'category': category.trim(),
        'description': description.trim(),
        if (imageUrl != null && imageUrl.trim().isNotEmpty)
          'image_url': imageUrl.trim(),
      };

      final response = await _dio.post('/items/products', data: payload);

      if (response.data != null && response.data['data'] != null) {
        return ProductApi.fromJson(
          response.data['data'] as Map<String, dynamic>,
        );
      }
      throw 'Gagal menambahkan produk (respons tidak valid)';
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// PATCH /items/products/:id — Mengubah data produk yang sudah ada
  Future<ProductApi> updateProduct({
    required String id,
    String? name,
    double? price,
    int? quantity,
    String? category,
    String? description,
    String? imageUrl,
  }) async {
    if (isDummyMode) {
      await Future.delayed(const Duration(milliseconds: 200));
      final idx = _dummyProducts.indexWhere((p) => p.id == id);
      if (idx != -1) {
        final old = _dummyProducts[idx];
        final updated = ProductApi(
          id: id,
          name: name?.trim() ?? old.name,
          price: price ?? old.price,
          quantity: quantity ?? old.quantity,
          category: category?.trim() ?? old.category,
          description: description?.trim() ?? old.description,
          imageUrl: imageUrl?.trim() ?? old.imageUrl,
          dateCreated: old.dateCreated,
        );
        _dummyProducts[idx] = updated;
        return updated;
      }
      throw 'Produk tidak ditemukan di data dummy';
    }

    try {
      final payload = <String, dynamic>{};
      if (name != null) payload['name'] = name.trim();
      if (price != null) payload['price'] = price.toStringAsFixed(0);
      if (quantity != null) payload['quantity'] = quantity.toString();
      if (category != null) payload['category'] = category.trim();
      if (description != null) payload['description'] = description.trim();
      if (imageUrl != null) payload['image_url'] = imageUrl.trim();

      final response = await _dio.patch('/items/products/$id', data: payload);

      if (response.data != null && response.data['data'] != null) {
        return ProductApi.fromJson(
          response.data['data'] as Map<String, dynamic>,
        );
      }
      throw 'Gagal memperbarui produk';
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// DELETE /items/products/:id — Menghapus produk dari Directus
  Future<bool> deleteProduct(String id) async {
    if (isDummyMode) {
      await Future.delayed(const Duration(milliseconds: 200));
      _dummyProducts.removeWhere((p) => p.id == id);
      return true;
    }

    try {
      final response = await _dio.delete('/items/products/$id');
      return response.statusCode == 200 || response.statusCode == 204;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Penanganan Error ramah mahasiswa sesuai materi praktikum
  String _handleDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return 'Koneksi batas waktu habis (Timeout). Periksa koneksi internet Anda.';
    }

    if (error.error is SocketException) {
      return 'Gagal terhubung ke server pos.cicd.web.id. Pastikan perangkat online.';
    }

    final statusCode = error.response?.statusCode;
    if (statusCode != null) {
      switch (statusCode) {
        case 400:
          return 'Error 400: Permintaan tidak valid (Bad Request).';
        case 401:
          return 'Error 401: Unauthorized. Email atau password salah, atau token kadaluarsa.';
        case 403:
          return 'Error 403: Forbidden. Anda tidak memiliki izin mengakses resource ini.';
        case 404:
          return 'Error 404: Data produk tidak ditemukan di server.';
        case 500:
          return 'Error 500: Server error pada BaaS Directus.';
        default:
          return 'Error HTTP $statusCode: ${error.response?.statusMessage ?? "Terjadi kesalahan"}';
      }
    }

    final rawMsg = error.message ?? '';
    final msgLower = rawMsg.toLowerCase();
    if (msgLower.contains('xmlhttprequest') ||
        msgLower.contains('cross-origin') ||
        msgLower.contains('cors')) {
      return 'CORS terblokir oleh Browser Chrome! Jalankan di Android Emulator/HP Fisik/Windows (tanpa CORS), atau gunakan tombol "Dummy Login" untuk preview web.';
    }

    return rawMsg.isNotEmpty ? rawMsg : 'Terjadi kesalahan pada jaringan.';
  }
}
