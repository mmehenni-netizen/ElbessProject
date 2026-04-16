import 'package:elbess/core/constants/colors.dart';
import 'package:elbess/features/cart/widgets/cartitem.dart';
import 'package:elbess/features/checkout/presentation/checkout_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Cartbody extends StatelessWidget {
  Cartbody({super.key});

  static const List<Map<String, dynamic>> _items = [
    {
      'img': 'assets/Images/clothes/item1.png',
      'prdctname': 'SweetShirt',
      'size': 'M',
      'color': 'Black',
      'price': 150.00,
    },
    {
      'img': 'assets/Images/clothes/item2.png',
      'prdctname': 'Baggy pant',
      'size': 'L',
      'color': 'white',
      'price': 89.00,
    },
    {
      'img': 'assets/Images/clothes/item3.png',
      'prdctname': 'overSize Shirt',
      'size': 'S',
      'color': 'black',
      'price': 156.00,
    },
  ];

  static const double _total = 370.00;

  @override
  Widget build(BuildContext context) {
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
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Cartitem(
                      img: item['img'] as String,
                      prdctname: item['prdctname'] as String,
                      size: item['size'] as String,
                      color: item['color'] as String,
                      price: item['price'] as double,
                    ),
                  );
                },
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
                          '\$${_total.toStringAsFixed(2)}',
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CheckoutView(),
                            ),
                          );
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
}
