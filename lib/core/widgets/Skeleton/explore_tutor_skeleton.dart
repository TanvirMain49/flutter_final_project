import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/Skeleton/skeleton_box.dart';
import 'package:flutter/material.dart';

class ExploreTutorSkeleton extends StatelessWidget {
  const ExploreTutorSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryDark, // same as your card bg
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left avatar
          SkeletonBox(
            height: 48,
            width: 48,
            borderRadius: BorderRadius.circular(12),
          ),

          const SizedBox(width: 12),

          // Right content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                SkeletonBox(
                  height: 16,
                  width: 120,
                  borderRadius: BorderRadius.circular(6),
                ),

                const SizedBox(height: 6),

                // Subject
                SkeletonBox(
                  height: 14,
                  width: 160,
                  borderRadius: BorderRadius.circular(6),
                ),

                const SizedBox(height: 12),

                // Bottom badges row
                Row(
                  children: [
                    _pillSkeleton(width: 50),
                    const SizedBox(width: 8),
                    _pillSkeleton(width: 60),
                    const SizedBox(width: 8),
                    _pillSkeleton(width: 70),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pillSkeleton({required double width}) {
    return SkeletonBox(
      height: 24,
      width: width,
      borderRadius: BorderRadius.circular(20),
    );
  }
}
