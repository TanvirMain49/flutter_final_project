import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/Skeleton/skeleton_box.dart';
import 'package:flutter/material.dart';


class MyTuitionPostsSkeleton extends StatelessWidget {
  const MyTuitionPostsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryDark, // dark green, not black
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ───────── Top Row ─────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonBox(
                height: 22,
                width: 60,
                borderRadius: BorderRadius.circular(20), // closed pill
              ),
              SkeletonBox(
                height: 18,
                width: 70, // ৳3000/mth
                borderRadius: BorderRadius.circular(6),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Title
          SkeletonBox(
            height: 18,
            width: 200,
            borderRadius: BorderRadius.circular(6),
          ),

          const SizedBox(height: 14),

          // Divider
          SkeletonBox(
            height: 1,
            width: double.infinity,
          ),

          const SizedBox(height: 14),

          // ───────── Info Rows ─────────
          _infoRow(),
          const SizedBox(height: 10),
          _infoRow(),
          const SizedBox(height: 10),
          _infoRow(),

          const SizedBox(height: 18),

          // CTA Button
          SkeletonBox(
            height: 44,
            width: double.infinity,
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
    );
  }

  Widget _infoRow() {
    return Row(
      children: [
        SkeletonBox(
          height: 16,
          width: 16, // icon placeholder
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(width: 10),
        SkeletonBox(
          height: 14,
          width: 160,
          borderRadius: BorderRadius.circular(6),
        ),
      ],
    );
  }
}
