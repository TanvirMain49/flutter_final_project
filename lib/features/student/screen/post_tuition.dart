import 'dart:ffi';

import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/custom_progress_bar.dart';
import 'package:_6th_sem_project/core/widgets/gradient_background.dart';
import 'package:flutter/material.dart';

class PostTuitionScreen extends StatefulWidget {
  const PostTuitionScreen({super.key});

  @override
  State<PostTuitionScreen> createState() => _PostTuitionScreenState();
}

class _PostTuitionScreenState extends State<PostTuitionScreen> {

  int currentStep = 1;
  final int totalSteps = 2;

  void goToNextStep(){
      if(currentStep < totalSteps){
        setState(() {
          currentStep++;
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF051205),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Post Tuition",
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white,),
        ),
      ),
      body: GradientBackground(
        child: Column(
          children: [
            CustomProgressBar(
              currentStep: currentStep,
              totalSteps: totalSteps,
            ),
          ],
        )
      ),
    );
  }
}
