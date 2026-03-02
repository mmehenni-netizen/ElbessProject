import 'package:elbess/core/constants/colors.dart';
import 'package:flutter/material.dart';

class OffersSlider extends StatefulWidget {
  const OffersSlider({super.key});

  @override
  State<OffersSlider> createState() => _OffersSliderState();
}

class _OffersSliderState extends State<OffersSlider> {
  int _currentPage = 0;

  final List<String> offerImages = [
    "assets/Images/offers_images/offer1.png",
    "assets/Images/offers_images/offer2.jpg",
    "assets/Images/offers_images/offer4.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
          child: PageView.builder(
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: offerImages.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                
                  child: Image.asset(
                    offerImages[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.red[100],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            'Image $index\nNot Found',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height:MediaQuery.of(context).size.height * 0.001),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            offerImages.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ?  MediaQuery.of(context).size.width * 0.08 : MediaQuery.of(context).size.width * 0.03,
              height: MediaQuery.of(context).size.height * 0.005,
              decoration: BoxDecoration(
                color: _currentPage == index ? AppColors.primary : Colors.grey,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        
      ],
    );
  }
}