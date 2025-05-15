import 'package:flutter/material.dart';

class RatingSummarySection extends StatelessWidget {
  const RatingSummarySection(
      {super.key, required this.averageRating, required this.totalRatings});

  final double averageRating;
  final int totalRatings;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Title
          const Text(
            'التقييم',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1548C7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Rating summary
          Row(
            children: [
              // Rating distribution
              // Expanded(
              //   child: Column(
              //     children: [
              //       _buildRatingBar(5, 4),
              //       _buildRatingBar(4, 2),
              //       _buildRatingBar(3, 1),
              //       _buildRatingBar(2, 0),
              //       _buildRatingBar(1, 0),
              //     ],
              //   ),
              // ),

              // Vertical divider
              Container(
                height: 100,
                width: 1,
                color: Colors.grey.shade300,
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),

              // Average rating
              Column(
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: averageRating.toString(),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1548C7),
                          ),
                        ),
                        TextSpan(
                          text: '/5',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(5, (index) {
                      if (index < averageRating.floor()) {
                        return const Icon(Icons.star,
                            color: Colors.amber, size: 20);
                      } else if (index < averageRating) {
                        return const Icon(Icons.star_half,
                            color: Colors.amber, size: 20);
                      } else {
                        return const Icon(Icons.star_border,
                            color: Colors.amber, size: 20);
                      }
                    }),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    totalRatings.toString(),
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int starNumber, int count) {
    // Calculate percentage for bar width (max 80% of available space)
    final double percentage = count > 0 ? (count / 7) * 0.8 : 0.05;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$starNumber',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.star, color: Colors.amber, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Stack(
              children: [
                // Background bar
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                // Filled bar
                FractionallySizedBox(
                  widthFactor: percentage,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: Color(0xFF1548C7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
