import 'package:flutter/material.dart';


// Quantity Button Component
class QuantityButton extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;
  
  const QuantityButton({
    super.key,
    required this.icon,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          color: Color(0xFF1548c7),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            icon,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}