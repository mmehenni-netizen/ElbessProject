import 'package:elbess/core/constants/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CheckoutBody extends StatefulWidget {
  const CheckoutBody({super.key, this.orderPayload});

  final Map<String, dynamic>? orderPayload;

  @override
  State<CheckoutBody> createState() => _CheckoutBodyState();
}

class _CheckoutBodyState extends State<CheckoutBody> {
  int _selectedAddress = 0;

  @override
  void initState() {
    super.initState();
    if (widget.orderPayload != null) {
      debugPrint('Checkout payload: ${widget.orderPayload}');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    line1: 'Amina Benali',
                    line2: '123 Rue de la Liberte, App 4B',
                    line3: 'Casablanca, 20000, Morocco',
                    selected: _selectedAddress == 0,
                    onTap: () => setState(() => _selectedAddress = 0),
                  ),
                  const Gap(12),
                  _AddressCard(
                    title: 'Work / Office',
                    line1: 'TechHub Center, Level 2',
                    line2: 'Boulevard d Anfa',
                    line3: 'Casablanca, 20100, Morocco',
                    selected: _selectedAddress == 1,
                    onTap: () => setState(() => _selectedAddress = 1),
                  ),
                  const Gap(18),
                  Container(
                    width: 132,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2DDD8)),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_shipping_outlined, size: 18),
                        Gap(6),
                        Text(
                          'Cash on Delivery',
                          style: TextStyle(fontFamily: 'medium', fontSize: 12),
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
                      border: Border.all(color: const Color(0xFFE2DDD8)),
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Text(
                              'ORDER SUMMARY',
                              style: TextStyle(fontFamily: 'semi', fontSize: 16),
                            ),
                            Spacer(),
                            Icon(Icons.keyboard_arrow_down_rounded),
                          ],
                        ),
                        const Gap(6),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '3 items in your cart',
                            style: TextStyle(
                              color: Colors.black54,
                              fontFamily: 'medium',
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const Gap(12),
                        const _SummaryRow(label: 'Subtotal', value: '\$1,240.00'),
                        const Gap(8),
                        const _SummaryRow(label: 'Shipping Fee', value: 'FREE'),
                        const Gap(8),
                        const _SummaryRow(
                          label: 'Promo Discount (ELBESS40)',
                          value: '-\$496.00',
                          valueColor: Color(0xFFD94B47),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(height: 1),
                        ),
                        _SummaryRow(
                          label: 'Total Amount',
                          value: '\$744.00',
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
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Order placed successfully.')),
                  );
                },
                child: const Row(
                  children: [
                    Text(
                      'PLACE ORDER',
                      style: TextStyle(fontFamily: 'semi', fontSize: 16),
                    ),
                    Spacer(),
                    Text(
                      '\$744.00',
                      style: TextStyle(fontFamily: 'bold', fontSize: 17),
                    ),
                    Gap(8),
                    Icon(Icons.chevron_right_rounded),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
    final Color borderColor = selected ? AppColors.primary : const Color(0xFFDCDCDC);
    final Color bgColor = selected ? const Color(0xFFF6E7DA) : const Color(0xFFF8F8F8);

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
                    style: const TextStyle(fontFamily: 'medium', color: Colors.black54),
                  ),
                  const Gap(2),
                  Text(
                    line2,
                    style: const TextStyle(fontFamily: 'medium', color: Colors.black54),
                  ),
                  const Gap(2),
                  Text(
                    line3,
                    style: const TextStyle(fontFamily: 'medium', color: Colors.black54),
                  ),
                ],
              ),
            ),
            const Icon(Icons.edit_outlined, size: 18, color: Colors.black54),
          ],
        ),
      ),
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
