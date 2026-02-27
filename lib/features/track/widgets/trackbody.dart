
import 'package:elbess/features/track/widgets/track_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';


class Trackbody extends StatelessWidget {
  const Trackbody({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Gap(35),
              Center(
                child: Text(
                  "Order Tracking",
                  style: TextStyle(fontFamily: "semi", fontSize: 38 / 2),
                ),
              ),
              Gap(10),
              ...List.generate(
                3,
                (index) => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: TrackCard(
                    imagePath: "assets/Images/clothes/item1.png",
                    itemName: 'Baggy Fit Jeans',
                    price: '620 DZ',
                    size: 'L',
                    color: 'Black',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}