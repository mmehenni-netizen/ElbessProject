import 'package:elbess/core/constants/colors.dart';
import 'package:elbess/core/network/network_config.dart';
import 'package:elbess/core/utils/pref_helpers.dart';
import 'package:elbess/core/utils/price_formatter.dart';
import 'package:elbess/features/checkout/presentation/checkout_view.dart';
import 'package:elbess/features/chat/views/chat_veiw.dart';
import 'package:elbess/features/home/data/product_model.dart';
import 'package:elbess/features/home/data/store_model.dart';
import 'package:elbess/features/productdetail/data/details_repo.dart';
import 'package:elbess/features/productdetail/widgets/product_header.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'product_image.dart';
import 'rating_stars.dart';
import 'selectable_stars.dart';
import 'quantity_button.dart';
import 'image_utils.dart';
import 'product_placeholders.dart';

class ProductDetailBody extends StatefulWidget {
  const ProductDetailBody({
    super.key,
    required this.productId,
    this.initialProduct,
  });
  final String productId;
  final ProductModel? initialProduct;

  @override
  State<ProductDetailBody> createState() => _ProductDetailBodyState();
}

class _ProductDetailBodyState extends State<ProductDetailBody> {
  final DetailsRepo detailsRepo = DetailsRepo();
  final PageController _pageController = PageController();

  ProductModel? product;
  StoreModel? store;
  bool isLoading = false;
  int currentIndex = 0;
  final Map<String, int> _selectedSizeQuantities = <String, int>{};
  bool _isFavorite = false;
  int _selectedRating = 0;
  bool _isSubmittingRating = false;
  double? _resolvedProductRating;

  void _setDefaultStore() {
    if (!mounted) {
      return;
    }

    setState(() {
      store = StoreModel(
        id: '',
        name: 'Unknown store',
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
      );
    });
  }

  

  Widget _buildRatingStars(double rating) {
    return RatingStars(rating: rating.round().clamp(0, 5));
  }

  Future<void> _loadProductRate({String? productIdOverride}) async {
    final productId = (productIdOverride ?? product?.id ?? widget.productId).trim();
    if (productId.isEmpty) {
      return;
    }

    try {
      final rate = await detailsRepo.getRate(productId: productId);
      if (!mounted || rate == null) {
        return;
      }

      setState(() {
        _resolvedProductRating = rate.rating;
        if (rate.userRate != null && rate.userRate! > 0) {
          _selectedRating = rate.userRate!.clamp(0, 5);
        }
      });
    } catch (e) {
      debugPrint('Error fetching product rate: $e');
    }
  }

  List<SizeQuantityModel> get _availableSizeQuantities {
    final sizeQuantities =
        product?.sizeQuantities ?? const <SizeQuantityModel>[];
    if (sizeQuantities.isNotEmpty) {
      return sizeQuantities;
    }

    return <SizeQuantityModel>[
      SizeQuantityModel(id: 'size-s', size: 'S', quantity: 999),
      SizeQuantityModel(id: 'size-m', size: 'M', quantity: 999),
      SizeQuantityModel(id: 'size-l', size: 'L', quantity: 999),
      SizeQuantityModel(id: 'size-xl', size: 'XL', quantity: 999),
    ];
  }

  int _selectedQuantityFor(String size) => _selectedSizeQuantities[size] ?? 0;

  int _maxQuantityFor(String size) {
    final match = _availableSizeQuantities
        .where((item) => item.size == size)
        .toList();

    if (match.isEmpty) {
      return 999;
    }

    final quantity = match.first.quantity;
    return quantity > 0 ? quantity : 0;
  }

  int get _selectedTotalQuantity {
    return _selectedSizeQuantities.values.fold<int>(
      0,
      (total, quantity) => total + quantity,
    );
  }

  List<Map<String, dynamic>> _buildSelectedOrderItems() {
    final productId = (product?.id ?? widget.productId).trim();
    if (productId.isEmpty) {
      return <Map<String, dynamic>>[];
    }

    final storeId = (product?.store?.id ?? store?.id ?? '').trim();
    final imageUrl = (product?.imageUrl ?? '').trim();
    final items = <Map<String, dynamic>>[];

    for (final entry in _selectedSizeQuantities.entries) {
      final size = entry.key.trim();
      final quantity = entry.value;
      if (size.isEmpty || quantity <= 0) {
        continue;
      }

      items.add(<String, dynamic>{
        'productId': productId,
        'storeId': storeId,
        'name': product?.name ?? '',
        'imageUrl': imageUrl,
        'price': product?.price ?? 0,
        'size': size,
        'quantity': quantity,
        'storeName': store?.name ?? product?.store?.name ?? '',
      });
    }

    return items;
  }

  void _changeSizeQuantity(String size, int delta) {
    final current = _selectedQuantityFor(size);
    final maxQuantity = _maxQuantityFor(size);
    final next = (current + delta).clamp(0, maxQuantity);

    if (next == current) {
      return;
    }

    setState(() {
      if (next == 0) {
        _selectedSizeQuantities.remove(size);
      } else {
        _selectedSizeQuantities[size] = next;
      }
    });
  }

  Future<void> _loadFavoriteState() async {
    final productId = (product?.id ?? widget.productId).trim();
    if (productId.isEmpty) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isFavorite = false;
      });
      return;
    }

    try {
      final favorite = await PrefHelpers.isFavoriteProduct(productId);
      if (!mounted) {
        return;
      }
      setState(() {
        _isFavorite = favorite;
      });
    } catch (e) {
      debugPrint('Error loading favorite state: $e');
      if (!mounted) {
        return;
      }
      setState(() {
        _isFavorite = false;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final productId = (product?.id ?? widget.productId).trim();
    if (productId.isEmpty) {
      return;
    }

    try {
      final isFavoriteNow = await PrefHelpers.toggleFavoriteProductId(
        productId,
      );
      if (!mounted) {
        return;
      }

      setState(() {
        _isFavorite = isFavoriteNow;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isFavoriteNow ? 'Added to favorites' : 'Removed from favorites',
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not update favorite right now')),
      );
    }
  }

  Future<void> getProductDetails() async {
    if (!mounted) {
      return;
    }

    final productId = widget.productId.trim();
    if (productId.isEmpty || productId == '0') {
      if (!mounted) {
        return;
      }

      setState(() {
        product = widget.initialProduct;
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final details = await detailsRepo.getProductDetails(productId);

      if (!mounted) {
        return;
      }

      setState(() {
        if (details != null) {
          product = details;
        }
        isLoading = false;
      });

      await _loadProductRate(
        productIdOverride: (details ?? product)?.id ?? productId,
      );

      await _loadFavoriteState();
      if (!mounted) {
        return;
      }

      final storeId = (details ?? product)?.store?.id ?? '';
      if (storeId.isNotEmpty) {
        await getStoreDetails(storeId);
      } else {
        _setDefaultStore();
      }

      debugPrint('Product Details: $details');
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;
      });
      debugPrint('Error fetching product details: $e');
    }
  }

  Future<void> getStoreDetails(String storeId) async {
    if (storeId.trim().isEmpty) {
      _setDefaultStore();
      return;
    }

    try {
      final details = await detailsRepo.getStoreDetails(storeId);

      if (!mounted) {
        return;
      }

      setState(() {
        store = details;
      });
      debugPrint('Store Details: $details');
    } catch (e) {
      debugPrint('Error fetching store details: $e');
      _setDefaultStore();
    }
  }

  Widget _buildSelectableStars(int rating, {required ValueChanged<int> onTap}) {
    return SelectableStars(rating: rating, onTap: onTap);
  }

  Future<void> _submitProductRating() async {
    final productId = (product?.id ?? widget.productId).trim();
    final rating = _selectedRating;

    if (productId.isEmpty || rating < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pick a rating first')),
      );
      return;
    }

    setState(() {
      _isSubmittingRating = true;
    });

    final errorMessage = await detailsRepo.rateProduct(
      productId: productId,
      rating: rating,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isSubmittingRating = false;
    });

    if (errorMessage != null) {
      final lowerMessage = errorMessage.toLowerCase();
      final displayMessage = lowerMessage.contains('unauthorized') ||
              lowerMessage.contains('token') ||
              lowerMessage.contains('login')
          ? 'Please log in to submit a rating'
          : errorMessage;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(displayMessage)),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Rating submitted successfully')),
    );

    await getProductDetails();
  }

  @override
  void initState() {
    super.initState();
    product = widget.initialProduct;
    _selectedRating = widget.initialProduct?.rating.clamp(0, 5) ?? 0;
    _loadFavoriteState();
    getProductDetails();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final safeProduct = product ?? _placeholderProduct;
    final safeStore = store ?? safeProduct.store ?? _placeholderStore;
    final productImage = safeProduct.imageUrl.isNotEmpty
        ? safeProduct.imageUrl
        : (safeProduct.imageUrls.isNotEmpty ? safeProduct.imageUrls.first : '');
    final storeName = safeStore.name.trim().isNotEmpty
        ? safeStore.name
        : 'Unknown store';
    final storeLogo = safeStore.logo.trim();

    final displayedRating = _resolvedProductRating ?? safeProduct.rating.toDouble();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: !isLoading && product == null
          ? const Center(
              child: Text(
                'Product details are not available.',
                style: TextStyle(fontFamily: 'semi', color: Colors.grey),
              ),
            )
          : Skeletonizer(
              enabled: isLoading,
              child: Column(
                children: [
                  ProductHeader(
                    rawImage: productImage,
                    currentIndex: currentIndex,
                    pageController: _pageController,
                    onPageChanged: (index) {
                      if (!mounted) return;
                      setState(() => currentIndex = index);
                    },
                    isLoading: isLoading,
                    isFavorite: _isFavorite,
                    onBack: () => Navigator.pop(context),
                    onToggleFavorite: _toggleFavorite,
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(36),
                          topRight: Radius.circular(36),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x12000000),
                            blurRadius: 18,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.fromLTRB(
                                18,
                                18,
                                18,
                                12,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            storeName,
                                            style: TextStyle(
                                              fontFamily: "bold",
                                              color: Colors.black,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const Gap(6),
                                          storeLogo.isNotEmpty
                                              ? Builder(
                                                  builder: (context) {
                                                    final resolvedLogo =
                                                        resolveImageUrlNormalized(
                                                          storeLogo,
                                                        );
                                                    if (resolvedLogo.startsWith(
                                                      'assets/',
                                                    )) {
                                                      return Image.asset(
                                                        resolvedLogo,
                                                        height:
                                                            MediaQuery.sizeOf(
                                                              context,
                                                            ).height *
                                                            0.04,
                                                        errorBuilder:
                                                            (
                                                              _,
                                                              __,
                                                              ___,
                                                            ) => const Icon(
                                                              Icons
                                                                  .storefront_outlined,
                                                              size: 18,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                      );
                                                    }

                                                    return Image.network(
                                                      resolvedLogo,
                                                      height:
                                                          MediaQuery.sizeOf(
                                                            context,
                                                          ).height *
                                                          0.04,
                                                      errorBuilder:
                                                          (
                                                            _,
                                                            __,
                                                            ___,
                                                          ) => const Icon(
                                                            Icons
                                                                .storefront_outlined,
                                                            size: 18,
                                                            color: Colors.grey,
                                                          ),
                                                    );
                                                  },
                                                )
                                              : const Icon(
                                                  Icons.storefront_outlined,
                                                  size: 18,
                                                  color: Colors.grey,
                                                ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          _buildRatingStars(displayedRating),
                                          Text(
                                            ' ${displayedRating.toStringAsFixed(1)}/5',
                                            style: TextStyle(
                                              fontFamily: "bold",
                                              color: Colors.black,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Gap(10),
                                  Text(
                                    safeProduct.name.isNotEmpty
                                        ? safeProduct.name
                                        : 'Product',
                                    style: TextStyle(
                                      fontFamily: "bold",
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    formatDzPrice(safeProduct.price),
                                    style: TextStyle(
                                      fontFamily: "bold",
                                      color: AppColors.primary,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const Gap(10),
                                  Text(
                                    safeProduct.description.isNotEmpty
                                        ? safeProduct.description
                                        : 'No description available.',
                                    style: TextStyle(
                                      fontFamily: "semi",
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const Gap(14),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF9F7F4),
                                      borderRadius: BorderRadius.circular(22),
                                      border: Border.all(
                                        color: const Color(0xFFEDE4DA),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Rate this product',
                                          style: TextStyle(
                                            fontFamily: 'semi',
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const Gap(6),
                                        Text(
                                          _selectedRating > 0
                                              ? 'You selected $_selectedRating star${_selectedRating == 1 ? '' : 's'}'
                                              : 'Tap a star to rate this item',
                                          style: const TextStyle(
                                            fontFamily: 'medium',
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const Gap(8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            _buildSelectableStars(
                                              _selectedRating,
                                              onTap: (value) {
                                                if (!mounted) {
                                                  return;
                                                }
                                                setState(() {
                                                  _selectedRating = value;
                                                });
                                              },
                                            ),
                                            TextButton(
                                              onPressed: _isSubmittingRating
                                                  ? null
                                                  : _submitProductRating,
                                              child: _isSubmittingRating
                                                  ? const SizedBox(
                                                      height: 18,
                                                      width: 18,
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                      ),
                                                    )
                                                  : Text(
                                                      'Submit',
                                                      style: TextStyle(
                                                        fontFamily: 'semi',
                                                        color:
                                                            AppColors.primary,
                                                      ),
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Gap(16),
                                  Container(
                                    color: Colors.white,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Size',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Wrap(
                                          spacing: 10,
                                          runSpacing: 10,
                                          children: _availableSizeQuantities.map((
                                            sizeItem,
                                          ) {
                                            final selectedQuantity =
                                                _selectedQuantityFor(
                                                  sizeItem.size,
                                                );
                                            final remaining =
                                                _maxQuantityFor(sizeItem.size) -
                                                selectedQuantity;

                                            return Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 10,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                                border: Border.all(
                                                  color: const Color(
                                                    0xFFE0D8D1,
                                                  ),
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    sizeItem.size,
                                                    style: const TextStyle(
                                                      fontFamily: 'semi',
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      QuantityButton(
                                                        icon: Icons.remove,
                                                        onTap:
                                                            selectedQuantity > 0
                                                            ? () =>
                                                                  _changeSizeQuantity(
                                                                    sizeItem
                                                                        .size,
                                                                    -1,
                                                                  )
                                                            : () {},
                                                      ),
                                                      SizedBox(
                                                        width: 30,
                                                        child: Center(
                                                          child: Text(
                                                            '$selectedQuantity',
                                                            style:
                                                                const TextStyle(
                                                                  fontFamily:
                                                                      'semi',
                                                                  fontSize: 15,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                      QuantityButton(
                                                        icon: Icons.add,
                                                        onTap: remaining > 0
                                                            ? () =>
                                                                  _changeSizeQuantity(
                                                                    sizeItem
                                                                        .size,
                                                                    1,
                                                                  )
                                                            : () {},
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          _selectedTotalQuantity > 0
                                              ? 'Selected: $_selectedTotalQuantity item${_selectedTotalQuantity == 1 ? '' : 's'}'
                                              : 'Pick sizes and quantities before checkout',
                                          style: const TextStyle(
                                            fontFamily: 'medium',
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SafeArea(
                            top: false,
                            minimum: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (isLoading) {
                                        return;
                                      }
                                      final items = _buildSelectedOrderItems();
                                      final messenger = ScaffoldMessenger.of(
                                        context,
                                      );
                                      if (items.isEmpty) {
                                        messenger.showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Select at least one size first',
                                            ),
                                          ),
                                        );
                                        return;
                                      }

                                      for (final item in items) {
                                        await PrefHelpers.addCartItem(item);
                                      }

                                      if (!mounted) {
                                        return;
                                      }

                                      messenger.showSnackBar(
                                        const SnackBar(
                                          content: Text('Added to cart'),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: screenSize.height * 0.055,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(18),
                                        border: Border.all(
                                          color: AppColors.primary,
                                          width: 1.2,
                                        ),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0x0F000000),
                                            blurRadius: 14,
                                            offset: Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Add to Cart",
                                          style: TextStyle(
                                            fontFamily: "semi",
                                            color: AppColors.primary,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Gap(5),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (isLoading) {
                                        return;
                                      }

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ChatView(
                                            productName: safeProduct.name.isNotEmpty
                                                ? safeProduct.name
                                                : 'Product',
                                            productImage: productImage,
                                            productPrice: safeProduct.price > 0
                                                ? formatDzPrice(safeProduct.price)
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: screenSize.height * 0.055,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF4ECFE),
                                        borderRadius: BorderRadius.circular(18),
                                        border: Border.all(
                                          color: AppColors.primary,
                                          width: 1.2,
                                        ),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0x0F7C3AED),
                                            blurRadius: 14,
                                            offset: Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.smart_toy_outlined,
                                              color: AppColors.primary,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Ask AI',
                                              style: TextStyle(
                                                fontFamily: 'semi',
                                                color: AppColors.primary,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Gap(5),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (isLoading) {
                                        return;
                                      }
                                      final items = _buildSelectedOrderItems();
                                      if (items.isEmpty) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Select at least one size first',
                                            ),
                                          ),
                                        );
                                        return;
                                      }

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => CheckoutView(
                                            orderPayload: <String, dynamic>{
                                              'items': items,
                                              'fromCart': false,
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: screenSize.height * 0.055,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Color(0xFFB56E3D),
                                            Color(0xFFD39A6B),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(18),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0x28000000),
                                            blurRadius: 18,
                                            offset: Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Buy Now",
                                          style: TextStyle(
                                            fontFamily: "semi",
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  StoreModel get _placeholderStore => placeholderStore();

  ProductModel get _placeholderProduct => placeholderProduct();
}

