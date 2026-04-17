import 'package:elbess/features/checkout/widgets/checkout_body.dart';
import 'package:flutter/material.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key, this.orderPayload});

  final Map<String, dynamic>? orderPayload;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CheckoutBody(orderPayload: orderPayload),
    );
  }
}
