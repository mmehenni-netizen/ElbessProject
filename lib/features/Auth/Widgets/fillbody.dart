import 'package:elbess/core/constants/button.dart';
import 'package:elbess/core/constants/textfield.dart';
import 'package:elbess/core/network/api_error.dart';
import 'package:elbess/core/utils/app_snackbar.dart';
import 'package:elbess/features/Auth/data/auth_repo.dart';
import 'package:elbess/root.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Fillbody extends StatefulWidget {
  const Fillbody({super.key});

  @override
  State<Fillbody> createState() => _FillbodyState();
}
class _FillbodyState extends State<Fillbody> {
  final AuthRepo authRepo = AuthRepo();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController familyNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dateofbirthController = TextEditingController();
  final TextEditingController adressController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  bool _isLoading = false;

  Future<void> setProfile() async {
    if (_isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final firstName = nameController.text.trim();
      final lastName = familyNameController.text.trim();
      final phone = phoneController.text.trim();
      final dateOfBirthText = dateofbirthController.text.trim();
      final address = adressController.text.trim();
      final gender = genderController.text.trim();

      if (firstName.isEmpty ||
          lastName.isEmpty ||
          phone.isEmpty ||
          dateOfBirthText.isEmpty ||
          address.isEmpty ||
          gender.isEmpty) {
        throw ApiError(message: 'All fields are required !');
      }

      final dateOfBirth = DateTime.tryParse(dateOfBirthText);
      if (dateOfBirth == null) {
        throw ApiError(message: 'Invalid date of birth format');
      }

      final response = await authRepo.setProfile(
        firstName,
        lastName,
        phone,
        dateOfBirth,
        address,
        gender,
      );

      if (!mounted) {
        return;
      }

      if (response?.success == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Root(),
          ),
        );
      } else {
        throw ApiError(message: response?.message ?? 'Profile update failed');
      }
    } on ApiError catch (e) {
      if (mounted) {
        AppSnackBar.show(context, e.message);
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    familyNameController.dispose();
    phoneController.dispose();
    dateofbirthController.dispose();
    adressController.dispose();
    genderController.dispose();
    super.dispose();
  }

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
                    'Fill your Profile',
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
              FillTextField(hint: "First name", controller: nameController),
              Gap(20),
              FillTextField(hint: "Family name", controller: familyNameController),
              Gap(20),
              FillTextField(hint: "Phone number", controller: phoneController),
              Gap(20),
              FillTextField(hint: "yyyy-MM-dd : Date of birth", controller: dateofbirthController),
              Gap(20),
              FillTextField(hint: "Adress", controller: adressController),
              Gap(20),
              FillTextField(hint: "male/female", controller: genderController),
              const Gap(60),
              CustomButton(
                text: _isLoading ? "Loading..." : "Start Shopping",
                onPressed: _isLoading ? () {} : setProfile,
              ),
              const Gap(20),

              
            ],
          ),
        ),
      ),

    );
  }
}