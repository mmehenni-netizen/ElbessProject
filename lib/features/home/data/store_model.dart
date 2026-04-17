import 'product_model.dart';

class StoreResponseModel {
  final bool success;
  final String message;
  final List<StoreModel> stores;

  StoreResponseModel({
    required this.success,
    required this.message,
    required this.stores,
  });

  factory StoreResponseModel.fromJson(Map<String, dynamic> json) {
    final rawStores = json['stores'];
    final stores = rawStores is List
        ? rawStores
            .whereType<Map<String, dynamic>>()
            .map(StoreModel.fromJson)
            .toList()
        : <StoreModel>[];

    return StoreResponseModel(
      success: json['success'] == true,
      message: (json['message'] as String?) ?? '',
      stores: stores,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'stores': stores.map((store) => store.toJson()).toList(),
    };
  }
}

class StoreModel {
  final String id;
  final String name;
  final String location;
  final String description;
  final int activeProducts;
  final int rating;
  final int revenus;
  final int shippingTime;
  final List<ProductModel> products;
  final int totalOrders;
  final String address;
  final String password;
  final bool isEmailVerified;
  final String logo;
  final List<StoreRateModel> rates;
  final int version;

  StoreModel({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.activeProducts,
    required this.rating,
    required this.revenus,
    required this.shippingTime,
    required this.products,
    required this.totalOrders,
    required this.address,
    required this.password,
    required this.isEmailVerified,
    required this.logo,
    required this.rates,
    required this.version,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    final rawProducts = json['products'];
    final rawRates = json['rates'];

    return StoreModel(
      id: (json['_id'] as String?) ?? '',
      name: ((json['name'] ?? json['Name']) as String?) ?? '',
      location: ((json['location'] ?? json['Location']) as String?) ?? '',
      description: ((json['description'] ?? json['Description']) as String?) ?? '',
      activeProducts: ((json['activeProducts'] ?? json['ActiveProducts']) as num?)?.toInt() ?? 0,
      rating: ((json['rating'] ?? json['Rating']) as num?)?.toInt() ?? 0,
      revenus: ((json['revenus'] ?? json['Revenus']) as num?)?.toInt() ?? 0,
      shippingTime: ((json['shippingTime'] ?? json['ShippingTime']) as num?)?.toInt() ?? 0,
      products: rawProducts is List
          ? rawProducts
              .whereType<Map<String, dynamic>>()
              .map(ProductModel.fromJson)
              .toList()
          : <ProductModel>[],
      totalOrders: ((json['totalOrders'] ?? json['TotalOrders']) as num?)?.toInt() ?? 0,
      address: ((json['address'] ?? json['Address']) as String?) ?? '',
      password: ((json['password'] ?? json['Password']) as String?) ?? '',
      isEmailVerified: json['isEmailVerified'] == true,
      logo: ((json['logo'] ?? json['Logo']) as String?) ?? '',
      rates: rawRates is List
          ? rawRates
              .whereType<Map<String, dynamic>>()
              .map(StoreRateModel.fromJson)
              .toList()
          : <StoreRateModel>[],
      version: (json['__v'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'location': location,
      'description': description,
      'activeProducts': activeProducts,
      'rating': rating,
      'revenus': revenus,
      'shippingTime': shippingTime,
      'products': products.map((product) => product.toJson()).toList(),
      'totalOrders': totalOrders,
      'address': address,
      'password': password,
      'isEmailVerified': isEmailVerified,
      'logo': logo,
      'rates': rates.map((rate) => rate.toJson()).toList(),
      '__v': version,
    };
  }
}

class StoreRateModel {
  final String userId;
  final int rate;
  final String id;

  StoreRateModel({
    required this.userId,
    required this.rate,
    required this.id,
  });

  factory StoreRateModel.fromJson(Map<String, dynamic> json) {
    return StoreRateModel(
      userId: (json['user'] as String?) ?? '',
      rate: (json['rate'] as num?)?.toInt() ?? 0,
      id: (json['_id'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': userId,
      'rate': rate,
      '_id': id,
    };
  }
}
