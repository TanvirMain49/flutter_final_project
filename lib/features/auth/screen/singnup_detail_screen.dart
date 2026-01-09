import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/custom_dropdown.dart';
import 'package:_6th_sem_project/core/widgets/gradient_background.dart';
import 'package:_6th_sem_project/core/widgets/input_field.dart';
import 'package:_6th_sem_project/core/widgets/primary_button.dart';
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
  String role = 'Student';
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

                const SizedBox(height: 24),

                /// Phone number Field
                CustomInputField(
                  label: "Phone number",
                  hint: "+8801XXXXXXXXX",
                  icon: Icons.call,
                  keyboardType: TextInputType.phone,
                  controller: phoneNumberController,
                ),

                const SizedBox(height: 24),

                /// Role dropdown menu
                CustomDropdown(
                  label: "Select Role",
                  items: const ["Student", "Tutor"],
                  onChange: (String value) {
                    role = value;
                  },
                ),

                const SizedBox(height: 24),

                /// Gender dropdown menu
                CustomDropdown(
                  label: "Select Gender",
                  items: const ["Male", "Female"],
                  onChange: (String value) {
                    gender = value;
                  },
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
