import 'package:elbess/core/constants/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Favoritecard extends StatelessWidget {
  const Favoritecard({
    super.key,
    required this.img,
    required this.prdctname,
    required this.brand,
    required this.price,
    required this.category,
    this.onRemoveTap,
  });

  final String img;
  final String prdctname;
  final String brand;
  final String price;
  final String category;
  final VoidCallback? onRemoveTap;

  String _normalizedAssetPath(String path) {
    return path
        .replaceFirst('assets/images/', 'assets/Images/')
        .replaceFirst('assets/icons/', 'assets/icons/');
  }

  String _resolveImageUrl(String rawPath) {
    final trimmed = rawPath.trim();

    if (trimmed.isEmpty) {
      return '';
    }

    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }

    if (trimmed.startsWith('/')) {
      final host = kIsWeb
          ? 'http://localhost:5000'
          : defaultTargetPlatform == TargetPlatform.android
              ? 'http://10.0.2.2:5000'
              : 'http://localhost:5000';
      return '$host$trimmed';
    }

    if (trimmed.startsWith('uploads/')) {
      final host = kIsWeb
          ? 'http://localhost:5000'
          : defaultTargetPlatform == TargetPlatform.android
              ? 'http://10.0.2.2:5000'
              : 'http://localhost:5000';
      return '$host/$trimmed';
    }

    if (trimmed.startsWith('assets/')) {
      return _normalizedAssetPath(trimmed);
    }

    if (!trimmed.contains('/') && !trimmed.contains('\\')) {
      return _normalizedAssetPath('assets/Images/clothes/$trimmed');
    }

    return trimmed;
  }

  Widget _buildImage(String rawPath) {
    final resolvedPath = _resolveImageUrl(rawPath);
    if (resolvedPath.isEmpty) {
      return const Center(
        child: Icon(Icons.image_not_supported_outlined, color: Colors.grey),
      );
    }

    if (resolvedPath.startsWith('assets/')) {
      return Image.asset(
        resolvedPath,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const Center(
          child: Icon(Icons.image_not_supported_outlined, color: Colors.grey),
        ),
      );
    }

    return Image.network(
      resolvedPath,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => const Center(
        child: Icon(Icons.image_not_supported_outlined, color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final scale = (cardWidth / 170).clamp(0.88, 1.12);
        final imageHeight = cardWidth * 1;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(8 * scale),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16 * scale),
            border: Border.all(color: const Color(0xFFE4E4E4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Container(
                    height: imageHeight,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F4F4),
                      borderRadius: BorderRadius.circular(14 * scale),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10* scale),
                      child: _buildImage(img),
                    ),
                  ),
                  Positioned(
                    top: 8 * scale,
                    right: 8 * scale,
                    child: GestureDetector(
                      onTap: onRemoveTap,
                      child: Container(
                        height: 26 * scale,
                        width: 26 * scale,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.favorite,
                          size: 16 * scale,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 8 * scale,
                    bottom: 8 * scale,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 7 * scale,
                        vertical: 2 * scale,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20 * scale),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: const Color(0xFF6A6A6A),
                          fontSize: 10 * scale,
                          fontFamily: 'medium',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12 * scale),
              Text(
                brand.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color(0xFF8A8A8A),
                  fontSize: 10 * scale,
                  fontFamily: 'semi',
                  letterSpacing: 0.6,
                ),
              ),
              SizedBox(height: 3 * scale),
              Text(
                prdctname,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16 * scale,
                  height: 1.1,
                  fontFamily: 'semi',
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8 * scale),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      price,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 18 * scale,
                        fontFamily: 'semi',
                      ),
                    ),
                  ),
                  Icon(
                    Icons.add,
                    color: AppColors.primary,
                    size: 20 * scale,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
