import 'package:elbess/core/constants/colors.dart';
import 'package:elbess/features/Auth/Presentation/Pages/login_view.dart';
import 'package:elbess/features/Auth/Presentation/Pages/signup_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class OptionsBody extends StatefulWidget {
  const OptionsBody({super.key});

  @override
  State<OptionsBody> createState() => _OptionsBodyState();
}

class _OptionsBodyState extends State<OptionsBody> {
  bool get _supports3dViewer {
    if (kIsWeb) {
      return true;
    }

    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final bool isTablet = size.width >= 600;
    final double horizontalPadding =
        (size.width * 0.08).clamp(20.0, 48.0).toDouble();
    final double modelHeight = isTablet ? 400 : 300;

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
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
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
                              horizontal: 16,
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
                              '3D PREVIEW',
                              style: TextStyle(
                                fontFamily: 'semi',
                                fontSize: 13,
                                letterSpacing: 1.0,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Drag to rotate',
                            style: TextStyle(
                              fontFamily: 'regular',
                              fontSize: 12,
                              color: AppColors.primary.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                      const Gap(14),
                      Container(
                        height: modelHeight,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFBF8),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: _supports3dViewer
                              ? ModelViewer(
                                  src: 'assets/Images/Elbess.glb',
                                  alt: 'Elbess 3D preview',
                                  autoRotate: false,
                                  autoPlay: false,
                                  cameraControls: true,
                                  disableZoom: false,
                                  interactionPrompt: InteractionPrompt.none,
                                  fieldOfView: '30deg',
                                  exposure: 1.0,
                                  shadowIntensity: 0.6,
                                  shadowSoftness: 0.8,
                                  debugLogging: true,
                                  backgroundColor: const Color(0xFFFFFBF8),
                                )
                              : const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(24),
                                    child: Text(
                                      '3D preview is available on Android, iOS, and Web.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'medium',
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      const Gap(14),
                      Text(
                        'Signature Collection',
                        style: TextStyle(
                          fontFamily: 'semi',
                          fontSize: 17,
                          color: const Color(0xFF2C2019),
                        ),
                      ),
                      const Gap(6),
                      Text(
                        'A clean preview space for your hero product before customers enter the app.',
                        style: TextStyle(
                          fontFamily: 'regular',
                          fontSize: 13,
                          height: 1.45,
                          color: const Color(0xFF786555),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(26),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupView(),
                        ),
                      );
                    },
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'bold',
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
                const Gap(12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      backgroundColor: Colors.white.withValues(alpha: 0.55),
                      minimumSize: const Size(double.infinity, 58),
                      side: BorderSide(
                        color: AppColors.primary.withValues(alpha: 0.22),
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
                          builder: (context) => const LoginView(),
                        ),
                      );
                    },
                    child: const Text(
                      'I Already Have an Account',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'semi',
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
