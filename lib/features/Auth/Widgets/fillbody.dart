import 'package:elbess/core/constants/button.dart';
import 'package:elbess/core/constants/textfield.dart';
import 'package:elbess/root.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Fillbody extends StatelessWidget {
  const Fillbody({super.key});

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
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back_ios_new_outlined, size: 20),
                  ),
                  Gap(20),
                  Text(
                    'Fill you Profile',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'meduim',
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
              const Gap(28),
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: const Color(0xFFEAEAEA),
                      child: Icon(
                        Icons.person,
                        size: 46,
                        color: const Color(0xFFD7D7D7),
                      ),
                    ),
                    Positioned(
                      right: -2,
                      bottom: 2,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: const Color(0xFF8A5A44),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(28),
              FillTextField(hint: "Full name"),
              Gap(20),
              FillTextField(hint: "Family name"),
              Gap(20),
              FillTextField(hint: "Phone number"),
              Gap(20),
              FillTextField(hint: "City"),
              Gap(20),
              FillTextField(hint: "Adress"),
              Gap(20),
              FillTextField(hint: "Gender"),
              const Gap(60),
              CustomButton(text: "Continue", onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const Root()));
              }),
              const Gap(20),

              
            ],
          ),
        ),
      ),

    );
  }
}