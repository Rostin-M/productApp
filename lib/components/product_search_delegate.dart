import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';
import '../screens/product_list_page.dart';
import 'product_card.dart';

class ProductSearchDelegate extends SearchDelegate<String?> {
  final ProductService service;
  final BuildContext mainContext;
  final List<Product> createdProducts;
  final List<Product> editedProducts;
  final List<int> deletedProductIds;

  ProductSearchDelegate({
    required this.service,
    required this.mainContext,
    required this.createdProducts,
    required this.editedProducts,
    required this.deletedProductIds,
  });

  @override
  String get searchFieldLabel => 'Buscar productos';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Escribe algo para buscar'));
    }
    return FutureBuilder<List<Product>>(
      future: service.searchProducts(query),
      builder: (context, snapshot) {
        List<Product> apiResults = snapshot.data ?? [];
        for (var edited in editedProducts) {
          final idxCreated = createdProducts.indexWhere(
            (p) => p.id == edited.id,
          );
          if (idxCreated != -1) createdProducts[idxCreated] = edited;
          final idxApi = apiResults.indexWhere((p) => p.id == edited.id);
          if (idxApi != -1) apiResults[idxApi] = edited;
        }
        final allResults = [...createdProducts, ...apiResults];
        final results = allResults
            .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
            .where((p) => !deletedProductIds.contains(p.id))
            .toList();
        if (results.isEmpty) {
          return const Center(child: Text('No se encontraron productos.'));
        }
        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final p = results[index];
            return ProductCard(
              product: p,
              onTap: () {
                close(context, null);
                Future.microtask(() {
                  if (mainContext.mounted) {
                    ProductListPage.openProductDetail(mainContext, p);
                  }
                });
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Escribe para buscar productos'));
    }
    return FutureBuilder<List<Product>>(
      future: service.searchProducts(query),
      builder: (context, snapshot) {
        List<Product> apiResults = snapshot.data ?? [];
        for (var edited in editedProducts) {
          final idxCreated = createdProducts.indexWhere(
            (p) => p.id == edited.id,
          );
          if (idxCreated != -1) createdProducts[idxCreated] = edited;
          final idxApi = apiResults.indexWhere((p) => p.id == edited.id);
          if (idxApi != -1) apiResults[idxApi] = edited;
        }
        final allResults = [...createdProducts, ...apiResults];
        final results = allResults
            .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
            .where((p) => !deletedProductIds.contains(p.id))
            .toList();
        if (results.isEmpty) {
          return const Center(child: Text('No se encontraron productos.'));
        }
        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final p = results[index];
            return ProductCard(
              product: p,
              onTap: () {
                close(context, null);
                Future.microtask(() {
                  if (mainContext.mounted) {
                    ProductListPage.openProductDetail(mainContext, p);
                  }
                });
              },
            );
          },
        );
      },
    );
  }
}
