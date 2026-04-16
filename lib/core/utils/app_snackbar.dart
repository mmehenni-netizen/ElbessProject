import 'package:flutter/material.dart';

class AppSnackBar {
  const AppSnackBar._();

  static const Duration _duration = Duration(seconds: 2);

  static void show(BuildContext context, String message, {Color? backgroundColor}) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: _duration,
          backgroundColor: backgroundColor,
          content: Text(message),
        ),
      );
  }
}