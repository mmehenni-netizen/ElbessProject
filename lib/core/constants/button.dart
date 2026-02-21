import 'package:elbess/core/constants/colors.dart';
import 'package:elbess/core/utils/size_config.dart';
import 'package:flutter/material.dart';
class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.text, required this.onPressed});

  final String text;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
         height: 57,
          width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
         
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
        text,
        style: TextStyle(
      color: Colors.white,
      fontSize: 15,
         
      fontFamily: 'semi'
        ),
      ),
        ),
      ),
    );
  }
}
