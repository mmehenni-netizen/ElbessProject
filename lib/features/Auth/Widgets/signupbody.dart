import 'package:elbess/core/constants/button.dart';
import 'package:elbess/core/constants/colors.dart';
import 'package:elbess/core/constants/textfield.dart';
import 'package:elbess/core/network/api_error.dart';
import 'package:elbess/features/Auth/Presentation/Pages/fill_profile_view.dart';
import 'package:elbess/features/Auth/Presentation/Pages/login_view.dart';
import 'package:elbess/features/Auth/data/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart' show Gap;

class Signupbody extends StatefulWidget {
  const Signupbody({super.key});

  @override
  State<Signupbody> createState() => _SignupbodyState();
}
class _SignupbodyState extends State<Signupbody> {
    final _formKey = GlobalKey<FormState>();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController usernameController = TextEditingController(); 
  late TextEditingController passwordController = TextEditingController();
  AuthRepo authRepo = AuthRepo();
  bool isLoading = false;

  bool _isNonBlockingEmailSendFailure(String message) {
    final lower = message.toLowerCase();
    return lower.contains('error sending verification email') ||
        lower.contains('sending usage of this domain has reached its limit') ||
        lower.contains('domain has reached its limit');
  }
 

  Future<void> signup() async {
   if(_formKey.currentState!.validate()){
    setState(() {
      isLoading = true;
    });
    try {
      await authRepo.signup(usernameController.text, emailController.text, passwordController.text);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FillProfileView()),
      );
    } catch (e) {
      
      String errorMessage = 'An error occurred during signup.';
      if (e is ApiError) {
        errorMessage = e.message;

        if (_isNonBlockingEmailSendFailure(errorMessage)) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Account created, but verification email was not sent due to provider limits. Try again later.',
              ),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => FillProfileView()),
          );
          return;
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
   }
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
               GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back_ios_new_outlined, size: 20),
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
                          'Create your ',
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
                const Gap(10),
                CustomTextField(
                  title: "username",
                  hinttext: "enter your username",
                  prefixIcon: Icons.person_outline,
                   controller: usernameController,
                ),
                const Gap(10),
                CustomTextField(
                  title: " password",
                  hinttext: "enter your password",
                  prefixIcon: Icons.lock_outline,
                  obscureText: true, 
                  controller: passwordController,
                ),
                const Gap(40),
                isLoading ? Center(child: CircularProgressIndicator()) :
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: CustomButton(
                    text: "Sign up",
                    onPressed: signup,
                  ),
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
                    Gap(7),
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
                Gap(13),
                OptionsButton(),
                Gap(20),
                Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don't have an account? ",style: TextStyle(fontSize: 12,fontFamily: "medium",color: Colors.grey),),
              GestureDetector(
                onTap: (){
                  setState(() {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginView()));
                  });
                },
                child: Text("Log in",style: TextStyle(fontSize: 12,fontFamily: "semi",color: AppColors.primary),))
        
            ],
          )
                
              ],
            ),
          ),
        ),
      )
    );
  }
}