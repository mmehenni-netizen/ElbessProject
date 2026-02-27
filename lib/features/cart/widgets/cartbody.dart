
import 'package:elbess/features/cart/widgets/cartitem.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Cartbody extends StatelessWidget {
   Cartbody({super.key});

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
                  "My Cart",
                  style: TextStyle(fontFamily: "semi", fontSize: 38 / 2),
                ),
              ),
              Gap(10),
              ...List.generate(
                6,
                (index) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Cartitem(
                    img: "assets/Images/clothes/item1.png",
                    prdctname: "Nike Air Max 270 React",
                    size: "M",
                    color: "Black",
                    price: 150.00,
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
  
