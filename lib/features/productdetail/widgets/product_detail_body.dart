import 'package:elbess/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProductDetailBody extends StatefulWidget {
  const ProductDetailBody({super.key});

  @override
  State<ProductDetailBody> createState() => _ProductDetailBodyState();
}
String selectedSize = "S";
  int selectedColorIndex = 0;
  PageController _pageController = PageController();
int currentIndex = 0;

  final List<String> sizes = ["S", "M", "L", "XL"];
  final List<Color> colors = [
    Colors.blue,
    const Color(0xFF8B5A3C), // brown
    Colors.grey.shade400,
  ];
  List<String> images = [
  "assets/Images/clothes/item3.png",
  "assets/Images/clothes/item4.png",
  "assets/Images/clothes/item5.png",
];

class _ProductDetailBodyState extends State<ProductDetailBody> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Column(
        children: [
          
            Stack(
                children: [
                
                  Container(
                    height: screenSize.height * 0.46,
                    decoration: BoxDecoration(
                      color: Color(0xffEEEEEE),
             
                    ),
                    child:   Column(
          children: [
            Gap(30),
            Expanded(
        child: PageView.builder(
          controller: _pageController,
          itemCount: images.length,
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return Center(
              child: Image.asset(
                images[index],
                height: MediaQuery.sizeOf(context).height * 0.6,
                width: MediaQuery.sizeOf(context).width * 0.6,
                fit: BoxFit.contain,
              ),
            );
          },
        ),
            ),
        
            /// 🔵 Dots
            Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          images.length,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
            width: currentIndex == index ? 10 : 6,
            height: currentIndex == index ? 10 : 6,
            decoration: BoxDecoration(
              color: currentIndex == index
                  ? Colors.black
                  : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
        ),
            ),
          ],
        ),
                  ),
               Positioned(
                top: 50,
                  left: 10,
                  right: 10,
                child:  Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child:   Icon(Icons.arrow_back_ios, color: Colors.black),
                    ),
                   Text(
                        "Product Details",
                        style: TextStyle(fontFamily: "semi", color: Colors.black, fontSize: 22),
                      ),
                    Icon(Icons.favorite_border, color: Colors.black),
                  ],
                ),)
                ],
            
            ),
         Expanded(
          child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
           
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
        
                    Text(
                      "StepX",style: TextStyle(fontFamily: "bold", color: Colors.black, fontSize: 12),
                    ),
                     Image.asset("assets/Images/stores/store1.png", height: MediaQuery.sizeOf(context).height * 0.04),
                      ],
                    ),
                   Row(
                    children: [
                      Icon( Icons.star, color: Colors.amber, size: 15),
                      Text(" 4.5", style: TextStyle(fontFamily: "bold", color: Colors.black, fontSize: 12)),
        
                    ],
                   ) 
                  ],
                ),
                Gap(10),
             Text("Relaxed Fit Oversized T-shirt", style: TextStyle(fontFamily: "bold", color: Colors.black, fontSize: 20)),
             const SizedBox(height: 10,),
             
             
             Text("420.00 dz", style: TextStyle(fontFamily: "bold", color: AppColors.primary, fontSize: 18)),
             Gap(10),
             Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec auctor, nisl eget ultricies lacinia, nunc nisl aliquam nisl, eget aliquam nunc nisl eget nunc. Donec auctor, nisl eget ultricies lacinia, nunc nisl aliquam nisl, eget aliquam nunc nisl eget nunc.", style: TextStyle(fontFamily: "semi", color: Colors.grey, fontSize: 12)),
         Gap(16),
           Container(
             
        color: Colors.white,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Row(
                children: [
                  const Text(
                    "Size",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Row(
                    children: List.generate(
                      sizes.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedSize = sizes[index];
                            });
                          },
                          child: Container(
                            width: 34,
                            height: 34,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: selectedSize == sizes[index]
                                  ? const Color(0xFF8B5A3C)
                                  : Colors.white,
                               border: Border.all(
                                color: selectedSize == sizes[index]
                                    ? const Color(0xFF8B5A3C)
                                    : Colors.grey,
                                width: 1,   
                            )),
                            child: Text(
                              sizes[index],
                              style: TextStyle(
                                color: selectedSize == sizes[index]
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
             SizedBox(height: 12),
          Row(
                children: [
                  const Text(
                    "Color ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Row(
                    children: List.generate(
                      colors.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedColorIndex = index;
                            });
                          },
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colors[index],
                              border: selectedColorIndex == index
                                  ? Border.all(color: Colors.black, width: 2)
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
             
            ],
          ),
            ),
          const Spacer(),
          Row(
            children: [
             Container(
              width: screenSize.width * 0.43,
              height: screenSize.height * 0.05,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppColors.primary, width: 1.5),
              ),
              child: Center(
                child: Text(
                  "Add to Cart",
                  style: TextStyle(fontFamily: "semi", color: AppColors.primary, fontSize: 16),
                ),
              ),
             ),
             Gap(5),
            Container(
              width: screenSize.width * 0.43,
              height: screenSize.height * 0.05,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  "Buy Now",
                  style: TextStyle(fontFamily: "semi", color: Colors.white, fontSize: 16),
                ),
              ),
            )
            ],
          )   ,     
        Gap(10),
          ]),
          ),
         ),
         ),
        ],
      ),
    );
  }
}