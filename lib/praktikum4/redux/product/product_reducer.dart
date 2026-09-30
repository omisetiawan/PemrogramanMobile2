import 'package:flutter_application_pos_praktikum/praktikum3/models/product_api_model.dart';
import 'product_actions.dart';
import 'product_state.dart';

ProductState productReducer(ProductState state, dynamic action) {
  if (action is FetchProductsRequestAction) {
    return state.copyWith(status: ProductListStatus.loading, clearError: true);
  }

  if (action is FetchProductsSuccessAction) {
    return state.copyWith(
      status: action.products.isEmpty
          ? ProductListStatus.empty
          : ProductListStatus.success,
      products: action.products,
      clearError: true,
    );
  }

  if (action is FetchProductsFailureAction) {
    return state.copyWith(
      status: ProductListStatus.error,
      errorMessage: action.error,
    );
  }

  if (action is SearchProductAction) {
    return state.copyWith(searchQuery: action.query);
  }

  if (action is SetProductSubmittingAction) {
    return state.copyWith(isSubmitting: action.isSubmitting);
  }

  if (action is ProductCreatedAction) {
    final updatedList = List<ProductApi>.from(state.products)
      ..insert(0, action.product);
    return state.copyWith(
      products: updatedList,
      status: ProductListStatus.success,
    );
  }

  if (action is ProductUpdatedAction) {
    final updatedList = state.products.map((p) {
      return p.id == action.product.id ? action.product : p;
    }).toList();
    return state.copyWith(
      products: updatedList,
      status: ProductListStatus.success,
    );
  }

  if (action is ProductDeletedAction) {
    final updatedList = state.products
        .where((p) => p.id != action.productId)
        .toList();
    return state.copyWith(
      products: updatedList,
      status: updatedList.isEmpty
          ? ProductListStatus.empty
          : ProductListStatus.success,
    );
  }

  if (action is ClearProductErrorAction) {
    return state.copyWith(clearError: true);
  }

  return state;
}
