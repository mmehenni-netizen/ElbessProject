import 'package:elbess/features/Categories/presentation/categoriesview.dart';
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
  bool _hasInitializedSizeConfig = false;
  final List<IconData> _icons = [
    CupertinoIcons.house,
    CupertinoIcons.square_grid_2x2,
    CupertinoIcons.cart,
    CupertinoIcons.location,
  ];
  final List<IconData> _selectedIcons = [
    CupertinoIcons.house_fill,
    CupertinoIcons.square_grid_2x2_fill,
    CupertinoIcons.cart_fill,
    CupertinoIcons.location_solid,
  ];
  final List<String> _labels = [
    'Home',
    'Categories',
    'Cart',
    'Track',
  ];
  @override
  void initState() {
    pages = [
      Homeview(),
      Categoriesview(),
      Cartview(),
      Trackview(),
    ];
    pageController = PageController(initialPage: currentScreen);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_hasInitializedSizeConfig) {
      return;
    }

    SizeConfig().init(context);
    _hasInitializedSizeConfig = true;
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentScreen,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 10,
        height: 72,
        animationDuration: Duration(milliseconds: 450),
        indicatorColor: Color(0x1F8A5A44),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (index) {
          setState(() {
            currentScreen = index;
          });
          pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 420),
            curve: Curves.easeOutCubic,
          );
        },
        destinations: List.generate(
          _icons.length,
          (index) => NavigationDestination(
            icon: Icon(_icons[index], color: Color(0xFFA9A9A9), size: 22),
            selectedIcon: Icon(_selectedIcons[index], color: Color(0xFF8A5A44), size: 24),
            label: _labels[index],
          ),
        ),
      ),
    );
  }
}
