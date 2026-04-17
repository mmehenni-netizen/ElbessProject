import 'package:elbess/core/constants/colors.dart';
import 'package:flutter/foundation.dart';
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
    this.onFavoriteTap,
  });
  final String imagePath;
  final String storeName;
    final String itemName;
      final String price;
      final String rating;
      final bool isFavorite;
      final VoidCallback? onFavoriteTap;
  
    

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  String _normalizedAssetPath(String path) {
    return path
        .replaceFirst('assets/images/', 'assets/Images/')
        .replaceFirst('assets/icons/', 'assets/icons/');
  }

  String _resolveImageUrl(String rawPath) {
    if (rawPath.startsWith('http://') || rawPath.startsWith('https://')) {
      return rawPath;
    }

    if (rawPath.startsWith('/')) {
      final host = kIsWeb
          ? 'http://localhost:5000'
          : defaultTargetPlatform == TargetPlatform.android
              ? 'http://10.0.2.2:5000'
              : 'http://localhost:5000';
      return '$host$rawPath';
    }

    return rawPath;
  }

  Widget _buildProductImage(String rawPath) {
    final trimmed = rawPath.trim();
    if (trimmed.isEmpty) {
      return const Center(
        child: Icon(Icons.image_not_supported_outlined, color: Colors.grey),
      );
    }

    if (trimmed.startsWith('assets/')) {
      final imagePath = _normalizedAssetPath(trimmed);
      return Image.asset(
        imagePath,
        height: MediaQuery.of(context).size.height * 0.5,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(Icons.image_not_supported_outlined, color: Colors.grey),
          );
        },
      );
    }

    if (!trimmed.contains('/') && !trimmed.contains('\\')) {
      return const Center(
        child: Icon(Icons.image_not_supported_outlined, color: Colors.grey),
      );
    }

    final imageUrl = _resolveImageUrl(trimmed);
    return Image.network(
      imageUrl,
      height: MediaQuery.of(context).size.height * 0.5,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Center(
          child: Icon(Icons.image_not_supported_outlined, color: Colors.grey),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
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
                top:10 ,
                left: 10,
                child: GestureDetector(
                  onTap: widget.onFavoriteTap,
                  child: widget.isFavorite
                      ? Icon(Icons.favorite, color: Colors.red, size: 18)
                      : Icon(Icons.favorite_border_outlined, color: Colors.grey, size: 18),
                ), 
              ),
              Positioned(
                top:10 ,
                right: 10,
                child:Row(
                  children: [
                   
                      Text(widget.rating,style: TextStyle(fontSize: 10, fontFamily: "semi",color: Colors.black),),
                     
                    Icon(Icons.star,color: Color(0xffFFAC33),size: 12,)
                  ],
                )
              )
            ],
          ),
          Gap(3),
       Padding(padding: EdgeInsets.symmetric(horizontal: 10),
       child:  Row(
          children: [
            Text("from",style: TextStyle(fontSize: 12, fontFamily: "medium",color: Colors.grey),),
            Gap(2),
            Text(widget.storeName,style: TextStyle(fontSize: 10, fontFamily: "semi",color: Color(0xffDDB892)),)
          ],
        ),
       ),
       Gap(5),
       Padding(padding: EdgeInsets.symmetric(horizontal: 10),
       child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.itemName,style: TextStyle(fontSize: 10, fontFamily: "semi",color: Colors.black),),
            
            Text(widget.price,style: TextStyle(fontSize: 10, fontFamily: "semi",color: AppColors.primary),)
          ],
        ),
       ),
      
        ],
       );
  }
}