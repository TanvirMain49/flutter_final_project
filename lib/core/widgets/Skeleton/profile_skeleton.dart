import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/Skeleton/skeleton_box.dart';
import 'package:flutter/material.dart';

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryDark.withOpacity(0.95), // NOT black
        // borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Profile photo
          SkeletonBox(
            height: 80,
            width: 80,
            borderRadius: BorderRadius.circular(40), // circle
          ),

          const SizedBox(height: 16),

          // Name
          SkeletonBox(
            height: 18,
            width: 100,
            borderRadius: BorderRadius.circular(6),
          ),

          const SizedBox(height: 8),

          // Role (Student)
          SkeletonBox(
            height: 14,
            width: 60,
            borderRadius: BorderRadius.circular(6),
          ),

          const SizedBox(height: 12),

          // Rating row
          SkeletonBox(
            height: 14,
            width: 120,
            borderRadius: BorderRadius.circular(6),
          ),

          const SizedBox(height: 20),

          // Edit profile button
          SkeletonBox(
            height: 44,
            width: double.infinity,
            borderRadius: BorderRadius.circular(10),
          ),

          const SizedBox(height: 60),

          SkeletonBox(
            height: 44,
            width: double.infinity,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 12),

          SkeletonBox(
            height: 44,
            width: double.infinity,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 12),

          SkeletonBox(
            height: 44,
            width: double.infinity,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 12),

          SkeletonBox(
            height: 44,
            width: double.infinity,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 12),

          SkeletonBox(
            height: 44,
            width: double.infinity,
            borderRadius: BorderRadius.circular(10),
          ),


        ],
      ),
    );
  }
}

