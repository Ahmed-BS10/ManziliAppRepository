import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manziliapp/controller/product_detail_controller.dart';
import 'package:manziliapp/controller/user_controller.dart';
import 'package:manziliapp/main.dart';
import 'package:manziliapp/model/full_producta.dart';
import 'package:manziliapp/view/product_ratings_view.dart';
import 'package:manziliapp/widget/product/ImageCarousel.dart';
import 'package:manziliapp/widget/product/ProductDescription.dart';
import 'package:manziliapp/widget/product/ProductNameAndQuantity.dart';
import 'package:manziliapp/widget/product/RatingAndStoreInfo.dart';
import 'package:manziliapp/widget/product/TabSelector.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProductDetailView extends StatefulWidget {
  final int productId;
  final int storeId;

  const ProductDetailView({
    Key? key,
    required this.productId,
    required this.storeId,
  }) : super(key: key);

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  int _quantity = 1;
  late final String _prefsKey;
  late final String _cartPrefsKey;
  late final ProductDetailController controller;
  late final CartController cartController;

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    controller = Get.put(ProductDetailController());
    cartController = Get.put(CartController());

    // Prepare SharedPreferences keys
    _prefsKey = 'quantity_${widget.productId}';
    _cartPrefsKey = 'isInCart_${widget.productId}';

    // Load saved quantity and apply to controller
    _loadSavedQuantity();

    // Load saved cart state
    _loadCartState();

    // Fetch product details
    controller.fetchProductDetails(widget.productId);
  }

  Future<void> _loadSavedQuantity() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getInt(_prefsKey);

    if (!mounted) return;
    if (saved != null && saved > 0) {
      setState(() {
        _quantity = saved;
      });
    }
  }

  Future<void> _saveQuantity(int qty) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefsKey, qty);
  }

  Future<void> _loadCartState() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getBool(_cartPrefsKey) ?? false;
    if (mounted) cartController.isInCart.value = saved;
  }

  Future<void> _saveCartState(bool isInCart) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_cartPrefsKey, isInCart);
  }

  Future<void> _toggleCart(int quantity) async {
    cartController.setLoading(true);
    cartController.toggleCartState();
    final desiredState = cartController.isInCart.value;

    try {
      final userId = Get.find<UserController>().userId.value;
      bool success;

      if (desiredState) {
        // Add to cart with selected quantity
        final url = Uri.parse(
          'http://man.runasp.net/api/Cart/add'
          '?userId=$userId&storeId=${widget.storeId}'
          '&productId=${widget.productId}&quantity=$quantity',
        );
        final response = await http.post(url);
        success =
            (response.statusCode == 200 && json.decode(response.body) == true);
      } else {
        // Remove from cart
        final url = Uri.parse(
          'http://man.runasp.net/api/Cart/DeleteCartItem'
          '?userId=$userId&productId=${widget.productId}',
        );
        final response = await http.delete(url);
        final data = json.decode(response.body);
        success = (response.statusCode == 200 && data['isSuccess'] == true);

        // Update quantity and total price
        if (success) {
          setState(() {
            // _quantity = 1; // Reset or update quantity as needed
            controller.updateQuantity(_quantity);
          });
          await _saveQuantity(_quantity);
        }
      }

      if (success) {
        // Persist the new cart state
        await _saveCartState(desiredState);
      } else {
        // Revert on failure
        cartController.toggleCartState();
      }
    } catch (e) {
      cartController.toggleCartState();
      debugPrint('Error toggling cart: \$e');
    } finally {
      cartController.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        final product = controller.product.value;

        return Column(
          children: [
            // Image carousel
            ImageCarousel(
              images: product.images!,
              currentIndex: 0,
              onPageChanged: (index) {},
            ),

            // Tab selector
            TabSelector(
              selectedTabIndex: controller.selectedTabIndex.value,
              onTabSelected: controller.updateTabIndex,
            ),

            // Tab content
            Expanded(
              child: Obx(() {
                if (controller.selectedTabIndex.value == 0) {
                  return ProductDetailsViewBody(
                    quantity: _quantity,
                    product: product,
                    storeImage: product.storeImage,
                    onQuantityChanged: (qty) async {
                      setState(() => _quantity = qty);
                      controller.updateQuantity(qty);
                      await _saveQuantity(qty);
                    },
                  );
                } else {
                  return ProductRatingsView(productId: product.id);
                }
              }),
            ),

            // Bottom action: add/remove cart button
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Obx(() {
                if (cartController.isLoading.value) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
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
                    ),
                  );
                }
                return Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(
                      cartController.isInCart.value
                          ? Icons.remove_circle_outline
                          : Icons.shopping_cart_outlined,
                      color: cartController.isInCart.value
                          ? Colors.red
                          : const Color(0xFF1548C7),
                      size: 30,
                    ),
                    onPressed: () => _toggleCart(_quantity),
                  ),
                );
              }),
            ),

            Text((product.price * _quantity).toString())
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
    Key? key,
    required this.product,
    required this.onQuantityChanged,
    required this.storeImage,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        // عرض تقييم ومعلومات المتجر
        RatingAndStoreInfo(
          rating: 0,
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
