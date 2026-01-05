// lib/widgets/application_card.dart
import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:flutter/material.dart';

class ApplicationCard extends StatelessWidget {
  final Map<String, dynamic> application;
  final VoidCallback onHire;
  final VoidCallback onReject;

  const ApplicationCard({
    super.key,
    required this.application,
    required this.onHire,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    // Extract user data
    final user = application['users'] as Map<String, dynamic>? ?? {};
    final fullName = user['full_name'] ?? 'John Doe';
    final number = user['phone_number'] ?? '+880';
    final email = user['email'] ?? '<john@example.com>';
    final message = application['message'];

    // Tutor skills (first entry)
    final tutorSkillsList = user['tutor_skills'] as List? ?? [];
    final tutorSkills = tutorSkillsList.isNotEmpty
        ? tutorSkillsList[0] as Map<String, dynamic>
        : {};

    final salary = tutorSkills['salary'] ?? 'Not specified';
    final experience = tutorSkills['experience_years'] ?? 'N/A';
    final education = tutorSkills['education_at'] ?? 'N/A';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      color: AppColors.primaryDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top: Avatar + Name/Email
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Container(
                  width: 66,
                  height: 68,
                  decoration: BoxDecoration(
                    color: AppColors.inputBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border, width: 1),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    size: 36,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(width: 12),
                // Name & Email
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName,
                        style: const TextStyle(
                          fontSize: 20,              // Slightly bigger
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 14,              // Bigger than before
                          color: AppColors.textMuted,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),Text(
                        '+88$number',
                        style: const TextStyle(
                          fontSize: 14,              // Bigger than before
                          color: AppColors.textMuted,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Key Info in a row (Experience, Salary, Availability)
            Row(
              children: [
                Expanded(child: _buildInfoItem(Icons.history_edu, 'Exp', '$experience yrs')),
                const SizedBox(width: 12),
                Expanded(child: _buildInfoItem(Icons.money, 'Salary', '$salary/mnt')),
                const SizedBox(width: 12),
                Expanded(child: _buildInfoItem(Icons.school_outlined, 'Graduate', education)),
              ],
            ),
            const SizedBox(height: 12),

            // Optional short message
            if (message != null && message.toString().trim().isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  message.toString().trim(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.white60,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            if (message != null && message.toString().trim().isNotEmpty)
              const SizedBox(height: 12),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReject,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      side: const BorderSide(color: Colors.red, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Reject',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onHire,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Hire',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.accent),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,                  // Bigger value text
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}