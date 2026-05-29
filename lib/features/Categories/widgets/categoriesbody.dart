import 'package:elbess/core/utils/pref_helpers.dart';
import 'package:elbess/core/utils/price_formatter.dart';
import 'package:elbess/features/home/data/home_repo.dart';
import 'package:elbess/features/home/data/product_model.dart';
import 'package:elbess/features/home/widgets/item_card.dart';
import 'package:elbess/features/productdetail/presentation/product_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

enum _CategorySortField { relevance, price, sales, rating }

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

    if (t.contains('t-shirt') ||
        t.contains('tshirts') ||
        t.contains('t-shirts') ||
        t.contains('t-shirts')) {
      return 'assets/Images/categories2/tshirtcat.avif';
    }

    if (t.contains('hood') ||
        t.contains('hoodie') ||
        t.contains('sweatshirt')) {
      return 'assets/Images/categories2/hoddiescat.avif';
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

    if (t.contains('sweater') ||
        t.contains('sweaters') ||
        t.contains('cardigan')) {
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

  Set<String> _categoryTerms(String value) {
    final normalized = value.toLowerCase().trim();

    if (normalized.isEmpty) {
      return <String>{};
    }

    return normalized
        .split(RegExp(r'\||,|/|\s+'))
        .map((part) => _normalizeCategory(part))
        .where((part) => part.isNotEmpty)
        .toSet();
  }

  Set<String> _aliasesForCategory(String categoryKey) {
    final key = _normalizeCategory(categoryKey);

    final aliases = <String>{key};

    if (key == 'polo') {
      aliases.addAll({'polo', 'poloshirt', 'poloshirts'});
    }

    if (key == 'tshirt' || key == 'tshirts') {
      aliases.addAll({'tshirt', 'tshirts', 't-shirt', 't-shirts'});
    }

    if (key == 'shirt' || key == 'shirts') {
      aliases.addAll({'shirt', 'shirts'});
    }

    if (key == 'trouser' || key == 'trousers' || key == 'pants') {
      aliases.addAll({'trouser', 'trousers', 'pants'});
    }

    if (key == 'denim' || key == 'jean' || key == 'jeans') {
      aliases.addAll({'denim', 'jean', 'jeans'});
    }

    if (key == 'sweater' ||
        key == 'sweaters' ||
        key == 'cardigan' ||
        key == 'cardigans') {
      aliases.addAll({'sweater', 'sweaters', 'cardigan', 'cardigans'});
    }

    if (key == 'hoodie' ||
        key == 'hoodies' ||
        key == 'sweatshirt' ||
        key == 'sweatshirts') {
      aliases.addAll({'hoodie', 'hoodies', 'sweatshirt', 'sweatshirts'});
    }

    if (key == 'shoe' || key == 'shoes') {
      aliases.addAll({'shoe', 'shoes'});
    }

    if (key == 'bag' || key == 'bags') {
      aliases.addAll({'bag', 'bags'});
    }

    return aliases;
  }

  // Build aliases from a displayed category title (handles pipes and synonyms)
  Set<String> _aliasesFromTitle(String title) {
    final parts = title
        .split(RegExp(r"\||,|/"))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final aliases = <String>{};

    for (final part in parts) {
      final key = _normalizeCategory(part);

      if (key.isEmpty) {
        continue;
      }

      aliases.addAll(_aliasesForCategory(key));

      if (key == 'polo') {
        continue;
      }

      if (key == 'tshirt' || key == 'tshirts') {
        continue;
      }

      if (key == 'shirt' || key == 'shirts') {
        continue;
      }

      if (key == 'trouser' || key == 'trousers' || key == 'pants') {
        continue;
      }

      if (key == 'denim' || key == 'jean' || key == 'jeans') {
        continue;
      }

      if (key == 'sweater' ||
          key == 'sweaters' ||
          key == 'cardigan' ||
          key == 'cardigans') {
        continue;
      }

      if (key == 'hoodie' ||
          key == 'hoodies' ||
          key == 'sweatshirt' ||
          key == 'sweatshirts') {
        continue;
      }

      if (key == 'shoe' || key == 'shoes') {
        continue;
      }

      if (key == 'bag' || key == 'bags') {
        continue;
      }

      // default: use the normalized key
      aliases.add(key);
    }

    return aliases;
  }

  List<ProductModel> _productsByCategory(String categoryTitle) {
    final titleTerms = _categoryTerms(categoryTitle);
    return products.where((product) {
      final productTerms = _categoryTerms(product.category);

      if (titleTerms.isEmpty || productTerms.isEmpty) {
        return false;
      }

      if (titleTerms.contains('polo')) {
        return productTerms.contains('polo') ||
            _aliasesForCategory(product.category).contains('polo');
      }

      return productTerms.any(titleTerms.contains) ||
          _aliasesForCategory(product.category).any(titleTerms.contains) ||
          _aliasesFromTitle(categoryTitle).any(productTerms.contains);
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
    final double horizontalPadding = (size.width * 0.04)
        .clamp(12.0, 24.0)
        .toDouble();
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
                    final categoryProducts = _productsByCategory(categoryTitle);

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
                                    colors: [
                                      Colors.transparent,
                                      Color(0xB0000000),
                                    ],
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
  final TextEditingController _searchController = TextEditingController();
  Set<String> _favoriteProductIds = <String>{};
  String _searchQuery = '';
  _CategorySortField _sortField = _CategorySortField.relevance;
  bool _sortDescending = true;
  RangeValues? _priceRange;
  double? _minRating;
  double? _minSales;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
        builder: (_) =>
            ProductDetailView(productId: product.id, initialProduct: product),
      ),
    );

    await _loadFavorites();
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  double get _maxProductPrice {
    if (widget.products.isEmpty) {
      return 0;
    }

    return widget.products
        .map((product) => product.price)
        .reduce((left, right) => left > right ? left : right);
  }

  double get _minProductPrice {
    if (widget.products.isEmpty) {
      return 0;
    }

    return widget.products
        .map((product) => product.price)
        .reduce((left, right) => left < right ? left : right);
  }

  bool get _hasAdvancedFilters {
    return _priceRange != null || _minRating != null || _minSales != null;
  }

  Future<void> _openAdvancedFilters() async {
    final minPrice = _minProductPrice;
    final maxPrice = _maxProductPrice;
    final currentRange = _priceRange ?? RangeValues(minPrice, maxPrice);

    final result = await showModalBottomSheet<_CategoryFilterResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        var selectedPriceRange = currentRange;
        var selectedMinRating = _minRating ?? 0;
        var selectedMinSales = _minSales ?? 0;

        return StatefulBuilder(
          builder: (context, setSheetState) {
            final hasPriceRange = maxPrice > minPrice;

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Container(
                          width: 44,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0E0E0),
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                      const Gap(18),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Advanced filters',
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'semi',
                                color: Colors.black,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setSheetState(() {
                                selectedPriceRange = RangeValues(
                                  minPrice,
                                  maxPrice,
                                );
                                selectedMinRating = 0;
                                selectedMinSales = 0;
                              });
                            },
                            child: const Text('Reset'),
                          ),
                        ],
                      ),
                      const Gap(12),
                      const Text(
                        'Price range',
                        style: TextStyle(fontFamily: 'semi', fontSize: 15),
                      ),
                      const Gap(8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Min: ${formatDzPrice(selectedPriceRange.start)}',
                            style: const TextStyle(fontFamily: 'medium'),
                          ),
                          Text(
                            'Max: ${formatDzPrice(selectedPriceRange.end)}',
                            style: const TextStyle(fontFamily: 'medium'),
                          ),
                        ],
                      ),
                      const Gap(6),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: const Color(0xFF1E1E1E),
                          inactiveTrackColor: const Color(0xFFE5E5E5),
                          thumbColor: const Color(0xFF1E1E1E),
                          overlayColor: const Color(0x221E1E1E),
                        ),
                        child: RangeSlider(
                          values: selectedPriceRange,
                          min: minPrice,
                          max: hasPriceRange ? maxPrice : minPrice + 1,
                          divisions: hasPriceRange
                              ? ((maxPrice - minPrice).round()).clamp(1, 100)
                              : null,
                          labels: RangeLabels(
                            formatDzPrice(selectedPriceRange.start),
                            formatDzPrice(selectedPriceRange.end),
                          ),
                          onChanged: hasPriceRange
                              ? (values) {
                                  setSheetState(() {
                                    selectedPriceRange = values;
                                  });
                                }
                              : null,
                        ),
                      ),
                      const Gap(16),
                      const Text(
                        'Minimum rating',
                        style: TextStyle(fontFamily: 'semi', fontSize: 15),
                      ),
                      Slider(
                        value: selectedMinRating,
                        min: 0,
                        max: 5,
                        divisions: 5,
                        label: selectedMinRating.toStringAsFixed(0),
                        onChanged: (value) {
                          setSheetState(() {
                            selectedMinRating = value;
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Any rating',
                            style: TextStyle(
                              fontFamily: 'medium',
                              color: selectedMinRating == 0
                                  ? const Color(0xFF1E1E1E)
                                  : const Color(0xFF8A8A8A),
                            ),
                          ),
                          Text(
                            '${selectedMinRating.toStringAsFixed(0)}+ stars',
                            style: const TextStyle(fontFamily: 'medium'),
                          ),
                        ],
                      ),
                      const Gap(16),
                      const Text(
                        'Minimum sales',
                        style: TextStyle(fontFamily: 'semi', fontSize: 15),
                      ),
                      Slider(
                        value: selectedMinSales,
                        min: 0,
                        max: 1000,
                        divisions: 20,
                        label: selectedMinSales.toStringAsFixed(0),
                        onChanged: (value) {
                          setSheetState(() {
                            selectedMinSales = value;
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Any sales',
                            style: TextStyle(
                              fontFamily: 'medium',
                              color: selectedMinSales == 0
                                  ? const Color(0xFF1E1E1E)
                                  : const Color(0xFF8A8A8A),
                            ),
                          ),
                          Text(
                            '${selectedMinSales.toStringAsFixed(0)}+',
                            style: const TextStyle(fontFamily: 'medium'),
                          ),
                        ],
                      ),
                      const Gap(18),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E1E1E),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(
                              context,
                              _CategoryFilterResult(
                                priceRange: selectedPriceRange,
                                minRating: selectedMinRating == 0
                                    ? null
                                    : selectedMinRating,
                                minSales: selectedMinSales == 0
                                    ? null
                                    : selectedMinSales,
                              ),
                            );
                          },
                          child: const Text('Apply filters'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (result == null || !mounted) {
      return;
    }

    setState(() {
      _priceRange = result.priceRange;
      _minRating = result.minRating;
      _minSales = result.minSales;
    });
  }

  List<ProductModel> get _visibleProducts {
    final query = _searchQuery.trim().toLowerCase();
    final priceRange = _priceRange;
    final minRating = _minRating;
    final minSales = _minSales;

    final filtered = widget.products.where((product) {
      final storeName = product.store?.name.toLowerCase() ?? '';
      final matchesQuery =
          query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query) ||
          storeName.contains(query);

      if (!matchesQuery) {
        return false;
      }

      if (priceRange != null &&
          (product.price < priceRange.start ||
              product.price > priceRange.end)) {
        return false;
      }

      if (minRating != null && product.rating < minRating) {
        return false;
      }

      if (minSales != null && product.totalQuantity < minSales) {
        return false;
      }

      return true;
    }).toList();

    int compareNumeric(num a, num b) {
      final comparison = a.compareTo(b);
      return _sortDescending ? -comparison : comparison;
    }

    switch (_sortField) {
      case _CategorySortField.price:
        filtered.sort((left, right) => compareNumeric(left.price, right.price));
        break;
      case _CategorySortField.sales:
        filtered.sort(
          (left, right) =>
              compareNumeric(left.totalQuantity, right.totalQuantity),
        );
        break;
      case _CategorySortField.rating:
        filtered.sort(
          (left, right) => compareNumeric(left.rating, right.rating),
        );
        break;
      case _CategorySortField.relevance:
        break;
    }

    return filtered;
  }

  Widget _buildSortChip({
    required String label,
    required _CategorySortField value,
    required IconData icon,
  }) {
    final bool isSelected = _sortField == value;

    return ChoiceChip(
      selected: isSelected,
      avatar: Icon(
        icon,
        size: 16,
        color: isSelected ? Colors.white : const Color(0xFF5F5F5F),
      ),
      label: Text(label),
      labelStyle: TextStyle(
        fontFamily: 'medium',
        color: isSelected ? Colors.white : const Color(0xFF5F5F5F),
      ),
      selectedColor: const Color(0xFF1E1E1E),
      backgroundColor: const Color(0xFFF2F2F2),
      side: BorderSide(
        color: isSelected ? const Color(0xFF1E1E1E) : const Color(0xFFE2E2E2),
      ),
      onSelected: (_) {
        setState(() {
          _sortField = value;
        });
      },
    );
  }

  Widget _buildFilterSummaryChip() {
    if (!_hasAdvancedFilters) {
      return ActionChip(
        avatar: const Icon(Icons.tune_rounded, size: 18),
        label: const Text('Advanced filters'),
        labelStyle: const TextStyle(
          fontFamily: 'medium',
          color: Color(0xFF5F5F5F),
        ),
        backgroundColor: const Color(0xFFF2F2F2),
        side: const BorderSide(color: Color(0xFFE2E2E2)),
        onPressed: _openAdvancedFilters,
      );
    }

    final parts = <String>[];

    if (_priceRange != null) {
      parts.add('Price');
    }

    if (_minRating != null) {
      parts.add('Rating');
    }

    if (_minSales != null) {
      parts.add('Sales');
    }

    return ActionChip(
      avatar: const Icon(Icons.tune_rounded, size: 18),
      label: Text(parts.join(' · ')),
      labelStyle: const TextStyle(fontFamily: 'medium', color: Colors.white),
      backgroundColor: const Color(0xFF1E1E1E),
      side: const BorderSide(color: Color(0xFF1E1E1E)),
      onPressed: _openAdvancedFilters,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final bool isTablet = size.width >= 600;
    final int productGridCount = size.width >= 900 ? 4 : (isTablet ? 3 : 2);
    final double horizontalPadding = (size.width * 0.03)
        .clamp(8.0, 16.0)
        .toDouble();
    final visibleProducts = _visibleProducts;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Text(
          widget.categoryTitle,
          style: const TextStyle(fontFamily: 'semi', color: Colors.black),
        ),
      ),
      body: widget.products.isEmpty
          ? const Center(
              child: Text(
                'No products available',
                style: TextStyle(fontFamily: 'medium', color: Colors.grey),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    12,
                    horizontalPadding,
                    10,
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText:
                          'Search in ${widget.categoryTitle.toLowerCase()}',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _searchQuery.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                              icon: const Icon(Icons.close_rounded),
                            ),
                      filled: true,
                      fillColor: const Color(0xFFF4F4F4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFF1E1E1E),
                          width: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildSortChip(
                        label: 'Best match',
                        value: _CategorySortField.relevance,
                        icon: Icons.auto_awesome_outlined,
                      ),
                      _buildSortChip(
                        label: 'Price',
                        value: _CategorySortField.price,
                        icon: Icons.attach_money_rounded,
                      ),
                      _buildSortChip(
                        label: 'Sales',
                        value: _CategorySortField.sales,
                        icon: Icons.local_fire_department_outlined,
                      ),
                      _buildSortChip(
                        label: 'Rating',
                        value: _CategorySortField.rating,
                        icon: Icons.star_rounded,
                      ),
                      _buildFilterSummaryChip(),
                      ActionChip(
                        avatar: Icon(
                          _sortDescending
                              ? Icons.south_rounded
                              : Icons.north_rounded,
                          size: 18,
                          color: const Color(0xFF5F5F5F),
                        ),
                        label: Text(
                          _sortDescending ? 'High to low' : 'Low to high',
                        ),
                        labelStyle: const TextStyle(
                          fontFamily: 'medium',
                          color: Color(0xFF5F5F5F),
                        ),
                        backgroundColor: const Color(0xFFF2F2F2),
                        side: const BorderSide(color: Color(0xFFE2E2E2)),
                        onPressed: () {
                          setState(() {
                            _sortDescending = !_sortDescending;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    10,
                    horizontalPadding,
                    8,
                  ),
                  child: Text(
                    '${visibleProducts.length} result${visibleProducts.length == 1 ? '' : 's'}${_hasAdvancedFilters ? ' • filters active' : ''}',
                    style: const TextStyle(
                      fontFamily: 'medium',
                      color: Color(0xFF7A7A7A),
                    ),
                  ),
                ),
                Expanded(
                  child: visibleProducts.isEmpty
                      ? const Center(
                          child: Text(
                            'No products match your search or filters',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'medium',
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : GridView.builder(
                          padding: EdgeInsets.fromLTRB(
                            horizontalPadding,
                            4,
                            horizontalPadding,
                            20,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: productGridCount,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: isTablet ? 0.5 : 0.9,
                              ),
                          itemCount: visibleProducts.length,
                          itemBuilder: (context, index) {
                            final product = visibleProducts[index];
                            return ItemCard(
                              imagePath: product.imageUrl,
                              productId: product.id,
                              storeName: product.store?.name ?? '',
                              itemName: product.name,
                              price: formatDzPrice(product.price),
                              rating: product.rating.toString(),
                              isFavorite: _favoriteProductIds.contains(
                                product.id,
                              ),
                              onTap: () => _openProduct(product),
                              onFavoriteTap: () => _toggleFavorite(product.id),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

class _CategoryFilterResult {
  const _CategoryFilterResult({
    required this.priceRange,
    required this.minRating,
    required this.minSales,
  });

  final RangeValues priceRange;
  final double? minRating;
  final double? minSales;
}
