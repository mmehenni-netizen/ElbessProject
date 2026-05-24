import 'package:elbess/core/constants/colors.dart';
import 'package:elbess/core/network/network_config.dart';
import 'package:elbess/core/utils/pref_helpers.dart';
import 'package:elbess/features/home/data/product_model.dart';
import 'package:elbess/features/home/data/store_model.dart';
import 'package:elbess/features/home/widgets/item_card.dart';
import 'package:elbess/features/productdetail/presentation/product_detail_view.dart';
import 'package:elbess/features/store_page/data/store_repo.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class StoreBody extends StatefulWidget {
  const StoreBody({super.key, required this.storeId, this.initialStore});

  final String storeId;
  final StoreModel? initialStore;

  @override
  State<StoreBody> createState() => _StoreBodyState();
}

class _StoreBodyState extends State<StoreBody> {
  final StoreRepo _storeRepo = StoreRepo();

  StoreModel? _store;
  bool _isLoading = true;
  int _selectedCategoryIndex = 0;
  Set<String> _favoriteProductIds = <String>{};

  @override
  void initState() {
    super.initState();
    _store = widget.initialStore;
    _loadFavorites();
    _loadStore();
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

  Future<void> _loadStore() async {
    final storeId = widget.storeId.trim();

    if (storeId.isEmpty) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final store = await _storeRepo.getStoreById(storeId);

    if (!mounted) {
      return;
    }

    setState(() {
      _store = store;
      _isLoading = false;
    });
  }

  String _resolveImageUrl(String rawPath) {
    final trimmed = rawPath.trim();

    if (trimmed.isEmpty) {
      return '';
    }

    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }

    if (trimmed.startsWith('assets/')) {
      return trimmed;
    }

    return resolveNetworkUrl(trimmed);
  }

  Widget _buildStoreLogo(String rawPath) {
    final resolved = _resolveImageUrl(rawPath);
    if (resolved.isEmpty) {
      return const Icon(Icons.storefront_outlined, color: Colors.grey);
    }

    if (resolved.startsWith('assets/')) {
      return Image.asset(
        resolved,
        width: 42,
        height: 42,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.storefront_outlined, color: Colors.grey),
      );
    }

    return Image.network(
      resolved,
      width: 42,
      height: 42,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) =>
          const Icon(Icons.storefront_outlined, color: Colors.grey),
    );
  }

  List<ProductModel> get _visibleProducts {
    final products = _store?.products ?? <ProductModel>[];
    if (products.isEmpty) {
      return products;
    }

    final categories = _categories;
    if (_selectedCategoryIndex <= 0 ||
        _selectedCategoryIndex >= categories.length) {
      return products;
    }

    final selectedCategory = categories[_selectedCategoryIndex];
    return products
        .where(
          (product) =>
              product.category.trim().toLowerCase() ==
              selectedCategory.toLowerCase(),
        )
        .toList();
  }

  List<String> get _categories {
    final productCategories =
        (_store?.products ?? <ProductModel>[])
            .map((product) => product.category.trim())
            .where((category) => category.isNotEmpty)
            .toSet()
            .toList()
          ..sort();

    return <String>['All', ...productCategories];
  }

  Future<void> _openProduct(ProductModel product) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ProductDetailView(productId: product.id, initialProduct: product),
      ),
    );

    await _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final store = _store;
    final products = _visibleProducts;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        title: const Text(
          'Store',
          style: TextStyle(
            fontFamily: 'semi',
            color: Colors.black,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading && store == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadStore,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[100],
                          ),
                          child: ClipOval(
                            child: SizedBox(
                              width: 56,
                              height: 56,
                              child: store == null
                                  ? const SizedBox.shrink()
                                  : _buildStoreLogo(store!.logo),
                            ),
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                store?.name.isNotEmpty == true
                                    ? store!.name
                                    : 'Unknown store',
                                style: const TextStyle(
                                  fontFamily: 'semi',
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                              const Gap(4),
                              Text(
                                store?.location.isNotEmpty == true
                                    ? '📍${store!.location}'
                                    : 'No location available',
                                style: const TextStyle(
                                  fontFamily: 'regular',
                                  color: Colors.black,
                                  fontSize: 11,
                                ),
                              ),
                              const Gap(4),
                              Text(
                                'Shipping time: ${store?.shippingTime ?? 0} days',
                                style: const TextStyle(
                                  fontFamily: 'medium',
                                  color: Colors.grey,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Gap(24),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontFamily: 'bold',
                        color: Colors.black,
                        fontSize: 22,
                      ),
                    ),
                    const Gap(6),
                    Text(
                      store?.description.isNotEmpty == true
                          ? store!.description
                          : 'No description available for this store.',
                      style: const TextStyle(
                        fontFamily: 'medium',
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const Gap(20),
                    const Text(
                      'Statistics',
                      style: TextStyle(
                        fontFamily: 'bold',
                        color: Colors.black,
                        fontSize: 22,
                      ),
                    ),
                    const Gap(14),
                    Row(
                      children: [
                        _StatCard(
                          label: 'Products',
                          value: '${store?.products.length ?? 0}',
                        ),
                        const Gap(10),
                        _StatCard(
                          label: 'Orders',
                          value: '${store?.totalOrders ?? 0}',
                        ),
                        const Gap(10),
                        _StatCard(
                          label: 'Rating',
                          value: '${store?.rating ?? 0}',
                        ),
                      ],
                    ),
                    const Gap(18),
                    const Text(
                      'Our Products',
                      style: TextStyle(
                        fontFamily: 'bold',
                        color: Colors.black,
                        fontSize: 22,
                      ),
                    ),
                    const Gap(10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(_categories.length, (index) {
                          final category = _categories[index];
                          final isSelected = _selectedCategoryIndex == index;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategoryIndex = index;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Text(
                                category,
                                style: TextStyle(
                                  fontFamily: 'medium',
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const Gap(18),
                    products.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 30),
                            child: Center(
                              child: Text(
                                'No products available for this store.',
                                style: TextStyle(
                                  fontFamily: 'medium',
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  mainAxisExtent: 215,
                                ),
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];
                              final productImage = product.imageUrl.isNotEmpty
                                  ? product.imageUrl
                                  : (product.imageUrls.isNotEmpty
                                        ? product.imageUrls.first
                                        : '');

                              return ItemCard(
                                imagePath: productImage,
                                storeName: store?.name ?? '',
                                itemName: product.name,
                                price: product.price.toStringAsFixed(2),
                                rating: product.rating.toString(),
                                isFavorite: _favoriteProductIds.contains(
                                  product.id,
                                ),
                                onTap: () => _openProduct(product),
                                onFavoriteTap: () => _toggleFavorite(product.id),
                              );
                            },
                          ),
                    const Gap(16),
                  ],
                ),
              ),
            ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'bold',
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            const Gap(4),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'medium',
                color: Colors.grey,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
