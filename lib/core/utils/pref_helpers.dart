import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PrefHelpers {
  static const String _keytoken = "auth token";
  static const String _keyFavoriteProductIds = "favorite_product_ids";
  static const String _keyCartItems = "cart_items";

  static String _normalizeFavoriteId(String productId) => productId.trim();

  static int _parseQuantity(dynamic raw) {
    if (raw is int) {
      return raw;
    }
    if (raw is num) {
      return raw.toInt();
    }
    return int.tryParse(raw?.toString() ?? '') ?? 1;
  }

  static double _parsePrice(dynamic raw) {
    if (raw is double) {
      return raw;
    }
    if (raw is num) {
      return raw.toDouble();
    }
    return double.tryParse(raw?.toString() ?? '') ?? 0.0;
  }

  static Map<String, dynamic>? sanitizeCartItem(Map<String, dynamic> rawItem) {
    final productId = (rawItem['productId'] ?? '').toString().trim();
    final size = (rawItem['size'] ?? '').toString().trim();

    if (productId.isEmpty || size.isEmpty) {
      return null;
    }

    final quantity = _parseQuantity(rawItem['quantity']);
    if (quantity <= 0) {
      return null;
    }

    return <String, dynamic>{
      'productId': productId,
      'storeId': (rawItem['storeId'] ?? '').toString().trim(),
      'name': (rawItem['name'] ?? 'Product').toString().trim(),
      'imageUrl': (rawItem['imageUrl'] ?? '').toString().trim(),
      'price': _parsePrice(rawItem['price']),
      'size': size,
      'quantity': quantity,
      'storeName': (rawItem['storeName'] ?? 'Store').toString().trim(),
    };
  }

  static List<Map<String, dynamic>> sanitizeCartItems(
    Iterable<Map<String, dynamic>> items,
  ) {
    return items
        .map(sanitizeCartItem)
        .whereType<Map<String, dynamic>>()
        .toList();
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keytoken, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keytoken);
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keytoken);
  }

  /// Remove local favorites and cart items (used when switching accounts)
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyFavoriteProductIds);
    await prefs.remove(_keyCartItems);
  }

  /// Remove everything including auth token
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keytoken);
    await prefs.remove(_keyFavoriteProductIds);
    await prefs.remove(_keyCartItems);
  }

  static Future<List<String>> getFavoriteProductIds() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_keyFavoriteProductIds) ?? <String>[])
        .map(_normalizeFavoriteId)
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();
  }

  static Future<void> saveFavoriteProductIds(List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    final normalizedIds = ids
        .map(_normalizeFavoriteId)
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();
    await prefs.setStringList(_keyFavoriteProductIds, normalizedIds);
  }

  static Future<bool> toggleFavoriteProductId(String productId) async {
    final ids = await getFavoriteProductIds();
    final set = ids.toSet();
    final normalizedProductId = _normalizeFavoriteId(productId);

    if (normalizedProductId.isEmpty) {
      return false;
    }

    final alreadyFavorite = set.contains(normalizedProductId);
    if (alreadyFavorite) {
      set.remove(normalizedProductId);
    } else {
      set.add(normalizedProductId);
    }

    await saveFavoriteProductIds(set.toList());
    return !alreadyFavorite;
  }

  static Future<bool> isFavoriteProduct(String productId) async {
    final ids = await getFavoriteProductIds();
    return ids.contains(_normalizeFavoriteId(productId));
  }

  static Future<List<Map<String, dynamic>>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_keyCartItems) ?? <String>[];

    final items = <Map<String, dynamic>>[];

    for (final item in raw) {
      try {
        final decoded = jsonDecode(item);
        if (decoded is Map) {
          final sanitizedItem = sanitizeCartItem(
            decoded.map((key, value) => MapEntry(key.toString(), value)),
          );
          if (sanitizedItem != null) {
            items.add(sanitizedItem);
          }
        }
      } catch (_) {
        // Skip malformed cart entries instead of crashing the app.
        continue;
      }
    }

    return items;
  }

  static Future<void> saveCartItems(List<Map<String, dynamic>> items) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = sanitizeCartItems(items).map(jsonEncode).toList();
    await prefs.setStringList(_keyCartItems, encoded);
  }

  static Future<void> addCartItem(Map<String, dynamic> newItem) async {
    final items = await getCartItems();

    final sanitizedNewItem = sanitizeCartItem(newItem);
    if (sanitizedNewItem == null) {
      return;
    }

    final productId = sanitizedNewItem['productId'].toString();
    final size = sanitizedNewItem['size'].toString();
    final quantityToAdd = _parseQuantity(sanitizedNewItem['quantity']);

    final index = items.indexWhere(
      (item) =>
          item['productId'].toString() == productId &&
          item['size'].toString() == size,
    );

    if (index >= 0) {
      final current = _parseQuantity(items[index]['quantity']);
      items[index]['quantity'] = current + quantityToAdd;
    } else {
      items.add(sanitizedNewItem);
    }

    await saveCartItems(items);
  }

  static Future<void> updateCartItemQuantity(
    String productId,
    String size,
    int quantity,
  ) async {
    final items = await getCartItems();
    final normalizedProductId = productId.trim();
    final normalizedSize = size.trim();
    final index = items.indexWhere(
      (item) =>
          item['productId'].toString() == normalizedProductId &&
          item['size'].toString() == normalizedSize,
    );

    if (index < 0) {
      return;
    }

    if (quantity <= 0) {
      items.removeAt(index);
    } else {
      items[index]['quantity'] = quantity;
    }

    await saveCartItems(items);
  }

  static Future<void> removeCartItem(String productId, String size) async {
    final items = await getCartItems();
    final normalizedProductId = productId.trim();
    final normalizedSize = size.trim();
    items.removeWhere(
      (item) =>
          item['productId'].toString() == normalizedProductId &&
          item['size'].toString() == normalizedSize,
    );
    await saveCartItems(items);
  }
}
