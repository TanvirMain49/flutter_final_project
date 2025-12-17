import 'package:flutter/material.dart';
import '../constants/colors.dart';

class StudentHomeCard extends StatelessWidget {
  final String title;
  final String location;
  final List<String> studyDays;
  final double price;
  final VoidCallback? onTap;
  final String studyType;
  final String subject;


  const StudentHomeCard({
    super.key,
    required this.title,
    required this.location,
    required this.studyDays,
    required this.price,
    required this.studyType,
    required this.subject,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryDark,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    subject,
                    style: TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),

                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "\$${price.toStringAsFixed(0)}",
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextSpan(
                        text: "/hr",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),

            const SizedBox(height: 16),
            const Divider(color: AppColors.white60, height: 1),
            const SizedBox(height: 16),

            _buildIconInfo(Icons.location_on_rounded, location),
            const SizedBox(height: 10),
            _buildIconInfo(Icons.book_rounded, studyType),
            const SizedBox(height: 10),
            _buildDateInfo(studyDays),
          ],
        ),
      ),
    );
  }

  // Helper
  Widget _buildIconInfo(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.white60),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDateInfo(List<String> days) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.date_range_rounded, size: 18, color: Colors.white60),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            days.join(", "),
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
