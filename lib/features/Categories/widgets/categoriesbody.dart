
import 'package:elbess/features/home/widgets/category_card.dart';
import 'package:elbess/features/home/widgets/item_card.dart';
import 'package:elbess/features/productdetail/presentation/product_detail_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Categoriesbody extends StatefulWidget {
  const Categoriesbody({super.key});

  @override
  State<Categoriesbody> createState() => _CategoriesbodyState();
}

class _CategoriesbodyState extends State<Categoriesbody> {
  final List<String> _categories = const [
    'T-shirts',
    'Hoodies',
    'Shoes',
    'Pants',
    'jackets',
    'sweetshirts',

  ];

  int _selectedCategoryIndex = -1;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final bool isTablet = size.width >= 600;
    final double horizontalPadding = (size.width * 0.04).clamp(12.0, 24.0).toDouble();
    final double topGap = (size.height * 0.03).clamp(20.0, 36.0).toDouble();
    final double sectionGap = (size.height * 0.025).clamp(16.0, 30.0).toDouble();
    final double titleFont = isTablet ? 28 : 24;
    final double sectionTitleFont = isTablet ? 24 : 20;
    final double searchHintFont = isTablet ? 16 : 14;
    final double searchIconSize = isTablet ? 24 : 20;
    final int gridCount = size.width >= 900 ? 4 : (isTablet ? 3 : 2);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios, color: Colors.black, size: isTablet ? 24 : 20),
        ),
        title: Text("Categories", style: TextStyle(fontFamily: "semi", color: Colors.black, fontSize: titleFont)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(topGap),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
                children: [
                  Gap(horizontalPadding * 0.6),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: searchHintFont),
                        prefixIcon: Icon(Icons.search, color: Colors.grey, size: searchIconSize),
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: horizontalPadding),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  
                  IconButton(onPressed: (){} , icon: Icon(CupertinoIcons.slider_horizontal_3, size: searchIconSize), color: Colors.grey),
                  
                  
                ],
              ),
            ),
            Gap(sectionGap),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
            children: [
               Text("Categories",style: TextStyle(fontSize: sectionTitleFont, fontFamily: "semi",color: Colors.black),),
               Spacer(),
            ],
          ),
            ),
            Gap(sectionGap * 0.8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:List.generate(_categories.length, (index){
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategoryIndex = index;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: CategoryCard(
                        image: "assets/Images/categories/jacket2.png",
                        name: _categories[index],
                        isSelected: _selectedCategoryIndex == index,
                      ),
                    ),
                  );
                }),
              )  ,
            ),
            Gap(sectionGap),
                           Padding(
                             padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                             child: Text("Items you want",style: TextStyle(fontSize: sectionTitleFont, fontFamily: "semi",color: Colors.black),),
                           ),

            Gap(sectionGap),
            GridView.builder(
  shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(),
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: gridCount,
    crossAxisSpacing: isTablet ? 8 : 1,
    mainAxisSpacing: isTablet ? 8 : 1,
    childAspectRatio: isTablet ? 0.9 : 1,
  ),
  itemCount: 3, 
  itemBuilder: (context, index) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailView()));
      },
      child: Padding(padding: EdgeInsets.symmetric(horizontal: 6),
    child: ItemCard(imagePath: 'assets/Images/clothes/item${index + 1}.png', storeName: 'Boutique Parma', itemName: 'Sweatshirt', price: '480.00Dz', rating: '4.5', isFavorite: false,),
    ),
    );
  },
)
            
          ],
        ),
        
          ),
    );
  }
}