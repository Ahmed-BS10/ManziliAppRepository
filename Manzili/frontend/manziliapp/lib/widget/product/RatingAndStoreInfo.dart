import 'package:flutter/material.dart';

// Rating and Store Info Component
class RatingAndStoreInfo extends StatelessWidget {
  final int rating;
  final String storeName;
  final String storeImage;

  const RatingAndStoreInfo({
    super.key,
    required this.rating,
    required this.storeName, required this.storeImage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 20),
            const SizedBox(width: 4),
            Text(rating.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        Row(
          children: [
            Text(storeName,
                style: const TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 15,
              backgroundColor: const Color(0xFF0047FF),
              child: Image.network('http://man.runasp.net$storeImage'),
            ),
          ],
        ),
      ],
    );
  }
}
