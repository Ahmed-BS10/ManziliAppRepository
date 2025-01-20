import 'package:flutter/material.dart';

class CustomTextButtonIcon extends StatelessWidget {
  const CustomTextButtonIcon({
    super.key,
    required this.title,
    required this.icon,
  });

  final String title;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        // Handle button press action
      },
      icon: Icon(
        Icons.apple,
        color: Colors.red, // Customize icon color
        size: 24,
      ),
      label: Text(
        title,
        style: TextStyle(fontSize: 16),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Color(0xF4F4F4), // Text and icon color

        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        fixedSize: Size(344, 49),
      ),
    );
  }
}
