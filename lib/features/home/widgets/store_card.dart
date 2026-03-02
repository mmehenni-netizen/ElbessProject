import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class StoreCard extends StatefulWidget {
  // ignore: non_constant_identifier_names
  const StoreCard({super.key, required this.store_name, required this.store_image});
  // ignore: non_constant_identifier_names
  final String store_name;
  // ignore: non_constant_identifier_names
  final String store_image;

  @override
  State<StoreCard> createState() => _StoreCardState();
}

class _StoreCardState extends State<StoreCard> {
  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        
          Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[100],
        
      ),
      child:Image.asset(widget.store_image,width: MediaQuery.of(context).size.width * 0.15,)
    ),
    Gap(6),
     Text(widget.store_name,style: TextStyle(fontSize: 12, fontFamily: "medium",fontWeight: FontWeight.w500,color: Colors.black),)
      ],
    );
  }
}