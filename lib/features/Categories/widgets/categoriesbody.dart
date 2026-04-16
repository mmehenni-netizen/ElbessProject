
import 'package:elbess/features/home/widgets/item_card.dart';
import 'package:elbess/features/productdetail/presentation/product_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Categoriesbody extends StatefulWidget {
  const Categoriesbody({super.key});

  @override
  State<Categoriesbody> createState() => _CategoriesbodyState();
}

class _CategoriesbodyState extends State<Categoriesbody> {
  List<Map<String, String>> get _categories => const [
    {'key': 'tshirt', 'title': 'TSHIRT', 'image': 'assets/Images/categories2/tshirtcat.avif'},
    {'key': 'hoddies', 'title': 'HODDIES', 'image': 'assets/Images/categories2/hoddiescat.avif'},
    {'key': 'shoes', 'title': 'SHOES', 'image': 'assets/Images/categories2/shoescat.avif'},
    {'key': 'pants', 'title': 'PANTS', 'image': 'assets/Images/categories2/pantscat.avif'},
    {'key': 'jackets', 'title': 'JACKETS', 'image': 'assets/Images/categories2/jacketscat.avif'},
    {'key': 'sweeters', 'title': 'SWEETERS', 'image': 'assets/Images/categories2/sweeterscat.avif'},
  ];

  final Map<String, List<Map<String, String>>> _productsByCategory = {
    'tshirt': [
      {'image': 'assets/Images/clothes/item1.png', 'store': 'Urban Basic', 'name': 'Classic T-shirt', 'price': '39.00Dz', 'rating': '4.5'},
      {'image': 'assets/Images/clothes/item4.png', 'store': 'Street Side', 'name': 'Relaxed Tee', 'price': '42.00Dz', 'rating': '4.4'},
      {'image': 'assets/Images/clothes/item3.png', 'store': 'New Mood', 'name': 'Graphic Tee', 'price': '45.00Dz', 'rating': '4.6'},
    ],
    'hoddies': [
      {'image': 'assets/Images/clothes/item2.png', 'store': 'Warm Up', 'name': 'Soft Hoodie', 'price': '79.00Dz', 'rating': '4.8'},
      {'image': 'assets/Images/clothes/item1.png', 'store': 'Urban Basic', 'name': 'Zip Hoodie', 'price': '85.00Dz', 'rating': '4.5'},
      {'image': 'assets/Images/clothes/item5.png', 'store': 'Move Co', 'name': 'Oversize Hoodie', 'price': '88.00Dz', 'rating': '4.7'},
    ],
    'shoes': [
      {'image': 'assets/Images/clothes/item3.png', 'store': 'Foot Lab', 'name': 'Running Shoes', 'price': '129.00Dz', 'rating': '4.7'},
      {'image': 'assets/Images/clothes/item4.png', 'store': 'Street Step', 'name': 'Daily Sneakers', 'price': '110.00Dz', 'rating': '4.4'},
      {'image': 'assets/Images/clothes/item2.png', 'store': 'Step One', 'name': 'Canvas Shoes', 'price': '95.00Dz', 'rating': '4.3'},
    ],
    'pants': [
      {'image': 'assets/Images/clothes/item2.png', 'store': 'Core Fit', 'name': 'Straight Pants', 'price': '70.00Dz', 'rating': '4.5'},
      {'image': 'assets/Images/clothes/item4.png', 'store': 'Modern Fit', 'name': 'Cargo Pants', 'price': '82.00Dz', 'rating': '4.6'},
      {'image': 'assets/Images/clothes/item1.png', 'store': 'Daily Wear', 'name': 'Wide Pants', 'price': '77.00Dz', 'rating': '4.4'},
    ],
    'jackets': [
      {'image': 'assets/Images/categories/jacket.png', 'store': 'Elbess Signature', 'name': 'Linen Jacket', 'price': '149.00Dz', 'rating': '4.8'},
      {'image': 'assets/Images/categories/jacket2.png', 'store': 'Elbess Studio', 'name': 'Light Jacket', 'price': '139.00Dz', 'rating': '4.7'},
      {'image': 'assets/Images/clothes/item5.png', 'store': 'Layer Up', 'name': 'Casual Jacket', 'price': '132.00Dz', 'rating': '4.5'},
    ],
    'sweeters': [
      {'image': 'assets/Images/clothes/item5.png', 'store': 'Warm Core', 'name': 'Wool Sweeter', 'price': '99.00Dz', 'rating': '4.6'},
      {'image': 'assets/Images/clothes/item1.png', 'store': 'Daily Knit', 'name': 'Soft Sweeter', 'price': '89.00Dz', 'rating': '4.4'},
      {'image': 'assets/Images/clothes/item2.png', 'store': 'Comfy Line', 'name': 'Basic Sweeter', 'price': '84.00Dz', 'rating': '4.5'},
    ],
  };

  List<Map<String, String>> _safeProductsForKey(String key) {
    final raw = _productsByCategory[key];
    if (raw == null) {
      return const [];
    }

    return raw
        .map((product) => Map<String, String>.from(product))
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final bool isTablet = size.width >= 600;
    final double horizontalPadding = (size.width * 0.04).clamp(12.0, 24.0).toDouble();
    final double topGap = (size.height * 0.01).clamp(6.0, 26.0).toDouble();
    final double sectionGap = (size.height * 0.02).clamp(12.0, 22.0).toDouble();
    final double titleFont = isTablet ? 30 : 26;

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(topGap),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: const Text(
                'DISCOVER THE COLLECTION',
                style: TextStyle(
                  color: Color(0xFFB2B2B2),
                  fontSize: 12,
                  letterSpacing: 1.1,
                  fontFamily: 'medium',
                ),
              ),
            ),
            const Gap(2),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Text(
                'Shop by Department',
                style: TextStyle(
                  fontSize: titleFont,
                  fontFamily: 'semi',
                  color: Colors.black,
                  height: 1.08,
                ),
              ),
            ),
            Gap(sectionGap),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.92,
                ),
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final products = _safeProductsForKey(category['key']!);

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CategoryProductsPage(
                            categoryTitle: category['title']!,
                            products: products,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              category['image']!,
                              fit: BoxFit.cover,
                            ),
                            const DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.transparent, Color(0xB0000000)],
                                  stops: [0.55, 1],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 10,
                              bottom: 10,
                              child: Text(
                                category['title']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'semi',
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}

class CategoryProductsPage extends StatelessWidget {
  const CategoryProductsPage({
    super.key,
    required this.categoryTitle,
    required this.products,
  });

  final String categoryTitle;
  final List<Map<String, String>> products;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final bool isTablet = size.width >= 600;
    final int productGridCount = size.width >= 900 ? 4 : (isTablet ? 3 : 2);
    final double horizontalPadding = (size.width * 0.03).clamp(8.0, 16.0).toDouble();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          categoryTitle,
          style: const TextStyle(
            fontFamily: 'semi',
            color: Colors.black,
          ),
        ),
      ),
      body: products.isEmpty
          ? const Center(
              child: Text(
                'No products available',
                style: TextStyle(fontFamily: 'medium', color: Colors.grey),
              ),
            )
          : GridView.builder(
              padding: EdgeInsets.fromLTRB(horizontalPadding, 12, horizontalPadding, 20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: productGridCount,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: isTablet ? 0.5 : 0.9,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProductDetailView(),
                      ),
                    );
                  },
                  child: ItemCard(
                    imagePath: product['image'] ?? '',
                    storeName: product['store'] ?? '',
                    itemName: product['name'] ?? '',
                    price: product['price'] ?? '',
                    rating: product['rating'] ?? '',
                    isFavorite: false,
                  ),
                );
              },
            ),
    );
  }
}