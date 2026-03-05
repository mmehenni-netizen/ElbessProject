import 'package:elbess/features/Categories/widgets/categoriesbody.dart';
import 'package:flutter/material.dart';

class Categoriesview extends StatelessWidget {
  const Categoriesview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Categoriesbody(),
    );
  }
}