import 'package:flutter/material.dart';

class SelectableStars extends StatelessWidget {
  const SelectableStars({super.key, required this.rating, required this.onTap});

  final int rating;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        final isFilled = starValue <= rating;

        return IconButton(
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
          onPressed: () => onTap(starValue),
          icon: Icon(
            isFilled ? Icons.star_rounded : Icons.star_border_rounded,
            color: Colors.amber,
            size: 24,
          ),
        );
      }),
    );
  }
}
