import 'package:flutter/material.dart';
import '../constants/colors.dart';

class StudentHomeCard extends StatelessWidget {
  final String title;
  final String location;
  final String studyDays;
  final String price;
  final String status;
  final VoidCallback? onTap;
  final String startTime;
  final String endTime;
  final String subject;
  final String studentName;
  final String postTime;

  const StudentHomeCard({
    super.key,
    required this.title,
    required this.location,
    required this.studyDays,
    required this.price,
    required this.status,
    required this.startTime,
    required this.endTime,
    required this.subject,
    required this.studentName,
    required this.postTime,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
        if (onTap != null) onTap!();
      },
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
                Expanded(
                  child: Container(
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const Spacer(),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontFamily: 'Roboto'),
                    children: [
                      TextSpan(
                        text: "৳ ",
                        style: TextStyle(
                          color: AppColors.accent.withOpacity(0.8),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: price,
                        style: const TextStyle(
                          color: AppColors.accent,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      TextSpan(
                        text: " / mth",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                const SizedBox(height: 6),
                Text(
                  "Posted by ${studentName} • ${postTime}",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(color: AppColors.white60, height: 1),
            const SizedBox(height: 16),

            _buildIconInfo(Icons.location_on_rounded, location, null),
            const SizedBox(height: 10),
            _buildIconInfo(Icons.school_rounded, startTime, endTime),
            const SizedBox(height: 10),
            _buildDateInfo(studyDays),
          ],
        ),
      ),
    );
  }

  // Helper
  Widget _buildIconInfo(IconData icon, String label, String? lable_two) {
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
        if (lable_two != null) ...[
          const SizedBox(width: 8),
          Text('-', style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),),
          const SizedBox(width: 8),
          Text(
            lable_two,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ]
      ],
    );
  }

  Widget _buildDateInfo(String days) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.date_range_rounded, size: 18, color: Colors.white60),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            days, // No .join() needed anymore since it's already a string
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
