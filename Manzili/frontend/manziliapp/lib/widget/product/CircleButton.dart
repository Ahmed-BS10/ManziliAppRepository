import 'package:flutter/material.dart';



// Circle Button Component
class CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  
  const CircleButton({
    Key? key,
    required this.icon,
    required this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            icon,
            size: 20,
          ),
        ),
      ),
    );
  }
}