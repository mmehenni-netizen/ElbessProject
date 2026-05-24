
import 'package:elbess/core/utils/pref_helpers.dart';
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
  // Updated category titles (8 items) — images are chosen heuristically
  List<String> get _categories => const [
        "T-SHIRTS",
        "SHIRTS",
        "POLO SHIRTS",
        "TROUSERS",
        "DENIM",
        "SWEATERS | CARDIGANS",
        "HOODIES | SWEATSHIRTS",
        "SHOES | BAGS",
      ];

  String _imageForCategoryTitle(String title) {
    final t = title.toLowerCase();

    if (t.contains('polo')) {
      return 'assets/Images/categories2/fd27985f494d7aa702f9002040f23fe8.jpg';
    }

    if (t.contains('t-shirt') || t.contains('tshirts') || t.contains('t-shirts') || t.contains('t-shirts')) {
      return 'assets/Images/categories2/tshirtcat.avif';
    }

    if (t.contains('hood') || t.contains('hoodie') || t.contains('sweatshirt')) {
      return 'assets/Images/categories2/093333c4bbfc6beee664aec0ec060e3c.jpg';
    }

    if (t.contains('shoe') || t.contains('bag')) {
      return 'assets/Images/categories2/shoescat.avif';
    }

    if (t.contains('trouser') || t.contains('pants')) {
      return 'assets/Images/categories2/40e146d0b4b7a8ad7bb2785dff461bb8.jpg';
    }

    if (t.contains('denim')) {
      return 'assets/Images/categories2/pantscat.avif';
    }

    if (t.contains('sweater') || t.contains('sweaters') || t.contains('cardigan')) {
      return 'assets/Images/categories2/f436e9b13ce21d26b85d09d4ffdc8c1b.jpg';
    }

    // fallback
    return 'assets/Images/categories2/d7329baef71fce8dea8eec58ce7e950b.jpg';
  }


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

  // Build aliases from a displayed category title (handles pipes and synonyms)
  Set<String> _aliasesFromTitle(String title) {
    final parts = title.split(RegExp(r"\||,|/"))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final aliases = <String>{};

    for (final part in parts) {
      final key = _normalizeCategory(part);

      if (key.contains('polo')) {
        aliases.addAll({'polo', 'poloshirts', 'poloshirt', 'polo', 'shirt'});
        continue;
      }

      if (key.contains('tshirt') || key.contains('tshirts')) {
        aliases.addAll({'tshirt', 'tshirts', 't-shirt', 't-shirts'});
        continue;
      }

      if (key.contains('shirt')) {
        aliases.addAll({'shirt', 'shirts'});
        continue;
      }

      if (key.contains('trouser') || key.contains('pants')) {
        aliases.addAll({'trouser', 'trousers', 'pants'});
        continue;
      }

      if (key.contains('denim') || key.contains('jean')) {
        aliases.addAll({'denim', 'jeans'});
        continue;
      }

      if (key.contains('sweater') || key.contains('cardigan')) {
        aliases.addAll({'sweater', 'sweaters', 'cardigan', 'cardigans'});
        continue;
      }

      if (key.contains('hood') || key.contains('hoodie') || key.contains('sweatshirt')) {
        aliases.addAll({'hoodie', 'hoodies', 'sweatshirt', 'sweatshirts'});
        continue;
      }

      if (key.contains('shoe') || key.contains('shoe')) {
        aliases.addAll({'shoe', 'shoes'});
        continue;
      }

      if (key.contains('bag')) {
        aliases.addAll({'bag', 'bags'});
        continue;
      }

      // default: use the normalized key
      aliases.add(key);
    }

    return aliases;
  }

  List<ProductModel> _productsByCategory(String categoryTitle) {
    final aliases = _aliasesFromTitle(categoryTitle);
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
                  final categoryTitle = _categories[index];
                  final categoryProducts = _productsByCategory(_normalizeCategory(categoryTitle));

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CategoryProductsPage(
                            categoryTitle: categoryTitle,
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
                              _imageForCategoryTitle(categoryTitle),
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
                                categoryTitle,
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

class CategoryProductsPage extends StatefulWidget {
  const CategoryProductsPage({
    super.key,
    required this.categoryTitle,
    required this.products,
  });

  final String categoryTitle;
  final List<ProductModel> products;

  @override
  State<CategoryProductsPage> createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  Set<String> _favoriteProductIds = <String>{};

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final ids = await PrefHelpers.getFavoriteProductIds();
    if (!mounted) {
      return;
    }

    setState(() {
      _favoriteProductIds = ids.toSet();
    });
  }

  Future<void> _toggleFavorite(String productId) async {
    final isFavoriteNow = await PrefHelpers.toggleFavoriteProductId(productId);
    if (!mounted) {
      return;
    }

    setState(() {
      if (isFavoriteNow) {
        _favoriteProductIds.add(productId);
      } else {
        _favoriteProductIds.remove(productId);
      }
    });
  }

  Future<void> _openProduct(ProductModel product) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailView(
          productId: product.id,
          initialProduct: product,
        ),
      ),
    );

    await _loadFavorites();
  }

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
          widget.categoryTitle,
          style: const TextStyle(
            fontFamily: 'semi',
            color: Colors.black,
          ),
        ),
      ),
      body: widget.products.isEmpty
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
              itemCount: widget.products.length,
              itemBuilder: (context, index) {
                final product = widget.products[index];
                return ItemCard(
                  imagePath: product.imageUrl,
                  storeName: product.store?.name ?? '',
                  itemName: product.name,
                  price: product.price.toStringAsFixed(2),
                  rating: product.rating.toString(),
                  isFavorite: _favoriteProductIds.contains(product.id),
                  onTap: () => _openProduct(product),
                  onFavoriteTap: () => _toggleFavorite(product.id),
                );
              },
            ),
    );
  }
}
