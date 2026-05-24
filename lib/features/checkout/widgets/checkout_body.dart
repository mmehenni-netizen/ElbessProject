import 'package:elbess/core/constants/colors.dart';
import 'package:elbess/core/network/api_error.dart';
import 'package:elbess/core/utils/app_snackbar.dart';
import 'package:elbess/core/utils/pref_helpers.dart';
import 'package:elbess/features/Auth/data/auth_repo.dart';
import 'package:elbess/features/Auth/data/profile_model.dart';
import 'package:elbess/features/checkout/data/order_repo.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CheckoutBody extends StatefulWidget {
  const CheckoutBody({super.key, this.orderPayload});

  final Map<String, dynamic>? orderPayload;

  @override
  State<CheckoutBody> createState() => _CheckoutBodyState();
}

class _CheckoutBodyState extends State<CheckoutBody> {
  final AuthRepo _authRepo = AuthRepo();
  final OrderRepo _orderRepo = OrderRepo();

  int _selectedAddress = 0;
  bool _isLoading = true;
  bool _isPlacingOrder = false;
  List<Map<String, dynamic>> _items = <Map<String, dynamic>>[];
  bool _shouldRemovePurchasedItemsFromCart = false;
  ProfileUser? _profileUser;

  bool get _isOfficeSelected => _selectedAddress == 1;
  bool get _isDomicileSelected => _selectedAddress == 0;

  int get _itemCount {
    int count = 0;
    for (final item in _items) {
      count += _quantityOf(item);
    }
    return count;
  }

  double get _subtotal {
    double total = 0;
    for (final item in _items) {
      total += _priceOf(item) * _quantityOf(item);
    }
    return total;
  }

  @override
  void initState() {
    super.initState();
    _loadCheckoutItems();
  }

  Future<void> _loadCheckoutItems() async {
    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final payload = widget.orderPayload;
    final payloadItems = _extractPayloadItems(payload);
    ProfileModel? profile;
    List<Map<String, dynamic>> cartItems = <Map<String, dynamic>>[];

    try {
      profile = await _authRepo.getProfile();
    } catch (e) {
      debugPrint('Error loading checkout profile: $e');
    }

    if (payloadItems != null) {
      cartItems = payloadItems;
    } else {
      try {
        cartItems = await PrefHelpers.getCartItems();
      } catch (e) {
        debugPrint('Error loading checkout cart items: $e');
        cartItems = <Map<String, dynamic>>[];
      }
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _profileUser = profile?.user;
      _items = PrefHelpers.sanitizeCartItems(cartItems);
      _isLoading = false;
      _shouldRemovePurchasedItemsFromCart = payloadItems != null
          ? ((payload?['fromCart'] as bool?) ?? false)
          : true;
    });
  }

  List<Map<String, dynamic>>? _extractPayloadItems(Map<String, dynamic>? payload) {
    if (payload == null) {
      return null;
    }

    final rawItems = payload['items'];
    if (rawItems is List) {
      return PrefHelpers.sanitizeCartItems(
        rawItems.whereType<Map>().map(
          (item) => item.map(
            (key, value) => MapEntry(key.toString(), value),
          ),
        ),
      );
    }

    if ((payload['productId'] ?? '').toString().trim().isNotEmpty) {
      return PrefHelpers.sanitizeCartItems(<Map<String, dynamic>>[
        payload.map((key, value) => MapEntry(key.toString(), value)),
      ]);
    }

    return null;
  }

  Future<void> _placeOrder() async {
    if (_items.isEmpty || _isPlacingOrder) {
      return;
    }

    final validItems = PrefHelpers.sanitizeCartItems(_items);
    if (validItems.isEmpty) {
      AppSnackBar.show(
        context,
        'No valid items available for checkout.',
        backgroundColor: Colors.red.shade600,
      );
      return;
    }

    setState(() {
      _isPlacingOrder = true;
    });

    try {
      await _orderRepo.checkout(
        orders: validItems,
        office: _isOfficeSelected,
        domicile: _isDomicileSelected,
        name: _profileDisplayName,
        location: _profileAddressLine,
        numero: _profilePhoneOrEmail,
      );

      if (_shouldRemovePurchasedItemsFromCart) {
        for (final item in validItems) {
          await PrefHelpers.removeCartItem(
            (item['productId'] ?? '').toString(),
            (item['size'] ?? '').toString(),
          );
        }
      }

      if (!mounted) {
        return;
      }

      AppSnackBar.show(context, 'Order placed successfully.');
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) {
        return;
      }

      final message = e is ApiError
          ? e.message
          : 'Something went wrong while placing your order.';
      AppSnackBar.show(
        context,
        message,
        backgroundColor: Colors.red.shade600,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPlacingOrder = false;
        });
      }
    }
  }

  int _quantityOf(Map<String, dynamic> item) {
    final quantity = item['quantity'];
    if (quantity is int) {
      return quantity;
    }
    if (quantity is num) {
      return quantity.toInt();
    }
    return int.tryParse(quantity?.toString() ?? '') ?? 1;
  }

  double _priceOf(Map<String, dynamic> item) {
    final price = item['price'];
    if (price is double) {
      return price;
    }
    if (price is num) {
      return price.toDouble();
    }
    return double.tryParse(price?.toString() ?? '') ?? 0;
  }

  String _money(double value) => '\$${value.toStringAsFixed(2)}';

  String get _profileDisplayName {
    final user = _profileUser;
    if (user == null) {
      return 'Add your profile details';
    }

    final fullName = '${user.firstName} ${user.lastName}'.trim();
    if (fullName.isNotEmpty) {
      return fullName;
    }

    if (user.username.trim().isNotEmpty) {
      return user.username.trim();
    }

    return 'Add your profile details';
  }

  String get _profileAddressLine {
    final address = _profileUser?.address.trim() ?? '';
    return address.isNotEmpty ? address : 'No address saved in your profile yet';
  }

  String get _profileContactLine {
    final phone = _profileUser?.phone.trim() ?? '';
    final email = _profileUser?.email.trim() ?? '';

    if (phone.isNotEmpty) {
      return phone;
    }

    if (email.isNotEmpty) {
      return email;
    }

    return 'Complete your profile for smoother delivery';
  }

  String get _profilePhoneOrEmail {
    final phone = _profileUser?.phone.trim() ?? '';
    if (phone.isNotEmpty) {
      return phone;
    }

    return _profileUser?.email.trim() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final total = _subtotal;
    final visibleItems = _isLoading ? _placeholderItems : _items;
    final visibleTotal = _isLoading ? _placeholderTotal : total;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 8),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                ),
                const Expanded(
                  child: Text(
                    'Checkout',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'bold', fontSize: 22),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),
          Expanded(
            child: !_isLoading && _items.isEmpty
                    ? const Center(
                        child: Text(
                          'No items available for checkout.',
                          style: TextStyle(
                            fontFamily: 'medium',
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : Skeletonizer(
                        enabled: _isLoading,
                        child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'SHIPPING ADDRESS',
                              style: TextStyle(
                                fontFamily: 'semi',
                                fontSize: 14,
                                letterSpacing: 0.6,
                              ),
                            ),
                            const Gap(12),
                            _AddressCard(
                              title: 'Home Address',
                              line1: _isLoading ? 'Lionel Messi' : _profileDisplayName,
                              line2: _isLoading ? 'Sidi Yassine, SBA' : _profileAddressLine,
                              line3: _isLoading ? '+213 555 00 00 00' : _profileContactLine,
                              selected: _isDomicileSelected,
                              onTap: () => setState(() => _selectedAddress = 0),
                            ),
                            const Gap(12),
                            _AddressCard(
                              title: 'Office Delivery',
                              line1: _isLoading ? 'Lionel Messi' : _profileDisplayName,
                              line2: _isLoading ? '+213 555 00 00 00' : _profileContactLine,
                              line3: 'Office shipping selected for this order',
                              selected: _isOfficeSelected,
                              onTap: () => setState(() => _selectedAddress = 1),
                            ),
                            const Gap(18),
                            Container(
                              width: 160,
                              height: 64,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xFFE2DDD8),
                                ),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.local_shipping_outlined, size: 18),
                                  Gap(6),
                                  Text(
                                    'Cash on Delivery',
                                    style: TextStyle(
                                      fontFamily: 'medium',
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(18),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F4F3),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xFFE2DDD8),
                                ),
                              ),
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                children: [
                                  const Row(
                                    children: [
                                      Text(
                                        'ORDER SUMMARY',
                                        style: TextStyle(
                                          fontFamily: 'semi',
                                          fontSize: 16,
                                        ),
                                      ),
                                      Spacer(),
                                      Icon(Icons.receipt_long_outlined),
                                    ],
                                  ),
                                  const Gap(6),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '${_isLoading ? visibleItems.length : _itemCount} item${(_isLoading ? visibleItems.length : _itemCount) == 1 ? '' : 's'} ready for checkout',
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontFamily: 'medium',
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const Gap(12),
                                  ...visibleItems.map(
                                    (item) => Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: _ItemSummaryRow(
                                        name: (item['name'] ?? 'Product')
                                            .toString(),
                                        details:
                                            'Size ${(item['size'] ?? 'M')} x ${_quantityOf(item)} • Unit ${_money(_priceOf(item))}',
                                        value: _money(
                                          _priceOf(item) * _quantityOf(item),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 6),
                                    child: Divider(height: 1),
                                  ),
                                  _SummaryRow(
                                    label: 'Subtotal',
                                    value: _money(visibleTotal),
                                  ),
                                  const Gap(8),
                                  const _SummaryRow(
                                    label: 'Shipping Fee',
                                    value: 'FREE',
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: Divider(height: 1),
                                  ),
                                  _SummaryRow(
                                    label: 'Total Amount',
                                    value: _money(visibleTotal),
                                    valueColor: AppColors.primary,
                                    isBold: true,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: (_isLoading || _items.isEmpty || _isPlacingOrder)
                    ? null
                    : _placeOrder,
                child: _isPlacingOrder
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Row(
                        children: [
                          const Text(
                            'PLACE ORDER',
                            style: TextStyle(
                              fontFamily: 'semi',
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _money(visibleTotal),
                            style: const TextStyle(
                              fontFamily: 'bold',
                              fontSize: 17,
                            ),
                          ),
                          const Gap(8),
                          const Icon(Icons.chevron_right_rounded),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> get _placeholderItems => <Map<String, dynamic>>[
        <String, dynamic>{
          'name': 'White Polo',
          'size': 'M',
          'quantity': 1,
          'price': 420.0,
        },
        <String, dynamic>{
          'name': 'Relaxed Hoodie',
          'size': 'L',
          'quantity': 1,
          'price': 210.0,
        },
      ];

  double get _placeholderTotal {
    double total = 0;
    for (final item in _placeholderItems) {
      total += _priceOf(item) * _quantityOf(item);
    }
    return total;
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.title,
    required this.line1,
    required this.line2,
    required this.line3,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String line1;
  final String line2;
  final String line3;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color borderColor =
        selected ? AppColors.primary : const Color(0xFFDCDCDC);
    final Color bgColor =
        selected ? const Color(0xFFF6E7DA) : const Color(0xFFF8F8F8);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected ? AppColors.primary : Colors.grey,
                size: 18,
              ),
            ),
            const Gap(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontFamily: 'semi', fontSize: 16),
                  ),
                  const Gap(3),
                  Text(
                    line1,
                    style: const TextStyle(
                      fontFamily: 'medium',
                      color: Colors.black54,
                    ),
                  ),
                  const Gap(2),
                  Text(
                    line2,
                    style: const TextStyle(
                      fontFamily: 'medium',
                      color: Colors.black54,
                    ),
                  ),
                  const Gap(2),
                  Text(
                    line3,
                    style: const TextStyle(
                      fontFamily: 'medium',
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.location_on_outlined,
                size: 18, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}

class _ItemSummaryRow extends StatelessWidget {
  const _ItemSummaryRow({
    required this.name,
    required this.details,
    required this.value,
  });

  final String name;
  final String details;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(fontFamily: 'semi', fontSize: 14),
              ),
              const Gap(2),
              Text(
                details,
                style: const TextStyle(
                  fontFamily: 'medium',
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        const Gap(8),
        Text(
          value,
          style: const TextStyle(fontFamily: 'semi', fontSize: 14),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor = Colors.black,
    this.isBold = false,
  });

  final String label;
  final String value;
  final Color valueColor;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: isBold ? 'semi' : 'medium',
              fontSize: isBold ? 20 : 14,
              color: isBold ? Colors.black : Colors.black54,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: isBold ? 'bold' : 'semi',
            fontSize: 17,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
