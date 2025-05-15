import 'package:flutter/material.dart';



class RatingBar extends StatelessWidget {
  final double initialRating;
  final Function(double) onRatingUpdate;

  const RatingBar({
    super.key,
    required this.initialRating,
    required this.onRatingUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < initialRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () {
            onRatingUpdate(index + 1.0);
          },
        );
      }),
    );
  }
}