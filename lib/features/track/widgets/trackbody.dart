import 'package:elbess/core/network/api_error.dart';
import 'package:elbess/features/checkout/data/order_model.dart';
import 'package:elbess/features/checkout/data/order_repo.dart';
import 'package:elbess/features/track/widgets/track_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Trackbody extends StatefulWidget {
  const Trackbody({super.key});

  @override
  State<Trackbody> createState() => _TrackbodyState();
}

class _TrackbodyState extends State<Trackbody> {
  final OrderRepo _orderRepo = OrderRepo();

  bool _isLoading = true;
  String _errorMessage = '';
  List<OrderModel> _orders = <OrderModel>[];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final orders = await _orderRepo.getOrders();

      if (!mounted) {
        return;
      }

      setState(() {
        _orders = orders.reversed.toList();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = e is ApiError ? e.message : 'Unable to load your orders.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibleOrders = _isLoading ? _placeholderOrders : _orders;

    return SafeArea(
      child: Skeletonizer(
        enabled: _isLoading,
        child: RefreshIndicator(
          onRefresh: _loadOrders,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(
              top: MediaQuery.sizeOf(context).height * 0.03,
              bottom: 24,
            ),
            children: [
              const Center(
                child: Text(
                  'Order Tracking',
                  style: TextStyle(fontFamily: 'bold', fontSize: 25),
                ),
              ),
              const Gap(10),
              if (!_isLoading && _errorMessage.isNotEmpty)
                _TrackStateMessage(
                  message: _errorMessage,
                  actionLabel: 'Try again',
                  onPressed: _loadOrders,
                )
              else if (!_isLoading && _orders.isEmpty)
                const _TrackStateMessage(
                  message: 'No orders yet. Your placed orders will appear here.',
                )
              else
                ...visibleOrders.map((order) => TrackCard(order: order)),
            ],
          ),
        ),
      ),
    );
  }

  List<OrderModel> get _placeholderOrders => <OrderModel>[
        OrderModel(
          id: 'placeholder-order-1',
          userId: 'user',
          storeId: 'store',
          productId: 'product',
          productName: 'Relaxed Sweatshirt',
          productImageUrl: '',
          productPrice: 620,
          quantity: 1,
          size: 'L',
          office: true,
          domicile: false,
          confirmed: true,
          prepared: true,
          shipped: false,
          delivered: false,
        ),
        OrderModel(
          id: 'placeholder-order-2',
          userId: 'user',
          storeId: 'store',
          productId: 'product-2',
          productName: 'White Polo',
          productImageUrl: '',
          productPrice: 420,
          quantity: 2,
          size: 'M',
          office: false,
          domicile: true,
          confirmed: true,
          prepared: false,
          shipped: false,
          delivered: false,
        ),
      ];
}

class _TrackStateMessage extends StatelessWidget {
  const _TrackStateMessage({
    required this.message,
    this.actionLabel,
    this.onPressed,
  });

  final String message;
  final String? actionLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 80, 24, 0),
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'medium',
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          if (actionLabel != null && onPressed != null) ...[
            const Gap(14),
            ElevatedButton(
              onPressed: onPressed,
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
