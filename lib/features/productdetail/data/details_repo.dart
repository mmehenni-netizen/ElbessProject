import 'package:elbess/core/network/api_service.dart';
import 'package:elbess/core/network/api_error.dart';
import 'package:elbess/features/home/data/product_model.dart';
import 'package:elbess/features/home/data/store_model.dart';
import 'package:elbess/features/store_page/data/store_repo.dart';
import 'package:flutter/foundation.dart';

class DetailsRepo {
final ApiService _apiService = ApiService();
final StoreRepo _storeRepo = StoreRepo();

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
  final rawStore = json['store'] ?? json['Store'];
  final imageUrls = _normalizeImageUrls(
    json['imageUrl'] ?? json['ImageUrl'] ?? json['imageUrls'] ?? json['image'],
  );

  Map<String, dynamic>? normalizedStore;
  if (rawStore is Map<String, dynamic>) {
    normalizedStore = rawStore;
  } else if (rawStore is String && rawStore.trim().isNotEmpty) {
    normalizedStore = {'_id': rawStore.trim()};
  }

  final rawSizeQuantities = json['sizeQuantities'] ?? json['SizeQuantities'];
  final normalizedSizeQuantities = rawSizeQuantities is List
      ? rawSizeQuantities
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
    'sizeQuantities': normalizedSizeQuantities,
    'store': normalizedStore,
    'imageUrl': imageUrls,
    'category': (json['category'] ?? json['Category'])?.toString() ?? '',
    'gender': (json['gender'] ?? json['Gender'])?.toString() ?? '',
    'rates': json['rates'] ?? <dynamic>[],
    '__v': json['__v'] ?? 0,
  };
}

Future<ProductModel?> getProductDetails(String productId) async {
 try {
      final response = await _apiService.get('/fetch/get-product/$productId');
      if (response is! Map<String, dynamic>) {
        return null;
      }

      final productJson = response['product'];
      if (productJson is! Map<String, dynamic>) {
        return null;
      }

      return ProductModel.fromJson(_normalizeProductJson(productJson));
 } catch (e) {
    debugPrint('Error fetching product details: $e');
    return null;

 }
  }

  Future<StoreModel> getStoreDetails(String storeId) async {
    return _storeRepo.getStoreById(storeId);
  }

Future<String?> rateProduct({
  required String productId,
  required int rating,
}) async {
  try {
    final payload = {
      'productId': productId.trim(),
      'rating': rating,
    };

    final response = await _apiService.post('/actions/rate', payload);

    if (response is ApiError) {
      return response.message;
    }

    if (response is! Map<String, dynamic>) {
      return 'Unexpected response from server';
    }

    if (response['success'] == true) return null;

    return response['message']?.toString() ?? 'Could not submit rating right now';
  } catch (e) {
    debugPrint('Error rating product: $e');
    return 'Could not submit rating right now';
  }
}}
