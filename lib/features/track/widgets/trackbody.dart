import 'package:elbess/core/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class Trackbody extends StatelessWidget {
  const Trackbody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Order Tracking', style: TextStyle(fontFamily: "semi", color: Colors.black)),
      centerTitle: true,
      ),
      body: Padding(
  padding: EdgeInsets.symmetric(horizontal: 15),
  child:  Container(
        height: MediaQuery.of(context).size.height * 0.4,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primary, width: 1),
        ),
        child: Column(
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
                color: Colors.grey.withOpacity(0.15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset("assets/Images/clothes/item2.png",height: MediaQuery.of(context).size.height * 0.5,),
                ),
              ),
              Gap(10),
               Column(
               mainAxisAlignment: MainAxisAlignment.start ,
               crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 7,),
                  Row(
                  
                     
                    children: [
                      
                      Text("baggy fit  jean", style: TextStyle(fontFamily: "semi", color: Colors.black, fontSize: 16),),
                      Gap(30),
                     Text("620 Dz", style: TextStyle(fontFamily: "semi",fontWeight: FontWeight.w600, color: Colors.black, fontSize: 10),),
                    ],
                  ),
                 const SizedBox(height: 7,),
                   Row(
                    children:[
                      
                      Text("size :", style: TextStyle(fontFamily: "semi", color: Colors.grey, fontSize: 16),),
                      Gap(3),
                     Text("L", style: TextStyle(fontFamily: "semi",fontWeight: FontWeight.w600, color: Colors.black, fontSize: 15),),
                    ],
                  ),
                   Row(
                    children:[
                      
                      Text("color :", style: TextStyle(fontFamily: "semi", color: Colors.grey, fontSize: 16),),
                      Gap(3),
                     Text("Black", style: TextStyle(fontFamily: "semi",fontWeight: FontWeight.w600, color: Colors.black, fontSize: 15),),
                    ],
                  ),
              
              
              
                ],
               )
              ],
            ),),
        Gap(5),
        Padding(padding: EdgeInsets.symmetric(horizontal: 25),
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
        Padding(padding: EdgeInsets.symmetric(horizontal: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset("assets/icons/order.svg", color: AppColors.primary,height: 100,),
           Container(
            height: MediaQuery.of(context).size.height * 0.03,
            width: MediaQuery.of(context).size.width * 0.06,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(child: SvgPicture.asset("assets/icons/order.svg", color: AppColors.primary),),
           )
            
            
         
          ],
         ) ,
        )
          ],
        ),
      ),
),
    );
  }
}