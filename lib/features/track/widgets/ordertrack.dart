import 'package:elbess/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Ordertrack extends StatefulWidget {
  const Ordertrack({
    super.key,
    required this.status,
    required this.description,
    required this.time,
    required this.isdone,
    this.showConnector = true,
  });
  final String status;
  final String description;
  final String time;
  final bool isdone;
  final bool showConnector;

  @override
  State<Ordertrack> createState() => _OrdertrackState();
}

class _OrdertrackState extends State<Ordertrack> {
  @override
  Widget build(BuildContext context) {
    return  Padding(padding: EdgeInsets.symmetric(horizontal: 25),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(10),
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          
           Row(
            children: [
      Container(
            height: MediaQuery.of(context).size.height * 0.03,
            width: MediaQuery.of(context).size.width * 0.06,
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: AppColors.primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(child: Image.asset("assets/icons/order.png", height: 12, width: 12),),
           ),
            Gap(5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.status, style: TextStyle(fontFamily: "semi", color: Colors.black, fontSize: 10),),
                Text(widget.description, style: TextStyle(fontFamily: "semi", color: Colors.grey, fontSize: 8),),
              ],
            )
            
           ],
           ),
           Text(widget.time, style: TextStyle(fontFamily: "semi", color: Colors.grey, fontSize: 8),)  
            
         
          ],
         ) ,
        if (widget.showConnector) ...[
          Gap(6),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              height: 20,
              width: 2,
              decoration: BoxDecoration(
                color: widget.isdone ? AppColors.primary : Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
          ],
        )
        );
  }
}