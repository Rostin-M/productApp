import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductFormPage extends StatefulWidget {
  final Product product;
  final List<String> categories;
  final void Function(Product) onSave;

  const ProductFormPage({
    super.key,
    required this.product,
    required this.categories,
    required this.onSave,
  });

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _brandController;
  late TextEditingController _priceController;
  late String _selectedCategory;
  final _formKey = GlobalKey<FormState>();

  static const int maxTitleLength = 40;
  static const int maxDescriptionLength = 200;
  static const int maxBrandLength = 30;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.product.title);
    _descriptionController = TextEditingController(
      text: widget.product.description,
    );
    _brandController = TextEditingController(text: widget.product.brand);
    _priceController = TextEditingController(
      text: widget.product.price.toString(),
    );
    if (widget.categories.contains(widget.product.category)) {
      _selectedCategory = widget.product.category;
    } else if (widget.categories.isNotEmpty) {
      _selectedCategory = widget.categories.first;
    } else {
      _selectedCategory = '';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState?.validate() != true) return;
    final edited = Product(
      id: widget.product.id,
      title: _titleController.text,
      description: _descriptionController.text,
      category: _selectedCategory,
      price: double.tryParse(_priceController.text) ?? widget.product.price,
      discountPercentage: widget.product.discountPercentage,
      rating: widget.product.rating,
      stock: widget.product.stock,
      tags: widget.product.tags,
      brand: _brandController.text,
      sku: widget.product.sku,
      weight: widget.product.weight,
      dimensions: widget.product.dimensions,
      warrantyInformation: widget.product.warrantyInformation,
      shippingInformation: widget.product.shippingInformation,
      availabilityStatus: widget.product.availabilityStatus,
      reviews: widget.product.reviews,
      returnPolicy: widget.product.returnPolicy,
      minimumOrderQuantity: widget.product.minimumOrderQuantity,
      meta: widget.product.meta,
      thumbnail: widget.product.thumbnail,
      images: widget.product.images,
    );
    widget.onSave(edited);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar producto')),
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
              maxLines: 3,
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
                        onPressed: _save,
                        child: const Text('Guardar cambios'),
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
    int? maxLines,
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
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }

  Widget _buildDropdown({double? width}) {
    return SizedBox(
      width: width,
      child: DropdownButtonFormField<String>(
        value: _selectedCategory.isNotEmpty ? _selectedCategory : null,
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
