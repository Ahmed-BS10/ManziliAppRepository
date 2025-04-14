

// UI for each product (ProductCard remains mostly unchanged except for using the image property)
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:manziliapp/model/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int storeId;
  final int subCategoryId; // If needed for further logic

  const ProductCard({
    Key? key,
    required this.product,
    required this.subCategoryId,
    required this.storeId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF1548C7)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Column for price and cart button
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 5),
                  child: Text(
                    '${product.price.toInt()} ريال',
                    style: const TextStyle(
                      color: Color(0xFF1548C7),
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(right: 25),
                    child: IconButton(
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Color(0xFF1548C7),
                        size: 30,
                      ),
                      onPressed: () {
                        // Add your add-to-cart logic here
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Product details
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 11),
                    child: Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Color(0xFF1548C7),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      product.description,
                      style: const TextStyle(fontSize: 14),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Product image and rating overlay
          Stack(
            alignment: Alignment.topRight,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'http://man.runasp.net${product.image}',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.fastfood, color: Colors.grey),
                    );
                  },
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  margin: const EdgeInsets.all(4),
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1548C7),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${product.rating}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}