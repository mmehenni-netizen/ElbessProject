import 'package:elbess/core/network/api_service.dart';
import 'package:elbess/features/home/data/product_model.dart';
import 'package:elbess/features/home/data/store_model.dart';

class DetailsRepo {
final ApiService _apiService = ApiService();

Map<String, dynamic> _normalizeProductJson(Map<String, dynamic> json) {
  final rawStore = json['store'] ?? json['Store'];

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
    'imageUrl': (json['imageUrl'] ?? json['ImageUrl'])?.toString() ?? '',
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
    print('Error fetching product details: $e');
    return null;

 }
  }

  Future<StoreModel> getStoreDetails(String storeId) async {
 try {
      final response = await _apiService.get('/fetch/get-store/$storeId');
      if (response is! Map<String, dynamic>) {
        return _defaultStore();
      }

      final storeJson = response['store'];
      if (storeJson is! Map<String, dynamic>) {
        return _defaultStore();
      }

      return StoreModel.fromJson(storeJson);
 } catch (e) {
    print('Error fetching store details: $e');
    return _defaultStore();

 }
  }

  StoreModel _defaultStore() {
    return StoreModel(
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
  }

}