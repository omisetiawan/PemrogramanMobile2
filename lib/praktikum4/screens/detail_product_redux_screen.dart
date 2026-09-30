import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_application_pos_praktikum/praktikum3/models/product_api_model.dart';
import 'package:flutter_application_pos_praktikum/praktikum4/redux/app_state.dart';
import 'package:flutter_application_pos_praktikum/praktikum4/redux/product/product_thunks.dart';
import '../widgets/redux_badge.dart';
import 'form_product_redux_screen.dart';

class DetailProductReduxScreen extends StatelessWidget {
  final String productId;

  const DetailProductReduxScreen({super.key, required this.productId});

  void _confirmDelete(
    BuildContext context,
    ProductApi product,
    _DetailViewModel vm,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Produk (DELETE)'),
        content: Text(
          'Hapus "${product.name}"? Aksi ini akan men-dispatch deleteProductThunk() ke Redux Store.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      vm.onDelete(
        product.id,
        onSuccess: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Produk "${product.name}" berhasil dihapus dari Redux Store!',
              ),
              backgroundColor: Colors.red,
            ),
          );
          Navigator.pop(context);
        },
        onError: (err) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menghapus produk: $err'),
              backgroundColor: Colors.red,
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StoreConnector<AppState, _DetailViewModel>(
      converter: (store) => _DetailViewModel.fromStore(store, productId),
      builder: (context, vm) {
        final product = vm.product;

        if (product == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Detail Produk')),
            body: const Center(
              child: Text('Produk tidak ditemukan atau telah dihapus.'),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(product.name),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 12),
                child: Center(child: ReduxBadge(extraText: 'Reactive Item')),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Gambar Produk
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    height: 220,
                    color: Colors.deepPurple.shade50,
                    child: product.fullImageUrl != null
                        ? Image.network(
                            product.fullImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(
                                  child: Icon(
                                    Icons.broken_image_outlined,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                ),
                          )
                        : Center(
                            child: Icon(
                              Icons.inventory_2_outlined,
                              size: 80,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                // Card Informasi Produk
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                product.category,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                            Text(
                              'Stok: ${product.quantity} unit',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Rp ${product.formattedPrice}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple.shade700,
                          ),
                        ),
                        const Divider(height: 30),
                        const Text(
                          'Deskripsi:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          product.description.isNotEmpty
                              ? product.description
                              : 'Tidak ada deskripsi produk.',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Product ID: ${product.id}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Tombol Aksi Edit & Hapus
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FormProductReduxScreen(product: product),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text('Edit Produk'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: vm.isSubmitting
                            ? null
                            : () => _confirmDelete(context, product, vm),
                        icon: vm.isSubmitting
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.delete_outline),
                        label: const Text('Hapus Produk'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DetailViewModel {
  final ProductApi? product;
  final bool isSubmitting;
  final void Function(
    String id, {
    VoidCallback? onSuccess,
    void Function(String error)? onError,
  })
  onDelete;

  _DetailViewModel({
    required this.product,
    required this.isSubmitting,
    required this.onDelete,
  });

  factory _DetailViewModel.fromStore(Store<AppState> store, String productId) {
    ProductApi? foundProduct;
    try {
      foundProduct = store.state.productState.products.firstWhere(
        (p) => p.id == productId,
      );
    } catch (_) {
      foundProduct = null;
    }

    return _DetailViewModel(
      product: foundProduct,
      isSubmitting: store.state.productState.isSubmitting,
      onDelete: (id, {onSuccess, onError}) {
        store.dispatch(
          deleteProductThunk(id: id, onSuccess: onSuccess, onError: onError),
        );
      },
    );
  }
}
