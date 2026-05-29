import 'package:elbess/features/favorites/widgets/favoritecard.dart';
import 'package:elbess/core/utils/pref_helpers.dart';
import 'package:elbess/core/utils/price_formatter.dart';
import 'package:elbess/features/home/data/product_model.dart';
import 'package:elbess/features/home/data/store_model.dart';
import 'package:elbess/features/productdetail/data/details_repo.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Favoritesbody extends StatefulWidget {
  const Favoritesbody({super.key});

  @override
  State<Favoritesbody> createState() => _FavoritesbodyState();
}

class _FavoritesbodyState extends State<Favoritesbody> {
  final DetailsRepo _detailsRepo = DetailsRepo();
  bool _isLoading = true;
  List<ProductModel> _favoriteProducts = <ProductModel>[];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final ids = await PrefHelpers.getFavoriteProductIds();
    if (ids.isEmpty) {
      if (!mounted) {
        return;
      }
      setState(() {
        _favoriteProducts = <ProductModel>[];
        _isLoading = false;
      });
      return;
    }

    final products = await Future.wait(ids.map(_detailsRepo.getProductDetails));
    final filtered = products.whereType<ProductModel>().toList();

    if (!mounted) {
      return;
    }

    setState(() {
      _favoriteProducts = filtered;
      _isLoading = false;
    });
  }

  Future<void> _removeFavorite(String productId) async {
    final isFavoriteNow = await PrefHelpers.toggleFavoriteProductId(productId);
    if (isFavoriteNow) {
      return;
    }

    await _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final visibleFavorites = _isLoading ? _placeholderProducts : _favoriteProducts;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              const Center(
                child: Text(
                  'My Favorites',
                  style: TextStyle(fontFamily: 'bold', fontSize: 25),
                ),
              ),
              const Gap(16),
              Expanded(
                child: !_isLoading && _favoriteProducts.isEmpty
                        ? const Center(
                            child: Text(
                              'No favorites yet',
                              style: TextStyle(fontFamily: 'medium', color: Colors.grey),
                            ),
                          )
                        : Skeletonizer(
                            enabled: _isLoading,
                            child: RefreshIndicator(
                            onRefresh: _loadFavorites,
                            child: GridView.builder(
                              itemCount: visibleFavorites.length,
                              padding: const EdgeInsets.only(bottom: 2),
                              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 10,
                                childAspectRatio: 0.57,
                              ),
                              itemBuilder: (context, index) {
                                final item = visibleFavorites[index];
                                final imagePath = item.imageUrl.isNotEmpty
                                    ? item.imageUrl
                                    : (item.imageUrls.isNotEmpty ? item.imageUrls.first : '');
                                return Favoritecard(
                                  img: imagePath,
                                  category: item.category.isNotEmpty ? item.category : 'General',
                                  prdctname: item.name.isNotEmpty ? item.name : 'Product',
                                  brand: item.store?.name.isNotEmpty == true ? item.store!.name : 'Unknown store',
                                  price: formatDzPrice(item.price),
                                  onRemoveTap: _isLoading ? null : () => _removeFavorite(item.id),
                                );
                              },
                            ),
                          ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<ProductModel> get _placeholderProducts => <ProductModel>[
        ProductModel(
          id: 'placeholder-1',
          name: 'Minimal Sweatshirt',
          description: 'A clean everyday layer.',
          price: 320,
          rating: 4,
          totalQuantity: 12,
          sizeQuantities: <SizeQuantityModel>[],
          store: StoreModel(
            id: 'store-1',
            name: 'Elbess Studio',
            location: '',
            description: '',
            activeProducts: 0,
            rating: 0,
            revenus: 0,
            shippingTime: 0,
            products: <ProductModel>[],
            totalOrders: 0,
            address: '',
            password: '',
            isEmailVerified: false,
            logo: '',
            rates: <StoreRateModel>[],
            version: 0,
          ),
          imageUrls: const <String>[],
          imageUrl: '',
          category: 'Sweatshirts',
          gender: 'unisex',
          rates: const <ProductRateModel>[],
          version: 0,
        ),
        ProductModel(
          id: 'placeholder-2',
          name: 'Classic Polo',
          description: 'A sharp staple.',
          price: 280,
          rating: 4,
          totalQuantity: 12,
          sizeQuantities: <SizeQuantityModel>[],
          store: StoreModel(
            id: 'store-2',
            name: 'Elbess Studio',
            location: '',
            description: '',
            activeProducts: 0,
            rating: 0,
            revenus: 0,
            shippingTime: 0,
            products: <ProductModel>[],
            totalOrders: 0,
            address: '',
            password: '',
            isEmailVerified: false,
            logo: '',
            rates: <StoreRateModel>[],
            version: 0,
          ),
          imageUrls: const <String>[],
          imageUrl: '',
          category: 'Polo Shirts',
          gender: 'male',
          rates: const <ProductRateModel>[],
          version: 0,
        ),
      ];
}
