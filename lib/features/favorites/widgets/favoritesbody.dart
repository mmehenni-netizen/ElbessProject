import 'package:elbess/features/favorites/widgets/favoritecard.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Favoritesbody extends StatelessWidget {
  const Favoritesbody({super.key});

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
                  "My Favorites",
                  style: TextStyle(fontFamily: "semi", fontSize: 38 / 2),
                ),
              ),
              Gap(20),
              ...List.generate(
                6,
                (index) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Favoritecard(
                    img: "assets/Images/clothes/item1.png",
                    prdctname: "Nike Air Max 270 React",
                    brand: "Nike",
                    price: "\$150.00",
                    rating: "4.5",
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
