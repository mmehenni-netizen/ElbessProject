import 'package:elbess/core/constants/colors.dart';
import 'package:elbess/core/network/network_config.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ItemCard extends StatefulWidget {
  const ItemCard({
    super.key,
    required this.imagePath,
    required this.storeName,
    required this.itemName,
    required this.price,
    required this.rating,
    required this.isFavorite,
    this.onTap,
    this.onFavoriteTap,
  });
  final String imagePath;
  final String storeName;
  final String itemName;
  final String price;
  final String rating;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  String _normalizedAssetPath(String path) {
    return path
        .replaceFirst('assets/images/', 'assets/Images/')
        .replaceFirst('assets/icons/', 'assets/icons/');
  }

  String _resolveImageUrl(String rawPath) {
    return resolveNetworkUrl(rawPath);
  }

  Widget _buildFallbackImage() {
    return Image.asset(
      'assets/Images/clothes/item1.png',
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Center(
          child: Icon(Icons.image_not_supported_outlined, color: Colors.grey),
        );
      },
    );
  }

  Widget _buildProductImage(String rawPath) {
    final trimmed = rawPath.trim();

    if (trimmed.isEmpty) {
      return _buildFallbackImage();
    }

    final resolved = _resolveImageUrl(trimmed);

    if (resolved.startsWith('http')) {
      return Image.network(
        resolved,
        fit: BoxFit.contain,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackImage();
        },
      );
    }

    // ✅ Case 2: Asset Image
    return Image.asset(
      _normalizedAssetPath(trimmed),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return _buildFallbackImage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
        Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.48,
              height: MediaQuery.of(context).size.height * 0.17,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                // ignore: deprecated_member_use
                color: Colors.grey.withOpacity(0.15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: _buildProductImage(widget.imagePath),
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: GestureDetector(
                onTap: widget.onFavoriteTap,
                child: widget.isFavorite
                    ? Icon(Icons.favorite, color: Colors.red, size: 18)
                    : Icon(
                        Icons.favorite_border_outlined,
                        color: Colors.grey,
                        size: 18,
                      ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Row(
                children: [
                  Text(
                    widget.rating,
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: "semi",
                      color: Colors.black,
                    ),
                  ),

                  Icon(Icons.star, color: Color(0xffFFAC33), size: 12),
                ],
              ),
            ),
          ],
        ),
        Gap(3),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Text(
                "from",
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "medium",
                  color: Colors.grey,
                ),
              ),
              Gap(2),
              Text(
                widget.storeName,
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: "semi",
                  color: Color(0xffDDB892),
                ),
              ),
            ],
          ),
        ),
        Gap(5),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.itemName,
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: "semi",
                  color: Colors.black,
                ),
              ),

              Text(
                widget.price,
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: "semi",
                  color: AppColors.primary,
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
