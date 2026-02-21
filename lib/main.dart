import 'package:elbess/features/Auth/Presentation/Pages/signup_view.dart';
import 'package:elbess/features/Login_view/Presentation/options_view.dart';
import 'package:elbess/features/Splashview/Presentation/splashview.dart';
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
      home:  Splashview(),
    );
  }
}
