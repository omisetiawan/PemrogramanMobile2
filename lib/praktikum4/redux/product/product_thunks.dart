import 'package:flutter/foundation.dart';
import 'package:flutter_application_pos_praktikum/praktikum3/models/product_api_model.dart';
import 'package:flutter_application_pos_praktikum/praktikum3/services/api_service.dart';
import 'package:flutter_application_pos_praktikum/praktikum4/redux/app_state.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'product_actions.dart';

/// Thunk untuk mengambil daftar produk dari API Directus atau data mock
ThunkAction<AppState> fetchProductsThunk({String? searchQuery}) {
  return (Store<AppState> store) async {
    store.dispatch(FetchProductsRequestAction());
    try {
      final apiService = ApiService();
      final products = await apiService.getProducts(searchQuery: searchQuery);
      store.dispatch(FetchProductsSuccessAction(products));
    } catch (e) {
      store.dispatch(FetchProductsFailureAction(e.toString()));
    }
  };
}

/// Thunk untuk menambah produk baru (POST /items/products)
ThunkAction<AppState> createProductThunk({
  required String name,
  required double price,
  required int quantity,
  required String category,
  required String description,
  String? imageUrl,
  void Function(ProductApi product)? onSuccess,
  void Function(String error)? onError,
}) {
  return (Store<AppState> store) async {
    store.dispatch(SetProductSubmittingAction(true));
    try {
      final apiService = ApiService();
      final newProduct = await apiService.createProduct(
        name: name,
        price: price,
        quantity: quantity,
        category: category,
        description: description,
        imageUrl: imageUrl,
      );
      store.dispatch(ProductCreatedAction(newProduct));
      store.dispatch(SetProductSubmittingAction(false));
      onSuccess?.call(newProduct);
    } catch (e) {
      store.dispatch(SetProductSubmittingAction(false));
      onError?.call(e.toString());
    }
  };
}

/// Thunk untuk mengubah data produk (PATCH /items/products/:id)
ThunkAction<AppState> updateProductThunk({
  required String id,
  String? name,
  double? price,
  int? quantity,
  String? category,
  String? description,
  String? imageUrl,
  void Function(ProductApi product)? onSuccess,
  void Function(String error)? onError,
}) {
  return (Store<AppState> store) async {
    store.dispatch(SetProductSubmittingAction(true));
    try {
      final apiService = ApiService();
      final updatedProduct = await apiService.updateProduct(
        id: id,
        name: name,
        price: price,
        quantity: quantity,
        category: category,
        description: description,
        imageUrl: imageUrl,
      );
      store.dispatch(ProductUpdatedAction(updatedProduct));
      store.dispatch(SetProductSubmittingAction(false));
      onSuccess?.call(updatedProduct);
    } catch (e) {
      store.dispatch(SetProductSubmittingAction(false));
      onError?.call(e.toString());
    }
  };
}

/// Thunk untuk menghapus produk (DELETE /items/products/:id)
ThunkAction<AppState> deleteProductThunk({
  required String id,
  VoidCallback? onSuccess,
  void Function(String error)? onError,
}) {
  return (Store<AppState> store) async {
    store.dispatch(SetProductSubmittingAction(true));
    try {
      final apiService = ApiService();
      final success = await apiService.deleteProduct(id);
      if (success) {
        store.dispatch(ProductDeletedAction(id));
        store.dispatch(SetProductSubmittingAction(false));
        onSuccess?.call();
      } else {
        throw 'Gagal menghapus produk dari server.';
      }
    } catch (e) {
      store.dispatch(SetProductSubmittingAction(false));
      onError?.call(e.toString());
    }
  };
}
