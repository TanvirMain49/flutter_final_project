import 'package:_6th_sem_project/core/services/auth_service.dart';
import 'package:_6th_sem_project/features/auth/screen/login_screen.dart';
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
  // final passwordController = TextEditingController();
  // final confirmPasswordController = TextEditingController();
  //
  // void dispose() {
  //   passwordController.dispose();
  //   confirmPasswordController.dispose();
  // }

  void _snackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> signUp({
    required BuildContext context,
    required String email,
    required String name,
    required String phoneNumber,
    required String role,
    required String password,
    required String confirmPassword,
    required VoidCallback onStart,
    required VoidCallback onEnd,
  }) async {
    // Basic validation
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _snackBar(context, "Email and password required");
      return;
    }

    if (password != confirmPassword) {
      _snackBar(context, "Confirm password did not match");
      return;
    }

    final authService = AuthService();

    try {
      onStart();

      // Call your signup API
      await authService.signUpWithEmailAndPassword(email, password);

      if (!context.mounted) return;

      _snackBar(context, "User registered successfully");

      // Navigate to main screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AppMainScreen()),
      );
    } catch (e) {
      if (!context.mounted) return;
      _snackBar(context, "Sign up failed: $e");
    } finally {
      onEnd();
    }
  }
}

class SignOutController {
  final AuthService _authService = AuthService();

  Future<void> signOut({
    required BuildContext context,
    required VoidCallback onStart,
    required VoidCallback onEnd,
  }) async {
    try {
      onStart();
      _authService.signOut();
      if (!context.mounted) return;
      _snackBar(context, "User logged out successfully");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      if (!context.mounted) return;
      _snackBar(context, "Logout failed: $e");
    } finally {
      onEnd();
    }
  }

  void _snackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }
}
