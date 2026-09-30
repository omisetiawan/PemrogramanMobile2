import 'package:flutter_application_pos_praktikum/praktikum3/models/product_api_model.dart';

enum ProductListStatus { initial, loading, success, empty, error }

class ProductState {
  final ProductListStatus status;
  final List<ProductApi> products;
  final String searchQuery;
  final String? errorMessage;
  final bool isSubmitting;

  const ProductState({
    required this.status,
    required this.products,
    this.searchQuery = '',
    this.errorMessage,
    this.isSubmitting = false,
  });

  factory ProductState.initial() => const ProductState(
    status: ProductListStatus.initial,
    products: [],
    searchQuery: '',
    errorMessage: null,
    isSubmitting: false,
  );

  List<ProductApi> get filteredProducts {
    if (searchQuery.trim().isEmpty) return products;
    final q = searchQuery.toLowerCase();
    return products.where((p) {
      final mName = p.name.toLowerCase().contains(q);
      final mCat = p.category.toLowerCase().contains(q);
      final mDesc = p.description.toLowerCase().contains(q);
      return mName || mCat || mDesc;
    }).toList();
  }

  ProductState copyWith({
    ProductListStatus? status,
    List<ProductApi>? products,
    String? searchQuery,
    String? errorMessage,
    bool? isSubmitting,
    bool clearError = false,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductState &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          products == other.products &&
          searchQuery == other.searchQuery &&
          errorMessage == other.errorMessage &&
          isSubmitting == other.isSubmitting;

  @override
  int get hashCode =>
      status.hashCode ^
      products.hashCode ^
      searchQuery.hashCode ^
      errorMessage.hashCode ^
      isSubmitting.hashCode;
}
