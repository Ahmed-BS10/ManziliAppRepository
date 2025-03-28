import 'package:flutter/material.dart';
import 'package:manziliapp/model/review_product.dart';



// Review Item Component
class ReviewItem extends StatelessWidget {
  final ReviewProduct review;
  
  const ReviewItem({
    Key? key,
    required this.review,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                review.date,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              Row(
                children: [
                  Text(
                    review.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: const Color(0xFF1548c7),
                    child: const Icon(Icons.person, color: Colors.white, size: 18),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: List.generate(
              5,
              (index) => Icon(
                Icons.star,
                color: index < review.rating ? Colors.amber : Colors.grey.shade300,
                size: 18,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            review.comment,
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 16),
          const Divider(),
        ],
      ),
    );
  }
}