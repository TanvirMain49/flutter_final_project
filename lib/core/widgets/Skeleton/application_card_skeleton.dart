import 'package:flutter/material.dart';
import 'package:_6th_sem_project/core/constants/colors.dart';
import 'skeleton_box.dart';

class ApplicationCardSkeleton extends StatelessWidget {
  const ApplicationCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Status Badge Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SkeletonBox(height: 24, width: 180), // Title skeleton
              SkeletonBox(
                height: 28,
                width: 80,
                borderRadius: BorderRadius.circular(8), // Status skeleton
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Grade skeleton
          const SkeletonBox(height: 16, width: 100),
          const SizedBox(height: 20),
          // Location and Price Row
          Row(
            children: [
              const SkeletonBox(height: 18, width: 18), // Icon placeholder
              const SizedBox(width: 8),
              const SkeletonBox(height: 14, width: 100),
              const SizedBox(width: 24),
              const SkeletonBox(height: 18, width: 18), // Icon placeholder
              const SizedBox(width: 8),
              const SkeletonBox(height: 14, width: 60),
            ],
          ),
          const SizedBox(height: 18),
          // Applied Date skeleton
          const SkeletonBox(height: 14, width: 140),
          const SizedBox(height: 20),
          // Button skeleton
          SkeletonBox(
            height: 56, // Matches your PrimaryButton height
            width: double.infinity,
            borderRadius: BorderRadius.circular(14),
          ),
        ],
      ),
    );
  }
}

// Widget to show 5 skeletons
class ApplicationsLoadingList extends StatelessWidget {
  const ApplicationsLoadingList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: const ApplicationCardSkeleton(),
          );
        },
      ),
    );
  }
}