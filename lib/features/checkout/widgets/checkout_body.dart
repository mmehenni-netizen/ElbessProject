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

  // Delivery rates per wilaya
  static const List<Map<String, dynamic>> _deliveryWilayas = [
    {
      "id": 1,
      "nameAr": "أدرار",
      "nameEn": "Adrar",
      "homeDelivery": 1400,
      "deskDelivery": 1000,
      "deliveryTime": "4 to 12 days",
    },
    {
      "id": 2,
      "nameAr": "الشلف",
      "nameEn": "Chlef",
      "homeDelivery": 850,
      "deskDelivery": 400,
      "deliveryTime": "3 to 12 days",
    },
    {
      "id": 3,
      "nameAr": "الأغواط",
      "nameEn": "Laghouat",
      "homeDelivery": 1000,
      "deskDelivery": 500,
      "deliveryTime": "4 to 12 days",
    },
    {
      "id": 4,
      "nameAr": "أم البواقي",
      "nameEn": "Oum El Bouaghi",
      "homeDelivery": 900,
      "deskDelivery": 400,
      "deliveryTime": "4 to 12 days",
    },
    {
      "id": 5,
      "nameAr": "باتنة",
      "nameEn": "Batna",
      "homeDelivery": 900,
      "deskDelivery": 400,
      "deliveryTime": "4 to 12 days",
    },
    {
      "id": 6,
      "nameAr": "بجاية",
      "nameEn": "Bejaia",
      "homeDelivery": 800,
      "deskDelivery": 400,
      "deliveryTime": "3 to 12 days",
    },
    {
      "id": 7,
      "nameAr": "بسكرة",
      "nameEn": "Biskra",
      "homeDelivery": 1000,
      "deskDelivery": 400,
      "deliveryTime": "4 to 12 days",
    },
    {
      "id": 8,
      "nameAr": "بشار",
      "nameEn": "Bechar",
      "homeDelivery": 1200,
      "deskDelivery": 500,
      "deliveryTime": "4 to 12 days",
    },
    {
      "id": 9,
      "nameAr": "البليدة",
      "nameEn": "Blida",
      "homeDelivery": 650,
      "deskDelivery": 400,
      "deliveryTime": "2 to 10 days",
    },
    {
      "id": 10,
      "nameAr": "البويرة",
      "nameEn": "Bouira",
      "homeDelivery": 750,
      "deskDelivery": 400,
      "deliveryTime": "3 to 12 days",
    },
    {
      "id": 11,
      "nameAr": "تمنراست",
      "nameEn": "Tamanrasset",
      "homeDelivery": 1800,
      "deskDelivery": 1000,
      "deliveryTime": "4 to 12 days",
    },
    {
      "id": 12,
      "nameAr": "تبسة",
      "nameEn": "Tebessa",
      "homeDelivery": 1000,
      "deskDelivery": 500,
      "deliveryTime": "4 to 12 days",
    },
    {
      "id": 13,
      "nameAr": "تلمسان",
      "nameEn": "Tlemcen",
      "homeDelivery": 850,
      "deskDelivery": 400,
      "deliveryTime": "3 to 12 days",
    },
    {
      "id": 14,
      "nameAr": "تيارت",
      "nameEn": "Tiaret",
      "homeDelivery": 900,
      "deskDelivery": 400,
      "deliveryTime": "4 to 12 days",
    },
    {
      "id": 15,
      "nameAr": "تيزي وزو",
      "nameEn": "Tizi Ouzou",
      "homeDelivery": 750,
      "deskDelivery": 400,
      "deliveryTime": "2 to 12 days",
    },
    {
      "id": 16,
      "nameAr": "الجزائر",
      "nameEn": "Algiers",
      "homeDelivery": 400,
      "deskDelivery": 0,
      "deliveryTime": "2 to 7 days",
    },
    {
      "id": 17,
      "nameAr": "الجلفة",
      "nameEn": "Djelfa",
      "homeDelivery": 1000,
      "deskDelivery": 500,
      "deliveryTime": "4 to 12 days",
    },
    {
      "id": 18,
      "nameAr": "جيجل",
      "nameEn": "Jijel",
      "homeDelivery": 900,
      "deskDelivery": 400,
      "deliveryTime": "3 to 12 days",
    },
    {
      "id": 19,
      "nameAr": "سطيف",
      "nameEn": "Setif",
      "homeDelivery": 850,
      "deskDelivery": 400,
      "deliveryTime": "3 to 12 days",
    },
    {
      "id": 20,
      "nameAr": "سعيدة",
      "nameEn": "Saida",
      "homeDelivery": 950,
      "deskDelivery": 400,
      "deliveryTime": "3 to 12 days",
    },
    {
      "id": 21,
      "nameAr": "سكيكدة",
      "nameEn": "Skikda",
      "homeDelivery": 900,
      "deskDelivery": 400,
      "deliveryTime": "3 to 12 days",
    },
    {
      "id": 22,
      "nameAr": "سيدي بلعباس",
      "nameEn": "Sidi Bel Abbes",
      "homeDelivery": 850,
      "deskDelivery": 400,
      "deliveryTime": "3 to 12 days",
    },
    {
      "id": 23,
      "nameAr": "عنابة",
      "nameEn": "Annaba",
      "homeDelivery": 850,
      "deskDelivery": 400,
      "deliveryTime": "3 to 12 days",
    },
    {
      "id": 24,
      "nameAr": "قالمة",
      "nameEn": "Guelma",
      "homeDelivery": 950,
      "deskDelivery": 400,
      "deliveryTime": "3 to 12 days",
    },
    {
      "id": 25,
      "nameAr": "قسنطينة",
      "nameEn": "Constantine",
      "homeDelivery": 850,
      "deskDelivery": 400,
      "deliveryTime": "3 to 12 days",
    },
    {
      "id": 26,
      "nameAr": "المدية",
      "nameEn": "Medea",
      "homeDelivery": 800,
      "deskDelivery": 400,
      "deliveryTime": "3 to 12 days",
    },
    {
      "id": 27,
      "nameAr": "مستغانم",
      "nameEn": "Mostaganem",
      "homeDelivery": 900,
      "deskDelivery": 400,
      "deliveryTime": "3 to 12 days",
    },
    {
      "id": 28,
      "nameAr": "المسيلة",
      "nameEn": "M'Sila",
      "homeDelivery": 850,
      "deskDelivery": 400,
      "deliveryTime": "3 to 12 days",
    },
    {
      "id": 29,
      "nameAr": "معسكر",
      "nameEn": "Mascara",
      "homeDelivery": 900,
      "deskDelivery": 400,
      "deliveryTime": "3 to 12 days",
    },
    {
      "id": 30,
      "nameAr": "ورقلة",
      "nameEn": "Ouargla",
      "homeDelivery": 1000,
      "deskDelivery": 500,
      "deliveryTime": "3 to 12 days",
    },
    {
      "id": 31,
      "nameAr": "وهران",
      "nameEn": "Oran",
      "homeDelivery": 850,
      "deskDelivery": 400,
      "deliveryTime": "2 to 18 days",
    },
    {
      "id": 32,
      "nameAr": "البيض",
      "nameEn": "El Bayadh",
      "homeDelivery": 1200,
      "deskDelivery": 500,
      "deliveryTime": "4 to 15 days",
    },
    {
      "id": 33,
      "nameAr": "إليزي",
      "nameEn": "Illizi",
      "homeDelivery": null,
      "deskDelivery": 1500,
      "deliveryTime": "4 to 15 days",
    },
    {
      "id": 34,
      "nameAr": "برج بوعريريج",
      "nameEn": "Bordj Bou Arreridj",
      "homeDelivery": 850,
      "deskDelivery": 400,
      "deliveryTime": "2 to 8 days",
    },
    {
      "id": 35,
      "nameAr": "بومرداس",
      "nameEn": "Boumerdes",
      "homeDelivery": 750,
      "deskDelivery": 400,
      "deliveryTime": "2 to 8 days",
    },
    {
      "id": 36,
      "nameAr": "الطارف",
      "nameEn": "El Tarf",
      "homeDelivery": 950,
      "deskDelivery": null,
      "deliveryTime": "4 to 12 days",
    },
    {
      "id": 37,
      "nameAr": "تندوف",
      "nameEn": "Tindouf",
      "homeDelivery": 1500,
      "deskDelivery": 1000,
      "deliveryTime": "4 to 15 days",
    },
    {
      "id": 38,
      "nameAr": "تيسمسيلت",
      "nameEn": "Tissemsilt",
      "homeDelivery": 950,
      "deskDelivery": null,
      "deliveryTime": "4 to 12 days",
    },
    {
      "id": 39,
      "nameAr": "الوادي",
      "nameEn": "El Oued",
      "homeDelivery": 1100,
      "deskDelivery": 600,
      "deliveryTime": "4 to 12 days",
    },
    {
      "id": 40,
      "nameAr": "خنشلة",
      "nameEn": "Khenchela",
      "homeDelivery": 800,
      "deskDelivery": 400,
      "deliveryTime": "4 to 12 days",
    },
    {
      "id": 41,
      "nameAr": "سوق أهراس",
      "nameEn": "Souk Ahras",
      "homeDelivery": 950,
      "deskDelivery": 400,
      "deliveryTime": "4 to 12 days",
    },
    {
      "id": 42,
      "nameAr": "تيبازة",
      "nameEn": "Tipaza",
      "homeDelivery": 650,
      "deskDelivery": 400,
      "deliveryTime": "4 to 8 days",
    },
    {
      "id": 43,
      "nameAr": "ميلة",
      "nameEn": "Mila",
      "homeDelivery": 900,
      "deskDelivery": 400,
      "deliveryTime": "4 to 12 days",
    },
    {
      "id": 44,
      "nameAr": "عين الدفلى",
      "nameEn": "Ain Defla",
      "homeDelivery": 900,
      "deskDelivery": 400,
      "deliveryTime": "4 to 12 days",
    },
    {
      "id": 45,
      "nameAr": "النعامة",
      "nameEn": "Naama",
      "homeDelivery": 1200,
      "deskDelivery": 500,
      "deliveryTime": "4 to 15 days",
    },
    {
      "id": 46,
      "nameAr": "عين تموشنت",
      "nameEn": "Ain Temouchent",
      "homeDelivery": 900,
      "deskDelivery": 400,
      "deliveryTime": "4 to 12 days",
    },
    {
      "id": 47,
      "nameAr": "غرداية",
      "nameEn": "Ghardaia",
      "homeDelivery": 1000,
      "deskDelivery": 500,
      "deliveryTime": "4 to 12 days",
    },
    {
      "id": 48,
      "nameAr": "غليزان",
      "nameEn": "Relizane",
      "homeDelivery": 900,
      "deskDelivery": 400,
      "deliveryTime": "4 to 8 days",
    },
    {
      "id": 49,
      "nameAr": "تيميمون",
      "nameEn": "Timimoun",
      "homeDelivery": null,
      "deskDelivery": null,
      "deliveryTime": "",
    },
    {
      "id": 50,
      "nameAr": "برج باجي مختار",
      "nameEn": "Bordj Badji Mokhtar",
      "homeDelivery": null,
      "deskDelivery": null,
      "deliveryTime": "",
    },
    {
      "id": 51,
      "nameAr": "أولاد جلال",
      "nameEn": "Ouled Djellal",
      "homeDelivery": null,
      "deskDelivery": null,
      "deliveryTime": "",
    },
    {
      "id": 52,
      "nameAr": "بني عباس",
      "nameEn": "Beni Abbes",
      "homeDelivery": null,
      "deskDelivery": null,
      "deliveryTime": "",
    },
    {
      "id": 53,
      "nameAr": "عين صالح",
      "nameEn": "In Salah",
      "homeDelivery": null,
      "deskDelivery": null,
      "deliveryTime": "",
    },
    {
      "id": 54,
      "nameAr": "عين قزام",
      "nameEn": "In Guezzam",
      "homeDelivery": null,
      "deskDelivery": null,
      "deliveryTime": "",
    },
    {
      "id": 55,
      "nameAr": "تقرت",
      "nameEn": "Touggourt",
      "homeDelivery": null,
      "deskDelivery": null,
      "deliveryTime": "",
    },
    {
      "id": 56,
      "nameAr": "جانت",
      "nameEn": "Djanet",
      "homeDelivery": null,
      "deskDelivery": null,
      "deliveryTime": "",
    },
    {
      "id": 57,
      "nameAr": "المغير",
      "nameEn": "El M'Ghair",
      "homeDelivery": null,
      "deskDelivery": null,
      "deliveryTime": "",
    },
    {
      "id": 58,
      "nameAr": "المنيعة",
      "nameEn": "El Meniaa",
      "homeDelivery": null,
      "deskDelivery": null,
      "deliveryTime": "",
    },
  ];

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

  String _money(double value) => 'DZD ${value.toStringAsFixed(2)}';

  Map<String, dynamic>? _deliveryForWilaya(String wilaya) {
    final w = wilaya.trim();
    if (w.isEmpty) return null;
    try {
      return _deliveryWilayas.firstWhere((e) => (e['nameEn'] as String).toLowerCase() == w.toLowerCase());
    } catch (e) {
      return null;
    }
  }

  double? get _shippingFeeValue {
    final address = _profileUser?.address?.trim() ?? '';
    final delivery = _deliveryForWilaya(address);
    if (delivery == null) return null;
    final fee = _isOfficeSelected ? delivery['deskDelivery'] : delivery['homeDelivery'];
    if (fee == null) return null;
    if (fee is num) return fee.toDouble();
    return null;
  }

  String get _shippingFeeLabel {
    final fee = _shippingFeeValue;
    if (fee == null) return 'Not available';
    if (fee == 0) return 'FREE';
    return _money(fee);
  }

  String get _shippingTimeLabel {
    final address = _profileUser?.address?.trim() ?? '';
    final delivery = _deliveryForWilaya(address);
    if (delivery == null) return '';
    final time = delivery['deliveryTime']?.toString() ?? '';
    return time;
  }

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
                                    value: _money(visibleTotal + (_shippingFeeValue ?? 0)),
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
