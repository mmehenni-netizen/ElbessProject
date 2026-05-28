import 'package:flutter/material.dart';
import 'image_utils.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({super.key, required this.rawPath});

  final String rawPath;

  @override
  Widget build(BuildContext context) {
    final resolvedPath = resolveImageUrlNormalized(rawPath);

    if (resolvedPath.isEmpty) {
      return const Icon(
        Icons.image_not_supported_outlined,
        size: 72,
        color: Colors.grey,
      );
    }

    if (resolvedPath.startsWith('assets/')) {
      return Image.asset(
        resolvedPath,
        height: MediaQuery.sizeOf(context).height * 0.6,
        width: MediaQuery.sizeOf(context).width * 0.6,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const Icon(
          Icons.image_not_supported_outlined,
          size: 72,
          color: Colors.grey,
        ),
      );
    }

    return Image.network(
      resolvedPath,
      height: MediaQuery.sizeOf(context).height * 0.6,
      width: MediaQuery.sizeOf(context).width * 0.6,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => const Icon(
        Icons.image_not_supported_outlined,
        size: 72,
        color: Colors.grey,
      ),
    );
  }
}
