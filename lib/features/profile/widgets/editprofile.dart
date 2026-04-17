import 'package:elbess/core/constants/button.dart';
import 'package:elbess/core/constants/textfield.dart';
import 'package:elbess/features/profile/presentation/profileview.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

  final TextEditingController nameController = TextEditingController();
  final TextEditingController familyNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController adressController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              const Gap(30),
              SizedBox(
                height: 24,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) =>  Profileview()));
              },
                        child: const Icon(Icons.arrow_back_ios_new_outlined, size: 20),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Edit Profile',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'meduim',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
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
              FillTextField(hint: "Full name", controller: nameController),
              Gap(20),
              FillTextField(hint: "Family name", controller: familyNameController),
              Gap(20),
              FillTextField(hint: "Phone number", controller: phoneController),
              Gap(20),
              FillTextField(hint: "City", controller: cityController),
              Gap(20),
              FillTextField(hint: "Adress", controller: adressController),
              Gap(20),
              FillTextField(hint: "Gender", controller: genderController),
              const Gap(60),
              CustomButton(text: "Save changes", onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) =>  Profileview()));
              }),
              const Gap(20),

              
              ],
            ),
          ),
        ),
      ),
    );
  }
}