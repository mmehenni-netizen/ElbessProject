import 'package:elbess/features/favorites/presentation/favoritesview.dart';
import 'package:elbess/features/home/presentation/homeview.dart';
import 'package:elbess/features/cart/presentation/cartview.dart';
import 'package:elbess/core/utils/size_config.dart';
import 'package:elbess/features/track/presentation/trackview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  late PageController pageController;
  late List<Widget> pages;
  int currentScreen = 0;
  final List<IconData> _icons = [
    CupertinoIcons.home,
    CupertinoIcons.shopping_cart,
    CupertinoIcons.location,
    CupertinoIcons.heart,
    
  ];
  final List<String> _labels = [
    'Home',
    'Cart',
    'Track',
    'Favorites',
  ];
  @override
  void initState() {
    pages = [
      Homeview(),
      Cartview(),
      Trackview(),
      Favoritesview(),
      
    ];
    pageController = PageController(initialPage: currentScreen);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      extendBody: true,
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        children: pages,
        onPageChanged: (index) {
          setState(() {
            currentScreen = index;
          });
        },
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.fromLTRB(13, 0, 16, 16),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            // ignore: deprecated_member_use
            colors: [Color(0xFF8A5A44), Color(0xFF8A5A44).withOpacity(0.76)],
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: List.generate(_icons.length, (index) {
              final bool isSelected = currentScreen == index;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      currentScreen = index;
                    });
                    pageController.animateToPage(
                      index,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 220),
                    curve: Curves.easeInOut,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _icons[index],
                          color: isSelected
                              ? Color(0xFFEDE0D4)
                              : Color(0XFFDDB892),
                          size: isSelected ? 22 : 20,
                        ),
                        SizedBox(height: 2),
                        Text(
                          _labels[index],
                          style: TextStyle(
                            color: isSelected
                                ? Color(0xFFEDE0D4)
                                : Color(0XFFDDB892),
                            fontSize: 11,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
