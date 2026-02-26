import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Favoritesbody extends StatelessWidget {
  const Favoritesbody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Gap(50),
            Text("My Favorites",style: TextStyle(fontSize: 28,fontFamily: 'bold'),),
            Gap(20),
       
          ],
        ),
      ),
    );
  }
}