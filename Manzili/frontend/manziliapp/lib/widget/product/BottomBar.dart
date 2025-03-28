import 'package:flutter/material.dart';

import 'AnimatedCounter.dart';



// Bottom Bar Component with price animation
class BottomBar extends StatelessWidget {
  final double price;
  final VoidCallback onAddToCart;
  
  const BottomBar({
    Key? key,
    required this.price,
    required this.onAddToCart,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xFF1548c7)),
          borderRadius: BorderRadius.circular(8),color: Color(0xFF1548c7)
        ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // This is the key change - we're using a proper animation that updates
          AnimatedCounter(
            value: price,
            duration: const Duration(milliseconds: 500),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          ElevatedButton.icon(
            onPressed: onAddToCart,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1548c7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text(
              'إضافة للسلة',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}