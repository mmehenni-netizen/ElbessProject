import 'package:elbess/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Favoritecard extends StatelessWidget {
  const Favoritecard({
    super.key,
    required this.img,
    required this.prdctname,
    required this.brand,
    required this.price,
    required this.category,
  });

  final String img;
  final String prdctname;
  final String brand;
  final String price;
  final String category;

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
                      child: Image.asset(img, fit: BoxFit.contain),
                    ),
                  ),
                  Positioned(
                    top: 8 * scale,
                    right: 8 * scale,
                    child: Container(
                      height: 26 * scale,
                      width: 26 * scale,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite_border_rounded,
                        size: 16 * scale,
                        color: AppColors.primary,
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
