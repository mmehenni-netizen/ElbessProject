import 'package:elbess/core/constants/colors.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatefulWidget {
  const CategoryCard({super.key, required this.image, required this.name});
  final String image;
    final String name;

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return  Container(
          width: MediaQuery.of(context).size.width * 0.25,
          height: MediaQuery.of(   context).size.height * 0.04,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.primary, width: 1),
          ),
          child:Padding(padding: EdgeInsets.symmetric(horizontal: 8),
          child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
               Image.asset(widget.image,height: MediaQuery.of(context).size.height * 0.02,),
              Text(widget.name,style: TextStyle(fontSize: 12, fontFamily: "medium",color: AppColors.primary),),
             
            ],
          ),),
         );
  }
}