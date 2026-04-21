class OrderModel {
  final String id;
  final String userId;
  final String storeId;
  final String productId;
  final String productName;
  final String productImageUrl;
  final double productPrice;
  final int quantity;
  final String size;
  final String name;
  final String location;
  final String numero;
  final bool office;
  final bool domicile;
  final bool confirmed;
  final bool rejected;
  final bool prepared;
  final bool shipped;
  final bool delivered;
  final bool canceled;
  final DateTime? confirmationDate;
  final DateTime? preparationDate;
  final DateTime? shippingDate;
  final DateTime? deliveryDate;
  final DateTime? cancellationDate;

  OrderModel({
    required this.id,
    required this.userId,
    required this.storeId,
    required this.productId,
    this.productName = '',
    this.productImageUrl = '',
    this.productPrice = 0,
    required this.quantity,
    this.size = '',
    this.name = '',
    this.location = '',
    this.numero = '',
    required this.office,
    required this.domicile,
    this.confirmed = false,
    this.rejected = false,
    this.prepared = false,
    this.shipped = false,
    this.delivered = false,
    this.canceled = false,
    this.confirmationDate,
    this.preparationDate,
    this.shippingDate,
    this.deliveryDate,
    this.cancellationDate,
  });

  /// Create an OrderModel from a JSON map (e.g. API response)
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final productJson = json['product'] is Map<String, dynamic>
        ? json['product'] as Map<String, dynamic>
        : null;

    final rawImage = productJson?['image'] ?? productJson?['imageUrl'];
    final productImageUrl = rawImage is List
        ? rawImage.whereType<String>().firstWhere(
            (item) => item.trim().isNotEmpty,
            orElse: () => '',
          )
        : rawImage?.toString() ?? '';

    return OrderModel(
      id: json['_id'] as String,
      userId: json['user'] is Map ? json['user']['_id'] as String : json['user'] as String,
      storeId: json['store'] is Map ? json['store']['_id'] as String : json['store'] as String,
      productId: json['product'] is Map ? json['product']['_id'] as String : json['product'] as String,
      productName: productJson?['name']?.toString() ?? '',
      productImageUrl: productImageUrl.trim(),
      productPrice: (json['price'] as num?)?.toDouble() ?? (productJson?['price'] as num?)?.toDouble() ?? 0,
      quantity: json['quantity'] as int,
      size: (json['size'] as String?) ?? '',
      name: (json['name'] as String?) ?? '',
      location: (json['location'] as String?) ?? '',
      numero: (json['numero'] as String?) ?? '',
      office: json['office'] as bool,
      domicile: json['domicile'] as bool,
      confirmed: json['confirmed'] as bool? ?? false,
      rejected: json['rejected'] as bool? ?? false,
      prepared: json['prepared'] as bool? ?? false,
      shipped: json['shipped'] as bool? ?? false,
      delivered: json['delivered'] as bool? ?? false,
      canceled: json['canceled'] as bool? ?? false,
      confirmationDate: json['confirmationDate'] != null
          ? DateTime.parse(json['confirmationDate'] as String)
          : null,
      preparationDate: json['preparationDate'] != null
          ? DateTime.parse(json['preparationDate'] as String)
          : null,
      shippingDate: json['shippingDate'] != null
          ? DateTime.parse(json['shippingDate'] as String)
          : null,
      deliveryDate: json['deliveryDate'] != null
          ? DateTime.parse(json['deliveryDate'] as String)
          : null,
      cancellationDate: json['cancellationDate'] != null
          ? DateTime.parse(json['cancellationDate'] as String)
          : null,
    );
  }

  /// Convert OrderModel to a JSON map (e.g. to send to API)
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': userId,
      'store': storeId,
      'product': productId,
      'productName': productName,
      'productImageUrl': productImageUrl,
      'price': productPrice,
      'productPrice': productPrice,
      'quantity': quantity,
      'size': size,
      'name': name,
      'location': location,
      'numero': numero,
      'office': office,
      'domicile': domicile,
      'confirmed': confirmed,
      'rejected': rejected,
      'prepared': prepared,
      'shipped': shipped,
      'delivered': delivered,
      'canceled': canceled,
      'confirmationDate': confirmationDate?.toIso8601String(),
      'preparationDate': preparationDate?.toIso8601String(),
      'shippingDate': shippingDate?.toIso8601String(),
      'deliveryDate': deliveryDate?.toIso8601String(),
      'cancellationDate': cancellationDate?.toIso8601String(),
    };
  }

  /// Create a copy of this model with updated fields
  OrderModel copyWith({
    String? id,
    String? userId,
    String? storeId,
    String? productId,
    String? productName,
    String? productImageUrl,
    double? productPrice,
    int? quantity,
    String? size,
    String? name,
    String? location,
    String? numero,
    bool? office,
    bool? domicile,
    bool? confirmed,
    bool? rejected,
    bool? prepared,
    bool? shipped,
    bool? delivered,
    bool? canceled,
    DateTime? confirmationDate,
    DateTime? preparationDate,
    DateTime? shippingDate,
    DateTime? deliveryDate,
    DateTime? cancellationDate,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      storeId: storeId ?? this.storeId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImageUrl: productImageUrl ?? this.productImageUrl,
      productPrice: productPrice ?? this.productPrice,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
      name: name ?? this.name,
      location: location ?? this.location,
      numero: numero ?? this.numero,
      office: office ?? this.office,
      domicile: domicile ?? this.domicile,
      confirmed: confirmed ?? this.confirmed,
      rejected: rejected ?? this.rejected,
      prepared: prepared ?? this.prepared,
      shipped: shipped ?? this.shipped,
      delivered: delivered ?? this.delivered,
      canceled: canceled ?? this.canceled,
      confirmationDate: confirmationDate ?? this.confirmationDate,
      preparationDate: preparationDate ?? this.preparationDate,
      shippingDate: shippingDate ?? this.shippingDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      cancellationDate: cancellationDate ?? this.cancellationDate,
    );
  }

  @override
  String toString() {
    return 'OrderModel(id: $id, userId: $userId, storeId: $storeId, '
        'productId: $productId, productName: $productName, quantity: $quantity, name: $name, '
        'location: $location, numero: $numero, office: $office, '
        'domicile: $domicile, confirmed: $confirmed, rejected: $rejected, '
        'prepared: $prepared, shipped: $shipped, delivered: $delivered, '
        'canceled: $canceled)';
  }
}
