import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/product_model.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  String _precioConDescuento(double? precio, double? descuento) {
    if (precio == null) return "NO HAY DATOS";
    if (descuento == null) return "\$${precio.toStringAsFixed(2)}";
    final precioFinal = precio - (precio * descuento / 100);
    return "\$${precioFinal.toStringAsFixed(2)}";
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageHeight = screenWidth < 400 ? 140.0 : 220.0;
    final galleryImageWidth = screenWidth < 400 ? 60.0 : 90.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        backgroundColor: Colors.green[700],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 700) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      Card(
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Center(
                            child: product.thumbnail.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      product.thumbnail,
                                      height: imageHeight,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Text("NO HAY IMAGEN"),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (product.images.isNotEmpty)
                        Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: galleryImageWidth + 30,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: product.images.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 8),
                                itemBuilder: (context, index) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      product.images[index],
                                      width: galleryImageWidth,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      _mainInfoCard(context),
                      const SizedBox(height: 16),
                      _descriptionCard(context),
                      const SizedBox(height: 16),
                      _detailsCard(),
                      const SizedBox(height: 16),
                      _metaCard(),
                      const SizedBox(height: 16),
                      _reviewsCard(context),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: product.thumbnail.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  product.thumbnail,
                                  height: imageHeight,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Text("NO HAY IMAGEN"),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (product.images.isNotEmpty)
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: galleryImageWidth + 30,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: product.images.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  product.images[index],
                                  width: galleryImageWidth,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  _mainInfoCard(context),
                  const SizedBox(height: 16),
                  _descriptionCard(context),
                  const SizedBox(height: 16),
                  _detailsCard(),
                  const SizedBox(height: 16),
                  _metaCard(),
                  const SizedBox(height: 16),
                  _reviewsCard(context),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.delete),
        label: const Text('Eliminar'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        onPressed: () async {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Eliminar producto'),
              content: const Text(
                '¿Estás seguro de que quieres eliminar este producto?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text(
                    'Eliminar',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );
          if (confirm == true) {
            Navigator.pop(context, product.id);
          }
        },
      ),
    );
  }

  Widget _mainInfoCard(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Marca: ${product.brand}",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text("Categoría: ${product.category}"),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  "\$${product.price.toStringAsFixed(2)}",
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _precioConDescuento(
                    product.price,
                    product.discountPercentage,
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text("Stock: ${product.stock}"),
                  backgroundColor: product.stock > 0
                      ? Colors.green[100]
                      : Colors.red[100],
                ),
              ],
            ),
            Text("Estado: ${product.availabilityStatus}"),
          ],
        ),
      ),
    );
  }

  Widget _descriptionCard(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Descripción:",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(product.description),
          ],
        ),
      ),
    );
  }

  Widget _detailsCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Peso: ${product.weight} kg"),
            Text(
              "Dimensiones: ${product.dimensions.width} x ${product.dimensions.height} x ${product.dimensions.depth} cm",
            ),
            Text("Garantía: ${product.warrantyInformation}"),
            Text("Envío: ${product.shippingInformation}"),
            Text("Política de devolución: ${product.returnPolicy}"),
            Text("Cantidad mínima: ${product.minimumOrderQuantity}"),
          ],
        ),
      ),
    );
  }

  Widget _metaCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Meta:", style: const TextStyle(fontWeight: FontWeight.bold)),
            Text("Creado: ${_formatDate(product.meta.createdAt)}"),
            Text("Actualizado: ${_formatDate(product.meta.updatedAt)}"),
            Text("Barcode: ${product.meta.barcode}"),
            Text("QR: ${product.meta.qrCode}"),
          ],
        ),
      ),
    );
  }

  Widget _reviewsCard(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Reseñas:", style: Theme.of(context).textTheme.titleMedium),
            if (product.reviews.isNotEmpty)
              ...product.reviews.map((review) {
                return Card(
                  color: Colors.grey[100],
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: Text(review.comment),
                    subtitle: Text(
                      "Por: ${review.reviewerName} (${review.reviewerEmail})\nFecha: ${_formatDate(review.date)}",
                    ),
                    trailing: Text("⭐ ${review.rating}"),
                  ),
                );
              })
            else
              const Text("NO HAY COMENTARIOS"),
          ],
        ),
      ),
    );
  }
}
