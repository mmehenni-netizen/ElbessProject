import 'package:dio/dio.dart';
import 'package:elbess/core/network/api_error.dart';
import 'package:elbess/core/network/api_exception.dart';
import 'package:elbess/core/network/api_service.dart';
import 'package:elbess/features/checkout/data/order_model.dart';

class OrderRepo {
  final ApiService _apiService = ApiService();

  Future<List<OrderModel>> checkout({
    required List<Map<String, dynamic>> orders,
    required bool office,
    required bool domicile,
    String name = '',
    String location = '',
    String numero = '',
  }) async {
    try {
      final response = await _apiService.post('/actions/checkout', {
        'orders': orders
            .map(
              (item) => <String, dynamic>{
                'productId': (item['productId'] ?? '').toString().trim(),
                'quantity': _parseQuantity(item['quantity']),
                'size': (item['size'] ?? '').toString().trim(),
                'price': _parsePrice(item['price']),
              },
            )
            .toList(),
        'office': office,
        'domicile': domicile,
        'name': name.trim(),
        'location': location.trim(),
        'numero': numero.trim(),
      });

      if (response is ApiError) {
        throw response;
      }

      if (response is! Map<String, dynamic>) {
        throw ApiError(message: 'Unexpected server response');
      }

      final ordersJson = _extractOrdersList(response);
      return ordersJson.map(_normalizeOrderJson).map(OrderModel.fromJson).toList();
    } on DioException catch (e) {
      throw ApiException.handleError(e);
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: e.toString());
    }
  }

  Future<OrderModel?> createOrder({
    required String productId,
    required String storeId,
    required int quantity,
    double? price,
    required bool office,
    required bool domicile,
    String? userId,
  }) async {
    try {
      final createdOrders = await checkout(
        orders: <Map<String, dynamic>>[
          <String, dynamic>{
            'productId': productId,
            'storeId': storeId,
            'quantity': quantity,
            'size': 'M',
            'userId': userId?.trim(),
            if (price != null) 'price': price,
          },
        ],
        office: office,
        domicile: domicile,
      );

      return createdOrders.isEmpty ? null : createdOrders.first;
    } catch (_) {
      rethrow;
    }
  }

  Future<List<OrderModel>> getOrders() async {
    try {
      final response = await _apiService.get('/fetch/get-orders');

      if (response is ApiError) {
        throw response;
      }

      if (response is! Map<String, dynamic>) {
        throw ApiError(message: 'Unexpected server response');
      }

      final ordersJson = _extractOrdersList(response);
      return ordersJson.map(_normalizeOrderJson).map(OrderModel.fromJson).toList();
    } on DioException catch (e) {
      throw ApiException.handleError(e);
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: e.toString());
    }
  }

  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      final response = await _apiService.get('/fetch/get-order/${orderId.trim()}');

      if (response is ApiError) {
        throw response;
      }

      if (response is! Map<String, dynamic>) {
        throw ApiError(message: 'Unexpected server response');
      }

      final orderJson = _extractOrderMap(response);
      if (orderJson == null) {
        return null;
      }

      return OrderModel.fromJson(orderJson);
    } on DioException catch (e) {
      throw ApiException.handleError(e);
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: e.toString());
    }
  }

  List<Map<String, dynamic>> _extractOrdersList(Map<String, dynamic> response) {
    final rawOrders = response['orders'] ?? response['data'] ?? response['results'];

    if (rawOrders is! List) {
      return <Map<String, dynamic>>[];
    }

    return rawOrders.whereType<Map<String, dynamic>>().toList();
  }

  Map<String, dynamic>? _extractOrderMap(Map<String, dynamic> response) {
    final rawOrder = response['order'] ?? response['data'];

    if (rawOrder is Map<String, dynamic>) {
      return rawOrder;
    }

    if (response.containsKey('_id')) {
      return response;
    }

    return null;
  }

  int _parseQuantity(dynamic raw) {
    if (raw is int) {
      return raw;
    }

    if (raw is num) {
      return raw.toInt();
    }

    return int.tryParse(raw?.toString() ?? '') ?? 1;
  }

  double _parsePrice(dynamic raw) {
    if (raw is double) {
      return raw;
    }

    if (raw is num) {
      return raw.toDouble();
    }

    return double.tryParse(raw?.toString() ?? '') ?? 0.0;
  }

  Map<String, dynamic> _normalizeOrderJson(Map<String, dynamic> json) {
    return <String, dynamic>{
      ...json,
      'user': json['user'] ?? '',
      'store': json['store'] ?? '',
      'product': json['product'] ?? '',
      'quantity': _parseQuantity(json['quantity']),
      'size': json['size']?.toString() ?? '',
      'name': json['name']?.toString() ?? '',
      'location': json['location']?.toString() ?? '',
      'numero': json['numero']?.toString() ?? '',
      'office': json['office'] ?? false,
      'domicile': json['domicile'] ?? false,
    };
  }
}
