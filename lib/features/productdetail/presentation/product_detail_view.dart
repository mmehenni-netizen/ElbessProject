import 'package:elbess/features/productdetail/widgets/product_detail_body.dart';
import 'package:elbess/features/home/data/product_model.dart';
import 'package:flutter/material.dart';

class ProductDetailView extends StatefulWidget {
  const ProductDetailView({super.key, required this.productId, this.initialProduct});
  final String productId;
  final ProductModel? initialProduct;

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  @override
  Widget build(BuildContext context) {
    return ProductDetailBody(
      productId: widget.productId,
      initialProduct: widget.initialProduct,
    );
  }
}