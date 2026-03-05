import 'package:flutter/material.dart';

class FillInfoContainer extends StatelessWidget {
  const FillInfoContainer({super.key, required this.hint});
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        hint,
        style: const TextStyle(
          color: Color(0xFFB1B1B1),
          fontSize: 16,
          fontFamily: 'regular',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}