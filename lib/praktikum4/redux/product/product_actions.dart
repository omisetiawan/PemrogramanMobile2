import 'package:flutter_application_pos_praktikum/praktikum3/models/product_api_model.dart';

class FetchProductsRequestAction {}

class FetchProductsSuccessAction {
  final List<ProductApi> products;
  FetchProductsSuccessAction(this.products);
}

class FetchProductsFailureAction {
  final String error;
  FetchProductsFailureAction(this.error);
}

class SearchProductAction {
  final String query;
  SearchProductAction(this.query);
}

class SetProductSubmittingAction {
  final bool isSubmitting;
  SetProductSubmittingAction(this.isSubmitting);
}

class ProductCreatedAction {
  final ProductApi product;
  ProductCreatedAction(this.product);
}

class ProductUpdatedAction {
  final ProductApi product;
  ProductUpdatedAction(this.product);
}

class ProductDeletedAction {
  final String productId;
  ProductDeletedAction(this.productId);
}

class ClearProductErrorAction {}
