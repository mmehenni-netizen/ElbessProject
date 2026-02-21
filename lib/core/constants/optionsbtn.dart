import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class OptionsBtn extends StatefulWidget {
  const OptionsBtn({super.key, required this.continuee, required this.image});
  final String continuee;
  final String image;


  @override
  State<OptionsBtn> createState() => _OptionsBtnState();
}

class _OptionsBtnState extends State<OptionsBtn> {
  @override
  Widget build(BuildContext context) {
    return  Padding(padding: EdgeInsets.symmetric(horizontal: 20),
         child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Color(0xffE4E4E4),
                width: 1,
              )
             
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               Image.asset(widget.image,height: 25,),
                Gap(40),
               Text(widget.continuee,style: TextStyle(fontSize: 13,fontFamily: "semi"),)
              ],
            ),
          )
          );
  }
}