import 'package:elbess/features/favorites/widgets/favoritesbody.dart';
import 'package:flutter/material.dart';

class Favoritesview extends StatelessWidget {
  const Favoritesview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Favoritesbody(),
    );
  }
}