import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  const CustomProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
      });

  @override
  Widget build(BuildContext context) {
    double progressPercent = currentStep / totalSteps;
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Step $currentStep of $totalSteps",
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                )
              ),
              Text(
                  "Step ${(progressPercent * 100).toInt()}% completed",
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )
              ),
            ],
          ),
          const SizedBox(height: 8,),

          //progress bar
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progressPercent,
              // the green progress bar
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(10),
                ),
              )
            ),
          )
        ]
      ),
    );
  }
}
