import 'package:elbess/core/constants/button.dart';
import 'package:elbess/core/constants/colors.dart';
import 'package:elbess/core/constants/textfield.dart';
import 'package:elbess/features/Auth/Presentation/Pages/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Loginbody extends StatelessWidget {
  const Loginbody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
              ),
              const Gap(20),
              CustomTextField(
                title: "Password",
                hinttext: "enter your password",
                prefixIcon: Icons.lock_outline,
                obscureText: true,
              ),
              const Gap(40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CustomButton(text: "Log in", onPressed: () {  },),
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
            Text("Don't have an account? ",style: TextStyle(fontSize: 12,fontFamily: "medium",color: Colors.grey),),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignupView()),
                );
              },
              child: Text("Sign up",style: TextStyle(fontSize: 12,fontFamily: "semi",color: AppColors.primary),),
            )

          ],
        )

              
            ],
          ),
        ),
      ),

    );
  }
}