import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _service = ProductService();

  List<Product> _products = [];
  List<Product> get products => _products;

  Product? _selectedProduct;
  Product? get selectedProduct => _selectedProduct;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  int _skip = 0;
  final int _limit = 10;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  Future<void> fetchProducts({bool refresh = false}) async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (refresh) {
        _skip = 0;
        _hasMore = true;
        _products = [];
      }

      final newProducts = await _service.getProducts(
        limit: _limit,
        skip: _skip,
      );

      if (newProducts.isEmpty) {
        _hasMore = false;
      } else {
        _skip += _limit;
        _products.addAll(newProducts);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProductById(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedProduct = await _service.getProduct(id);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProduct(Product product) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newProduct = await _service.createProduct(product);
      _products.insert(0, newProduct);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProduct(Product product) async {
    if (product.id == 0) return;

    _isLoading = true;
    notifyListeners();

    try {
      final updatedProduct = await _service.updateProduct(
        product.id,
        product.toJson(),
      );
      final index = _products.indexWhere((p) => p.id == product.id);

      if (index != -1) {
        _products[index] = updatedProduct;
      }

      if (_selectedProduct?.id == product.id) {
        _selectedProduct = updatedProduct;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _service.deleteProduct(id);
      if (success) {
        _products.removeWhere((p) => p.id == id);
        if (_selectedProduct?.id == id) {
          _selectedProduct = null;
        }
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
