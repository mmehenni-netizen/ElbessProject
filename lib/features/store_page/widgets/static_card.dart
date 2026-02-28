import 'package:elbess/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class StaticCard extends StatefulWidget {
  const StaticCard({super.key, required this.title, required this.data, required this.imagePath});
  final String title ;
  final String data;
  final String imagePath ; 

  @override
  State<StaticCard> createState() => _StaticCardState();
}

class _StaticCardState extends State<StaticCard> {
  @override
  Widget build(BuildContext context) {
    return   Container(
            width: MediaQuery.sizeOf(context).width*0.35,
            height: MediaQuery.sizeOf(context).height*0.09,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.primary, width: 1)
              
            ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.sizeOf(context).height*0.01,),
             
             Text(widget.title, style: TextStyle(fontFamily: "semi", color: Colors.black, fontSize: 15)),
             Spacer(),
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Image.asset(widget.imagePath,height: MediaQuery.sizeOf(context).height*0.03,),
               Gap(5),
                Text(" ${widget.data}", style: TextStyle(fontFamily: "semi", color: AppColors.primary, fontSize: 14)),
                
                
              ],
             ),
          Gap(5),
            ],
          ),
          );
  }
}