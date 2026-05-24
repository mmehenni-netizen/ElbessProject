import 'package:elbess/core/constants/button.dart';
import 'package:elbess/core/constants/colors.dart';
import 'package:elbess/core/constants/textfield.dart';
import 'package:elbess/core/network/api_error.dart';
import 'package:elbess/core/utils/app_snackbar.dart';
import 'package:elbess/features/Auth/Presentation/Pages/signup_view.dart';
import 'package:elbess/features/Auth/data/auth_repo.dart';
import 'package:elbess/root.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Loginbody extends StatefulWidget {
  const Loginbody({super.key});

  @override
  State<Loginbody> createState() => _LoginbodyState();
}

class _LoginbodyState extends State<Loginbody> {
  final _formKey = GlobalKey<FormState>();
  final AuthRepo authRepo = AuthRepo();
  late final TextEditingController emailController = TextEditingController();
  late final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> login() async {
    if (isLoading) {
      return;
    }

    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await authRepo.login(emailController.text.trim(), passwordController.text);
      if (!mounted) {
        return;
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const Root()),
      );
    } catch (e) {
      String errorMessage = 'An error occurred during login.';
      if (e is ApiError) {
        errorMessage = e.message;
      }

      if (!mounted) {
        return;
      }
      AppSnackBar.show(context, errorMessage);
    } finally {
      if (!mounted) {
        return;
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              const Gap(16),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 24,
                    color: Color(0xFF9A9A9A),
                  ),
                ),
              ),
              const Gap(50),
              SizedBox(
                width: double.infinity,
                height: 107,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Text(
                        'Login to your',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 36,
                          fontFamily: 'semi',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 53,
                      child: Text(
                        'Account',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 36,
                          fontFamily: 'semi',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(30),
              CustomTextField(
                title: "Email",
                hinttext: "enter your email",
                prefixIcon: Icons.email_outlined,
                controller: emailController,
              ),
              const Gap(20),
              CustomTextField(
                title: "Password",
                hinttext: "enter your password",
                prefixIcon: Icons.lock_outline,
                obscureText: true,
                controller: passwordController,
              ),
              const Gap(40),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: CustomButton(text: "Log in", onPressed: login),
                    ),
              const Gap(40),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Color(0xFFD4D4D4),
                      thickness: 1,
                    ),
                  ),
                  Gap(12),
                  Text(
                    'Or with',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'semi',
                    ),
                  ),
                  Gap(12),
                  Expanded(
                    child: Divider(
                      color: Color(0xFFD4D4D4),
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              Gap(20),
              OptionsButton(),
              Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: "medium",
                      color: Colors.grey,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SignupView()),
                      );
                    },
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: "semi",
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              )
              
              ],
            ),
          ),
        ),
      ),
    );
  }
}