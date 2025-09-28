import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';
import '../components/product_card.dart';
import 'product_detail_page.dart';
import 'product_form_page.dart';
import 'product_create_page.dart';
import '../utils/product_filter_sheet.dart';
import '../components/product_search_delegate.dart';
import '../components/select_product_dialog.dart';

List<Product> _editedProducts = [];
List<Product> _createdProducts = [];
List<int> _deletedProductIds = [];

class ProductListPage extends StatefulWidget {
  static void openProductDetail(BuildContext context, Product product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(product: product),
      ),
    );
  }

  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ProductService _service = ProductService();
  final ScrollController _scrollController = ScrollController();

  List<Product> _products = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  final int _limit = 10;
  int _skip = 0;
  String? _error;
  bool _isFiltered = false;
  int _selectedNavIndex = 0;

  double? _filterMinPrice;
  double? _filterMaxPrice;
  String? _filterCategory;

  @override
  void initState() {
    super.initState();
    _loadInitial();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitial() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _hasMore = true;
      _skip = 0;
      _products = [];
    });
    try {
      List<Product> items = [];

      if (_isFiltered) {
        if (_filterCategory != null && _filterCategory!.isNotEmpty) {
          items = await _service.getProductsByCategory(_filterCategory!);
        } else {
          items = await _service.getProductsAll();
        }

        final createdFiltered = _createdProducts
            .where(
              (p) =>
                  _filterCategory == null ||
                  _filterCategory!.isEmpty ||
                  p.category == _filterCategory,
            )
            .toList();

        items = [...createdFiltered, ...items];
        for (var edited in _editedProducts) {
          final idx = items.indexWhere((p) => p.id == edited.id);
          if (idx != -1) items[idx] = edited;
        }

        if (_filterMinPrice != null || _filterMaxPrice != null) {
          items = items.where((p) {
            final minOk =
                _filterMinPrice == null || p.price >= _filterMinPrice!;
            final maxOk =
                _filterMaxPrice == null || p.price <= _filterMaxPrice!;
            return minOk && maxOk;
          }).toList();
        }
        items = items.skip(_skip).take(_limit).toList();
      } else {
        items = await _service.getProducts(limit: _limit, skip: _skip);
        items = [..._createdProducts, ...items];
        for (var edited in _editedProducts) {
          final idx = items.indexWhere((p) => p.id == edited.id);
          if (idx != -1) items[idx] = edited;
        }
      }

      items = items.where((p) => !_deletedProductIds.contains(p.id)).toList();
      setState(() {
        _products = items;
        _skip += items.length;
        _hasMore = items.length == _limit;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadMore() async {
    if (!_hasMore || _isLoadingMore) return;
    setState(() {
      _isLoadingMore = true;
      _error = null;
    });
    try {
      List<Product> items = [];

      if (_isFiltered) {
        if (_filterCategory != null && _filterCategory!.isNotEmpty) {
          items = await _service.getProductsByCategory(_filterCategory!);
        } else {
          items = await _service.getProductsAll();
        }
        if (_filterMinPrice != null || _filterMaxPrice != null) {
          items = items.where((p) {
            final minOk =
                _filterMinPrice == null || p.price >= _filterMinPrice!;
            final maxOk =
                _filterMaxPrice == null || p.price <= _filterMaxPrice!;
            return minOk && maxOk;
          }).toList();
        }
        items = items.skip(_skip).take(_limit).toList();
      } else {
        items = await _service.getProducts(limit: _limit, skip: _skip);
      }

      items = items.where((p) => !_deletedProductIds.contains(p.id)).toList();
      setState(() {
        _products.addAll(items);
        _skip += items.length;
        if (items.length < _limit) _hasMore = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() => _isLoadingMore = false);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> _onRefresh() async {
    await _loadInitial();
  }

  Future<void> _onNavTap(int index) async {
    setState(() {
      _selectedNavIndex = index;
    });

    if (index == 0) {
      if (_products.isEmpty) return;
      final categories = await _service.getCategories();
      if (!mounted) return;
      final selected = await showDialog<Product>(
        context: context,
        builder: (context) => SelectProductDialog(
          service: _service,
          deletedProductIds: _deletedProductIds,
          editedProducts: _editedProducts,
        ),
      );
      if (!mounted) return;
      if (selected != null) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductFormPage(
              product: selected,
              categories: categories,
              onSave: (editedProduct) async {
                setState(() {
                  final idx = _products.indexWhere(
                    (p) => p.id == editedProduct.id,
                  );
                  if (idx != -1) _products[idx] = editedProduct;
                  final idxEdit = _editedProducts.indexWhere(
                    (p) => p.id == editedProduct.id,
                  );
                  if (idxEdit != -1) {
                    _editedProducts[idxEdit] = editedProduct;
                  } else {
                    _editedProducts.add(editedProduct);
                  }
                });
              },
            ),
          ),
        );
      }
    }

    if (index == 1) {
      final categories = await _service.getCategories();
      if (!mounted) return;
      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductCreatePage(
            categories: categories,
            onCreate: (newProduct) {
              setState(() {
                final allIds = _products.map((p) => p.id).toList();
                final maxId = allIds.isNotEmpty
                    ? allIds.reduce((a, b) => a > b ? a : b)
                    : 0;
                newProduct = newProduct.copyWith(id: maxId + 1);
                _createdProducts.insert(0, newProduct);
                _products.insert(0, newProduct);
              });
            },
          ),
        ),
      );
    }

    if (index == 2) {
      double minPrice = 0;
      double maxPrice = 1000;
      List<String> categories = await _service.getCategories();
      if (!mounted) return;
      await showModalBottomSheet(
        context: context,
        builder: (context) {
          return ProductFilterSheet(
            minPrice: minPrice,
            maxPrice: maxPrice,
            categories: categories,
            selectedMin: _filterMinPrice,
            selectedMax: _filterMaxPrice,
            selectedCategory: _filterCategory,
            onApply: (min, max, cat) async {
              setState(() {
                _filterMinPrice = min;
                _filterMaxPrice = max;
                _filterCategory = cat;
                _isFiltered = true;
                _skip = 0;
              });
              await _loadInitial();
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              await showSearch<String?>(
                context: context,
                delegate: ProductSearchDelegate(
                  service: _service,
                  mainContext: context,
                  createdProducts: _createdProducts,
                  editedProducts: _editedProducts,
                  deletedProductIds: _deletedProductIds,
                ),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 700;
          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_error != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Error: $_error'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _loadInitial,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }
          return Column(
            children: [
              if (_isFiltered)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.clear),
                    label: const Text('Quitar filtro y ver todos'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[100],
                      foregroundColor: Colors.black87,
                    ),
                    onPressed: () {
                      setState(() {
                        _filterMinPrice = null;
                        _filterMaxPrice = null;
                        _filterCategory = null;
                        _isFiltered = false;
                        _skip = 0;
                      });
                      _loadInitial();
                    },
                  ),
                ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: SizedBox.expand(
                    child: isWide
                        ? GridView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(16),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: constraints.maxWidth > 1200
                                      ? 4
                                      : 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 1.2,
                                ),
                            itemCount:
                                _products.length + (_isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index < _products.length) {
                                final p = _products[index];
                                return ProductCard(
                                  product: p,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetailPage(product: p),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount:
                                _products.length + (_isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index < _products.length) {
                                final p = _products[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  child: ProductCard(
                                    product: p,
                                    onTap: () async {
                                      final deletedId =
                                          await Navigator.push<int>(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductDetailPage(product: p),
                                            ),
                                          );
                                      if (deletedId != null) {
                                        setState(() {
                                          _deletedProductIds.add(deletedId);
                                          _products.removeWhere(
                                            (prod) => prod.id == deletedId,
                                          );
                                          _createdProducts.removeWhere(
                                            (prod) => prod.id == deletedId,
                                          );
                                          _editedProducts.removeWhere(
                                            (prod) => prod.id == deletedId,
                                          );
                                        });
                                      }
                                    },
                                  ),
                                );
                              } else {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                            },
                          ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        onTap: _onNavTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Editar'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Crear'),
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_alt),
            label: 'Filtrar',
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
