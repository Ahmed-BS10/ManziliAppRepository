import 'package:flutter/material.dart';


// Product Description Component
class ProductDescription extends StatelessWidget {
  final String title;
  final String description;
  //final String additionalInfo;
  
  const ProductDescription({
    super.key,
    required this.title,
    required this.description,
    //required this.additionalInfo,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 15),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1548c7),
            ),
            textAlign: TextAlign.right,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.only(right: 15),
          child: Text(
            description,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.right,
          ),
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