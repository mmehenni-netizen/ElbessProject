import 'package:elbess/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ItemCard extends StatefulWidget {
  const ItemCard({super.key, required this.imagePath, required this.storeName, required this.itemName, required this.price, required this.rating, required this.isFavorite});
  final String imagePath;
  final String storeName;
    final String itemName;
      final String price;
      final String rating;
      final bool isFavorite;
  
    

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  String _normalizedAssetPath(String path) {
    return path
        .replaceFirst('assets/images/', 'assets/Images/')
        .replaceFirst('assets/icons/', 'assets/icons/');
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = _normalizedAssetPath(widget.imagePath);

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
                    child: Image.asset(
                      imagePath,
                      height: MediaQuery.of(context).size.height * 0.5,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.broken_image_outlined, color: Colors.grey),
                        );
                      },
                    ),
                ),
              ),
              Positioned(
                top:10 ,
                left: 10,
                child:widget.isFavorite?Icon(Icons.favorite,color: Colors.red,size: 18,):Icon(Icons.favorite_border_outlined,color: Colors.grey,size: 18,), 
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