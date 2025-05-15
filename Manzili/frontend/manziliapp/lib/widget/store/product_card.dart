import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manziliapp/controller/user_controller.dart';
import 'package:manziliapp/model/product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProductCard extends StatefulWidget {
  final Product product;
  final int? subCategoryId;
  final int storeId;

  const ProductCard({
    super.key,
    required this.product,
    this.subCategoryId,
    required this.storeId,
  });

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late final String _prefsKey;
  bool _isInCart = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _prefsKey = 'isInCart_${widget.product.id}';
    _loadCartState();
  }

  Future<void> _loadCartState() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getBool(_prefsKey) ?? false;
    if (mounted) setState(() => _isInCart = saved);
  }

  Future<void> _saveCartState(bool inCart) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, inCart);
  }

  /// Removes all stored prefs for this product
  Future<void> _clearProductPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
    await prefs.remove('quantity_${widget.product.id}');
    await prefs.remove('price_${widget.product.id}');
  }

  Future<void> _toggleCart(int productId) async {
    setState(() => _isLoading = true);
    final wantToAdd = !_isInCart;

    try {
      final userId = Get.find<UserController>().userId.value;
      bool success = false;

      if (wantToAdd) {
        // ----- ADD TO CART -----
        final url = Uri.parse(
          'http://man.runasp.net/api/Cart/add'
          '?userId=$userId&storeId=${widget.storeId}'
          '&productId=$productId&quantity=1',
        );
        final resp = await http.post(url);
        success = resp.statusCode == 200 && json.decode(resp.body) == true;
      } else {
        // ----- REMOVE FROM CART -----
        debugPrint('Removing from cart...');
        final url = Uri.parse(
          'http://man.runasp.net/api/Cart/DeleteCartItemFromStore?storeId=${widget.storeId}&userId=$userId&productId=$productId',
        );
        final resp = await http.delete(url);
        if (resp.statusCode == 200) {
          final body = json.decode(resp.body);
          if (body['isSuccess'] == true) {
            // clear exactly the same prefs as in CartCardWidget
            await _clearProductPrefs();
            success = true;
          }
        }
      }

      if (success) {
        // persist & update UI
        setState(() => _isInCart = wantToAdd);
        if (wantToAdd) {
          await _saveCartState(true);
        }
      }
    } catch (e) {
      debugPrint('Error toggling cart: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
        children: [
          // Price + cart icon
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.product.price.toInt()} ريال',
                  style: const TextStyle(
                    color: Color(0xFF1548C7),
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 12),
                _isLoading
                    ? const SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      )
                    : IconButton(
                        icon: Icon(
                          _isInCart
                              ? Icons.remove_circle_outline
                              : Icons.shopping_cart_outlined,
                          color:
                              _isInCart ? Colors.red : const Color(0xFF1548C7),
                          size: 30,
                        ),
                        onPressed: () => _toggleCart(widget.product.id),
                      ),
              ],
            ),
          ),

          // Product details
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  widget.product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Color(0xFF1548C7),
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.product.description,
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),

          // Image + rating
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              'http://man.runasp.net${widget.product.image}',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 100,
                height: 100,
                color: Colors.grey.shade300,
                child: const Icon(Icons.fastfood, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
