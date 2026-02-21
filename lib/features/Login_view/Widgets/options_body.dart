import 'package:elbess/core/constants/button.dart';
import 'package:elbess/core/constants/colors.dart';
import 'package:elbess/core/constants/optionsbtn.dart';
import 'package:elbess/core/utils/size_config.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Gap(160),
            SvgPicture.asset('assets/Images/Logo.svg',height:40),
            Gap(40),
            Text("Let’s you in",style: TextStyle(fontSize: 30,fontFamily: "bold"),),
         Gap(30),
          OptionsBtn(continuee: "Continue with facebook", image: "assets/Images/facebook.png"),
                Gap(15),
                 OptionsBtn(continuee: "Continue with google", image: "assets/Images/google.png"),
                 Gap(15),
             OptionsBtn(continuee: "Continue with apple", image: "assets/Images/apple-logo.png"),
          Gap(60),
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
         Gap(30),
          Padding(padding: EdgeInsets.symmetric(horizontal: 20),
          child: CustomButton(text: "Log in with password", onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginView()));
          }),),
Gap(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Don't have an account?",style: TextStyle(fontSize: 12,fontFamily: "medium",color: Colors.grey),),
            GestureDetector(
              onTap: (){
                setState(() {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupView()));
                });
              },
              child: Text(" Sign up",style: TextStyle(fontSize: 12,fontFamily: "medium",color: AppColors.primary),))
          
          ],
        )
          ],
        ),
      )
    );
  }
}