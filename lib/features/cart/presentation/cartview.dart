import 'package:elbess/features/cart/widgets/cartbody.dart';
import 'package:flutter/material.dart';

class Cartview extends StatelessWidget {
  const Cartview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Cartbody(),
    );
  }
}