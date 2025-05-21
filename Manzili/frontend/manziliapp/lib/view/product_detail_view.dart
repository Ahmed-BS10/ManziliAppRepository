import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:manziliapp/controller/product_detail_controller.dart';
import 'package:manziliapp/controller/user_controller.dart';
import 'package:manziliapp/model/full_producta.dart';
import 'package:manziliapp/widget/product/ImageCarousel.dart';
import 'package:manziliapp/widget/product/ProductDescription.dart';
import 'package:manziliapp/widget/product/ProductNameAndQuantity.dart';
import 'package:manziliapp/widget/product/RatingAndStoreInfo.dart';
import 'package:manziliapp/widget/product/TabSelector.dart';
import 'package:manziliapp/view/product_ratings_view.dart';

class ProductDetailView extends StatefulWidget {
  final int productId;
  final int storeId;

  const ProductDetailView({
    super.key,
    required this.productId,
    required this.storeId,
  });

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  int _quantity = 1;
  bool _isInCart = false;
  bool _isLoading = false;

  late final String _qtyPrefsKey;
  late final String _cartPrefsKey;
  late final ProductDetailController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(ProductDetailController());

    _qtyPrefsKey = 'quantity_${widget.productId}';
    _cartPrefsKey = 'isInCart_${widget.productId}';

    _loadSavedQuantity();
    _loadCartState();
    _controller.fetchProductDetails(widget.productId);
  }

  Future<void> _loadSavedQuantity() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getInt(_qtyPrefsKey) ?? 1;
    if (mounted) setState(() => _quantity = saved);
  }

  Future<void> _saveQuantity(int qty) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_qtyPrefsKey, qty);
  }

  Future<void> _loadCartState() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getBool(_cartPrefsKey) ?? false;
    if (mounted) setState(() => _isInCart = saved);
  }

  Future<void> _saveCartState(bool inCart) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_cartPrefsKey, inCart);
  }

  Future<void> _clearProductPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartPrefsKey);
    await prefs.remove(_qtyPrefsKey);
    await prefs.remove('price_${widget.productId}');
  }

  Future<void> _toggleCart() async {
    setState(() => _isLoading = true);
    final wantToAdd = !_isInCart;
    bool success = false;

    try {
      final userId = Get.find<UserController>().userId.value;
      if (wantToAdd) {
        // Add to cart
        final url = Uri.parse(
          'http://man.runasp.net/api/Cart/add'
          '?userId=$userId&storeId=${widget.storeId}'
          '&productId=${widget.productId}&quantity=$_quantity',
        );
        final resp = await http.post(url);
        success = resp.statusCode == 200 && json.decode(resp.body) == true;
      } else {
        // Remove from cart
        debugPrint('Removing from cart...');
        final url = Uri.parse(
          'http://man.runasp.net/api/Cart/DeleteCartItemFromStore?storeId=${widget.storeId}&userId=$userId&productId=${widget.productId}',
        );
        final resp = await http.delete(url);
        if (resp.statusCode == 200) {
          final body = json.decode(resp.body);
          if (body['isSuccess'] == true) {
            await _clearProductPrefs();
            success = true;
          }
        }
      }

      if (success) {
        setState(() => _isInCart = wantToAdd);
        if (wantToAdd) await _saveCartState(true);
      }
    } catch (e) {
      debugPrint('Error toggling cart: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_controller.errorMessage.isNotEmpty) {
          return Center(child: Text(_controller.errorMessage.value));
        }

        final product = _controller.product.value;
        return Column(
          children: [
            ImageCarousel(
              images: product.images!.map((imageUrl) {
                return imageUrl.startsWith('http')
                    ? imageUrl
                    : 'lib/assets/image/ad1.jpeg';
              }).toList(),
              currentIndex: 0,
              onPageChanged: (_) {},
            ),

            TabSelector(
              selectedTabIndex: _controller.selectedTabIndex.value,
              onTabSelected: _controller.updateTabIndex,
            ),

            Expanded(
              child: Obx(() {
                return _controller.selectedTabIndex.value == 0
                    ? ProductDetailsViewBody(
                        quantity: _quantity,
                        product: product,
                        storeImage: product.storeImage,
                        onQuantityChanged: (qty) async {
                          setState(() => _quantity = qty);
                          _controller.updateQuantity(qty);
                          await _saveQuantity(qty);
                        },
                      )
                    : ProductRatingsView(
                        productId: product.id,
                        reviewI: product.rating,
                      );
              }),
            ),

            // Add/Remove Cart Button & Price
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _isLoading
                      ? SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _isInCart ? Colors.red : const Color(0xFF1548C7),
                            ),
                          ),
                        )
                      : IconButton(
                          icon: Icon(
                            _isInCart
                                ? Icons.remove_circle_outline
                                : Icons.shopping_cart_outlined,
                            color: _isInCart
                                ? Colors.red
                                : const Color(0xFF1548C7),
                            size: 30,
                          ),
                          onPressed: _toggleCart,
                        ),
                  Text(
                    'السعر: ${(product.price * _quantity).toStringAsFixed(2)} ريال',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class ProductDetailsViewBody extends StatelessWidget {
  final int quantity;
  final ProductData product;
  final Function(int) onQuantityChanged;
  final String storeImage;

  const ProductDetailsViewBody({
    super.key,
    required this.product,
    required this.onQuantityChanged,
    required this.storeImage,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        // عرض تقييم ومعلومات المتجر
        RatingAndStoreInfo(
          // rating: product.rating.round(),
          storeName: product.storeName,
          storeImage: storeImage,
        ),
        const SizedBox(height: 24),
        // اسم المنتج والكمية مع زر الزيادة والنقصان
        ProductNameAndQuantity(
          name: product.name,
          quantity: quantity,
          onIncrement: () {
            int newQuantity = quantity + 1;
            onQuantityChanged(newQuantity);
          },
          onDecrement: () {
            if (quantity > 1) {
              int newQuantity = quantity - 1;
              onQuantityChanged(newQuantity);
            }
          },
        ),
        const SizedBox(height: 24),
        const SizedBox(height: 32),
        // وصف المنتج
        ProductDescription(
          title: 'وصف المنتج',
          description: product.description,
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
