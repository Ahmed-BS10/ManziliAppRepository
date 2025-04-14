import 'package:flutter/material.dart';
import 'AnimatedCounter.dart';

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
          border: Border.all(color: const Color(0xFF1548c7)),
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xFF1548c7)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // العدد المتحرك للسعر مع تأثير حركة سلس
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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





class AnimatedCounter extends StatelessWidget {
  final double value;
  final Duration duration;
  final TextStyle style;

  const AnimatedCounter({
    Key? key,
    required this.value,
    required this.duration,
    required this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value),
      duration: duration,
      builder: (context, animatedValue, child) {
        return Text(
          animatedValue.toStringAsFixed(2),
          style: style,
        );
      },
    );
  }
}
