import 'package:flutter/material.dart';


// Product Description Component
class ProductDescription extends StatelessWidget {
  final String title;
  final String description;
  //final String additionalInfo;
  
  const ProductDescription({
    Key? key,
    required this.title,
    required this.description,
    //required this.additionalInfo,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1548c7),
          ),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: const TextStyle(fontSize: 16),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 8),
        // Text(
        //   additionalInfo,
        //   style: const TextStyle(fontSize: 16),
        //   textAlign: TextAlign.right,
        // ),
      ],
    );
  }
}