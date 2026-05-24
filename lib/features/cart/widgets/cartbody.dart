import 'package:elbess/core/constants/colors.dart';
import 'package:elbess/core/utils/pref_helpers.dart';
import 'package:elbess/features/cart/widgets/cartitem.dart';
import 'package:elbess/features/checkout/presentation/checkout_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Cartbody extends StatefulWidget {
  const Cartbody({super.key});

  @override
  State<Cartbody> createState() => _CartbodyState();
}

class _CartbodyState extends State<Cartbody> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _items = <Map<String, dynamic>>[];

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    List<Map<String, dynamic>> items = <Map<String, dynamic>>[];
    try {
      items = await PrefHelpers.getCartItems();
    } catch (_) {
      items = <Map<String, dynamic>>[];
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _items = items;
      _isLoading = false;
    });
  }

  Future<void> _updateQuantity(int index, int quantity) async {
    if (index < 0 || index >= _items.length) {
      return;
    }

    final item = _items[index];
    final productId = (item['productId'] ?? '').toString();
    final size = (item['size'] ?? '').toString();
    await PrefHelpers.updateCartItemQuantity(productId, size, quantity);

    if (!mounted) {
      return;
    }

    setState(() {
      _items[index]['quantity'] = quantity;
    });
  }

  Future<void> _removeItem(int index) async {
    if (index < 0 || index >= _items.length) {
      return;
    }

    final item = _items[index];
    final productId = (item['productId'] ?? '').toString();
    final size = (item['size'] ?? '').toString();
    await PrefHelpers.removeCartItem(productId, size);
    await _loadCart();
  }

  double get _total {
    double total = 0;
    for (final item in _items) {
      final price = (item['price'] as num?)?.toDouble() ?? 0.0;
      final quantity = (item['quantity'] as num?)?.toInt() ?? 1;
      total += price * quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final visibleItems = _isLoading ? _placeholderItems : _items;
    final visibleTotal = _isLoading ? 420.0 : _total;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),
            const Center(
              child: Text(
                'My Cart',
                style: TextStyle(fontFamily: 'bold', fontSize: 25),
              ),
            ),
            const Gap(15),
            Expanded(
              child: !_isLoading && _items.isEmpty
                      ? const Center(
                          child: Text(
                            'Your cart is empty',
                            style: TextStyle(fontFamily: 'medium', color: Colors.grey),
                          ),
                        )
                      : Skeletonizer(
                          enabled: _isLoading,
                          child: RefreshIndicator(
                          onRefresh: _loadCart,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: visibleItems.length,
                            itemBuilder: (context, index) {
                              final item = visibleItems[index];
                              final price = (item['price'] as num?)?.toDouble() ?? 0;
                              final quantity = (item['quantity'] as num?)?.toInt() ?? 1;
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: Cartitem(
                                  img: (item['imageUrl'] ?? '').toString(),
                                  prdctname: (item['name'] ?? 'Product').toString(),
                                  size: (item['size'] ?? 'M').toString(),
                                  color: (item['storeName'] ?? 'Store').toString(),
                                  price: price,
                                  initialQuantity: quantity,
                                  onDelete: () => _removeItem(index),
                                  onQuantityChanged: (quantity) => _updateQuantity(index, quantity),
                                ),
                              );
                            },
                          ),
                        ),
                        ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'semi',
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          '\$${visibleTotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'bold',
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const Gap(12),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: _isLoading || _items.isEmpty ? null : () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CheckoutView(
                                orderPayload: <String, dynamic>{
                                  'items': List<Map<String, dynamic>>.from(_items),
                                  'fromCart': true,
                                },
                              ),
                            ),
                          );

                          if (result == true) {
                            await _loadCart();
                          }
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Proceed to Checkout',
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'semi',
                              ),
                            ),
                            Icon(Icons.chevron_right_rounded),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> get _placeholderItems => <Map<String, dynamic>>[
        <String, dynamic>{
          'imageUrl': '',
          'name': 'Oversized Hoodie',
          'size': 'M',
          'storeName': 'Elbess',
          'price': 210.0,
          'quantity': 1,
        },
        <String, dynamic>{
          'imageUrl': '',
          'name': 'Classic White Tee',
          'size': 'L',
          'storeName': 'Elbess',
          'price': 210.0,
          'quantity': 2,
        },
      ];
}
