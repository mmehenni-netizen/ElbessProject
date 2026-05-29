import 'dart:async';

import 'package:elbess/core/utils/pref_helpers.dart';
import 'package:elbess/features/Options_view/Presentation/options_view.dart';
import 'package:elbess/root.dart'; // ✅ your HomeScreen/Root
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class Splashbody extends StatefulWidget {
  const Splashbody({super.key});

  @override
  State<Splashbody> createState() => _SplashbodyState();
}

class _SplashbodyState extends State<Splashbody> {
  bool _fadeOut = false;

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => _fadeOut = true);
    });

    Timer(const Duration(milliseconds: 3600), () async {
      if (!mounted) return;

      // ✅ Check for saved token
      final token = await PrefHelpers.getToken();
      final isLoggedIn = token != null && token.isNotEmpty;

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => isLoggedIn
              ? const Root()        // ✅ skip login → go home
              : const OptionsView() // go to login/signup
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _fadeOut ? 0 : 1,
      duration: const Duration(milliseconds: 600),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/Images/appLogo/Logo.svg',
              width: 281,
              height: 42,
              fit: BoxFit.contain,
            ),
            const Gap(6),
            const Text(
              'Own Your Look',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF8A5A44),
                fontSize: 17,
                fontFamily: 'meduim',
              ),
            ),
          ],
        ),
      ),
    );
  }
}