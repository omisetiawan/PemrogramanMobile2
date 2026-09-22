import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/local_storage_service.dart';
import '../widgets/card_product.dart';
import 'form_product_screen.dart';

class ListProductScreen extends StatefulWidget {
  const ListProductScreen({super.key});

  @override
  State<ListProductScreen> createState() => _ListProductScreenState();
}

class _ListProductScreenState extends State<ListProductScreen> {
  final LocalStorageService _storageService = LocalStorageService();
  final TextEditingController _searchController = TextEditingController();

  // State Variables
  bool _isLoading = false;
  String? _errorMessage;
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadProductsFromStorage();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Memuat produk dengan penanganan State (Loading, Success, Error)
  Future<void> _loadProductsFromStorage() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Simulasi delay sedikit agar loading state terlihat jelas
      await Future.delayed(const Duration(milliseconds: 400));
      final products = await _storageService.loadProducts();

      setState(() {
        _allProducts = products;
        _applyFilter();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat data produk: $e';
        _isLoading = false;
      });
    }
  }

  /// Filter pencarian berdasarkan nama produk atau kategori
  void _applyFilter() {
    if (_searchQuery.trim().isEmpty) {
      _filteredProducts = List.from(_allProducts);
    } else {
      _filteredProducts = _allProducts.where((p) {
        final query = _searchQuery.toLowerCase();
        final matchName = p.name.toLowerCase().contains(query);
        final matchCategory = p.category.toLowerCase().contains(query);
        return matchName || matchCategory;
      }).toList();
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
      _applyFilter();
    });
  }

  /// Tambah produk baru
  Future<void> _navigateToAddProduct() async {
    final newProduct = await Navigator.push<Product>(
      context,
      MaterialPageRoute(builder: (context) => const FormProductScreen()),
    );

    if (newProduct != null) {
      setState(() {
        _allProducts.insert(0, newProduct);
        _applyFilter();
      });
      await _storageService.saveProducts(_allProducts);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Produk "${newProduct.name}" berhasil ditambahkan!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  /// Edit produk yang sudah ada
  Future<void> _navigateToEditProduct(Product product) async {
    final updatedProduct = await Navigator.push<Product>(
      context,
      MaterialPageRoute(
        builder: (context) => FormProductScreen(product: product),
      ),
    );

    if (updatedProduct != null) {
      setState(() {
        final index = _allProducts.indexWhere((p) => p.id == product.id);
        if (index != -1) {
          _allProducts[index] = updatedProduct;
          _applyFilter();
        }
      });
      await _storageService.saveProducts(_allProducts);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Produk "${updatedProduct.name}" berhasil diubah!'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    }
  }

  /// Hapus produk dengan dialog konfirmasi
  Future<void> _confirmDelete(Product product) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Produk'),
          content: Text('Apakah Anda yakin ingin menghapus "${product.name}"?'),
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
        );
      },
    );

    if (confirmed == true) {
      setState(() {
        _allProducts.removeWhere((p) => p.id == product.id);
        _applyFilter();
      });
      await _storageService.saveProducts(_allProducts);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Produk "${product.name}" berhasil dihapus!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Reset ke dummy data awal
  Future<void> _resetData() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Data'),
        content: const Text(
          'Kembalikan data produk ke daftar dummy bawaan praktikum?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _storageService.resetToDefault();
      _searchController.clear();
      _searchQuery = '';
      await _loadProductsFromStorage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Praktikum 2: Simple Inventory'),
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Opsi',
            onSelected: (val) {
              if (val == 'reset') {
                _resetData();
              } else if (val == 'refresh') {
                _loadProductsFromStorage();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'refresh',
                child: Row(
                  children: [
                    Icon(Icons.refresh, size: 20),
                    SizedBox(width: 8),
                    Text('Refresh Data'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'reset',
                child: Row(
                  children: [
                    Icon(Icons.restore, size: 20),
                    SizedBox(width: 8),
                    Text('Reset ke Data Dummy'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Product',
                hintText: 'Cari nama atau kategori...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: _onSearchChanged,
            ),
          ),

          // Content berdasarkan 4 State (Loading, Error, Empty, Success)
          Expanded(child: _buildBodyContent()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddProduct,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Produk'),
      ),
    );
  }

  Widget _buildBodyContent() {
    // 1. Loading State
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Memuat produk...'),
          ],
        ),
      );
    }

    // 2. Error State
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadProductsFromStorage,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    // 3. Empty State
    if (_filteredProducts.isEmpty) {
      final isSearching = _searchQuery.isNotEmpty;
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSearching ? Icons.search_off : Icons.inventory_2_outlined,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                isSearching
                    ? 'Tidak ada produk cocok dengan "$_searchQuery"'
                    : 'Belum ada data produk tersedia.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              if (isSearching)
                OutlinedButton(
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged('');
                  },
                  child: const Text('Hapus Pencarian'),
                )
              else
                ElevatedButton.icon(
                  onPressed: _navigateToAddProduct,
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Produk Sekarang'),
                ),
            ],
          ),
        ),
      );
    }

    // 4. Success State (List Product)
    return RefreshIndicator(
      onRefresh: _loadProductsFromStorage,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: _filteredProducts.length,
        itemBuilder: (context, index) {
          final product = _filteredProducts[index];
          return CardProduct(
            product: product,
            onEdit: () => _navigateToEditProduct(product),
            onDelete: () => _confirmDelete(product),
          );
        },
      ),
    );
  }
}
