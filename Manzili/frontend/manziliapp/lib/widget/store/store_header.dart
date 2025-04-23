import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manziliapp/core/globals/globals.dart';
import 'package:manziliapp/view/cart_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StoreHeader extends StatelessWidget {
  const StoreHeader(
      {Key? key,
      required this.imageUrl,
      required this.storeId,
      required this.userId})
      : super(key: key);

  final int storeId;
  final int userId;
  final String imageUrl;

  Future<CartCardModel?> _fetchCartData(int userId, int storeId) async {
    try {
      final url = Uri.parse(
          'http://man.runasp.net/api/Cart/GetCartByUserAndStoreAsync?userId=$userId&storeId=$storeId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['isSuccess'] == true) {
          final data = responseData['data'];
          final cart = CartCardModel(
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
          return cart;
        }
      }
    } catch (e) {
      print('Error fetching cart data: $e');
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
          // Back button (إزاحة لليمين)
          Padding(
            padding: const EdgeInsets.only(left: 8.0), // إزاحة لليمين
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),

          //Store logo
          Transform.translate(
            offset: const Offset(10, 15),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xFF1548C7), width: 4),
              ),
              child: ClipOval(
                child: Image.network(
                  'http://man.runasp.net/${imageUrl}',
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) {
                    return const CircleAvatar(
                      backgroundColor: Colors.white,
                      child:
                          Icon(Icons.restaurant, color: Colors.amber, size: 35),
                    );
                  },
                ),
              ),
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
                  Get.to(() => CartView(cartCardModel: cartData));
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
