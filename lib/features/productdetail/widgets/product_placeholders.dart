import 'package:elbess/features/home/data/product_model.dart';
import 'package:elbess/features/home/data/store_model.dart';

StoreModel placeholderStore() => StoreModel(
      id: 'store-placeholder',
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
    );

ProductModel placeholderProduct() => ProductModel(
      id: 'product-placeholder',
      name: 'Relaxed Cotton Hoodie',
      description: 'A clean, easy layer with a soft brushed finish.',
      price: 420,
      rating: 4,
      totalQuantity: 12,
      sizeQuantities: <SizeQuantityModel>[
        SizeQuantityModel(id: 'size-s', size: 'S', quantity: 4),
        SizeQuantityModel(id: 'size-m', size: 'M', quantity: 4),
        SizeQuantityModel(id: 'size-l', size: 'L', quantity: 4),
      ],
      store: placeholderStore(),
      imageUrls: const <String>[],
      imageUrl: '',
      category: 'Hoodies',
      gender: 'unisex',
      rates: const <ProductRateModel>[],
      version: 0,
    );
