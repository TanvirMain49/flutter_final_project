import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/gradient_background.dart';
import 'package:_6th_sem_project/core/widgets/input_field.dart';
import 'package:_6th_sem_project/core/widgets/primary_button.dart';
import 'package:_6th_sem_project/features/auth/controller/auth.controller.dart';
import 'package:_6th_sem_project/features/auth/screen/signup.password.dart';
import 'package:flutter/material.dart';

class SignupDetailsScreen extends StatefulWidget {
  final String email;

  const SignupDetailsScreen({
    super.key,
    required this.email
  });

  @override
  State<SignupDetailsScreen> createState() => _SignupDetailsScreenState();
}

class _SignupDetailsScreenState extends State<SignupDetailsScreen> {
  final SignUpController _controller = SignUpController();

  // Initialize controller fields with values passed from
  // the previous screen so they are ready when the UI builds
  @override
  void initState(){
    super.initState();
    _controller.emailController.text = widget.email;
  }

  // Dispose controllers to free up resources when
  // this State object is removed from the widget tree
  @override
  void dispose() {
    _controller.dispose();
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
                  controller: _controller.nameController,
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.inputBackground,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _controller.role,
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
                          _controller.role = newValue!;
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

                const SizedBox(height: 30),

                /// Next Button
                PrimaryButton(
                  text: "Next",
                  onPressed: () {
                    if (_controller.nameController.text.isEmpty || _controller.role.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please enter your name or role")),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignupPasswordScreen(
                          email: widget.email,
                          name: _controller.nameController.text,
                          role: _controller.role,
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
