// cart_card_widget.dart

import 'package:flutter/material.dart';
import 'package:manziliapp/view/cart_view.dart'; // your model import
import 'package:manziliapp/widget/card/quantity_selector_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartCardWidget extends StatefulWidget {
  const CartCardWidget({
    Key? key,
    required this.cartCardModel,
    required this.index,
  }) : super(key: key);

  final CartCardModel cartCardModel;
  final int index;

  @override
  State<CartCardWidget> createState() => _CartCardWidgetState();
}

class _CartCardWidgetState extends State<CartCardWidget> {
  int _quantity = 1;
  late final String _prefsKey;
  bool _isLoading = false; // Add loading state

  @override
  void initState() {
    super.initState();
    if (widget.cartCardModel.getProductCard.isNotEmpty &&
        widget.index >= 0 &&
        widget.index < widget.cartCardModel.getProductCard.length) {
      final product = widget.cartCardModel.getProductCard[widget.index];
      _prefsKey = 'quantity_${product.productId}';
      _loadSavedQuantity();
    } else {
      debugPrint('Invalid index or empty product list.');
    }
  }

  Future<void> _loadSavedQuantity() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getInt(_prefsKey);
    debugPrint('[_loadSavedQuantity] key=$_prefsKey saved=$saved');
    if (!mounted) return;
    if (saved != null && saved > 0) {
      setState(() {
        _quantity = saved;
      });
    }
  }

  Future<void> _saveQuantity(int qty) async {
    final prefs = await SharedPreferences.getInstance();
    final success = await prefs.setInt(_prefsKey, qty);
    debugPrint('[_saveQuantity] key=$_prefsKey qty=$qty success=$success');
  }

  Future<void> _deleteCartItem(int cartId, int productId) async {
    setState(() => _isLoading = true);
    try {
      final url = Uri.parse(
          'http://man.runasp.net/api/Cart/DeleteCartItem?cartId=$cartId&productId=$productId');
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['isSuccess'] == true) {
          // Update SharedPreferences for ProductCard
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isInCart_$productId', false); // Add this line

          if (mounted) {
            setState(() {
              widget.cartCardModel.getProductCard.removeAt(widget.index);
            });
          }
        }
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cartCardModel.getProductCard.isEmpty ||
        widget.index < 0 ||
        widget.index >= widget.cartCardModel.getProductCard.length) {
      return const Center(
        child: CartEmpty(),
      );
    }

    final product = widget.cartCardModel.getProductCard[widget.index];
    final cartId = widget.cartCardModel.cartId; // Assuming cartId is available
    final totalPrice = product.price * _quantity;

    return Stack(
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Product image
              Expanded(
                flex: 1,
                child: AspectRatio(
                  aspectRatio: 117 / 85,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Image.network(
                      'http://man.runasp.net' + product.imageUrl,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Details: name, menu, quantity & total price
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + delete menu
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'delete') {
                              await _deleteCartItem(cartId, product.productId);
                              if (mounted) {
                                setState(() {
                                  widget.cartCardModel.getProductCard
                                      .removeAt(widget.index);
                                });
                                // Notify parent widget or update shared state
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setBool(
                                    'isInCart_${product.productId}', false);
                              }
                            }
                          },
                          itemBuilder: (c) => const [
                            PopupMenuItem(
                              value: 'delete',
                              child: Center(
                                child: Text('حذف من السلة',
                                    style: TextStyle(fontSize: 16)),
                              ),
                            ),
                          ],
                          icon: const Icon(Icons.more_vert),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Quantity selector + total price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        QuantitySelectorWidget(
                          initialQuantity: _quantity,
                          onQuantityChanged: (newQty) {
                            setState(() => _quantity = newQty);
                            _saveQuantity(newQty);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            '\$${totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}

class CartEmpty extends StatelessWidget {
  const CartEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Image.asset(
              'assets/image/parcel.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 8),
            Text('السلة فارغة'),
            const SizedBox(height: 16),
            SafeArea(
              child: SizedBox(
                height: 51,
                width: 298,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff1548C7),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    'إستكشف التصنيفات',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
