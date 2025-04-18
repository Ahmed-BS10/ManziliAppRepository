import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manziliapp/CustomerViews/controller/user_controller.dart';
import 'package:manziliapp/main.dart';
import 'package:manziliapp/CustomerViews/model/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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
  final CartController cartController = Get.put(CartController());

  @override
  void initState() {
    super.initState();
    _loadCartState();
  }

  Future<void> _loadCartState() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'isInCart_${widget.product.id}';
    if (mounted) {
      cartController.isInCart.value = prefs.getBool(key) ?? false;
    }
  }

  Future<void> _saveCartState(bool state) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'isInCart_${widget.product.id}';
    await prefs.setBool(key, state);
  }

  Future<void> _toggleCart(int productId, int quantity) async {
    cartController.setLoading(true);
    cartController.toggleCartState();

    try {
      if (cartController.isInCart.value) {
        // Add to cart logic
        final userId = Get.find<UserController>().userId.value;
        final url = Uri.parse(
            'http://man.runasp.net/api/Cart/add?userId=$userId&storeId=${widget.storeId}&productId=$productId&quantity=$quantity');
        final response = await http.post(url);

        if (response.statusCode == 200 && json.decode(response.body) == true) {
          await _saveCartState(true);
        } else {
          cartController.toggleCartState();
        }
      } else {
        // Remove from cart logic
        final userId = Get.find<UserController>().userId.value;
        final url = Uri.parse(
            'http://man.runasp.net/api/Cart/DeleteCartItem?userId=$userId&productId=$productId');
        final response = await http.delete(url);

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          if (responseData['isSuccess'] == true) {
            await _saveCartState(false);
          } else {
            cartController.toggleCartState();
          }
        } else {
          cartController.toggleCartState();
        }
      }
    } catch (e) {
      cartController.toggleCartState();
      debugPrint('Error toggling cart: $e');
    } finally {
      cartController.setLoading(false);
    }
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
                    child: Obx(() => cartController.isLoading.value
                        ? SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                cartController.isInCart.value
                                    ? Colors.red
                                    : const Color(0xFF1548C7),
                              ),
                            ),
                          )
                        : IconButton(
                            icon: Icon(
                              cartController.isInCart.value
                                  ? Icons.remove_circle_outline
                                  : Icons.shopping_cart_outlined,
                              color: cartController.isInCart.value
                                  ? Colors.red
                                  : const Color(0xFF1548C7),
                              size: 30,
                            ),
                            onPressed: () => _toggleCart(widget.product.id, 1),
                          )),
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
                  '[http://man.runasp.net](http://man.runasp.net)${widget.product.image}',
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
