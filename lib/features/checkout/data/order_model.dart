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

  static String _readId(dynamic value) {
    if (value is Map) {
      final nestedId = value['_id'];
      return nestedId?.toString() ?? '';
    }
    return value?.toString() ?? '';
  }

  static int _readInt(dynamic value, {int fallback = 0}) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static double _readDouble(dynamic value, {double fallback = 0}) {
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static bool _readBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    final normalized = value?.toString().trim().toLowerCase() ?? '';
    return normalized == 'true' || normalized == '1';
  }

  static DateTime? _readDate(dynamic value) {
    if (value is DateTime) {
      return value;
    }
    if (value is String && value.trim().isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  /// Create an OrderModel from a JSON map (e.g. API response)
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final productJson = json['product'] is Map<String, dynamic>
        ? json['product'] as Map<String, dynamic>
        : null;

    final rawImage =
        productJson?['image'] ?? productJson?['imageUrl'] ?? productJson?['imageUrls'];
    final productImageUrl = rawImage is List
        ? rawImage.whereType<String>().firstWhere(
            (item) => item.trim().isNotEmpty,
            orElse: () => '',
          )
        : rawImage?.toString() ?? '';

    return OrderModel(
      id: _readId(json['_id']),
      userId: _readId(json['user']),
      storeId: _readId(json['store']),
      productId: _readId(json['product']),
      productName: productJson?['name']?.toString() ?? '',
      productImageUrl: productImageUrl.trim(),
      productPrice: _readDouble(
        json['price'],
        fallback: _readDouble(productJson?['price']),
      ),
      quantity: _readInt(json['quantity'], fallback: 1),
      size: (json['size'] as String?) ?? '',
      name: (json['name'] as String?) ?? '',
      location: (json['location'] as String?) ?? '',
      numero: (json['numero'] as String?) ?? '',
      office: _readBool(json['office']),
      domicile: _readBool(json['domicile']),
      confirmed: _readBool(json['confirmed']),
      rejected: _readBool(json['rejected']),
      prepared: _readBool(json['prepared']),
      shipped: _readBool(json['shipped']),
      delivered: _readBool(json['delivered']),
      canceled: _readBool(json['canceled']),
      confirmationDate: _readDate(json['confirmationDate']),
      preparationDate: _readDate(json['preparationDate']),
      shippingDate: _readDate(json['shippingDate']),
      deliveryDate: _readDate(json['deliveryDate']),
      cancellationDate: _readDate(json['cancellationDate']),
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
