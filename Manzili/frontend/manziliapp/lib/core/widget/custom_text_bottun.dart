import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    this.onPressed,
    required this.name,
    required this.fontColor,
    required this.backColor,
    this.radius = 18,
  });

  final double? radius;
  final VoidCallback? onPressed;
  final String name;
  final Color fontColor;
  final Color backColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 51,
      width: 298,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            iconColor: Colors.black12,
            backgroundColor: backColor,
            foregroundColor: fontColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius!),
                side: const BorderSide(
                  color: Colors.black,
                  width: 1,
                ))),
        child: Text(
          name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
