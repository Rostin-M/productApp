// lib/services/product_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../utils/api_constants.dart';

class ProductService {
  final http.Client client;
  ProductService({http.Client? client}) : client = client ?? http.Client();

  Future<List<Product>> getProducts({int limit = 10, int skip = 0}) async {
    final url = "${ApiConstants.products}?limit=$limit&skip=$skip";
    final uri = Uri.parse(url);

    try {
      final resp = await client.get(uri);
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        final List products = data['products'] ?? [];
        return products.map((j) => Product.fromJson(j)).toList();
      } else {
        throw Exception('Error ${resp.statusCode} al obtener productos');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Product> getProductById(int id) async {
    final url = ApiConstants.productById(id);
    final uri = Uri.parse(url);

    final resp = await client.get(uri);
    if (resp.statusCode == 200) {
      return Product.fromJson(jsonDecode(resp.body));
    } else {
      throw Exception('Error ${resp.statusCode} al obtener producto $id');
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    final url = ApiConstants.searchProducts(query);
    final uri = Uri.parse(url);

    try {
      final resp = await client.get(uri);
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        final List products = data['products'] ?? [];
        return products.map((j) => Product.fromJson(j)).toList();
      } else {
        throw Exception('Error ${resp.statusCode} en búsqueda');
      }
    } catch (e) {
      return [];
    }
  }

  Future<Product> addProduct(Map<String, dynamic> productData) async {
    final url = ApiConstants.addProduct;
    final uri = Uri.parse(url);

    final resp = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(productData),
    );

    if (resp.statusCode == 200 || resp.statusCode == 201) {
      return Product.fromJson(jsonDecode(resp.body));
    } else {
      throw Exception('Error ${resp.statusCode} al crear producto');
    }
  }

  Future<Product> updateProduct(
    int id,
    Map<String, dynamic> productData,
  ) async {
    final url = ApiConstants.updateProduct(id);
    final uri = Uri.parse(url);

    final resp = await client.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(productData),
    );

    if (resp.statusCode == 200) {
      return Product.fromJson(jsonDecode(resp.body));
    } else {
      throw Exception('Error ${resp.statusCode} al actualizar producto $id');
    }
  }

  Future<bool> deleteProduct(int id) async {
    final url = ApiConstants.deleteProduct(id);
    final uri = Uri.parse(url);

    final resp = await client.delete(uri);

    if (resp.statusCode == 200) {
      return true;
    } else {
      throw Exception('Error ${resp.statusCode} al eliminar producto $id');
    }
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    final url = ApiConstants.productsByCategory(category);
    final uri = Uri.parse(url);

    final resp = await client.get(uri);
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      final List products = data['products'] ?? [];
      return products.map((j) => Product.fromJson(j)).toList();
    } else {
      throw Exception(
        'Error ${resp.statusCode} al obtener categoría $category',
      );
    }
  }

  Future<List<String>> getCategories() async {
    final url = ApiConstants.categories;
    final uri = Uri.parse(url);

    final resp = await client.get(uri);
    if (resp.statusCode == 200) {
      final List cats = jsonDecode(resp.body);

      if (cats.isNotEmpty && cats.first is Map) {
        return cats
            .map((c) => c['slug']?.toString() ?? '')
            .where((s) => s.isNotEmpty)
            .toList();
      } else {
        return cats.map((c) => c.toString()).toList();
      }
    } else {
      throw Exception('Error ${resp.statusCode} al obtener categorías');
    }
  }

  Future<Product> getProduct(int id) async {
    throw UnimplementedError('getProduct method not implemented');
  }

  Future<Product> createProduct(Product product) async {
    throw UnimplementedError('createProduct is not implemented');
  }

  Future<List<Product>> getProductsAll() async {
    final url = "${ApiConstants.products}?limit=1000&skip=0";
    final uri = Uri.parse(url);

    try {
      final resp = await client.get(uri);
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        final List products = data['products'] ?? [];
        return products.map((j) => Product.fromJson(j)).toList();
      } else {
        throw Exception(
          'Error ${resp.statusCode} al obtener todos los productos',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
