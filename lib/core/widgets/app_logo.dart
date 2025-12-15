import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, this.size = 90});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.secondary,
        boxShadow: [
          BoxShadow(
            color: AppColors.accent,
            blurRadius: 25,
            spreadRadius: 2
          )
        ]
      ),
      child: const Icon(
        Icons.school_rounded,
        color: AppColors.accent,
        size: 40,
      ),
    );
  }
}
