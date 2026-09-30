import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_application_pos_praktikum/praktikum4/redux/app_state.dart';
import 'package:flutter_application_pos_praktikum/praktikum4/redux/auth/auth_thunks.dart';
import 'package:flutter_application_pos_praktikum/praktikum4/redux/product/product_state.dart';
import 'package:flutter_application_pos_praktikum/praktikum4/redux/product/product_thunks.dart';
import 'product_list_redux_screen.dart';

class DashboardReduxScreen extends StatelessWidget {
  const DashboardReduxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StoreConnector<AppState, _DashboardViewModel>(
      onInit: (store) {
        // Jika produk masih kosong atau initial, fetch otomatis
        if (store.state.productState.status == ProductListStatus.initial) {
          store.dispatch(fetchProductsThunk());
        }
      },
      converter: (store) => _DashboardViewModel.fromStore(
        store,
        onLoggedOut: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Anda telah logout dari Redux Store.'),
              duration: Duration(seconds: 1),
            ),
          );
        },
      ),
      builder: (context, vm) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Dashboard Redux'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Logout Redux',
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Konfirmasi Logout'),
                      content: const Text(
                        'Apakah Anda yakin ingin keluar dan mereset auth state di Redux Store?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Batal'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true) {
                    vm.onLogout();
                  }
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              vm.onRefresh();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // User Profile Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.tertiary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.3,
                          ),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 36,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Selamat Datang,',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                vm.userEmail,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  vm.isDummyMode
                                      ? 'Redux Mode: Mock / Preview'
                                      : 'Redux Mode: Directus BaaS Live',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Redux Architecture Banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.deepPurple.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.hub_outlined, color: Colors.deepPurple),
                            SizedBox(width: 8),
                            Text(
                              'Arsitektur Redux Aktif',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Data di layar ini bersumber dari Redux Store (Single Source of Truth), '
                          'tanpa redundant HTTP call berkat sinkronisasi state terpusat.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.deepPurple.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Metrics Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          title: 'Total Produk (Store)',
                          value: vm.isLoadingProducts
                              ? '...'
                              : (vm.hasError
                                    ? '!'
                                    : '${vm.totalProducts} item'),
                          icon: Icons.inventory_2_outlined,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMetricCard(
                          title: 'Status Store',
                          value: vm.isDummyMode
                              ? 'Mock State'
                              : (vm.hasError ? 'Error Sync' : 'Synced (OK)'),
                          icon: vm.hasError
                              ? Icons.warning_amber_rounded
                              : Icons.check_circle_outline,
                          color: vm.hasError ? Colors.red : Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Server & Redux Technical Info
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.settings_suggest_outlined,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Konfigurasi Redux Praktikum 4',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          _buildInfoRow(
                            'State Container',
                            'Redux Store<AppState>',
                          ),
                          _buildInfoRow(
                            'Async Middleware',
                            'Redux Thunk (Dio Client)',
                          ),
                          _buildInfoRow(
                            'UI Connector',
                            'StoreConnector<AppState, VM>',
                          ),
                          _buildInfoRow(
                            'Base API URL',
                            'https://pos.cicd.web.id',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // CTA Button to Product Catalog
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProductListReduxScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.shopping_bag_outlined),
                    label: const Text(
                      'Buka Katalog Produk (Redux CRUD)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _DashboardViewModel {
  final String userEmail;
  final bool isDummyMode;
  final int totalProducts;
  final bool isLoadingProducts;
  final bool hasError;
  final VoidCallback onRefresh;
  final VoidCallback onLogout;

  _DashboardViewModel({
    required this.userEmail,
    required this.isDummyMode,
    required this.totalProducts,
    required this.isLoadingProducts,
    required this.hasError,
    required this.onRefresh,
    required this.onLogout,
  });

  factory _DashboardViewModel.fromStore(
    Store<AppState> store, {
    required VoidCallback onLoggedOut,
  }) {
    return _DashboardViewModel(
      userEmail: store.state.authState.userEmail ?? 'praktikum@gmail.com',
      isDummyMode: store.state.authState.isDummyMode,
      totalProducts: store.state.productState.products.length,
      isLoadingProducts:
          store.state.productState.status == ProductListStatus.loading,
      hasError: store.state.productState.status == ProductListStatus.error,
      onRefresh: () {
        store.dispatch(fetchProductsThunk());
      },
      onLogout: () {
        store.dispatch(logoutThunk(onLoggedOut: onLoggedOut));
      },
    );
  }
}
