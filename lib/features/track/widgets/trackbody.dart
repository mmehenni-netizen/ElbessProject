import 'package:elbess/core/constants/colors.dart';
import 'package:elbess/features/track/widgets/ordertrack.dart';
import 'package:elbess/features/track/widgets/track_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class Trackbody extends StatelessWidget {
  const Trackbody({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            
            children: [
               SizedBox(height:MediaQuery.of(context).size.height * 0.07),
              const Text(
                'Order Tracking',
                style: TextStyle(fontFamily: "semi", color: Colors.black, fontSize: 20),
              ),
              const SizedBox(height: 8),
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