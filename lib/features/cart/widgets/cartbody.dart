
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
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.03,),
              Center(
                child: Text(
                  "My Cart",
                  style: TextStyle(fontFamily: "bold", fontSize: 25),
                ),
              ),
              Gap(15),
              ...List.generate(
                3,
                (index) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: Cartitem(
                    img: "assets/Images/clothes/item1.png",
                    prdctname: "SweetShirt",
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
  
