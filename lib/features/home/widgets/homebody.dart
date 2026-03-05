
import 'package:elbess/core/constants/colors.dart';
import 'package:elbess/features/Categories/widgets/categoriesbody.dart';
import 'package:elbess/features/home/widgets/category_card.dart';
import 'package:elbess/features/home/widgets/item_card.dart';
import 'package:elbess/features/home/widgets/slider.dart';
import 'package:elbess/features/home/widgets/store_card.dart';
import 'package:elbess/features/profile/presentation/profileview.dart';
import 'package:elbess/features/productdetail/presentation/product_detail_view.dart';
import 'package:elbess/features/store_page/presentation/store_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Homebody extends StatefulWidget {
  const Homebody({super.key});

  @override
  State<Homebody> createState() => _HomebodyState();
}

class _HomebodyState extends State<Homebody> {
  int _selectedCategoryIndex = -1;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final bool isTablet = size.width >= 600;
    final double horizontalPadding = (size.width * 0.05).clamp(10.0, 24.0).toDouble();
    final double sectionPadding = (size.width * 0.025).clamp(8.0, 16.0).toDouble();
    final double topSpace = (size.height * 0.07).clamp(36.0, 70.0).toDouble();
    final double sectionTitleFont = isTablet ? 24 : 20;
    final double headingFont = isTablet ? 28 : 24;
    final double subHeadingFont = isTablet ? 20 : 18;
    final double captionFont = isTablet ? 14 : 12;
    final int trendGridCount = size.width >= 900 ? 4 : (isTablet ? 3 : 2);

    return Scaffold(
      body:SingleChildScrollView(
        child:  Column(
        children: [
          SizedBox(height: topSpace),
       Padding(padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
       child:   Row(
          
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hi,",style: TextStyle(fontSize: headingFont, fontFamily: "semi",color: Colors.black),),
                Row(
                  children: [
                    Text("Mohamed",style: TextStyle(fontSize: subHeadingFont, fontFamily: "semi",color: AppColors.primary),),
                    Gap(4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => Profileview()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFE6E6E6),
                        ),
                        child:  Icon(CupertinoIcons.person, size: 16,color: AppColors.primary,),
                      ),
                    )
                  ],
                )

              ],
            ),
            Spacer() ,
      Container(
      padding: EdgeInsets.all(isTablet ? 6 : 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Icon(
        Icons.search,
        color: Colors.black,
        size: isTablet ? 22 : 18,
      ),
    ),
        Gap(size.width * 0.02),
        Icon(Icons.notifications_none_outlined,color: Colors.black,size: isTablet ? 30 : 25,)
          ],

         ),
       ),
          const SizedBox(height: 8),
          const OffersSlider(),
          const SizedBox(height: 8),
          //categories title
        Padding(padding: EdgeInsets.symmetric(horizontal: sectionPadding),
         child:  Row(
            children: [

            Text("Categories",style: TextStyle(fontSize: sectionTitleFont, fontFamily: "semi",color: Colors.black),),
               Spacer(),
            Text("see all",style: TextStyle(fontSize: captionFont, fontFamily: "medium",color: Colors.grey),),
             
             
            ],
          ),
         
         ),
         SizedBox(height: isTablet ? 18 : 15),
         //categories items
       SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children:List.generate(5, (index){
            return GestureDetector(
              onTap: () async {
                setState(() {
                  _selectedCategoryIndex = index;
                });
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Categoriesbody()),
                );
                if (!mounted) {
                  return;
                }
                setState(() {
                  _selectedCategoryIndex = -1;
                });
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isTablet ? 7 : 5),
                child: CategoryCard(
                  image: "assets/Images/categories/jacket2.png",
                  name: "Jacket",
                  isSelected: _selectedCategoryIndex == index,
                ),
              ),
            );
          }),
        )  ,
        ),
        //store title
      Gap(isTablet ? 24 : 20),
       Padding(padding: EdgeInsets.symmetric(horizontal: sectionPadding),
         child:  Row(
            children: [

         Text("Stores",style: TextStyle(fontSize: sectionTitleFont, fontFamily: "semi",color: Colors.black),),
               Spacer(),
        Text("see all",style: TextStyle(fontSize: captionFont, fontFamily: "medium",color: Colors.grey),),
             
             
            ],
          ),
         
         ),
      Gap(isTablet ? 14 : 10),
       //store items
        SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children:List.generate(5, (index){
            return GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => StoreView()));
              },
              child: Padding(padding: EdgeInsets.symmetric(horizontal: isTablet ? 4 : 2),
            child:  StoreCard(store_image: "assets/Images/stores/store2.png", store_name: "Stepx",),
            ),
            );

          }),
        )  ,
        ),
  Gap(isTablet ? 24 : 20),
   Padding(padding: EdgeInsets.symmetric(horizontal: sectionPadding),
         child:  Row(
            children: [
          Text("Trend items",style: TextStyle(fontSize: sectionTitleFont, fontFamily: "semi",color: Colors.black),),
               Spacer(),
          Text("see all",style: TextStyle(fontSize: captionFont, fontFamily: "medium",color: Colors.grey),),
             
             
            ],
          ),
         
         ),
       
      GridView.builder(
  shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(),
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: trendGridCount,
    crossAxisSpacing: isTablet ? 8 : 1,
    mainAxisSpacing: isTablet ? 8 : 1,
    childAspectRatio: isTablet ? 0.88 : 1,
  ),
  itemCount: 3, 
  itemBuilder: (context, index) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailView()));
      },
      child: Padding(padding: EdgeInsets.symmetric(horizontal: isTablet ? 8 : 6),
    child: ItemCard(imagePath: 'assets/Images/clothes/item${index + 1}.png', storeName: 'Boutique Parma', itemName: 'Sweatshirt', price: '480.00Dz', rating: '4.5', isFavorite: false,),
    ),
    );
  },
)
        ],
      ),
      )
    );
  }
}