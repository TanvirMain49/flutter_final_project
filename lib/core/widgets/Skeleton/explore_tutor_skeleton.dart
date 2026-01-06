import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/Skeleton/skeleton_box.dart';
import 'package:flutter/material.dart';

class ExploreTutorSkeleton extends StatelessWidget {
  const ExploreTutorSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryDark, // dark green, NOT black
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ───────── Top Row ─────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBox(
                height: 48,
                width: 48,
                borderRadius: BorderRadius.circular(12),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(
                      height: 16,
                      width: 140,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    const SizedBox(height: 6),
                    SkeletonBox(
                      height: 14,
                      width: 100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ],
                ),
              ),

              SkeletonBox(
                height: 16,
                width: 50,
                borderRadius: BorderRadius.circular(6),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Divider
          SkeletonBox(
            height: 1,
            width: double.infinity,
            borderRadius: BorderRadius.circular(2),
          ),

          const SizedBox(height: 14),

          // ───────── Info Grid ─────────
          Row(
            children: [
              Expanded(child: _infoItem()),
              const SizedBox(width: 12),
              Expanded(child: _infoItem()),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _infoItem()),
              const SizedBox(width: 12),
              Expanded(child: _infoItem()),
            ],
          ),

          const SizedBox(height: 18),

          // ───────── Button ─────────
          SkeletonBox(
            height: 44,
            width: double.infinity,
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
    );
  }

  Widget _infoItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonBox(
          height: 12,
          width: 70,
          borderRadius: BorderRadius.circular(6),
        ),
        const SizedBox(height: 6),
        SkeletonBox(
          height: 14,
          width: 90,
          borderRadius: BorderRadius.circular(6),
        ),
      ],
    );
  }
}
