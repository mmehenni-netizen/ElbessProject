import 'package:elbess/core/network/api_service.dart';
import 'package:elbess/features/home/data/product_model.dart';
import 'package:elbess/features/home/data/store_model.dart';

class HomeRepo {
  final ApiService _apiService = ApiService();

  String _normalizeSingleImageUrl(String raw) {
    final imagePath = raw.trim();

    if (imagePath.isEmpty || imagePath == 'default-product-image.jpg') {
      return 'assets/Images/clothes/item1.png';
    }

    if (imagePath.startsWith('assets/') ||
        imagePath.startsWith('/uploads/') ||
        imagePath.startsWith('uploads/') ||
        imagePath.startsWith('http://') ||
        imagePath.startsWith('https://')) {
      return imagePath;
    }

    if (!imagePath.contains('/') && !imagePath.contains('\\')) {
      return 'assets/Images/clothes/$imagePath';
    }

    return imagePath;
  }

  List<String> _normalizeImageUrls(dynamic rawValue) {
    if (rawValue is List) {
      final normalized = rawValue
          .whereType<String>()
          .map(_normalizeSingleImageUrl)
          .where((item) => item.isNotEmpty)
          .toList();

      if (normalized.isNotEmpty) {
        return normalized;
      }
    }

    if (rawValue is String && rawValue.trim().isNotEmpty) {
      return <String>[_normalizeSingleImageUrl(rawValue)];
    }

    return <String>['assets/Images/clothes/item1.png'];
  }

  Map<String, dynamic> _normalizeProductJson(Map<String, dynamic> json) {
    final imageUrls = _normalizeImageUrls(
      json['imageUrl'] ?? json['ImageUrl'] ?? json['imageUrls'] ?? json['image'],
    );
    final sizeQuantitiesRaw = json['sizeQuantities'] ?? json['SizeQuantities'];
    final sizeQuantities = sizeQuantitiesRaw is List
        ? sizeQuantitiesRaw
            .whereType<Map<String, dynamic>>()
            .map((item) => <String, dynamic>{
                  '_id': item['_id'],
                  'size': (item['size'] ?? item['Size'])?.toString() ?? '',
                  'quantity': item['quantity'] ?? item['Quantity'] ?? 0,
                })
            .toList()
        : <Map<String, dynamic>>[];

    return <String, dynamic>{
      ...json,
      '_id': json['_id'],
      'name': (json['name'] ?? json['Name'])?.toString() ?? '',
      'description': (json['description'] ?? json['Description'])?.toString() ?? '',
      'price': json['price'] ?? json['Price'] ?? 0,
      'rating': json['rating'] ?? json['Rating'] ?? 0,
      'totalQuantity': json['totalQuantity'] ?? json['TotalQuantity'] ?? 0,
      'sizeQuantities': sizeQuantities,
      'store': json['store'] ?? json['Store'],
      'imageUrl': imageUrls,
      'category': (json['category'] ?? json['Category'])?.toString() ?? '',
      'gender': (json['gender'] ?? json['Gender'])?.toString() ?? '',
      'rates': json['rates'] ?? <dynamic>[],
      '__v': json['__v'] ?? 0,
    };
  }

  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _apiService.get('/fetch/get-products');

      if (response is! Map<String, dynamic>) {
        return <ProductModel>[];
      }

      final rawProducts = response['products'];

      if (rawProducts is! List) {
        return <ProductModel>[];
      }

      final normalizedProducts = rawProducts
          .whereType<Map<String, dynamic>>()
          .map(_normalizeProductJson)
          .map(ProductModel.fromJson)
          .toList();

      return normalizedProducts;
    } catch (e) {
      print('Error fetching products: $e');
      return <ProductModel>[];
    }
  }

  Future<List<StoreModel>> getStores() async {
    try {
      final response = await _apiService.get('/fetch/get-stores');

      if (response is! Map<String, dynamic>) {
        return <StoreModel>[];
      }

      return StoreResponseModel.fromJson(response).stores;
    } catch (e) {
      print('Error fetching stores: $e');
      return <StoreModel>[];
    }
  }

 
}