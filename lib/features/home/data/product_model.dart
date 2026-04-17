import 'store_model.dart';

class ProductResponseModel {
	final bool success;
	final String message;
	final List<ProductModel> products;

	ProductResponseModel({
		required this.success,
		required this.message,
		required this.products,
	});

	factory ProductResponseModel.fromJson(Map<String, dynamic> json) {
		final rawProducts = json['products'];
		final products = rawProducts is List
				? rawProducts
						.whereType<Map<String, dynamic>>()
						.map(ProductModel.fromJson)
						.toList()
				: <ProductModel>[];

		return ProductResponseModel(
			success: json['success'] == true,
			message: (json['message'] as String?) ?? '',
			products: products,
		);
	}

	Map<String, dynamic> toJson() {
		return {
			'success': success,
			'message': message,
			'products': products.map((product) => product.toJson()).toList(),
		};
	}
}

class ProductModel {
	final String id;
	final String name;
	final String description;
	final double price;
	final int rating;
	final int totalQuantity;
	final List<SizeQuantityModel> sizeQuantities;
	final StoreModel? store;
	final String imageUrl;
	final String category;
	final String gender;
	final List<ProductRateModel> rates;
	final int version;

	ProductModel({
		required this.id,
		required this.name,
		required this.description,
		required this.price,
		required this.rating,
		required this.totalQuantity,
		required this.sizeQuantities,
		required this.store,
		required this.imageUrl,
		required this.category,
		required this.gender,
		required this.rates,
		required this.version,
	});

	factory ProductModel.fromJson(Map<String, dynamic> json) {
		final rawSizeQuantities = json['sizeQuantities'];
		final rawRates = json['rates'];

		return ProductModel(
			id: (json['_id'] as String?) ?? '',
			name: (json['name'] as String?) ?? '',
			description: (json['description'] as String?) ?? '',
			price: (json['price'] as num?)?.toDouble() ?? 0.0,
			rating: (json['rating'] as num?)?.toInt() ?? 0,
			totalQuantity: (json['totalQuantity'] as num?)?.toInt() ?? 0,
			sizeQuantities: rawSizeQuantities is List
					? rawSizeQuantities
							.whereType<Map<String, dynamic>>()
							.map(SizeQuantityModel.fromJson)
							.toList()
					: <SizeQuantityModel>[],
			store: json['store'] is Map<String, dynamic>
					? StoreModel.fromJson(json['store'] as Map<String, dynamic>)
					: null,
			imageUrl: (json['imageUrl'] as String?) ?? '',
			category: (json['category'] as String?) ?? '',
			gender: (json['gender'] as String?) ?? '',
			rates: rawRates is List
					? rawRates
							.whereType<Map<String, dynamic>>()
							.map(ProductRateModel.fromJson)
							.toList()
					: <ProductRateModel>[],
			version: (json['__v'] as num?)?.toInt() ?? 0,
		);
	}

	Map<String, dynamic> toJson() {
		return {
			'_id': id,
			'name': name,
			'description': description,
			'price': price,
			'rating': rating,
			'totalQuantity': totalQuantity,
			'sizeQuantities': sizeQuantities.map((item) => item.toJson()).toList(),
			'store': store?.toJson(),
			'imageUrl': imageUrl,
			'category': category,
			'gender': gender,
			'rates': rates.map((item) => item.toJson()).toList(),
			'__v': version,
		};
	}

  void operator [](int other) {}
}

class SizeQuantityModel {
	final String id;
	final String size;
	final int quantity;

	SizeQuantityModel({
		required this.id,
		required this.size,
		required this.quantity,
	});

	factory SizeQuantityModel.fromJson(Map<String, dynamic> json) {
		return SizeQuantityModel(
			id: (json['_id'] as String?) ?? '',
			size: (json['size'] as String?) ?? '',
			quantity: (json['quantity'] as num?)?.toInt() ?? 0,
		);
	}

	Map<String, dynamic> toJson() {
		return {
			'_id': id,
			'size': size,
			'quantity': quantity,
		};
	}
}

class ProductRateModel {
	final String userId;
	final int rate;
	final String id;

	ProductRateModel({
		required this.userId,
		required this.rate,
		required this.id,
	});

	factory ProductRateModel.fromJson(Map<String, dynamic> json) {
		return ProductRateModel(
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
