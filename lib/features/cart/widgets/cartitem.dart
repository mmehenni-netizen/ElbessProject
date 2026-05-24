import 'package:elbess/core/constants/colors.dart';
import 'package:elbess/core/network/network_config.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Cartitem extends StatefulWidget {
  const Cartitem({
    super.key,
    required this.img,
    required this.prdctname,
    required this.size,
    required this.color,
    required this.price,
    this.initialQuantity = 1,
    this.onDelete,
    this.onQuantityChanged,
  });

  final String img;
  final String prdctname;
  final String size;
  final String color;
  final double price;
  final int initialQuantity;
  final VoidCallback? onDelete;
  final ValueChanged<int>? onQuantityChanged;

  @override
  State<Cartitem> createState() => _CartitemState();
}

class _CartitemState extends State<Cartitem> {
  late int quantity;

  String _resolveImageUrl(String rawPath) {
    return resolveNetworkUrl(rawPath);
  }

  Widget _buildImage(String rawPath) {
    final trimmed = rawPath.trim();
    if (trimmed.isEmpty) {
      return const Center(
        child: Icon(Icons.image_not_supported_outlined, color: Colors.grey),
      );
    }

    if (trimmed.startsWith('assets/')) {
      return Image.asset(
        trimmed,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const Center(
          child: Icon(Icons.image_not_supported_outlined, color: Colors.grey),
        ),
      );
    }

    return Image.network(
      _resolveImageUrl(trimmed),
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => const Center(
        child: Icon(Icons.image_not_supported_outlined, color: Colors.grey),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    quantity = widget.initialQuantity < 1 ? 1 : widget.initialQuantity;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardWidth = constraints.maxWidth;
          final scale = (cardWidth / 340).clamp(0.9, 1.08);
          final imageSize = 82 * scale;

          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22 * scale),
              border: Border.all(color: const Color(0xFFE5DDD6)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 4 * scale,
                  height: 120 * scale,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5D3CF),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(22 * scale),
                      bottomLeft: Radius.circular(22 * scale),
                    ),
                  ),
                ),
                Gap(12 * scale),
                Container(
                  width: imageSize,
                  height: imageSize,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(18 * scale),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18 * scale),
                    child: _buildImage(widget.img),
                  ),
                ),
                Gap(12 * scale),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 14 * scale,
                      horizontal: 2 * scale,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.prdctname,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 17 * scale,
                                      fontFamily: 'semi',
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: widget.onDelete,
                                  splashRadius: 18,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: Icon(
                                    Icons.delete_outline,
                                    size: 20 * scale,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6 * scale),
                            Text(
                              'ELBESS Studio • ${widget.color}, ${widget.size}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.5 * scale,
                                fontFamily: 'medium',
                                color: const Color(0xFF7F746E),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '\$${widget.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 18 * scale,
                                fontFamily: 'semi',
                              ),
                            ),
                            const Spacer(),
                            Container(
                              height: 30 * scale,
                              width: 122 * scale,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16 * scale),
                                border: Border.all(
                                  color: const Color(0xFFE0D8D1),
                                ),
                              ),
                              child: Row(
                                children: [
                                  _QuantityButton(
                                    icon: Icons.remove,
                                    onTap: () {
                                      if (quantity > 1) {
                                        setState(() {
                                          quantity--;
                                        });
                                        widget.onQuantityChanged?.call(
                                          quantity,
                                        );
                                      }
                                    },
                                  ),
                                  Container(
                                    width: 1,
                                    height: 18,
                                    color: const Color(0xFFE0D8D1),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        '$quantity',
                                        style: TextStyle(
                                          fontSize: 16 * scale,
                                          fontFamily: 'semi',
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 18,
                                    color: const Color(0xFFE0D8D1),
                                  ),
                                  _QuantityButton(
                                    icon: Icons.add,
                                    onTap: () {
                                      setState(() {
                                        quantity++;
                                      });
                                      widget.onQuantityChanged?.call(quantity);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(8 * scale),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 40,
        height: 32,
        child: Icon(icon, size: 18, color: Colors.black87),
      ),
    );
  }
}
