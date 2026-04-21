import 'package:elbess/core/network/api_service.dart';
import 'package:elbess/features/home/data/product_model.dart';
import 'package:elbess/features/home/data/store_model.dart';

class StoreRepo {
  final ApiService _apiService = ApiService();

  String _normalizeImageUrl(dynamic rawValue) {
    if (rawValue is List && rawValue.isNotEmpty) {
      final first = rawValue.first?.toString().trim() ?? '';
      if (first.isNotEmpty) {
        return first;
      }
    }

    final raw = rawValue?.toString().trim() ?? '';

    if (raw.isEmpty || raw == 'default-product-image.jpg') {
      return 'assets/Images/clothes/item1.png';
    }

    if (raw.startsWith('assets/') ||
        raw.startsWith('/uploads/') ||
        raw.startsWith('uploads/') ||
        raw.startsWith('http://') ||
        raw.startsWith('https://')) {
      return raw;
    }

    if (!raw.contains('/') && !raw.contains('\\')) {
      return 'assets/Images/clothes/$raw';
    }

    return raw;
  }

  Map<String, dynamic> _normalizeProductJson(Map<String, dynamic> json) {
    final rawStore = json['store'] ?? json['Store'];
    final normalizedStore = rawStore is String && rawStore.trim().isNotEmpty
        ? <String, dynamic>{'_id': rawStore.trim()}
        : rawStore is Map<String, dynamic>
            ? rawStore
            : null;

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

    final rawImageUrls = json['imageUrl'] ?? json['imageUrls'] ?? json['image'];
    final normalizedImageUrls = rawImageUrls is List
        ? rawImageUrls
            .whereType<String>()
            .map((item) => item.trim())
            .where((item) => item.isNotEmpty)
            .toList()
        : rawImageUrls is String && rawImageUrls.trim().isNotEmpty
            ? <String>[rawImageUrls.trim()]
            : <String>[];

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
      'imageUrl': normalizedImageUrls,
      'category': (json['category'] ?? json['Category'])?.toString() ?? '',
      'gender': (json['gender'] ?? json['Gender'])?.toString() ?? '',
      'rates': json['rates'] ?? <dynamic>[],
      '__v': json['__v'] ?? 0,
    };
  }

  Map<String, dynamic> _normalizeStoreJson(Map<String, dynamic> json) {
    final rawProducts = json['products'];
    final products = rawProducts is List
        ? rawProducts
            .whereType<Map<String, dynamic>>()
            .map(_normalizeProductJson)
            .map(ProductModel.fromJson)
            .toList()
        : <ProductModel>[];

    return <String, dynamic>{
      ...json,
      '_id': json['_id'],
      'name': (json['name'] ?? json['Name'])?.toString() ?? '',
      'location': (json['location'] ?? json['Location'])?.toString() ?? '',
      'description': (json['description'] ?? json['Description'])?.toString() ?? '',
      'activeProducts': json['activeProducts'] ?? json['ActiveProducts'] ?? 0,
      'rating': json['rating'] ?? json['Rating'] ?? 0,
      'revenus': json['revenus'] ?? json['Revenus'] ?? 0,
      'shippingTime': json['shippingTime'] ?? json['ShippingTime'] ?? 0,
      'products': products.map((product) => product.toJson()).toList(),
      'totalOrders': json['totalOrders'] ?? json['TotalOrders'] ?? 0,
      'address': (json['address'] ?? json['Address'])?.toString() ?? '',
      'password': (json['password'] ?? json['Password'])?.toString() ?? '',
      'isEmailVerified': json['isEmailVerified'] == true,
      'logo': _normalizeImageUrl(json['logo'] ?? json['Logo']),
      'rates': json['rates'] ?? <dynamic>[],
      '__v': json['__v'] ?? 0,
    };
  }

  Future<StoreModel> getStoreById(String storeId) async {
    try {
      final response = await _apiService.get('/fetch/get-store/${storeId.trim()}');

      if (response is! Map<String, dynamic>) {
        return _defaultStore();
      }

      final storeJson = response['store'];
      if (storeJson is! Map<String, dynamic>) {
        return _defaultStore();
      }

      return StoreModel.fromJson(_normalizeStoreJson(storeJson));
    } catch (e) {
      print('Error fetching store by id: $e');
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