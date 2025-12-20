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
  final String role;

  const SignupPasswordScreen({
    super.key,
    required this.email,
    required this.name,
    required this.role,
  });

  @override
  State<SignupPasswordScreen> createState() => _SignupPasswordScreenState();
}

class _SignupPasswordScreenState extends State<SignupPasswordScreen> {
  final SignUpController _controller = SignUpController();
  bool isLoading = false;

  // Initialize controller fields with values passed from the
  // previous screen so they are ready when the UI builds
  @override
  void initState() {
    super.initState();
    // In a StatefulWidget, constructor values passed from the previous screen or parent widget are stored in the widget instance,
    // so inside the State class you access them using `widget.parameterName`.
    _controller.emailController.text = widget.email;
    _controller.nameController.text = widget.name;
    _controller.role = widget.role;
  }

  // Dispose controllers to free up resources when
  // this State object is removed from the widget tree
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void signUp() async {
    if (_controller.passwordController.text.isEmpty ||
        _controller.confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    if (_controller.passwordController.text !=
        _controller.confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }

    // save the data in profile or user db

    await _controller.signUp(
      context: context,
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
                  controller: _controller.passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  label: "Confirm Password",
                  hint: "********",
                  icon: Icons.lock_outline,
                  controller: _controller.confirmPasswordController,
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
                    PrimaryButton(
                      text: "Back",
                      isLoading: isLoading,
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
