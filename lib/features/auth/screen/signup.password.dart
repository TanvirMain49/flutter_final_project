import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/gradient_background.dart';
import 'package:_6th_sem_project/core/widgets/input_field.dart';
import 'package:_6th_sem_project/core/widgets/primary_button.dart';
import 'package:_6th_sem_project/features/auth/controller/auth.controller.dart';
import 'package:_6th_sem_project/features/auth/screen/signup_student.dart';
import 'package:flutter/material.dart';

class SignupPasswordScreen extends StatefulWidget {
  final String email;
  final String name;
  final String phoneNumber;
  final String role;
  final String gender;

  const SignupPasswordScreen({
    super.key,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.role,
    required this.gender
  });

  @override
  State<SignupPasswordScreen> createState() => _SignupPasswordScreenState();
}

class _SignupPasswordScreenState extends State<SignupPasswordScreen> {
  final SignUpController _controller = SignUpController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false;

  // Dispose controllers to free up resources when
  // this State object is removed from the widget tree
  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void signUp() async {
    if (passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    // save the data in profile or user db
    await _controller.signUp(
      context: context,
      email: widget.email,
      name: widget.name,
      phoneNumber: widget.phoneNumber,
      role: widget.role,
      gender:widget.gender,
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
      onStart: () => setState(() => isLoading = true),
      onEnd: () => setState(() => isLoading = false),
    );
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
                  "Set Password",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.email,
                  style: const TextStyle(
                    color: AppColors.white60,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 30),
                CustomInputField(
                  label: "Password",
                  hint: "********",
                  icon: Icons.lock_outline,
                  controller: passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  label: "Confirm Password",
                  hint: "********",
                  icon: Icons.lock_outline,
                  controller: confirmPasswordController,
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                Column(
                  children: [
                    PrimaryButton(
                      text: "Sign Up",
                      isLoading: isLoading,
                      onPressed: signUp,
                    ),
                    const SizedBox(height: 16),
                    PrimaryButton(
                      text: "Back",
                      icon: Icons.arrow_back,
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupScreen(),
                          ),
                        ),
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
