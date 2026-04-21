import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:gap/gap.dart';

class StoreCard extends StatefulWidget {
  // ignore: non_constant_identifier_names
  const StoreCard({super.key, required this.store_name, required this.store_image});
  // ignore: non_constant_identifier_names
  final String store_name;
  // ignore: non_constant_identifier_names
  final String store_image;

  @override
  State<StoreCard> createState() => _StoreCardState();
}

class _StoreCardState extends State<StoreCard> {
  String _resolveImageUrl(String rawPath) {
    if (rawPath.startsWith('http://') || rawPath.startsWith('https://')) {
      return rawPath;
    }

    if (rawPath.startsWith('/') || rawPath.startsWith('uploads/')) {
      final host = kIsWeb
          ? 'http://localhost:5000'
          : defaultTargetPlatform == TargetPlatform.android
              ? 'http://10.0.2.2:5000'
              : 'http://localhost:5000';
      if (rawPath.startsWith('/')) {
        return '$host$rawPath';
      }
      return '$host/$rawPath';
    }

    return rawPath;
  }

  Widget _buildImage(double size) {
    final imagePath = widget.store_image.trim();
    if (imagePath.isEmpty) {
      return SizedBox(width: size, height: size);
    }

    if (imagePath.startsWith('/uploads/') ||
      imagePath.startsWith('uploads/') ||
        imagePath.startsWith('http://') ||
        imagePath.startsWith('https://')) {
      final imageUrl = _resolveImageUrl(imagePath);
      return Image.network(
        imageUrl,
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => SizedBox(width: size, height: size),
      );
    }

    return Image.asset(
      imagePath,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => SizedBox(width: size, height: size),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.of(context).size.width * 0.15;
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        
          Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[100],
        
      ),
      child: ClipOval(child: _buildImage(imageSize)),
    ),
    Gap(6),
     Text(widget.store_name,style: TextStyle(fontSize: 12, fontFamily: "medium",fontWeight: FontWeight.w500,color: Colors.black),)
      ],
    );
  }
}