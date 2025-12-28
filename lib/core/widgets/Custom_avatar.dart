import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomAvatar extends StatelessWidget {
  final String? photoUrl;

  const CustomAvatar({super.key, this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 35,
      backgroundColor: AppColors.secondary,
      child: photoUrl != null && photoUrl!.isNotEmpty
          ? ClipOval(
        child: Image.network(
          photoUrl!,
          width: 70,
          height: 70,
          fit: BoxFit.cover,
          // Added error builder to prevent app crash if URL is broken
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.person,
            size: 35,
            color: AppColors.accent,
          ),
        ),
      )
          : const Icon(
        Icons.person,
        size: 35,
        color: AppColors.accent,
      ),
    );
  }
}
