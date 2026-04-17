import 'package:elbess/core/constants/colors.dart';
import 'package:elbess/core/utils/pref_helpers.dart';
import 'package:elbess/features/checkout/presentation/checkout_view.dart';
import 'package:elbess/features/home/data/product_model.dart';
import 'package:elbess/features/home/data/store_model.dart';
import 'package:elbess/features/productdetail/data/details_repo.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProductDetailBody extends StatefulWidget {
  const ProductDetailBody({super.key, required this.productId, this.initialProduct});
  final String productId;
  final ProductModel? initialProduct;

  @override
  State<ProductDetailBody> createState() => _ProductDetailBodyState();
}

class _ProductDetailBodyState extends State<ProductDetailBody> {
  final DetailsRepo detailsRepo = DetailsRepo();
  final PageController _pageController = PageController();
  final List<String> sizes = ["S", "M", "L", "XL"];

  ProductModel? product;
  StoreModel? store;
  bool isLoading = false;
  int currentIndex = 0;
  String selectedSize = "S";
  bool _isFavorite = false;

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

    final favorite = await PrefHelpers.isFavoriteProduct(productId);
    if (!mounted) {
      return;
    }
    setState(() {
      _isFavorite = favorite;
    });
  }

  Future<void> _toggleFavorite() async {
    final productId = (product?.id ?? widget.productId).trim();
    if (productId.isEmpty) {
      return;
    }

    final isFavoriteNow = await PrefHelpers.toggleFavoriteProductId(productId);
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
  }

  Future<void> getProductDetails() async {
    if (!mounted) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final details = await detailsRepo.getProductDetails(widget.productId);

      if (!mounted) {
        return;
      }

      setState(() {
        if (details != null) {
          product = details;
        }
        isLoading = false;
      });

      await _loadFavoriteState();

      final storeId = (details ?? product)?.store?.id ?? '';
      if (storeId.isNotEmpty) {
        await getStoreDetails(storeId);
      } else {
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

      print('Product Details: $details');
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;
      });
      print('Error fetching product details: $e');
    }
  }

  Future<void> getStoreDetails(String storeId) async {
    try {
      final details = await detailsRepo.getStoreDetails(storeId);

      if (!mounted) {
        return;
      }

      setState(() {
        store = details;
      });
      print('Store Details: $details');
    } catch (e) {
      print('Error fetching store details: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    product = widget.initialProduct;
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
    final safeProduct = product;
    final safeStore = store;
    final storeName = (safeStore?.name.trim().isNotEmpty ?? false)
        ? safeStore!.name
        : 'Unknown store';
    final storeLogo = safeStore?.logo.trim() ?? '';

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : safeProduct == null
              ? const Center(
                  child: Text(
                    'Product details are not available.',
                    style: TextStyle(fontFamily: 'semi', color: Colors.grey),
                  ),
                )
              : Column(
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
          itemCount: 1,
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return Center(
              child: safeProduct.imageUrl.trim().isEmpty
                  ? const Icon(Icons.image_not_supported_outlined, size: 72, color: Colors.grey)
                  : Image.network(
                      safeProduct.imageUrl,
                      height: MediaQuery.sizeOf(context).height * 0.6,
                      width: MediaQuery.sizeOf(context).width * 0.6,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.image_not_supported_outlined,
                        size: 72,
                        color: Colors.grey,
                      ),
                    ),
            );
          },
        ),
            ),
        
           
            Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          1,
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
                    GestureDetector(
                      onTap: _toggleFavorite,
                      child: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? Colors.red : Colors.black,
                      ),
                    ),
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
                      storeName,
                      style: TextStyle(fontFamily: "bold", color: Colors.black, fontSize: 12),
                    ),
                     const Gap(6),
                     (storeLogo.isNotEmpty)
                         ? Image.network(
                             storeLogo,
                             height: MediaQuery.sizeOf(context).height * 0.04,
                             errorBuilder: (_, __, ___) => const Icon(
                               Icons.storefront_outlined,
                               size: 18,
                               color: Colors.grey,
                             ),
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
                      Icon( Icons.star, color: Colors.amber, size: 15),
                      Text(" 4.5", style: TextStyle(fontFamily: "bold", color: Colors.black, fontSize: 12)),
        
                    ],
                   ) 
                  ],
                ),
                Gap(10),
               Text(safeProduct.name.isNotEmpty ? safeProduct.name : 'Product', style: TextStyle(fontFamily: "bold", color: Colors.black, fontSize: 20)),
             const SizedBox(height: 10,),
             
             
               Text("\$${safeProduct.price.toStringAsFixed(2)}", style: TextStyle(fontFamily: "bold", color: AppColors.primary, fontSize: 18)),
             Gap(10),
               Text(safeProduct.description.isNotEmpty ? safeProduct.description : 'No description available.', style: TextStyle(fontFamily: "semi", color: Colors.grey, fontSize: 12)),
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
             
            ],
          ),
            ),
          const Spacer(),
          Row(
            children: [
             GestureDetector(
              onTap: () async {
                final item = <String, dynamic>{
                  'productId': safeProduct.id,
                  'name': safeProduct.name,
                  'imageUrl': safeProduct.imageUrl,
                  'price': safeProduct.price,
                  'size': selectedSize,
                  'quantity': 1,
                  'storeName': storeName,
                };

                await PrefHelpers.addCartItem(item);

                if (!mounted) {
                  return;
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to cart')),
                );
              },
              child: Container(
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
             ),
             Gap(5),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CheckoutView(),
                  ),
                );
              },
              child: Container(
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