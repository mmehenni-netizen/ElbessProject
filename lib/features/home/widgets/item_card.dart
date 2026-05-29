import 'package:elbess/core/constants/colors.dart';
import 'package:elbess/core/network/network_config.dart';
import 'package:elbess/features/productdetail/data/details_repo.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ItemCard extends StatefulWidget {
  const ItemCard({
    super.key,
    required this.imagePath,
    required this.storeName,
    required this.itemName,
    required this.price,
    required this.rating,
    required this.isFavorite,
    this.productId,
    this.onTap,
    this.onFavoriteTap,
  });

  final String imagePath;
  final String storeName;
  final String itemName;
  final String price;
  final String rating;
  final bool isFavorite;
  final String? productId;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  final DetailsRepo _detailsRepo = DetailsRepo();
  String? _resolvedRating;
  bool _isLoadingRemoteRating = false;

  @override
  void initState() {
    super.initState();
    _resolvedRating = widget.rating;
    _loadRemoteRating();
  }

  @override
  void didUpdateWidget(covariant ItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // ✅ Only reload if productId actually changed
    if (oldWidget.productId != widget.productId) {
      _resolvedRating = widget.rating;
      _loadRemoteRating();
    }
  }

  Future<void> _loadRemoteRating() async {
    // ✅ Guard against concurrent calls
    if (_isLoadingRemoteRating) return;

    final productId = widget.productId?.trim() ?? '';
    if (productId.isEmpty) return;

    setState(() => _isLoadingRemoteRating = true);

    try {
      final result = await _detailsRepo.getRate(productId: productId);
      if (!mounted || result == null) return;

      setState(() {
        _resolvedRating = _formatRating(result.rating);
      });
    } catch (_) {
      // Keep fallback rating on failure
    } finally {
      if (mounted) {
        setState(() => _isLoadingRemoteRating = false);
      }
    }
  }

  String _formatRating(double value) {
    if (value <= 0) return '0';
    if ((value - value.roundToDouble()).abs() < 0.05) {
      return value.round().toString();
    }
    return value.toStringAsFixed(1);
  }

  String _normalizedAssetPath(String path) {
    return path.replaceFirst('assets/images/', 'assets/Images/');
  }

  Widget _buildFallbackImage() {
    return Image.asset(
      'assets/Images/clothes/item1.png',
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const Center(
        child: Icon(Icons.image_not_supported_outlined, color: Colors.grey),
      ),
    );
  }

  Widget _buildProductImage(String rawPath) {
    final trimmed = rawPath.trim();

    if (trimmed.isEmpty) return _buildFallbackImage();

    final resolved = resolveNetworkUrl(trimmed);

    if (resolved.startsWith('http')) {
      return Image.network(
        resolved,
        fit: BoxFit.contain,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => _buildFallbackImage(),
      );
    }

    return Image.asset(
      _normalizedAssetPath(trimmed),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => _buildFallbackImage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.48,
                height: MediaQuery.of(context).size.height * 0.17,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  // ignore: deprecated_member_use
                  color: Colors.grey.withOpacity(0.15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: _buildProductImage(widget.imagePath),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: GestureDetector(
                  onTap: widget.onFavoriteTap,
                  child: widget.isFavorite
                      ? const Icon(Icons.favorite, color: Colors.red, size: 18)
                      : const Icon(Icons.favorite_border_outlined,
                          color: Colors.grey, size: 18),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Row(
                  children: [
                    // ✅ Show loading indicator while fetching
                    if (_isLoadingRemoteRating)
                      const SizedBox(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: Colors.grey,
                        ),
                      )
                    else
                      Text(
                        _resolvedRating ?? widget.rating,
                        style: const TextStyle(
                          fontSize: 10,
                          fontFamily: "semi",
                          color: Colors.black,
                        ),
                      ),
                    const Icon(Icons.star, color: Color(0xffFFAC33), size: 12),
                  ],
                ),
              ),
            ],
          ),
          const Gap(3),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                const Text(
                  "from",
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "medium",
                    color: Colors.grey,
                  ),
                ),
                const Gap(2),
                Text(
                  widget.storeName,
                  style: const TextStyle(
                    fontSize: 10,
                    fontFamily: "semi",
                    color: Color(0xffDDB892),
                  ),
                ),
              ],
            ),
          ),
          const Gap(5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.itemName,
                  style: const TextStyle(
                    fontSize: 10,
                    fontFamily: "semi",
                    color: Colors.black,
                  ),
                ),
                Text(
                  widget.price,
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: "semi",
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
