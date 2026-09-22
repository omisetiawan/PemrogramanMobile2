import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/product_api_model.dart';

class DetailProductApiScreen extends StatelessWidget {
  final ProductApi product;

  const DetailProductApiScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl = product.fullImageUrl;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Produk (API)')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gambar Produk dari Directus Assets
            if (imageUrl != null)
              Container(
                height: 220,
                width: double.infinity,
                color: Colors.grey.shade100,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: progress.expectedTotalBytes != null
                            ? progress.cumulativeBytesLoaded /
                                  progress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image,
                            size: 48,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Text('Gambar gagal dimuat dari server'),
                        ],
                      ),
                    );
                  },
                ),
              )
            else
              Container(
                height: 140,
                color: theme.colorScheme.primaryContainer.withValues(
                  alpha: 0.4,
                ),
                child: Center(
                  child: Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),

            // Konten Detail
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          product.category,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Rp ${product.price.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  _buildDetailRow(
                    icon: Icons.numbers,
                    title: 'Stok (Quantity)',
                    value: '${product.quantity} unit',
                  ),
                  _buildDetailRow(
                    icon: Icons.fingerprint,
                    title: 'UUID Produk (Directus)',
                    value: product.id,
                    isCopyable: true,
                    context: context,
                  ),
                  if (product.imageUrl != null && product.imageUrl!.isNotEmpty)
                    _buildDetailRow(
                      icon: Icons.image_outlined,
                      title: 'Asset ID Directus',
                      value: product.imageUrl!,
                    ),
                  if (product.dateCreated != null)
                    _buildDetailRow(
                      icon: Icons.calendar_today_outlined,
                      title: 'Tanggal Dibuat',
                      value: product.dateCreated!,
                    ),
                  const SizedBox(height: 16),
                  Text(
                    'Deskripsi Produk',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      product.description.isEmpty
                          ? 'Tidak ada deskripsi yang tersedia.'
                          : product.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade800,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
    bool isCopyable = false,
    BuildContext? context,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: Colors.grey.shade600),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (isCopyable && context != null)
            IconButton(
              icon: const Icon(Icons.copy, size: 18),
              tooltip: 'Salin UUID',
              onPressed: () {
                Clipboard.setData(ClipboardData(text: value));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('UUID disalin ke clipboard!'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
