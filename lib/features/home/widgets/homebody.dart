import 'package:elbess/core/constants/colors.dart';
import 'package:elbess/core/utils/pref_helpers.dart';
import 'package:elbess/features/favorites/presentation/favoritesview.dart';
import 'package:elbess/features/home/data/home_repo.dart';
import 'package:elbess/features/home/data/product_model.dart';
import 'package:elbess/features/home/data/store_model.dart';
import 'package:elbess/features/home/widgets/item_card.dart';
import 'package:elbess/features/home/widgets/slider.dart';
import 'package:elbess/features/home/widgets/store_card.dart';
import 'package:elbess/features/profile/presentation/profileview.dart';
import 'package:elbess/features/productdetail/presentation/product_detail_view.dart';
import 'package:elbess/features/store_page/presentation/store_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Homebody extends StatefulWidget {
  const Homebody({super.key});

  @override
  State<Homebody> createState() => _HomebodyState();
}

class _HomebodyState extends State<Homebody> {
  final HomeRepo _homeRepo = HomeRepo();
  bool isLoading = false;
  List<ProductModel>? products;
  List<StoreModel>? stores;
  Set<String> _favoriteProductIds = <String>{};

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    getProducts();
    getStores();
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
    try {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailView(
            productId: product.id,
            initialProduct: product,
          ),
        ),
      );

      await _loadFavorites();
    } catch (e, st) {
      // Log and show a non-fatal error instead of allowing a potential crash
      // to take down the emulator.
      // ignore: avoid_print
      print('Error opening product detail: $e');
      // ignore: avoid_print
      print(st);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open product details')),
      );
    }
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

  Future<void> getStores() async {
    if (!mounted) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final res = await _homeRepo.getStores();
      if (!mounted) {
        return;
      }

      setState(() {
        stores = res;
        isLoading = false;
      });
      print(stores);
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;
      });
      print("Error fetching stores: $e");
    }
  }

  Future<void> refresh() async {
    await Future.wait([getProducts(), getStores()]);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final bool isTablet = size.width >= 600;
    final double horizontalPadding = (size.width * 0.05)
        .clamp(10.0, 24.0)
        .toDouble();
    final double sectionPadding = (size.width * 0.025)
        .clamp(8.0, 16.0)
        .toDouble();
    final double topSpace = (size.height * 0.07).clamp(36.0, 70.0).toDouble();
    final double sectionTitleFont = isTablet ? 24 : 20;
    final double headingFont = isTablet ? 28 : 24;
    final double subHeadingFont = isTablet ? 20 : 18;
    final double captionFont = isTablet ? 14 : 12;
    final int trendGridCount = size.width >= 900 ? 4 : (isTablet ? 3 : 2);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refresh,
        child: Skeletonizer(
          enabled: isLoading,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: topSpace),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hi,",
                            style: TextStyle(
                              fontSize: headingFont,
                              fontFamily: "semi",
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "Mohamed",
                                style: TextStyle(
                                  fontSize: subHeadingFont,
                                  fontFamily: "semi",
                                  color: AppColors.primary,
                                ),
                              ),
                              Gap(4),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => Profileview(),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFE6E6E6),
                                  ),
                                  child: Icon(
                                    CupertinoIcons.person,
                                    size: 16,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const Favoritesview(),
                            ),
                          ).then((_) => _loadFavorites());
                        },
                        child: Container(
                          padding: EdgeInsets.all(isTablet ? 6 : 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          child: Icon(
                            CupertinoIcons.heart,
                            color: Colors.black,
                            size: isTablet ? 22 : 18,
                          ),
                        ),
                      ),
                      Gap(size.width * 0.02),
                      Icon(
                        Icons.notifications_none_outlined,
                        color: Colors.black,
                        size: isTablet ? 30 : 25,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const OffersSlider(),
                const SizedBox(height: 8),
                //categories title

                //categories items

                //store title
                Gap(isTablet ? 24 : 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: sectionPadding),
                  child: Row(
                    children: [
                      Text(
                        "Stores",
                        style: TextStyle(
                          fontSize: sectionTitleFont,
                          fontFamily: "semi",
                          color: Colors.black,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "see all",
                        style: TextStyle(
                          fontSize: captionFont,
                          fontFamily: "medium",
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(isTablet ? 14 : 10),
                //store items
                LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: constraints.maxWidth,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(stores?.length ?? 0, (index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StoreView(
                                      storeId: stores![index].id,
                                      initialStore: stores![index],
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isTablet ? 4 : 5,
                                ),
                                child: StoreCard(
                                  store_image:
                                      (stores?[index].logo.trim().isNotEmpty ??
                                          false)
                                      ? stores![index].logo
                                      : "assets/Images/stores/store1.png",
                                  store_name:
                                      (stores?[index].name.trim().isNotEmpty ??
                                          false)
                                      ? stores![index].name
                                      : "Unknown store",
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    );
                  },
                ),
                Gap(isTablet ? 24 : 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: sectionPadding),
                  child: Row(
                    children: [
                      Text(
                        "Trend items",
                        style: TextStyle(
                          fontSize: sectionTitleFont,
                          fontFamily: "semi",
                          color: Colors.black,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "see all",
                        style: TextStyle(
                          fontSize: captionFont,
                          fontFamily: "medium",
                          color: Colors.grey,
                        ),
                      ),
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
                  itemCount: products?.length ?? 0,
                  itemBuilder: (context, index) {
                    if (products == null || index >= products!.length) {
                      return SizedBox.shrink();
                    }
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 8 : 6,
                      ),
                      child: ItemCard(
                        imagePath: products![index].imageUrl,
                        storeName: products![index].store?.name ?? '',
                        itemName: products![index].name,
                        price: products![index].price.toStringAsFixed(2),
                        rating: products![index].rating.toString(),
                        isFavorite: _favoriteProductIds.contains(
                          products![index].id,
                        ),
                        onTap: () => _openProduct(products![index]),
                        onFavoriteTap: () =>
                            _toggleFavorite(products![index].id),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
