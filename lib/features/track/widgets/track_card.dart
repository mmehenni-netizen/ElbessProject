import 'package:elbess/core/constants/colors.dart';
import 'package:elbess/features/checkout/data/order_model.dart';
import 'package:elbess/features/track/widgets/ordertrack.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TrackCard extends StatefulWidget {
  const TrackCard({
    super.key,
    required this.order,
  });

  final OrderModel order;

  @override
  State<TrackCard> createState() => _TrackCardState();
}

class _TrackCardState extends State<TrackCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final imageUrl = order.productImageUrl.trim();
    final title = order.productName.trim().isNotEmpty
        ? order.productName.trim()
        : 'Product';
    final size = order.size.trim().isNotEmpty ? order.size.trim() : 'N/A';
    final deliveryType = order.office ? 'Office' : 'Home';
    final priceText = '\$${order.productPrice.toStringAsFixed(2)}';
    final statusSteps = _buildStatusSteps(order);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE5E1DC)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 14,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeInOut,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: imageUrl.isEmpty
                                ? const Icon(
                                    Icons.image_not_supported_outlined,
                                    color: Colors.grey,
                                  )
                                : Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => const Icon(
                                      Icons.image_not_supported_outlined,
                                      color: Colors.grey,
                                    ),
                                  ),
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'semi',
                                  color: Color(0xFF222222),
                                  fontSize: 19,
                                  height: 1.15,
                                ),
                              ),
                              const Gap(8),
                              Text(
                                'Size $size • Qty ${order.quantity} • $deliveryType',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'medium',
                                  color: Color(0xFF7E7E7E),
                                  fontSize: 13,
                                ),
                              ),
                              const Gap(8),
                              Row(
                                children: [
                                  Text(
                                    priceText,
                                    style: TextStyle(
                                      fontFamily: 'bold',
                                      color: AppColors.primary,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const Spacer(),
                                  Icon(
                                    _expanded
                                        ? Icons.keyboard_arrow_up_rounded
                                        : Icons.keyboard_arrow_down_rounded,
                                    color: const Color(0xFF8F8F8F),
                                    size: 24,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_expanded) ...[
                  const Gap(14),
                  const Divider(height: 1, color: Color(0xFFEDEDED)),
                  const Gap(10),
                  ...List.generate(
                    statusSteps.length,
                    (index) {
                      final step = statusSteps[index];
                      return Ordertrack(
                        status: step.title,
                        subtitle: step.subtitle,
                        active: step.active,
                        isdone: step.isDone,
                        showConnector: index != statusSteps.length - 1,
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<_TrackStep> _buildStatusSteps(OrderModel order) {
    if (order.canceled || order.rejected) {
      return <_TrackStep>[
        _TrackStep(
          title: 'Order Placed',
          subtitle: _formatDate(order.confirmationDate),
          active: true,
          isDone: true,
        ),
        _TrackStep(
          title: order.rejected ? 'Order Rejected' : 'Order Canceled',
          subtitle: _formatDate(order.cancellationDate),
          active: true,
          isDone: true,
        ),
      ];
    }

    return <_TrackStep>[
      _TrackStep(
        title: 'Order Placed',
        subtitle: _formatDate(order.confirmationDate),
        active: true,
        isDone: true,
      ),
      _TrackStep(
        title: 'Order Confirmed',
        subtitle: _formatDate(order.confirmationDate),
        active: order.confirmed || order.prepared || order.shipped || order.delivered,
        isDone: order.confirmed || order.prepared || order.shipped || order.delivered,
      ),
      _TrackStep(
        title: 'Prepared',
        subtitle: _formatDate(order.preparationDate),
        active: order.prepared || order.shipped || order.delivered,
        isDone: order.prepared || order.shipped || order.delivered,
      ),
      _TrackStep(
        title: 'Shipped',
        subtitle: _formatDate(order.shippingDate),
        active: order.shipped || order.delivered,
        isDone: order.shipped || order.delivered,
      ),
      _TrackStep(
        title: 'Delivered',
        subtitle: _formatDate(order.deliveryDate),
        active: order.delivered,
        isDone: order.delivered,
      ),
    ];
  }

  String _formatDate(DateTime? value) {
    if (value == null) {
      return 'Pending update';
    }

    final local = value.toLocal();
    final month = _monthLabel(local.month);
    final day = local.day;
    final year = local.year;
    final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    final period = local.hour >= 12 ? 'PM' : 'AM';
    return '$month $day, $year • $hour:$minute $period';
  }

  String _monthLabel(int month) {
    const labels = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return labels[month - 1];
  }
}

class _TrackStep {
  const _TrackStep({
    required this.title,
    required this.subtitle,
    required this.active,
    required this.isDone,
  });

  final String title;
  final String subtitle;
  final bool active;
  final bool isDone;
}
