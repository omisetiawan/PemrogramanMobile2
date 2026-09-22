import 'package:flutter/material.dart';
import '../models/product_api_model.dart';
import '../services/api_service.dart';
import '../widgets/card_product_api.dart';
import 'form_product_api_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  List<ProductApi> _products = [];
  List<ProductApi> _filteredProducts = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Mengambil data dari GET /items/products dengan Dio
  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _apiService.getProducts();
      setState(() {
        _products = data;
        _applySearch();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _applySearch() {
    if (_searchQuery.trim().isEmpty) {
      _filteredProducts = List.from(_products);
    } else {
      final q = _searchQuery.toLowerCase();
      _filteredProducts = _products.where((p) {
        final matchName = p.name.toLowerCase().contains(q);
        final matchCategory = p.category.toLowerCase().contains(q);
        final matchDesc = p.description.toLowerCase().contains(q);
        return matchName || matchCategory || matchDesc;
      }).toList();
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
      _applySearch();
    });
  }

  /// Navigasi ke Form Tambah (POST)
  Future<void> _navigateToAddProduct() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const FormProductApiScreen()),
    );

    if (result == true) {
      _fetchProducts();
    }
  }

  /// Navigasi ke Form Edit (PATCH)
  Future<void> _navigateToEditProduct(ProductApi product) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => FormProductApiScreen(product: product),
      ),
    );

    if (result == true) {
      _fetchProducts();
    }
  }

  /// Konfirmasi Hapus Produk (DELETE /items/products/:id)
  Future<void> _confirmDelete(ProductApi product) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Produk dari API'),
        content: Text(
          'Apakah Anda yakin ingin menghapus "${product.name}" dari database server?',
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

    if (confirmed == true) {
      try {
        await _apiService.deleteProduct(product.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Produk "${product.name}" berhasil dihapus!'),
              backgroundColor: Colors.red,
            ),
          );
        }
        _fetchProducts();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menghapus: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Produk (API)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Segarkan (Refresh)',
            onPressed: _fetchProducts,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_apiService.isDummyMode)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade300),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 18,
                    color: Colors.amber.shade800,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Mode Mock Aktif: Menggunakan data mock lokal (CRUD berfungsi penuh bebas CORS browser).',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.amber.shade900,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Search Field (Challenge Praktikum 3)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cari Produk API',
                hintText: 'Cari nama, kategori, deskripsi...',
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

          // Body Content (4 State UI)
          Expanded(child: _buildBodyContent()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddProduct,
        icon: const Icon(Icons.add),
        label: const Text('Tambah (POST)'),
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
            Text(
              'Mengambil data dari https://pos.cicd.web.id...',
              style: TextStyle(color: Colors.grey),
            ),
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
              const Icon(Icons.cloud_off, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Gagal Mengambil Data API',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _fetchProducts,
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
                    : 'Belum ada produk di database Directus.',
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
                  label: const Text('Tambah Produk Pertama'),
                ),
            ],
          ),
        ),
      );
    }

    // 4. Success State (Pull to refresh challenge implemented)
    return RefreshIndicator(
      onRefresh: _fetchProducts,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: _filteredProducts.length,
        itemBuilder: (context, index) {
          final product = _filteredProducts[index];
          return CardProductApi(
            product: product,
            onEdit: () => _navigateToEditProduct(product),
            onDelete: () => _confirmDelete(product),
          );
        },
      ),
    );
  }
}
