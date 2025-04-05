import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:manziliapp/view/cart_view.dart';

class StoreHeader extends StatelessWidget {
  const StoreHeader({Key? key}) : super(key: key);

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

          // Store logo
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
                child: Image.asset(
                  'assets/images/Rectangle 509.jpg',
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
              onPressed: () {
                Get.to(() => CartView());
              },
            ),
          ),
        ],
      ),
    );
  }
}
