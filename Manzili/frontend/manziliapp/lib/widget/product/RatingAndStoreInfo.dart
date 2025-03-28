import 'package:flutter/material.dart';



// Rating and Store Info Component
class RatingAndStoreInfo extends StatelessWidget {
  final double rating;
  final String storeName;
  
  const RatingAndStoreInfo({
    Key? key,
    required this.rating,
    required this.storeName,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 20),
            const SizedBox(width: 4),
            Text(rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        Row(
          children: [
            Text(storeName, style: const TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 15,
              backgroundColor: const Color(0xFF0047FF),
              child: const Icon(Icons.person, color: Colors.white, size: 18),
            ),
          ],
        ),
      ],
    );
  }
}