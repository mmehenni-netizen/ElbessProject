
import 'package:elbess/core/constants/colors.dart';
import 'package:elbess/features/home/widgets/category_card.dart';
import 'package:elbess/features/home/widgets/item_card.dart';
import 'package:elbess/features/home/widgets/slider.dart';
import 'package:elbess/features/home/widgets/store_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Homebody extends StatelessWidget {
  const Homebody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
        child:  Column(
        children: [
          SizedBox(height: MediaQuery.of( context).size.height * 0.07),
       Padding(padding: EdgeInsets.symmetric(horizontal: 20),
       child:   Row(
          
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hi,",style: TextStyle(fontSize: 24, fontFamily: "semi",color: Colors.black),),
                Text("Mohamed",style: TextStyle(fontSize: 18, fontFamily: "semi",color: AppColors.primary),)

              ],
            ),
            Spacer() ,
      Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Icon(
        Icons.search,
        color: Colors.black,
        size: 18,
      ),
    ),
        Gap(MediaQuery.of(context).size.width * 0.02),
        Icon(Icons.notifications_none_outlined,color: Colors.black,size: 25,)
          ],

         ),
       ),
          const SizedBox(height: 8),
          const OffersSlider(),
          const SizedBox(height: 8),
          //categories title
         Padding(padding: EdgeInsets.symmetric(horizontal: 10),
         child:  Row(
            children: [

               Text("Categories",style: TextStyle(fontSize: 20, fontFamily: "semi",color: Colors.black),),
               Spacer(),
              Text("see all",style: TextStyle(fontSize: 12, fontFamily: "medium",color: Colors.grey),),
             
             
            ],
          ),
         
         ),
         SizedBox(height: 15),
         //categories items
       SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children:List.generate(5, (index){
            return Padding(padding: EdgeInsets.symmetric(horizontal: 5),
            child:  CategoryCard(image: "assets/Images/categories/jacket2.png", name: "Jacket",),
            );
          }),
        )  ,
        ),
        //store title
       Gap(20),
        Padding(padding: EdgeInsets.symmetric(horizontal: 10),
         child:  Row(
            children: [

               Text("Stores",style: TextStyle(fontSize: 20, fontFamily: "semi",color: Colors.black),),
               Spacer(),
              Text("see all",style: TextStyle(fontSize: 12, fontFamily: "medium",color: Colors.grey),),
             
             
            ],
          ),
         
         ),
       Gap(10),
       //store items
        SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children:List.generate(5, (index){
            return Padding(padding: EdgeInsets.symmetric(horizontal: 2),
            child:  StoreCard(store_image: "assets/Images/stores/store2.png", store_name: "Stepx",),
            );

          }),
        )  ,
        ),
   Gap(20),
    Padding(padding: EdgeInsets.symmetric(horizontal: 10),
         child:  Row(
            children: [
               Text("Trend items",style: TextStyle(fontSize: 20, fontFamily: "semi",color: Colors.black),),
               Spacer(),
              Text("see all",style: TextStyle(fontSize: 12, fontFamily: "medium",color: Colors.grey),),
             
             
            ],
          ),
         
         ),
       
      GridView.builder(
  shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(),
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 1,
    mainAxisSpacing: 1,
    childAspectRatio: 1,
  ),
  itemCount: 3, 
  itemBuilder: (context, index) {
    return Padding(padding: EdgeInsets.symmetric(horizontal: 6),
    child: ItemCard(imagePath: 'assets/Images/clothes/item${index + 1}.png', storeName: 'Boutique Parma', itemName: 'Sweatshirt', price: '480.00Dz', rating: '4.5', isFavorite: false,),
    );
  },
)
        ],
      ),
      )
    );
  }
}