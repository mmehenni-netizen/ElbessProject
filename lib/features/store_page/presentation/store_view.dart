import 'package:elbess/features/store_page/widgets/store_body.dart';
import 'package:elbess/features/home/data/store_model.dart';
import 'package:flutter/material.dart';

class StoreView extends StatefulWidget {
  const StoreView({super.key, required this.storeId, this.initialStore});

  final String storeId;
  final StoreModel? initialStore;

  @override
  State<StoreView> createState() => _StoreViewState();
}

class _StoreViewState extends State<StoreView> {
  @override
  Widget build(BuildContext context) {
    return StoreBody(
      storeId: widget.storeId,
      initialStore: widget.initialStore,
    );
  }
}