import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CardSkeleton extends StatelessWidget {
  const CardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.inputBackground, // The dark grey you use for cards
      highlightColor: Colors.grey[700]!,    // A slightly lighter grey for the shine
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Title and Bookmark placeholder
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBox(width: 180, height: 20), // Title line
                const CircleAvatar(radius: 20),    // Bookmark circle
              ],
            ),
            const SizedBox(height: 12),
            // Tags placeholders
            Row(
              children: [
                _buildBox(width: 80, height: 24, radius: 8),
                const SizedBox(width: 8),
                _buildBox(width: 60, height: 24, radius: 8),
              ],
            ),
            const SizedBox(height: 12),
            // Location and Info placeholders
            Row(
              children: [
                _buildBox(width: 100, height: 14),
                const Spacer(),
                _buildBox(width: 60, height: 14),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: AppColors.border),
            const SizedBox(height: 12),
            // Price and Button placeholders
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBox(width: 80, height: 24), // Price line
                _buildBox(width: 100, height: 36, radius: 8), // Button shape
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBox({required double width, required double height, double radius = 4}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white, // Color doesn't matter, Shimmer overrides it
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}