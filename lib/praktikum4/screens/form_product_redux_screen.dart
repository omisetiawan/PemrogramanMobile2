import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_application_pos_praktikum/praktikum3/models/product_api_model.dart';
import 'package:flutter_application_pos_praktikum/praktikum4/redux/app_state.dart';
import 'package:flutter_application_pos_praktikum/praktikum4/redux/product/product_thunks.dart';
import '../widgets/redux_badge.dart';

class FormProductReduxScreen extends StatefulWidget {
  final ProductApi? product; // null = POST baru, not null = PATCH/Edit

  const FormProductReduxScreen({super.key, this.product});

  bool get isEdit => product != null;

  @override
  State<FormProductReduxScreen> createState() => _FormProductReduxScreenState();
}

class _FormProductReduxScreenState extends State<FormProductReduxScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _quantityController;
  late final TextEditingController _descController;
  late final TextEditingController _imageUrlController;
  late String _selectedCategory;

  final List<String> _categories = [
    'Makanan',
    'Minuman',
    'Snack',
    'Elektronik',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _priceController = TextEditingController(
      text: widget.product != null
          ? widget.product!.price.toStringAsFixed(0)
          : '',
    );
    _quantityController = TextEditingController(
      text: widget.product != null ? widget.product!.quantity.toString() : '1',
    );
    _descController = TextEditingController(
      text: widget.product?.description ?? '',
    );
    _imageUrlController = TextEditingController(
      text: widget.product?.imageUrl ?? '',
    );

    if (widget.product != null &&
        _categories.contains(widget.product!.category)) {
      _selectedCategory = widget.product!.category;
    } else {
      _selectedCategory = 'Makanan';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _descController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context, _FormProductViewModel vm) {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim()) ?? 0;
    final quantity = int.tryParse(_quantityController.text.trim()) ?? 1;
    final description = _descController.text.trim();
    final imageUrl = _imageUrlController.text.trim().isEmpty
        ? null
        : _imageUrlController.text.trim();

    if (widget.isEdit) {
      vm.onUpdate(
        id: widget.product!.id,
        name: name,
        price: price,
        quantity: quantity,
        category: _selectedCategory,
        description: description,
        imageUrl: imageUrl,
        onSuccess: (updated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Redux State & Directus Updated: "${updated.name}" berhasil diubah!',
              ),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        },
        onError: (err) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal mengubah produk: $err'),
              backgroundColor: Colors.red,
            ),
          );
        },
      );
    } else {
      vm.onCreate(
        name: name,
        price: price,
        quantity: quantity,
        category: _selectedCategory,
        description: description,
        imageUrl: imageUrl,
        onSuccess: (created) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Redux State & Directus Updated: "${created.name}" berhasil ditambahkan!',
              ),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        },
        onError: (err) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menambah produk: $err'),
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

    return StoreConnector<AppState, _FormProductViewModel>(
      converter: (store) => _FormProductViewModel.fromStore(store),
      builder: (context, vm) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.isEdit
                  ? 'Edit Produk (Redux Thunk)'
                  : 'Tambah Produk (Redux Thunk)',
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 12),
                child: Center(child: ReduxBadge(extraText: 'Thunk Action')),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Subtitle Banner
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.deepPurple.shade100),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.flash_on,
                              color: Colors.deepPurple,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.isEdit
                                    ? 'Aksi akan men-dispatch updateProductThunk() ke Redux Store.'
                                    : 'Aksi akan men-dispatch createProductThunk() ke Redux Store.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.deepPurple.shade900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Nama Produk
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nama Produk *',
                          prefixIcon: Icon(Icons.shopping_bag_outlined),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Nama produk wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // Kategori Dropdown
                      DropdownButtonFormField<String>(
                        initialValue: _selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Kategori *',
                          prefixIcon: Icon(Icons.category_outlined),
                          border: OutlineInputBorder(),
                        ),
                        items: _categories.map((cat) {
                          return DropdownMenuItem(value: cat, child: Text(cat));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedCategory = val;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      // Harga & Stok Row
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              controller: _priceController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Harga (Rp) *',
                                prefixIcon: Icon(Icons.attach_money),
                                border: OutlineInputBorder(),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Harga wajib diisi';
                                }
                                if (double.tryParse(val) == null) {
                                  return 'Angka tidak valid';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _quantityController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Stok *',
                                prefixIcon: Icon(Icons.numbers),
                                border: OutlineInputBorder(),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Stok wajib';
                                }
                                if (int.tryParse(val) == null) {
                                  return 'Harus bulat';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Image URL / Directus Asset ID
                      TextFormField(
                        controller: _imageUrlController,
                        decoration: const InputDecoration(
                          labelText: 'URL Gambar / Directus File ID',
                          hintText: 'Opsional (https://... atau UUID)',
                          prefixIcon: Icon(Icons.image_outlined),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Deskripsi
                      TextFormField(
                        controller: _descController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Deskripsi Produk',
                          alignLabelWithHint: true,
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(bottom: 45),
                            child: Icon(Icons.description_outlined),
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Tombol Simpan (Dispatch Action)
                      ElevatedButton.icon(
                        onPressed: vm.isSubmitting
                            ? null
                            : () => _submit(context, vm),
                        icon: vm.isSubmitting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Icon(
                                widget.isEdit ? Icons.save : Icons.add_circle,
                              ),
                        label: Text(
                          vm.isSubmitting
                              ? 'Menyimpan ke Redux Store...'
                              : (widget.isEdit
                                    ? 'Perbarui Produk (PATCH)'
                                    : 'Simpan Produk (POST)'),
                          style: const TextStyle(
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
            ),
          ),
        );
      },
    );
  }
}

class _FormProductViewModel {
  final bool isSubmitting;
  final void Function({
    required String name,
    required double price,
    required int quantity,
    required String category,
    required String description,
    String? imageUrl,
    void Function(ProductApi product)? onSuccess,
    void Function(String error)? onError,
  })
  onCreate;

  final void Function({
    required String id,
    String? name,
    double? price,
    int? quantity,
    String? category,
    String? description,
    String? imageUrl,
    void Function(ProductApi product)? onSuccess,
    void Function(String error)? onError,
  })
  onUpdate;

  _FormProductViewModel({
    required this.isSubmitting,
    required this.onCreate,
    required this.onUpdate,
  });

  factory _FormProductViewModel.fromStore(Store<AppState> store) {
    return _FormProductViewModel(
      isSubmitting: store.state.productState.isSubmitting,
      onCreate:
          ({
            required name,
            required price,
            required quantity,
            required category,
            required description,
            imageUrl,
            onSuccess,
            onError,
          }) {
            store.dispatch(
              createProductThunk(
                name: name,
                price: price,
                quantity: quantity,
                category: category,
                description: description,
                imageUrl: imageUrl,
                onSuccess: onSuccess,
                onError: onError,
              ),
            );
          },
      onUpdate:
          ({
            required id,
            name,
            price,
            quantity,
            category,
            description,
            imageUrl,
            onSuccess,
            onError,
          }) {
            store.dispatch(
              updateProductThunk(
                id: id,
                name: name,
                price: price,
                quantity: quantity,
                category: category,
                description: description,
                imageUrl: imageUrl,
                onSuccess: onSuccess,
                onError: onError,
              ),
            );
          },
    );
  }
}
