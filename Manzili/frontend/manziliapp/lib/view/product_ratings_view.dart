import 'package:flutter/material.dart';
import 'package:manziliapp/model/review_product.dart';
import 'package:manziliapp/widget/product/CommentButton.dart';
import 'package:manziliapp/widget/product/RatingHeader.dart';
import 'package:manziliapp/widget/product/ReviewItem.dart';

class ProductRatingsView extends StatelessWidget {
  final List<ReviewProduct> reviews;

  const ProductRatingsView({
    Key? key,
    required this.reviews,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        // Overall Rating
        const RatingHeader(totalReviews: 3),

        const SizedBox(height: 24),

        // Reviews List
        ...reviews.map((review) => ReviewItem(review: review)).toList(),

        const SizedBox(height: 24),

        // Comment Input
        const CommentButton(),

        const SizedBox(height: 32),
      ],
    );
  }
}
