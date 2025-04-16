import 'package:flutter/material.dart';
import 'package:manziliapp/model/product.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final int? subCategoryId;
  final int storeId;

  const ProductCard({
    Key? key,
    required this.product,
    this.subCategoryId,
    required this.storeId,
  }) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isInCart = false; // Track whether the product is in cart

  // Example methods to simulate adding or removing a product from a cart.
  void _addProductToCart(Product product) {
    // Insert your logic here to add the product to your cart data model, API, etc.
    print('${product.name} added to cart');
  }

  void _removeProductFromCart(Product product) {
    // Insert your logic here to remove the product from your cart
    print('${product.name} removed from cart');
  }

  void _toggleCart(int produtcId) {
    setState(() {
      // Toggle cart status
      isInCart = !isInCart;

      // Call the appropriate method
      if (isInCart) {
        _addProductToCart(widget.product);
      } else {
        _removeProductFromCart(widget.product);
      }
    });
  }

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
          // Price and cart column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 5),
                  child: Text(
                    '${widget.product.price.toInt()} ريال',
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
                      icon: Icon(
                        isInCart
                            ? Icons
                                .remove_shopping_cart // Icon to remove from cart
                            : Icons
                                .shopping_cart_outlined, // Icon to add product to cart
                        color: const Color(0xFF1548C7),
                        size: 30,
                      ),
                      onPressed: () => _toggleCart(widget.product.id),
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
                      widget.product.name,
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
                      widget.product.description,
                      style: const TextStyle(fontSize: 14),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Product image and rating
          Stack(
            alignment: Alignment.topRight,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'http://man.runasp.net${widget.product.image}',
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1548C7),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.product.rating.toStringAsFixed(1),
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
