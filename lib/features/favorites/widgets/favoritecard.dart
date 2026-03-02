import 'package:elbess/core/constants/colors.dart';
import 'package:elbess/core/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Favoritecard extends StatelessWidget {
  const Favoritecard({
    super.key,
    required this.img,
    required this.prdctname,
    required this.brand,
    required this.price,
    required this.rating,
  });
  final String img;
  final String prdctname;
  final String brand;
  final String price;
  final String rating;
  @override
  Widget build(BuildContext context) {
    final double screenWidth = SizeConfig.screenWidth!;
    final double screenHeight = SizeConfig.screenHeight!;
    final double hScale = (screenWidth / 375).clamp(0.9, 1.15);
    final double vScale = (screenHeight / 812).clamp(0.9, 1.1);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10 * hScale),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double cardWidth = constraints.maxWidth;
          final double imageWidth = cardWidth * 0.36;

          return Container(
        height: screenHeight * 0.20,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(20 * hScale),
        ),
        child: Row(
          children: [
            Gap(8 * hScale),
            SizedBox(
              width: imageWidth,
              child: Stack(
                children: [
                  Container(
                    width: imageWidth,
                    height: screenHeight * 0.16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20 * hScale),
                      // ignore: deprecated_member_use
                      color: Colors.grey.withOpacity(0.15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20 * hScale),
                      child: Image.asset(img, fit: BoxFit.contain),
                    ),
                  ),
                  Positioned(
                    top: 8 * vScale,
                    right: 10 * hScale,
                    child: Row(
                      children: [
                        Text(
                          rating,
                          style: TextStyle(
                            fontSize: 10 * hScale,
                            fontFamily: "semi",
                            color: Colors.black,
                          ),
                        ),
                        Icon(
                          Icons.star,
                          color: Color(0xffFFAC33),
                          size: 12 * hScale,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Gap(10 * hScale),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    prdctname,
                    style: TextStyle(fontSize: 14 * hScale, fontFamily: "semi"),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Gap(45 * vScale),
                  RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 14 * hScale,
                        fontFamily: "regular",
                      ),
                      children: [
                        TextSpan(
                          text: "from ",
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextSpan(
                          text: brand,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontFamily: "semi",
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(12 * vScale),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 14 * hScale,
                      fontFamily: "semi",
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            Gap(8 * hScale),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10 * vScale),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.favorite, color: Colors.red, size: 26 * hScale),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10 * hScale,
                      vertical: 5 * vScale,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20 * hScale),
                    ),
                    child: Text(
                      "Buy Now",
                      style: TextStyle(
                        fontSize: 9 * hScale,
                        fontFamily: "semi",
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Gap(8 * hScale),
          ],
        ),
      );
        },
      ),
    );
  }
}
