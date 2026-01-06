import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/Skeleton/skeleton_box.dart';
import 'package:flutter/material.dart';

class TutorProfileSkeleton extends StatelessWidget {
  const TutorProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: SkeletonBox(
          height: 40,
          width: 40,
          borderRadius: BorderRadius.circular(8),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SkeletonBox(
              height: 40,
              width: 40,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SkeletonBox(
              height: 40,
              width: 40,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.secondary,
              ),
              child: Center(
                child: SkeletonBox(
                  height: 140,
                  width: 140,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Name and Subject
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBox(
                    height: 28,
                    width: 200,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  const SizedBox(height: 12),
                  SkeletonBox(
                    height: 18,
                    width: 100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Rating and Stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatSkeleton(),
                    Container(
                      width: 1,
                      height: 40,
                      color: AppColors.border.withOpacity(0.3),
                    ),
                    _buildStatSkeleton(),
                    Container(
                      width: 1,
                      height: 40,
                      color: AppColors.border.withOpacity(0.3),
                    ),
                    _buildStatSkeleton(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Key Information Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCardSkeleton(),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCardSkeleton(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCardSkeleton(),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCardSkeleton(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // About Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBox(
                    height: 18,
                    width: 80,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        SkeletonBox(
                          height: 14,
                          width: double.infinity,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        const SizedBox(height: 8),
                        SkeletonBox(
                          height: 14,
                          width: double.infinity,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        const SizedBox(height: 8),
                        SkeletonBox(
                          height: 14,
                          width: 150,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Availability Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBox(
                    height: 18,
                    width: 120,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(
                      3,
                          (index) => SkeletonBox(
                        height: 32,
                        width: 80,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Contact Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBox(
                    height: 18,
                    width: 150,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  const SizedBox(height: 12),
                  _buildContactItemSkeleton(),
                  const SizedBox(height: 10),
                  _buildContactItemSkeleton(),
                  const SizedBox(height: 10),
                  _buildContactItemSkeleton(),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
        decoration: BoxDecoration(
          color: AppColors.primaryDark,
          border: Border(
            top: BorderSide(color: AppColors.border.withOpacity(0.3)),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: SkeletonBox(
                height: 50,
                width: double.infinity,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SkeletonBox(
                height: 50,
                width: double.infinity,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatSkeleton() {
    return Column(
      children: [
        SkeletonBox(
          height: 16,
          width: 16,
          borderRadius: BorderRadius.circular(6),
        ),
        const SizedBox(height: 6),
        SkeletonBox(
          height: 14,
          width: 30,
          borderRadius: BorderRadius.circular(6),
        ),
        const SizedBox(height: 6),
        SkeletonBox(
          height: 11,
          width: 40,
          borderRadius: BorderRadius.circular(6),
        ),
      ],
    );
  }

  Widget _buildInfoCardSkeleton() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SkeletonBox(
                height: 16,
                width: 16,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: SkeletonBox(
                  height: 11,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SkeletonBox(
            height: 14,
            width: 100,
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItemSkeleton() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          SkeletonBox(
            height: 18,
            width: 18,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBox(
                height: 11,
                width: 50,
                borderRadius: BorderRadius.circular(6),
              ),
              const SizedBox(height: 6),
              SkeletonBox(
                height: 13,
                width: 120,
                borderRadius: BorderRadius.circular(6),
              ),
            ],
          ),
        ],
      ),
    );
  }
}