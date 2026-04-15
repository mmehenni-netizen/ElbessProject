import 'package:elbess/features/favorites/widgets/favoritecard.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Favoritesbody extends StatelessWidget {
  const Favoritesbody({super.key});

  static const List<Map<String, String>> _items = [
    {
      'img': 'assets/Images/clothes/item1.png',
      'category': 'Outerwear',
      'brand': 'Elbess Signature',
      'name': 'Linen Blend Blazer',
      'price': '\$129.00',
    },
    {
      'img': 'assets/Images/clothes/item2.png',
      'category': 'Trousers',
      'brand': 'Modern Essentials',
      'name': 'High-Rise',
      'price': '\$89.00',
    },
    {
      'img': 'assets/Images/clothes/item3.png',
      'category': 'Dresses',
      'brand': 'Elbess Signature',
      'name': 'Silk Wrap Midi Dress',
      'price': '\$156.00',
    },
    {
      'img': 'assets/Images/clothes/item4.png',
      'category': 'Accessories',
      'brand': 'Accessorize',
      'name': 'Leather Crossbody Bag',
      'price': '\$210.00',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              const Center(
                child: Text(
                  'My Favorites',
                  style: TextStyle(fontFamily: 'bold', fontSize: 25),
                ),
              ),
              const Gap(16),
              Expanded(
                child: GridView.builder(
                  itemCount: _items.length,
                  padding: const EdgeInsets.only(bottom: 2),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.57,
                  ),
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return Favoritecard(
                      img: item['img']!,
                      category: item['category']!,
                      prdctname: item['name']!,
                      brand: item['brand']!,
                      price: item['price']!,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
