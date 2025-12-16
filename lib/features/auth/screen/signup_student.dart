import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/app_logo.dart';
import 'package:_6th_sem_project/core/widgets/gradient_background.dart';
import 'package:_6th_sem_project/core/widgets/input_field.dart';
import 'package:_6th_sem_project/core/widgets/primary_button.dart';
import 'package:_6th_sem_project/features/auth/screen/login_screen.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final _confirmPasswordController = TextEditingController();

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 32,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppLogo(size: 80),
                  const SizedBox(height: 24),

                  // Heading
                  const Text(
                    "Create Account",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Sub-heading
                  const Text(
                    "Sign up to connect with the best tutors near you",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.white60,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Email Field
                  CustomInputField(
                    label: "Email address",
                    hint: "name@example.com",
                    icon: Icons.email_outlined,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                  ),

                  const SizedBox(height: 16),

                  // Password Field
                  CustomInputField(
                    label: "Password",
                    hint: "Create a password",
                    icon: Icons.lock_outline,
                    controller: _passwordController,
                    obscureText: true,
                  ),

                  const SizedBox(height: 16),

                  // Confirm Password Field
                  CustomInputField(
                    label: "Confirm Password",
                    hint: "Re-enter your password",
                    icon: Icons.lock_outline,
                    controller: _confirmPasswordController,
                    obscureText: true,
                  ),

                  const SizedBox(height: 36),

                  // Signup Button
                  PrimaryButton(
                    text: "Sign Up",
                    onPressed: () {
                      // handle signup
                    },
                  ),

                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(
                          color: AppColors.white60,
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginScreen())
                          );
                        },
                        child: const Text(
                          "Log In",
                          style: TextStyle(
                            color: AppColors.accent,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
