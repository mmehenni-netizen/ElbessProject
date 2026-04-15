
import 'package:elbess/features/Auth/Presentation/Pages/signup_view.dart';
import 'package:elbess/features/Splashview/Presentation/splashview.dart';
import 'package:elbess/features/productdetail/presentation/product_detail_view.dart';
import 'package:elbess/features/store_page/presentation/store_view.dart';
import 'package:elbess/root.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
     debugShowCheckedModeBanner: false,
      theme: ThemeData(
        
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const Splashview(),
    );
  }
}
