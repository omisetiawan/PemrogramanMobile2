import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_application_pos_praktikum/praktikum3/models/product_api_model.dart';
import 'package:flutter_application_pos_praktikum/praktikum4/redux/app_state.dart';
import 'package:flutter_application_pos_praktikum/praktikum4/redux/product/product_actions.dart';
import 'package:flutter_application_pos_praktikum/praktikum4/redux/product/product_state.dart';
import 'package:flutter_application_pos_praktikum/praktikum4/redux/product/product_thunks.dart';
import '../widgets/card_product_redux.dart';
import '../widgets/redux_badge.dart';
import 'detail_product_redux_screen.dart';
import 'form_product_redux_screen.dart';

class ProductListReduxScreen extends StatefulWidget {
  const ProductListReduxScreen({super.key});

  @override
  State<ProductListReduxScreen> createState() => _ProductListReduxScreenState();
}

class _ProductListReduxScreenState extends State<ProductListReduxScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _confirmDelete(
    BuildContext context,
    ProductApi product,
    _ProductListViewModel vm,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Produk (DELETE)'),
        content: Text(
          'Apakah Anda yakin ingin menghapus "${product.name}"? Perubahan akan langsung disinkronkan ke Redux Store.',
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
            child: const Text('Hapus (DELETE)'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      vm.onDeleteProduct(
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
    return StoreConnector<AppState, _ProductListViewModel>(
      onInit: (store) {
        if (store.state.productState.status == ProductListStatus.initial) {
          store.dispatch(fetchProductsThunk());
        }
      },
      converter: (store) => _ProductListViewModel.fromStore(store),
      builder: (context, vm) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Katalog Redux'),
            actions: [
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Center(child: ReduxBadge(extraText: 'Reactive UI')),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Segarkan State (fetchProductsThunk)',
                onPressed: vm.onRefresh,
              ),
            ],
          ),
          body: Column(
            children: [
              // Search Input connected directly to Redux Action
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Cari Produk (Redux Search)',
                    hintText: 'Cari nama, kategori, deskripsi...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: vm.searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              vm.onSearchChanged('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onChanged: vm.onSearchChanged,
                ),
              ),

              // Status Bar Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Menampilkan ${vm.products.length} dari ${vm.totalRawProducts} item',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (vm.isDummyMode)
                      Text(
                        'Mode Mock',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.amber.shade900,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),

              // 4 States Body Content
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    vm.onRefresh();
                  },
                  child: _buildContent(context, vm),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FormProductReduxScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Tambah (POST Redux)'),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, _ProductListViewModel vm) {
    // 1. Loading State
    if (vm.status == ProductListStatus.loading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Mengambil data via Redux Thunk...',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // 2. Error State
    if (vm.status == ProductListStatus.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off_rounded, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Gagal Mengambil Data di Redux Store',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                vm.errorMessage ?? 'Terjadi kesalahan tidak diketahui',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: vm.onRefresh,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi (Dispatch Thunk)'),
              ),
            ],
          ),
        ),
      );
    }

    // 3. Empty State
    if (vm.status == ProductListStatus.empty || vm.totalRawProducts == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            const Text(
              'Belum Ada Produk di Redux Store',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tambahkan produk pertama menggunakan tombol di bawah.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FormProductReduxScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Tambah Produk Baru'),
            ),
          ],
        ),
      );
    }

    // Pencarian tidak menemukan hasil
    if (vm.products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 54, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              'Tidak ditemukan produk dengan kata "${vm.searchQuery}"',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // 4. Success State (List Products)
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: vm.products.length,
      itemBuilder: (context, index) {
        final product = vm.products[index];
        return CardProductRedux(
          product: product,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DetailProductReduxScreen(productId: product.id),
              ),
            );
          },
          onEdit: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FormProductReduxScreen(product: product),
              ),
            );
          },
          onDelete: () => _confirmDelete(context, product, vm),
        );
      },
    );
  }
}

class _ProductListViewModel {
  final ProductListStatus status;
  final List<ProductApi> products;
  final int totalRawProducts;
  final String searchQuery;
  final String? errorMessage;
  final bool isDummyMode;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onRefresh;
  final void Function(
    String id, {
    VoidCallback? onSuccess,
    void Function(String error)? onError,
  })
  onDeleteProduct;

  _ProductListViewModel({
    required this.status,
    required this.products,
    required this.totalRawProducts,
    required this.searchQuery,
    this.errorMessage,
    required this.isDummyMode,
    required this.onSearchChanged,
    required this.onRefresh,
    required this.onDeleteProduct,
  });

  factory _ProductListViewModel.fromStore(Store<AppState> store) {
    return _ProductListViewModel(
      status: store.state.productState.status,
      products: store.state.productState.filteredProducts,
      totalRawProducts: store.state.productState.products.length,
      searchQuery: store.state.productState.searchQuery,
      errorMessage: store.state.productState.errorMessage,
      isDummyMode: store.state.authState.isDummyMode,
      onSearchChanged: (query) {
        store.dispatch(SearchProductAction(query));
      },
      onRefresh: () {
        store.dispatch(fetchProductsThunk());
      },
      onDeleteProduct: (id, {onSuccess, onError}) {
        store.dispatch(
          deleteProductThunk(id: id, onSuccess: onSuccess, onError: onError),
        );
      },
    );
  }
}
