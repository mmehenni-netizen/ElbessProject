import 'package:elbess/core/constants/colors.dart';
import 'package:elbess/features/home/widgets/item_card.dart';
import 'package:elbess/features/productdetail/presentation/product_detail_view.dart';
import 'package:elbess/features/store_page/widgets/cat_texts.dart';
import 'package:elbess/features/store_page/widgets/static_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class StoreBody extends StatefulWidget {
  const StoreBody({super.key});

  @override
  State<StoreBody> createState() => _StoreBodyState();
}

class _StoreBodyState extends State<StoreBody> {
  final List<String> _categories = const [
    'T-shirts',
    'Hoodies',
    'Shoes',
    'Pants',
    'jackets',
    'sweetshirts',

  ];

  int _selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        title: Text("Store", style: TextStyle(fontFamily: "semi", color: Colors.black, fontSize: 24)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(10),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[100],
                    ),
                    child: Image.asset("assets/Images/stores/store2.png", width: MediaQuery.of(context).size.width * 0.15),
                  ),
                  Gap(10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("StepX", style: TextStyle(fontFamily: "semi", color: Colors.black, fontSize: 18)),
                      Gap(2),
                      Text("📍Alger", style: TextStyle(fontFamily: "regular", color: Colors.black, fontSize: 10)),
                      Gap(2),
                      Row(
                        children: [
                          Text("category:", style: TextStyle(fontFamily: "regular", color: Colors.grey, fontSize: 10)),
                          Gap(2),
                          Text("shoes", style: TextStyle(fontFamily: "bold", color: AppColors.primary, fontSize: 10)),
                        ],
                      )
                    ],
                  )
                ],
              ),
              Gap(30),
              Text("Description", style: TextStyle(fontFamily: "bold", color: Colors.black, fontSize: 22)),
              Gap(5),
              Text(
                "Our store is where comfort meets culture featuring bold graphics, minimalist essentials,minimalist essentials, and exclusive drops from emerging and designer established brands. Whether you're building your everyday rotationor seeking statement pieces, our curated collection has something for every style and occasion.",
                style: TextStyle(fontFamily: "medium", color: Colors.grey, fontSize: 12),
              ),
              Gap(20),
              Text("Statics", style: TextStyle(fontFamily: "bold", color: Colors.black, fontSize: 22)),
              Gap(19),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(4, (index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: StaticCard(
                        title: "Shipping Time ",
                        data: "2-3 days",
                        imagePath: "assets/icons/express.png",
                      ),
                    );
                  }),
                ),
              ),
              Gap(15),
              Text("Our Products", style: TextStyle(fontFamily: "bold", color: Colors.black, fontSize: 22)),
              Gap(10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_categories.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategoryIndex = index;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: CatTexts(
                          isSelected: _selectedCategoryIndex == index,
                          category: _categories[index],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Gap(20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  mainAxisExtent: screenSize.height * 0.255,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailView(productId: "0")));
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      child: ItemCard(
                        imagePath: 'assets/Images/clothes/item${(index % 5) + 1}.png',
                        storeName: 'Boutique Parma',
                        itemName: 'Sweatshirt',
                        price: '480.00Dz',
                        rating: '4.5',
                        isFavorite: false,
                      ),
                    ),
                  );
                },
              ),
              Gap(16),
            ],
          ),
        ),
      ),
    );
  }
}