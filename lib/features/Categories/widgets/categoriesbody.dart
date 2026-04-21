
import 'package:elbess/features/home/data/home_repo.dart';
import 'package:elbess/features/home/data/product_model.dart';
import 'package:elbess/features/home/widgets/item_card.dart';
import 'package:elbess/features/productdetail/presentation/product_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

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


  final HomeRepo _homeRepo = HomeRepo();
  List<ProductModel> products = <ProductModel>[];
  bool isLoading = true;

  String _normalizeCategory(String value) {
    return value.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
  }

  Set<String> _aliasesForCategory(String categoryKey) {
    final key = _normalizeCategory(categoryKey);

    switch (key) {
      case 'hoddies':
      case 'hoodies':
      case 'hoodie':
        return <String>{'hoddies', 'hoodies', 'hoodie'};
      case 'sweeters':
      case 'sweaters':
      case 'sweater':
        return <String>{'sweeters', 'sweaters', 'sweater'};
      default:
        return <String>{key};
    }
  }

  List<ProductModel> _productsByCategory(String categoryKey) {
    final aliases = _aliasesForCategory(categoryKey);
    return products.where((product) {
      final category = _normalizeCategory(product.category);
      return aliases.contains(category);
    }).toList();
  }

  Future<void> getProducts() async {
    if (!mounted) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final res = await _homeRepo.getProducts();
      if (!mounted) {
        return;
      }

      setState(() {
        products = res;
        isLoading = false;
      });
      print(products);
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;
      });
      print("Error fetching products: $e");
    }
  }

  @override
  void initState() {
    getProducts();
    super.initState();
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Skeletonizer(
          enabled: isLoading,
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
                  final categoryProducts = _productsByCategory(category['key'] ?? '');

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CategoryProductsPage(
                            categoryTitle: category['title']!,
                            products: categoryProducts,
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
  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final bool isTablet = size.width >= 600;
    final int productGridCount = size.width >= 900 ? 4 : (isTablet ? 3 : 2);
    final double horizontalPadding = (size.width * 0.03).clamp(8.0, 16.0).toDouble();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.transparent,
        scrolledUnderElevation: 0,
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
                        builder: (_) => ProductDetailView(
                          productId: product.id,
                          initialProduct: product,
                        ),
                      ),
                    );
                  },
                  child: ItemCard(
                    imagePath: product.imageUrl,
                    storeName: product.store?.name ?? '',
                    itemName: product.name,
                    price: product.price.toStringAsFixed(2),
                    rating: product.rating.toString(),
                    isFavorite: false,
                  ),
                );
              },
            ),
    );
  }
}
