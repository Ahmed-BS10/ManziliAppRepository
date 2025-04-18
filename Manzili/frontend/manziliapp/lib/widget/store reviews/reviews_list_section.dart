import 'package:flutter/material.dart';
import 'package:manziliapp/model/review.dart';

class ReviewsListSection extends StatelessWidget {
  const ReviewsListSection({Key? key, required this.reviews}) : super(key: key);

  final List<Review> reviews;

  @override
  Widget build(BuildContext context) {
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
                backgroundImage: NetworkImage(
                  "http://man.runasp.net/${review.userImage}",
                ),
                onBackgroundImageError: (_, __) {},
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
                              index < review.valueRate
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
