import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manziliapp/core/globals/globals.dart';
import 'package:manziliapp/view/cart_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// A reusable circular image widget with translation, border, loading, and error handling.
class TranslatedStoreImage extends StatelessWidget {
  /// Raw image path or full URL. If it doesn’t start with 'http', it's prefixed by [baseUrl].
  final String? imageUrl;
  final double size;
  final Offset offset;
  final Color borderColor;

  /// Border width used when there is no image (placeholder state).
  final double placeholderBorderWidth;
  final String baseUrl;
  final Widget placeholder;

  const TranslatedStoreImage({
    super.key,
    this.imageUrl,
    this.size = 100.0,
    this.offset = const Offset(10, 15),
    this.borderColor = const Color(0xFF1548C7),
    this.placeholderBorderWidth = 4.4,
    this.baseUrl = 'http://man.runasp.net/',
    this.placeholder = const Icon(
      Icons.storefront_outlined,
      size: 48,
      color: Colors.grey,
    ),
  });

  @override
  Widget build(BuildContext context) {
    final hasUrl = imageUrl?.isNotEmpty == true;
    final fullUrl = hasUrl && imageUrl!.startsWith('http')
        ? imageUrl!
        : '$baseUrl${imageUrl ?? ''}';
    // Use border only when showing placeholder (no image or network error)
    final borderWidth = hasUrl ? 0.0 : placeholderBorderWidth;

    return Transform.translate(
      offset: offset,
      child: SizedBox(
        width: size,
        height: size,
        child: ClipOval(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: borderWidth),
            ),
            child: hasUrl
                ? Image.network(
                    fullUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (ctx, child, progress) {
                      if (progress == null) return child;
                      return Center(
                        child: SizedBox(
                          width: size * 0.5,
                          height: size * 0.5,
                          child: const CircularProgressIndicator(),
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => _buildPlaceholder(),
                  )
                : _buildPlaceholder(),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(child: placeholder);
  }
}

/// Header widget for a store page: back button, store logo, and cart icon.
class StoreHeader extends StatelessWidget {
  final int storeId;
  final int userId;
  final String? imageUrl;
  final int deliveryFee;

  const StoreHeader({
    super.key,
    this.imageUrl,
    required this.storeId,
    required this.userId,
    required this.deliveryFee,
  });

  Future<CartCardModel?> _fetchCartData(int userId, int storeId) async {
    try {
      final url = Uri.parse(
          'http://man.runasp.net/api/Cart/GetCartByUserAndStoreAsync?userId=$userId&storeId=$storeId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        if (jsonBody['isSuccess'] == true) {
          final data = jsonBody['data'];
          return CartCardModel(
            cartId: data['cartId'],
            userId: data['userId'],
            storeId: data['storeId'],
            note: data['note'],
            getProductCard: (data['getProductCardDtos'] as List)
                .map((item) => GetProductCard(
                      productId: item['productId'],
                      name: item['name'],
                      imageUrl: item['imageUrl'],
                      price: item['price'],
                      quantity: item['quantity'],
                    ))
                .toList(),
          );
        }
      }
    } catch (e) {
      debugPrint('Error fetching cart data: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),

          // Store logo
          Container(
            margin: const EdgeInsets.only(left: 35),
            child: TranslatedStoreImage(
              imageUrl: imageUrl,
              size: 100,
              offset: const Offset(10, 15),
            ),
          ),

          // Shopping cart
          Transform.translate(
            offset: const Offset(0, 10),
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Color(0xFF1548C7),
                size: 38,
              ),
              onPressed: () async {
                final cartData = await _fetchCartData(userId, storeId);
                if (cartData != null) {
                  Get.to(() => CartView(
                      deliveryFee: deliveryFee, cartCardModel: cartData));
                } else {
                  Get.snackbar('Error', 'Failed to load cart data');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
