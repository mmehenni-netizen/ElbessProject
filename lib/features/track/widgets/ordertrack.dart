import 'package:elbess/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Ordertrack extends StatelessWidget {
  const Ordertrack({
    super.key,
    required this.status,
    required this.subtitle,
    required this.active,
    required this.isdone,
    this.showConnector = true,
  });

  final String status;
  final String subtitle;
  final bool active;
  final bool isdone;
  final bool showConnector;

  @override
  Widget build(BuildContext context) {
    final iconBg = active
        ? AppColors.primary.withOpacity(0.13)
        : const Color(0xFFF5F5F5);
    final iconBorder = active ? AppColors.primary : const Color(0xFFE6E6E6);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: iconBorder, width: 1.2),
                ),
                child: Icon(
                  Icons.check_rounded,
                  size: 14,
                  color: active ? AppColors.primary : const Color(0xFFCACACA),
                ),
              ),
              if (showConnector)
                Container(
                  width: 2,
                  height: 32,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                    color: isdone ? AppColors.primary.withOpacity(0.45) : const Color(0xFFE5E5E5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
            ],
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status,
                  style: TextStyle(
                    fontFamily: 'semi',
                    fontSize: 22 / 1.55,
                    color: active ? const Color(0xFF2E2E2E) : const Color(0xFF666666),
                  ),
                ),
                const Gap(2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'medium',
                    fontSize: 12,
                    color: Color(0xFF8F8F8F),
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