import 'package:elbess/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CatTexts extends StatefulWidget {
  const CatTexts({super.key, required this.isSelected, required this.category});
   final bool isSelected;
  final String category;
  @override
  State<CatTexts> createState() => _CatTextsState();
}

class _CatTextsState extends State<CatTexts> {
  @override
  Widget build(BuildContext context) {
    return  Column(
        children: [
           Text(widget.category, style: TextStyle(fontFamily: "medium", color:widget.isSelected ? AppColors.primary : Colors.grey, fontSize: 13)), 
          Gap(2),
          widget.isSelected ? Container(
            width: 20,
            height: 2,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(1),
            ),
          ) : SizedBox.shrink(),
        ],
       );
  }
}