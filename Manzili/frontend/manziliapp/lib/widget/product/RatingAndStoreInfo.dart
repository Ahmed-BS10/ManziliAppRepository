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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFF4F4F4), width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 4),
              Text(
                rating.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: Text(
                storeName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFF0047FF),
                child: Image.network('http://man.runasp.net$storeImage'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
