import 'package:_6th_sem_project/core/widgets/gradient_background.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
          child: const Center(
            child: Text("Login Page", style: TextStyle( color: Colors.white ),),
          ),
      )
    );
  }
}
