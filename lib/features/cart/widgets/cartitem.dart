import 'package:elbess/core/constants/colors.dart';
import 'package:elbess/core/utils/size_config.dart';
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
  });

  final String img;
  final String prdctname;
  final String size;
  final String color;
  final double price;
  final int initialQuantity;
  final VoidCallback? onDelete;

  @override
  State<Cartitem> createState() => _CartitemState();
}

class _CartitemState extends State<Cartitem> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.initialQuantity < 1 ? 1 : widget.initialQuantity;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = SizeConfig.screenWidth!;
    final double screenHeight = SizeConfig.screenHeight!;
    final double hScale = (screenWidth / 375).clamp(0.9, 1.15);
    final double vScale = (screenHeight / 812).clamp(0.9, 1.1);

    return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10 * hScale),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double cardWidth = constraints.maxWidth;
              final double imageWidth = cardWidth * 0.36;
              return Container(
        height: screenHeight * 0.205,
        width: double.infinity,
        decoration: BoxDecoration(
          
          borderRadius: BorderRadius.circular(20 * hScale),
        ),
        child: Row(
          children: [
            Gap(6 * hScale),
            SizedBox(
              width: imageWidth,
              child: Container(
                width: double.infinity,
                height: screenHeight * 0.17,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20 * hScale),
                  // ignore: deprecated_member_use
                  color: Colors.grey.withOpacity(0.15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20 * hScale),
                  child: Image.asset(widget.img, fit: BoxFit.contain),
                ),
              ),
            ),
            Gap(8 * hScale),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 14 * vScale),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.prdctname,
                          style: TextStyle(fontSize: 14 * hScale, fontFamily: "semi"),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Gap(8 * hScale),
                      Text(
                        "${widget.price.toStringAsFixed(2)} DZ",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14 * hScale,
                          fontFamily: 'semi',
                        ),
                      ),
                    ],
                  ),
                  Gap(10 * vScale),
                  Row(
                    children: [
                      Text("Size :", style: TextStyle(fontFamily: "semi", color: Colors.grey, fontSize: 16 * hScale),),
                      Gap(3 * hScale),
                     Text(widget.size, style: TextStyle(fontFamily: "semi",fontWeight: FontWeight.w600, color: Colors.black, fontSize: 15 * hScale),),
                    ],
                  ),
                  Row(
                    children:[
                      
                      Text("color :", style: TextStyle(fontFamily: "semi", color: Colors.grey, fontSize: 16 * hScale),),
                      Gap(3 * hScale),
                     Text(widget.color, style: TextStyle(fontFamily: "semi",fontWeight: FontWeight.w600, color: Colors.black, fontSize: 15 * hScale),),
                    ],
                  ),
                  Gap(16 * vScale),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                        SizedBox(
                          width: 126,
                          height: 28,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(13.5),
                              border: Border.all(color: Colors.black26),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (quantity > 1) {
                                      setState(() {
                                        quantity--;
                                      });
                                    }
                                  },
                                  child: SizedBox(
                                    width: 36,
                                    height: 27,
                                    child: Center(
                                      child: Text(
                                        '-',
                                        style: TextStyle(
                                          fontFamily: 'semi',
                                          fontSize: 24,
                                          color: Colors.black,
                                          height: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(width: 1, height: 18, color: Colors.black26),
                                SizedBox(
                                  width: 45,
                                  height: 27,
                                  child: Center(
                                    child: Text(
                                      '$quantity',
                                      style: TextStyle(
                                        fontFamily: 'semi',
                                        fontSize: 20,
                                        height: 1,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(width: 1, height: 18, color: Colors.black26),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      quantity++;
                                    });
                                  },
                                  child: SizedBox(
                                    width: 36,
                                    height: 27,
                                    child: Center(
                                      child: Text(
                                        '+',
                                        style: TextStyle(
                                          fontFamily: 'semi',
                                          fontSize: 24,
                                          color: Colors.black,
                                          height: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Gap(6 * hScale),
                        InkWell(
                          onTap: widget.onDelete,
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: 32,
                            height: 26,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF1E1E),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                        Gap(8 * hScale),
                       
                        ],
                      ),
                    ),
                  ),
                  
                ],
              ),
            ),
            const SizedBox.shrink(),
              ],
            ),
          );
            },
          ),
        );
  }
}