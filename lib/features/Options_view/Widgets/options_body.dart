import 'package:elbess/core/constants/colors.dart';

import 'package:elbess/features/Auth/Presentation/Pages/login_view.dart';
import 'package:elbess/features/Auth/Presentation/Pages/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class OptionsBody extends StatefulWidget {
  const OptionsBody({super.key});

  @override
  State<OptionsBody> createState() => _OptionsBodyState();
}

class _OptionsBodyState extends State<OptionsBody> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F2EE),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -130,
              right: -90,
              child: Container(
                width: 300,
                height: 300,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Color(0xFFFFE4D4), Color(0x00FFE4D4)],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -140,
              left: -90,
              child: Container(
                width: 280,
                height: 280,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Color(0xFFFFDCC8), Color(0x00FFDCC8)],
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: screenHeight - 40),
                child: Column(
                  children: [
                    const Gap(56),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.72),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFFECE7E2),
                        ),
                      ),
                      child: SvgPicture.asset(
                        'assets/Images/appLogo/Logo.svg',
                        height: 36,
                      ),
                    ),
                    const Gap(28),
                    const Text(
                      'Let\'s get you in',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 34,
                        fontFamily: 'bold',
                        color: Color(0xFF1F1B19),
                        height: 1.1,
                      ),
                    ),
                    const Gap(8),
                    const Text(
                      'Access your style picks, saved favorites, and quick checkout.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'medium',
                        color: Color(0xFF7D7874),
                      ),
                    ),
                    const Gap(28),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x15000000),
                            blurRadius: 30,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Choose how you want to continue',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF908A86),
                              fontSize: 13,
                              fontFamily: 'medium',
                            ),
                          ),
                          const Gap(16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                minimumSize: const Size(double.infinity, 56),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginView(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Log in',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'semi',
                                ),
                              ),
                            ),
                          ),
                          const Gap(12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.primary,
                                elevation: 0,
                                minimumSize: const Size(double.infinity, 56),
                                side: BorderSide(
                                  color: AppColors.primary,
                                  width: 1.2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignupView(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Sign up',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'semi',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(24),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}