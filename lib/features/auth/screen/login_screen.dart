import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/app_logo.dart';
import 'package:_6th_sem_project/core/widgets/gradient_background.dart';
import 'package:_6th_sem_project/core/widgets/input_field.dart';
import 'package:_6th_sem_project/core/widgets/primary_button.dart';
import 'package:_6th_sem_project/features/auth/screen/signup_student.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final _emailController = TextEditingController();

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Stack(
            children: [
              Center(
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

                      // Heading text
                      const Text(
                        "Welcome Back",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Sub-heading text
                      const Text(
                        "Contact with the best tutors near you for personalized learning",
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
                        hint: "Enter your password",
                        icon: Icons.lock_outline,
                        obscureText: true,
                      ),

                      const SizedBox(height: 36),

                      // Login Button
                      PrimaryButton(
                        text: "Log In",
                        onPressed: () {},
                      ),

                      const SizedBox(height: 32,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account,",
                          style: TextStyle(
                            color: AppColors.white60,
                            fontSize: 14
                          ),
                          ),
                          TextButton(
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context)=>const SignupScreen()
                                  )
                                );
                              },
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: AppColors.accent,
                                  fontSize: 14
                                )
                              )
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
}
