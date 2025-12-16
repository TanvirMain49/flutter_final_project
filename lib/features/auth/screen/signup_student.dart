import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/app_logo.dart';
import 'package:_6th_sem_project/core/widgets/gradient_background.dart';
import 'package:_6th_sem_project/core/widgets/input_field.dart';
import 'package:_6th_sem_project/core/widgets/primary_button.dart';
import 'package:_6th_sem_project/features/auth/controller/auth.controller.dart';
import 'package:_6th_sem_project/features/auth/screen/login_screen.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final SignUpController _controller = SignUpController();

  ///State variable for button loading status
  bool _isLoading = false;

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  /// signup function
  void _signUp() async {
    await _controller.signUp(
      context: context,
      onStart: ()=> setState(() {
        _isLoading = true;
      }),
      onEnd: ()=> setState(() {
        _isLoading = false;
      })
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    controller: _controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                  ),

                  const SizedBox(height: 16),

                  // Password Field
                  CustomInputField(
                    label: "Password",
                    hint: "Create a password",
                    icon: Icons.lock_outline,
                    controller: _controller.passwordController,
                    obscureText: true,
                  ),

                  const SizedBox(height: 16),

                  // Confirm Password Field
                  CustomInputField(
                    label: "Confirm Password",
                    hint: "Re-enter your password",
                    icon: Icons.lock_outline,
                    controller: _controller.confirmPasswordController,
                    obscureText: true,
                  ),

                  const SizedBox(height: 36),

                  // Signup Button
                  PrimaryButton(
                    text: "Sign Up",
                    isLoading: _isLoading,
                    onPressed: () {
                      _isLoading ? null : _signUp();
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
