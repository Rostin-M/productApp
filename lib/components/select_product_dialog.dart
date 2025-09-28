import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class SelectProductDialog extends StatefulWidget {
  final ProductService service;
  final int limit;
  final List<int> deletedProductIds;
  final List<Product> editedProducts;

  const SelectProductDialog({
    super.key,
    required this.service,
    this.limit = 10,
    required this.deletedProductIds,
    required this.editedProducts,
  });

  @override
  State<SelectProductDialog> createState() => _SelectProductDialogState();
}

class _SelectProductDialogState extends State<SelectProductDialog> {
  int skip = 0;
  bool hasMore = true;
  bool isLoadingMore = false;
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts({bool append = false}) async {
    List<Product> items = await widget.service.getProducts(
      limit: widget.limit,
      skip: skip,
    );
    items = items
        .where((p) => !widget.deletedProductIds.contains(p.id))
        .toList();

    for (var edited in widget.editedProducts) {
      final idx = items.indexWhere((p) => p.id == edited.id);
      if (idx != -1) items[idx] = edited;
    }

    setState(() {
      if (append) {
        products.addAll(items);
      } else {
        products = items;
      }
      skip += items.length;
      if (items.length < widget.limit) hasMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    scrollController.addListener(() async {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          hasMore &&
          !isLoadingMore) {
        isLoadingMore = true;
        await _loadProducts(append: true);
        isLoadingMore = false;
      }
    });

    return AlertDialog(
      title: const Text('Selecciona producto a editar'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: ListView.builder(
          controller: scrollController,
          itemCount: products.length + (isLoadingMore ? 1 : 0),
          itemBuilder: (context, idx) {
            if (idx < products.length) {
              final p = products[idx];
              return ListTile(
                title: Text(p.title),
                subtitle: Text('Precio: \$${p.price}'),
                onTap: () => Navigator.pop(context, p),
              );
            } else {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
      ),
    );
  }
}
