import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/app_logo.dart';
import 'package:_6th_sem_project/core/widgets/gradient_background.dart';
import 'package:_6th_sem_project/features/auth/screen/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  void _navigateToLogin() async{
    await Future.delayed(const Duration(seconds: 2));
    if(!mounted) return;

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Spacer(),

              //App logo
              const AppLogo(),

              const SizedBox(height: 24,),

              // App name
              Text(
                "Tuition Marketplace",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5
                ),
              ),

              const SizedBox(height: 8,),

              // Tag line
              Text(
                "Connect.Learn.Growth",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70
                ),
              ),

              const Spacer(),

              // Loader
              const CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.accent,
                ),
              ),

              const SizedBox(height: 12,),

              //Version
              Text("v1.0.2",
                style: TextStyle(
                  color: AppColors.white60,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 32,)

            ],
          )

      )
    );
  }
}

