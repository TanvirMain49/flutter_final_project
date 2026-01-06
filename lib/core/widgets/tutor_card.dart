import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';


class TutorCard extends StatelessWidget {
  final String name;
  final String subject;
  final String price;
  final String? gender;
  final String experience;
  final String education;
  final VoidCallback? onpressed;

  const TutorCard({
    super.key,
    required this.name,
    required this.subject,
    required this.price,
    this.gender,
    required this.experience,
    required this.education,
    this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar + Name + Price
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.accent.withOpacity(0.2),
                ),
                child: Center(
                  child: Icon(
                    gender?.toLowerCase() == 'female'
                        ? Icons.woman_rounded
                        : Icons.man_rounded,
                    size: 30,
                    color: AppColors.accent,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Name and Subject
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subject,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              // Price
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '৳$price',
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '/mnt',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Divider
          Container(
            height: 1,
            color: Colors.white.withOpacity(0.06),
          ),

          const SizedBox(height: 12),

          // Information Grid
          Column(
            children: [
              // Row 1: Experience + Education
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      icon: Icons.trending_up,
                      label: 'Experience',
                      value: experience,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildInfoItem(
                      icon: Icons.school,
                      label: 'Education',
                      value: education,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Row 2: Location + Gender
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      icon: Icons.location_on_outlined,
                      label: 'Location',
                      value: 'Sylhet',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildInfoItem(
                      icon: Icons.person_outline,
                      label: 'Gender',
                      value: gender ?? 'N/A',
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Divider
          Container(
            height: 1,
            color: Colors.white.withOpacity(0.06),
          ),

          const SizedBox(height: 12),

          // Action Buttons
          PrimaryButton(text: 'View Profile', onPressed: onpressed,)
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.accent,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}