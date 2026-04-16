import 'package:elbess/core/constants/colors.dart';
import 'package:elbess/features/track/widgets/ordertrack.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TrackCard extends StatefulWidget {
  const TrackCard({
    super.key,
    required this.imagePath,
    required this.itemName,
    required this.price,
    required this.size,
    required this.color,
  });

  final String imagePath;
  final String itemName;
  final String price;
  final String size;
  final String color;

  @override
  State<TrackCard> createState() => _TrackCardState();
}

class _TrackCardState extends State<TrackCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
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
                            child: Image.asset(widget.imagePath, fit: BoxFit.cover),
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.itemName,
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
                                'Size ${widget.size} • Color ${widget.color}',
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
                                    widget.price,
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
                  const Ordertrack(
                    status: 'Order Placed',
                    subtitle: 'Oct 20, 2023 • 09:30 AM',
                    active: true,
                    isdone: true,
                  ),
                  const Ordertrack(
                    status: 'Order Confirmed',
                    subtitle: 'Oct 20, 2023 • 11:45 AM',
                    active: true,
                    isdone: true,
                  ),
                  const Ordertrack(
                    status: 'Shipped from Warehouse',
                    subtitle: 'Oct 21, 2023 • 02:20 PM',
                    active: true,
                    isdone: true,
                  ),
                  const Ordertrack(
                    status: 'Out for Delivery',
                    subtitle: 'Expected by 10:00 AM',
                    active: false,
                    isdone: false,
                    showConnector: false,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
