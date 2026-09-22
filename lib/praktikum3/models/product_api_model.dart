class ProductApi {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String category;
  final String description;
  final String? imageUrl;
  final String? dateCreated;

  ProductApi({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    this.category = 'Umum',
    this.description = '',
    this.imageUrl,
    this.dateCreated,
  });

  /// Base URL untuk assets Directus
  static const String assetBaseUrl = 'https://pos.cicd.web.id/assets';

  /// Helper untuk mendapatkan URL gambar lengkap dari ID asset
  String? get fullImageUrl {
    if (imageUrl == null || imageUrl!.trim().isEmpty) return null;
    if (imageUrl!.startsWith('http')) return imageUrl;
    return '$assetBaseUrl/$imageUrl';
  }

  /// Deserialisasi dari JSON response Directus
  factory ProductApi.fromJson(Map<String, dynamic> json) {
    // Parsing harga (bisa berupa num atau string)
    double parsedPrice = 0.0;
    if (json['price'] is num) {
      parsedPrice = (json['price'] as num).toDouble();
    } else if (json['price'] != null) {
      parsedPrice = double.tryParse(json['price'].toString()) ?? 0.0;
    }

    // Parsing kuantitas/stok (bisa berupa null, int, atau string)
    int parsedQuantity = 0;
    if (json['quantity'] is num) {
      parsedQuantity = (json['quantity'] as num).toInt();
    } else if (json['quantity'] != null) {
      parsedQuantity = int.tryParse(json['quantity'].toString()) ?? 0;
    }

    return ProductApi(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      price: parsedPrice,
      quantity: parsedQuantity,
      category: json['category']?.toString() ?? 'Umum',
      description: json['description']?.toString() ?? '',
      imageUrl: json['image_url']?.toString(),
      dateCreated: json['date_created']?.toString(),
    );
  }

  /// Serialisasi ke Map untuk dikirim ke API Directus (POST / PATCH)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price.toStringAsFixed(0),
      'quantity': quantity.toString(),
      'category': category,
      'description': description,
      if (imageUrl != null && imageUrl!.isNotEmpty) 'image_url': imageUrl,
    };
  }

  ProductApi copyWith({
    String? id,
    String? name,
    double? price,
    int? quantity,
    String? category,
    String? description,
    String? imageUrl,
    String? dateCreated,
  }) {
    return ProductApi(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }
}
