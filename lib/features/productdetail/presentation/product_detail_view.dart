import 'package:elbess/features/productdetail/widgets/product_detail_body.dart';
import 'package:flutter/material.dart';

class ProductDetailView extends StatefulWidget {
  const ProductDetailView({super.key});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProductDetailBody(),
    );
  }
}