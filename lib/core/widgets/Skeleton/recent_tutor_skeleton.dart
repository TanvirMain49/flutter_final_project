import 'package:_6th_sem_project/core/widgets/Skeleton/skeleton_box.dart';
import 'package:flutter/material.dart';


class RecentTutorSkeleton extends StatelessWidget {
  const RecentTutorSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Image
          SkeletonBox(
            height: 64,
            width: 64,
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(
                  height: 20,
                  width: 100,
                ),

                const SizedBox(height: 8),

                SkeletonBox(
                  height: 16,
                  width: 160,
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    SkeletonBox(
                      height: 16,
                      width: 80,
                    ),
                    const SizedBox(width: 12),
                    SkeletonBox(
                      height: 24,
                      width: 60,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

