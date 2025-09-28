import 'package:flutter/material.dart';

class ProductFilterSheet extends StatelessWidget {
  final double minPrice;
  final double maxPrice;
  final List<String> categories;
  final double? selectedMin;
  final double? selectedMax;
  final String? selectedCategory;
  final void Function(double, double, String?) onApply;

  const ProductFilterSheet({
    super.key,
    required this.minPrice,
    required this.maxPrice,
    required this.categories,
    this.selectedMin,
    this.selectedMax,
    this.selectedCategory,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    final minPriceController = TextEditingController(
      text: (selectedMin ?? minPrice).toString(),
    );
    final maxPriceController = TextEditingController(
      text: (selectedMax ?? maxPrice).toString(),
    );
    double tempMin = selectedMin ?? minPrice;
    double tempMax = selectedMax ?? maxPrice;
    String? tempCategory = selectedCategory;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StatefulBuilder(
        builder: (context, setModalState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Filtrar por precio y categoría',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Precio mínimo',
                      ),
                      keyboardType: TextInputType.number,
                      controller: minPriceController,
                      onChanged: (value) {
                        setModalState(() {
                          tempMin = double.tryParse(value) ?? minPrice;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Precio máximo',
                      ),
                      keyboardType: TextInputType.number,
                      controller: maxPriceController,
                      onChanged: (value) {
                        setModalState(() {
                          tempMax = double.tryParse(value) ?? maxPrice;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: tempCategory,
                items: categories
                    .map(
                      (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                    )
                    .toList(),
                onChanged: (value) {
                  setModalState(() {
                    tempCategory = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Categoría'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  onApply(tempMin, tempMax, tempCategory);
                  Navigator.pop(context);
                },
                child: const Text('Aplicar filtro'),
              ),
            ],
          );
        },
      ),
    );
  }
}
