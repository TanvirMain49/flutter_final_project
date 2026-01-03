import 'package:_6th_sem_project/core/widgets/Skeleton/skeleton_box.dart';
import 'package:flutter/material.dart';

class CardDetailsSkeleton extends StatelessWidget {
  const CardDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0F1C16),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //profile + name
            Row(
              children: [
                const SkeletonBox(height: 40, width: 40, borderRadius: BorderRadius.all(Radius.circular(20))),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SkeletonBox(height: 14, width: 120),
                    SizedBox(height: 6),
                    SkeletonBox(height: 12, width: 80),
                  ],
                )
              ],
            ),
            const SizedBox(height: 16),

            // Title
            const SkeletonBox(height: 18, width: 220),

            const SizedBox(height: 10),

            // Tag
            const SkeletonBox(height: 22, width: 150, borderRadius: BorderRadius.all(Radius.circular(20))),

            const SizedBox(height: 16),

            // Price
            const SkeletonBox(height: 20, width: 100),

            const SizedBox(height: 16),

            // Info grid
            Row(
              children: const [
                Expanded(child: SkeletonBox(height: 80, width: double.infinity)),
                SizedBox(width: 10),
                Expanded(child: SkeletonBox(height: 80, width: double.infinity)),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: const [
                Expanded(child: SkeletonBox(height: 80, width: double.infinity)),
                SizedBox(width: 10),
                Expanded(child: SkeletonBox(height: 80, width: double.infinity)),
              ],
            ),

            const SizedBox(height: 24),

            // Description lines
            const SkeletonBox(height: 14, width: double.infinity),
            const SizedBox(height: 8),
            const SkeletonBox(height: 14, width: double.infinity),
            const SizedBox(height: 8),
            const SkeletonBox(height: 14, width: 200),

            const SizedBox(height: 20),
          ],
        ),
      ),
      // bottomNavigationBar: Row(
      //   children: [
      //     Expanded(
      //       child: const SkeletonBox(height: 20, width: double.infinity)
      //     ),
      //     const SizedBox(width: 12,),
      //     Expanded(
      //         child: const SkeletonBox(height: 20, width: double.infinity)
      //     )
      //   ],
      // ),
    );
  }
}
