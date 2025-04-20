import 'package:flutter/material.dart';
import 'package:manziliapp/model/product_store.dart';
import 'product_store_card.dart';

class ProductsSheet extends StatefulWidget {
  final List<ProductStore> products;

  const ProductsSheet({
    super.key,
    required this.products,
  });

  @override
  State<ProductsSheet> createState() => _ProductsSheetState();
}

class _ProductsSheetState extends State<ProductsSheet> {
  final DraggableScrollableController _controller =
      DraggableScrollableController();
  double _sheetPosition = 0.1;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSheetPositionChanged);
  }

  void _onSheetPositionChanged() {
    setState(() {
      _sheetPosition = _controller.size;
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onSheetPositionChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.9,
      controller: _controller,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              if (_sheetPosition > 0.15) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'منتجاتي',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'لديك ${widget.products.length} منتجات',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (_sheetPosition <= 0.15) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.products.length}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'منتجاتي',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (_sheetPosition > 0.15) ...[
                Expanded(
                  child: GridView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: widget.products.length,
                    itemBuilder: (context, index) {
                      return ProductStoreCard(product: widget.products[index]);
                    },
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
