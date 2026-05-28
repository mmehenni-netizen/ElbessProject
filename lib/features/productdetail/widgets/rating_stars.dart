import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({super.key, required this.rating});

  final int rating;

  @override
  Widget build(BuildContext context) {
    final clampedRating = rating.clamp(0, 5);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final isFilled = index < clampedRating;

        return Icon(
          isFilled ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 15,
        );
      }),
    );
  }
}
