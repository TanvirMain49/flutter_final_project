import 'package:_6th_sem_project/features/auth/screen/login_screen.dart';
import 'package:_6th_sem_project/features/home/app_main_screen.dart';
import 'package:_6th_sem_project/features/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:ui';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://qdbmhotvqpbqkuepqjsd.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFkYm1ob3R2cXBicWt1ZXBxanNkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU4NjkwMjUsImV4cCI6MjA4MTQ0NTAyNX0.DUlcM5QZnI3j-VOTv1CYbf-CfPfxUQUOx24Oh8HIi1Q',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      title: 'Tuition App',
      theme: ThemeData(useMaterial3: true),
      home: const AuthCheck(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  final supabase = Supabase.instance.client;
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _hideSplashAfterDelay();
  }

  void _hideSplashAfterDelay() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showSplash = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show splash screen for 3 seconds
    if (_showSplash) {
      return const SplashScreen();
    }

    // After splash, listen to auth state changes
    return StreamBuilder<AuthState>(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, authSnapshot) {
        // Handle errors
        if (authSnapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${authSnapshot.error}')),
          );
        }

        // Check auth state
        final session = authSnapshot.data?.session;

        if (session != null) {
          // User is logged in
          return const AppMainScreen();
        } else {
          // User is logged out
          return const LoginScreen();
        }
      },
    );
  }
}
