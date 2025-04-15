import 'package:flutter/material.dart';
import 'package:manziliapp/model/review.dart';
import 'add_review_view.dart';

class ReviewsView extends StatelessWidget {
  const ReviewsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Rating summary section
          const RatingSummarySection(),

          // Reviews list section
          const Expanded(
            child: ReviewsListSection(),
          ),

          // Add review button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddReviewView(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1548C7),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'أعطي لنا تقييمك',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RatingSummarySection extends StatelessWidget {
  const RatingSummarySection({Key? key}) : super(key: key);

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
              Expanded(
                child: Column(
                  children: [
                    _buildRatingBar(5, 4),
                    _buildRatingBar(4, 2),
                    _buildRatingBar(3, 1),
                    _buildRatingBar(2, 0),
                    _buildRatingBar(1, 0),
                  ],
                ),
              ),

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
                        const TextSpan(
                          text: '4.2',
                          style: TextStyle(
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
                    children: const [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      Icon(Icons.star_half, color: Colors.amber, size: 20),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '7 مراجعات',
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

class ReviewsListSection extends StatelessWidget {
  const ReviewsListSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Review> reviews = [
      Review(
        id: '1',
        userName: 'Ahmed Salah',
        userImage:
            'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-UU5E4nyA6JLcVKlNsYZWEfiz3EOZOk.png',
        rating: 5,
        date: '30/3/25',
      ),
      Review(
        id: '2',
        userName: 'Ahmed Salah',
        userImage:
            'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-UU5E4nyA6JLcVKlNsYZWEfiz3EOZOk.png',
        rating: 5,
        date: '30/3/25',
      ),
      // Add more reviews as needed
    ];

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: reviews.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User image
              CircleAvatar(
                radius: 27,
                backgroundImage: const NetworkImage(
                  'assets/images/Guy.jpg',
                ),
                onBackgroundImageError: (_, __) {},
                child: const Icon(Icons.person, color: Colors.grey),
              ),
              const SizedBox(width: 15),

              // Review content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User name and rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          review.userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < review.rating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 16,
                            );
                          }),
                        ),
                      ],
                    ),

                    // Review date
                    Text(
                      review.date,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
