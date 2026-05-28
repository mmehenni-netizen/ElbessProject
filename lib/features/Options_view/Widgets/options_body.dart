import 'package:elbess/core/constants/colors.dart';
import 'package:elbess/features/Auth/Presentation/Pages/login_view.dart';
import 'package:elbess/features/Auth/Presentation/Pages/signup_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class OptionsBody extends StatefulWidget {
  const OptionsBody({super.key});

  @override
  State<OptionsBody> createState() => _OptionsBodyState();
}

class _OptionsBodyState extends State<OptionsBody> {
  void _openLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginView(),
      ),
    );
  }

  void _openSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignupView(),
      ),
    );
  }

  Widget _buildChoiceButton({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color accentColor,
    required IconData icon,
    bool filled = false,
  }) {
    return Material(
      color: filled ? accentColor : Colors.white,
      elevation: filled ? 8 : 0,
      shadowColor: Colors.black12,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: filled ? accentColor : const Color(0xFFE8D8CB),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: filled
                      ? Colors.white.withValues(alpha: 0.16)
                      : const Color(0xFFF8F3EE),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: filled ? Colors.white : accentColor,
                  size: 22,
                ),
              ),
              const Gap(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'bold',
                        fontSize: 17,
                        color: filled ? Colors.white : const Color(0xFF1C140F),
                      ),
                    ),
                    const Gap(4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: 'medium',
                        fontSize: 12,
                        height: 1.35,
                        color: filled
                            ? Colors.white.withValues(alpha: 0.88)
                            : const Color(0xFF725A4A),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(12),
              Icon(
                Icons.arrow_forward_rounded,
                color: filled ? Colors.white : accentColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final bool isTablet = size.width >= 600;
    final double horizontalPadding =
        (size.width * 0.08).clamp(20.0, 48.0).toDouble();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F3EE),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFCF9),
              Color(0xFFF5EEE8),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding:
                EdgeInsets.fromLTRB(horizontalPadding, 20, horizontalPadding, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: const Color(0xFFE8D6CA)),
                    ),
                    child: SvgPicture.asset(
                      'assets/Images/appLogo/Logo.svg',
                      height: 34,
                    ),
                  ),
                ),
                const Gap(28),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF4EC),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0xFFE9D1C0)),
                  ),
                  child: Text(
                    'CUSTOM APPAREL STUDIO',
                    style: TextStyle(
                      fontFamily: 'semi',
                      fontSize: 12,
                      letterSpacing: 1.2,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const Gap(18),
                Text(
                  'Build your look\nwith a live preview.',
                  style: TextStyle(
                    fontSize: isTablet ? 50 : 36,
                    height: 1.08,
                    fontFamily: 'bold',
                    color: const Color(0xFF1C140F),
                  ),
                ),
                const Gap(12),
                Text(
                  'Choose your style, check the fit in 3D, and move straight into your account.',
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 15,
                    height: 1.5,
                    fontFamily: 'regular',
                    color: const Color(0xFF725A4A),
                  ),
                ),
                const Gap(24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.94),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: const Color(0xFFE7D2C4)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x12000000),
                        blurRadius: 28,
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF7F1),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: const Color(0xFFE6C8B5),
                                  ),
                                ),
                                child: Text(
                                  'WELCOME',
                                  style: TextStyle(
                                    fontFamily: 'semi',
                                    fontSize: 12,
                                    letterSpacing: 1.0,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.verified_rounded,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ],
                          ),
                          const Gap(16),
                          Text(
                            'Choose how you want to start.',
                            style: TextStyle(
                              fontSize: isTablet ? 24 : 20,
                              height: 1.15,
                              fontFamily: 'bold',
                              color: const Color(0xFF1C140F),
                            ),
                          ),
                          const Gap(10),
                          Text(
                            'Sign in to continue your shopping or create a new account in a few taps.',
                            style: TextStyle(
                              fontSize: isTablet ? 16 : 14,
                              height: 1.5,
                              fontFamily: 'regular',
                              color: const Color(0xFF725A4A),
                            ),
                          ),
                          const Gap(20),
                          _buildChoiceButton(
                            title: 'Log In',
                            subtitle:
                                'Access your favorites, orders, and profile.',
                            onTap: _openLogin,
                            accentColor: AppColors.primary,
                            icon: Icons.login_rounded,
                            filled: true,
                          ),
                          const Gap(12),
                          _buildChoiceButton(
                            title: 'Sign Up',
                            subtitle:
                                'Create a new account and start shopping now.',
                            onTap: _openSignup,
                            accentColor: AppColors.primary,
                            icon: Icons.person_add_alt_1_rounded,
                            filled: false,
                          ),
                        ],
                      ),
                ),
                const Gap(26),
              ],
            ),
          ),
        ),
      )
    );
  }
}
