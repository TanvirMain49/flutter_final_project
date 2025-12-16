import 'package:_6th_sem_project/core/services/auth_service.dart';
import 'package:_6th_sem_project/features/home/app_mainScreen.dart';
import 'package:flutter/material.dart';

class SignInController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }

  Future<void> signIn({
    required BuildContext context,
    required VoidCallback onStart,
    required VoidCallback onEnd,
  }) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _snackBar(context, "Email and password required");
      return;
    }

    try {
      onStart();
      await _authService.signInWithEmailAndPassword(email, password);
      if (!context.mounted) return;
      _snackBar(context, "User logged in successfully");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AppMainScreen()),
      );
    } catch (e) {
      _snackBar(context, "Login failed: $e");
    } finally {
      onEnd();
    }
  }

  void _snackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}

class SignUpController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  Future<void> signUp({
    required BuildContext context,
    required VoidCallback onStart,
    required VoidCallback onEnd,
  }) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    final authService = AuthService();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _snackBar(context, "Email and password required");
      return;
    }

    if (password != confirmPassword) {
      _snackBar(context, "Confirm password did not match");
      return;
    }

    try {
      onStart();
      await authService.signUpWithEmailAndPassword(email, password);
      if (!context.mounted) return;
      _snackBar(context, "User registered successfully");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AppMainScreen()),
      );
    } catch (e) {
      if (!context.mounted) return;
      _snackBar(context, "Login failed: $e");
    } finally {
      onEnd();
    }
  }

  void _snackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}
