class Product {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String description;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    this.description = '',
    this.category = 'Umum',
  });

  /// Factory constructor to deserialize JSON into Product object
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      price: (json['price'] is num)
          ? (json['price'] as num).toDouble()
          : double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      quantity: (json['quantity'] is int)
          ? json['quantity'] as int
          : int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? 'Umum',
    );
  }

  /// Convert Product object into JSON Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'description': description,
      'category': category,
    };
  }

  /// Helper copyWith for easy editing
  Product copyWith({
    String? id,
    String? name,
    double? price,
    int? quantity,
    String? description,
    String? category,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      description: description ?? this.description,
      category: category ?? this.category,
    );
  }
}
