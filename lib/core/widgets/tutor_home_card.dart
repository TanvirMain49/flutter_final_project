import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:flutter/material.dart';

class TutorHomeCard extends StatelessWidget {
  final String name;
  final String subject;
  final String price;
  final String? gender;

  const TutorHomeCard({
    super.key,
    required this.name,
    required this.subject,
    required this.price,
    this.gender,
  });

  @override
  Widget build(BuildContext context) {
    // Determine icon and color based on gender
    IconData genderIcon;
    Color genderColor;

    if (gender != null) {
      final genderLower = gender!.toLowerCase();
      if (genderLower == 'male' || genderLower == 'm') {
        genderIcon = Icons.male;
        genderColor = Colors.blue;
      } else if (genderLower == 'female' || genderLower == 'f') {
        genderIcon = Icons.female;
        genderColor = Colors.pink;
      } else {
        genderIcon = Icons.person;
        genderColor = Colors.grey;
      }
    } else {
      genderIcon = Icons.person;
      genderColor = Colors.grey;
    }

    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Avatar with Gender Icon
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: [
                  genderColor.withOpacity(0.3),
                  genderColor.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: genderColor.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Icon(
                genderIcon,
                size: 32,
                color: genderColor,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 2),

                // Subject
                Row(
                  children: [
                    const Icon(
                      Icons.school,
                      size: 14,
                      color: Colors.white60,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        subject,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Price
                Row(
                  children: [
                    const Icon(
                      Icons.attach_money,
                      size: 14,
                      color: AppColors.accent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$price/mnt',
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Gender Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: genderColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: genderColor.withOpacity(0.5),
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            genderIcon,
                            size: 10,
                            color: genderColor,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            gender ?? 'N/A',
                            style: TextStyle(
                              color: genderColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
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