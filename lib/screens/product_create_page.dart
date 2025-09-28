import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductCreatePage extends StatefulWidget {
  final List<String> categories;
  final void Function(Product) onCreate;

  const ProductCreatePage({
    super.key,
    required this.categories,
    required this.onCreate,
  });

  @override
  State<ProductCreatePage> createState() => _ProductCreatePageState();
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _brandController;
  late TextEditingController _priceController;
  late TextEditingController _discountController;
  late TextEditingController _stockController;
  late TextEditingController _weightController;
  late TextEditingController _imageController;
  late TextEditingController _barcodeController;
  late TextEditingController _qrController;
  late String _selectedCategory;

  static const int maxTitleLength = 40;
  static const int maxDescriptionLength = 200;
  static const int maxBrandLength = 30;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _brandController = TextEditingController();
    _priceController = TextEditingController();
    _discountController = TextEditingController();
    _stockController = TextEditingController();
    _weightController = TextEditingController();
    _imageController = TextEditingController();
    _barcodeController = TextEditingController();
    _qrController = TextEditingController();
    _selectedCategory = widget.categories.isNotEmpty
        ? widget.categories.first
        : '';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _stockController.dispose();
    _weightController.dispose();
    _imageController.dispose();
    _barcodeController.dispose();
    _qrController.dispose();
    super.dispose();
  }

  void _create() {
    if (_formKey.currentState?.validate() != true) return;
    final price = double.tryParse(_priceController.text) ?? 0;
    final discount = double.tryParse(_discountController.text) ?? 0;
    final stock = int.tryParse(_stockController.text) ?? 0;
    final weight = double.tryParse(_weightController.text) ?? 0;
    final estado = stock > 0 ? "In Stock" : "Out of Stock";
    final now = DateTime.now();

    final product = Product(
      id: 0,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory,
      price: price,
      discountPercentage: discount,
      rating: 0,
      stock: stock,
      tags: [],
      brand: _brandController.text.trim(),
      sku: '',
      weight: weight,
      dimensions: Dimensions(width: 0, height: 0, depth: 0),
      warrantyInformation: '',
      shippingInformation: '',
      availabilityStatus: estado,
      reviews: [],
      returnPolicy: '',
      minimumOrderQuantity: 1,
      meta: Meta(
        createdAt: now,
        updatedAt: now,
        barcode: _barcodeController.text.trim(),
        qrCode: _qrController.text.trim(),
      ),
      thumbnail: _imageController.text.trim(),
      images: _imageController.text.trim().isNotEmpty
          ? [_imageController.text.trim()]
          : [],
    );
    widget.onCreate(product);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear producto')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 700;
          final fieldWidth = isWide
              ? constraints.maxWidth / 2 - 32
              : constraints.maxWidth - 32;

          List<Widget> fields = [
            _buildField(
              _titleController,
              'Título',
              maxLength: maxTitleLength,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El título es obligatorio';
                }
                if (value.length > maxTitleLength) {
                  return 'Máximo $maxTitleLength caracteres';
                }
                return null;
              },
              width: fieldWidth,
            ),
            _buildField(
              _descriptionController,
              'Descripción',
              maxLength: maxDescriptionLength,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La descripción es obligatoria';
                }
                if (value.length > maxDescriptionLength) {
                  return 'Máximo $maxDescriptionLength caracteres';
                }
                return null;
              },
              width: fieldWidth,
            ),
            _buildDropdown(width: fieldWidth),
            _buildField(
              _brandController,
              'Marca',
              maxLength: maxBrandLength,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La marca es obligatoria';
                }
                if (value.length > maxBrandLength) {
                  return 'Máximo $maxBrandLength caracteres';
                }
                return null;
              },
              width: fieldWidth,
            ),
            _buildField(
              _priceController,
              'Precio',
              keyboardType: TextInputType.number,
              validator: (value) {
                final price = double.tryParse(value ?? '');
                if (value == null || value.trim().isEmpty) {
                  return 'El precio es obligatorio';
                }
                if (price == null || price <= 0) {
                  return 'Ingresa un precio válido (> 0)';
                }
                return null;
              },
              width: fieldWidth,
            ),
            _buildField(
              _discountController,
              'Descuento (%)',
              keyboardType: TextInputType.number,
              validator: (value) {
                final discount = double.tryParse(value ?? '');
                if (discount == null || discount < 0 || discount > 100) {
                  return 'Ingresa un descuento entre 0 y 100';
                }
                return null;
              },
              width: fieldWidth,
            ),
            _buildField(
              _stockController,
              'Stock',
              keyboardType: TextInputType.number,
              validator: (value) {
                final stock = int.tryParse(value ?? '');
                if (stock == null || stock < 0) {
                  return 'Ingresa un stock válido (>= 0)';
                }
                return null;
              },
              width: fieldWidth,
            ),
            _buildField(
              _weightController,
              'Peso',
              keyboardType: TextInputType.number,
              validator: (value) {
                final weight = double.tryParse(value ?? '');
                if (weight == null || weight < 0) {
                  return 'Ingresa un peso válido (>= 0)';
                }
                return null;
              },
              width: fieldWidth,
            ),
            _buildField(
              _imageController,
              'URL de imagen',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La imagen es obligatoria';
                }
                final uri = Uri.tryParse(value);
                if (uri == null || !uri.hasAbsolutePath) {
                  return 'Ingresa una URL válida';
                }
                return null;
              },
              width: fieldWidth,
            ),
            _buildField(
              _barcodeController,
              'Barcode',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El barcode es obligatorio';
                }
                return null;
              },
              width: fieldWidth,
            ),
            _buildField(
              _qrController,
              'QR',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El QR es obligatorio';
                }
                return null;
              },
              width: fieldWidth,
            ),
          ];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    isWide
                        ? Wrap(spacing: 16, runSpacing: 16, children: fields)
                        : Column(
                            children: fields
                                .map(
                                  (f) => Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: f,
                                  ),
                                )
                                .toList(),
                          ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: isWide ? 300 : double.infinity,
                      child: ElevatedButton(
                        onPressed: _create,
                        child: const Text('Crear producto'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label, {
    int? maxLength,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    double? width,
  }) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        maxLength: maxLength,
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }

  Widget _buildDropdown({double? width}) {
    return SizedBox(
      width: width,
      child: DropdownButtonFormField<String>(
        value: _selectedCategory,
        items: widget.categories
            .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
            .toList(),
        onChanged: (value) {
          if (value != null) setState(() => _selectedCategory = value);
        },
        decoration: const InputDecoration(labelText: 'Categoría'),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Selecciona una categoría';
          return null;
        },
      ),
    );
  }
}
