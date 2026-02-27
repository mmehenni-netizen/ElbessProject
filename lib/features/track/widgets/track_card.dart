import 'package:elbess/core/constants/colors.dart';
import 'package:elbess/features/track/widgets/ordertrack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TrackCard extends StatefulWidget {
  const TrackCard({super.key, required this.imagePath, required this.itemName, required this.price, required this.size, required this.color});
  final String imagePath ;
  final String itemName ;
  final String price ;      
  final String size ;
  final String color ;

  @override
  State<TrackCard> createState() => _TrackCardState();
}

class _TrackCardState extends State<TrackCard> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primary, width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
             Padding(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
             child:  Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: MediaQuery.of(context).size.height * 0.15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  // ignore: deprecated_member_use
                  color: Colors.grey.withOpacity(0.15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(widget.imagePath,height: MediaQuery.of(context).size.height * 0.5,),
                  ),
                ),
                Gap(10),
                 Expanded(
                   child: Column(
                 mainAxisAlignment: MainAxisAlignment.start ,
                 crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 7,),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.itemName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontFamily: "semi", color: Colors.black, fontSize: 16),
                          ),
                        ),
                        Gap(8),
                        Text(
                          widget.price,
                          style: TextStyle(fontFamily: "bold", color: AppColors.primary, fontSize: 12),
                        ),
                      ],
                    ),
                   const SizedBox(height: 7,),
                     Row(
                      children:[
                        
                        Text("size :", style: TextStyle(fontFamily: "semi", color: Colors.grey, fontSize: 16),),
                        Gap(3),
                       Text(widget.size, style: TextStyle(fontFamily: "semi",fontWeight: FontWeight.w600, color: Colors.black, fontSize: 15),),
                      ],
                    ),
                     Row(
                      children:[
                        
                        Text("color :", style: TextStyle(fontFamily: "semi", color: Colors.grey, fontSize: 16),),
                        Gap(3),
                       Text(widget.color, style: TextStyle(fontFamily: "semi",fontWeight: FontWeight.w600, color: Colors.black, fontSize: 15),),
                      ],
                    ),
                
                
                
                  ],
                 ),
                 )
                ],
              ),),
          Gap(5),
          Padding(padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.03,
                width: MediaQuery.of(context).size.width * 0.2,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(child: Text("time line", style: TextStyle(fontFamily: "semi", color: Colors.grey, fontSize: 10),)),
              ),
              Row(
               children:List.generate(15, (index){
                return Container(
                  height: 5,
                  width:10,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle
                  ),
                );
               }),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.03,
                width: MediaQuery.of(context).size.width * 0.2,
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Color(0xff8A5A44).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon( CupertinoIcons.check_mark_circled_solid, size: 12, color: AppColors.primary,),
                    Gap(2),
                    Center(child: Text("in progress", style: TextStyle(fontFamily: "semi", color: AppColors.primary, fontSize: 8),))
      
                  ],
                ),
              ),
           
            ],
           ) ,
          ),
           Column(
            children: List.generate(4, (index){
              if(index == 0){
                return const Ordertrack(status: 'Order Confirmed', description: 'Order placed and confirmed', time: '17,february 8:24', isdone: true);
              }
              else if(index == 1){
                return const Ordertrack(status: 'Order Shipped', description: 'Your order has been shipped', time: '17,february 9:24', isdone: false);
              }
              else if(index == 2){
                return const Ordertrack(status: 'In Transit', description: 'Your order is in transit', time: '18,february 10:24', isdone: false);
              }
              else{
                return const Ordertrack(status: 'Delivered', description: 'Your order has been delivered', time: '19,february 11:24', isdone: false, showConnector: false);
              }
             }
           ))
            ],
          ),
        ),
    );
  }
}