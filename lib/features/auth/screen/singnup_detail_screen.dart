import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/gradient_background.dart';
import 'package:_6th_sem_project/core/widgets/input_field.dart';
import 'package:_6th_sem_project/core/widgets/primary_button.dart';
import 'package:_6th_sem_project/features/auth/controller/auth.controller.dart';
import 'package:_6th_sem_project/features/auth/screen/signup.password.dart';
import 'package:flutter/material.dart';

class SignupDetailsScreen extends StatefulWidget {
  final String email;

  const SignupDetailsScreen({super.key, required this.email});

  @override
  State<SignupDetailsScreen> createState() => _SignupDetailsScreenState();
}

class _SignupDetailsScreenState extends State<SignupDetailsScreen> {
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  String role = 'student';
  String gender = 'male';

  // Dispose controllers to free up resources when
  // this State object is removed from the widget tree
  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Personal Information",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 42),

                /// Name Field
                CustomInputField(
                  label: "Full Name",
                  hint: "John Doe",
                  icon: Icons.person_outline,
                  controller: nameController,
                ),

                /// Phone number Field
                CustomInputField(
                  label: "Phone number",
                  hint: "+8801XXXXXXXXX",
                  icon: Icons.call,
                  keyboardType: TextInputType.phone,
                  controller: phoneNumberController,
                ),

                const SizedBox(height: 24),

                /// Role Selection
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Select Role",
                    style: TextStyle(
                      color: AppColors.white.withOpacity(0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                /// Role dropdown menu
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.inputBackground,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: role,
                      isExpanded: true,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.white60,
                      ),
                      dropdownColor: AppColors.inputBackground,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          role = newValue!;
                        });
                      },
                      items: const [
                        DropdownMenuItem<String>(
                          value: 'student',
                          child: Text('Student'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'tutor',
                          child: Text('Tutor'),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// Gender dropdown menu
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Select Gender",
                    style: TextStyle(
                      color: AppColors.white.withOpacity(0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.inputBackground,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: gender,
                      isExpanded: true,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.white60,
                      ),
                      dropdownColor: AppColors.inputBackground,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          gender = newValue!;
                        });
                      },
                      items: const [
                        DropdownMenuItem<String>(
                          value: 'male',
                          child: Text('Male'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'female',
                          child: Text('Female'),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                /// Next Button
                PrimaryButton(
                  text: "Next",
                  onPressed: () {
                    if (nameController.text.isEmpty ||
                        role.isEmpty ||
                        phoneNumberController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Please enter your name or role or phone number",
                          ),
                        ),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignupPasswordScreen(
                          email: widget.email,
                          name: nameController.text,
                          phoneNumber: phoneNumberController.text,
                          role: role,
                          gender: gender,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
