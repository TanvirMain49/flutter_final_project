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
    final status = application['status']?.toString().toLowerCase() ?? 'pending';

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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      elevation: 2,
      color: AppColors.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top: Avatar + Name/Email/Phone + Status Badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar with gradient background
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.accent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    size: 40,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(width: 16),
                // Name & Email & Phone
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        number.startsWith('+') ? number : '+88$number',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Status Badge
                _buildStatusBadge(status),
              ],
            ),
            const SizedBox(height: 18),

            // Divider
            Divider(
              color: Colors.grey.withOpacity(0.2),
              thickness: 1,
            ),
            const SizedBox(height: 16),

            // Key Info in a row (Experience, Salary, Education)
            Row(
              children: [
                Expanded(child: _buildInfoItem(Icons.work_outline, 'Experience', '$experience years')),
                const SizedBox(width: 12),
                Expanded(child: _buildInfoItem(Icons.attach_money, 'Salary', '$salary/m')),
                const SizedBox(width: 12),
                Expanded(child: _buildInfoItem(Icons.school, 'Education', education)),
              ],
            ),
            const SizedBox(height: 16),

            // Optional message section
            if (message != null && message.toString().trim().isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.15),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Application Message',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      message.toString().trim(),
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.white,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

            if (message != null && message.toString().trim().isNotEmpty)
              const SizedBox(height: 18),

            // Action Buttons or Status Info based on application status
            if (status == 'pending')
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onReject,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(
                          color: AppColors.accent.withOpacity(0.5),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Decline',
                        style: TextStyle(
                          color: AppColors.accent,
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
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Hire',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else if (status == 'hired')
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.green.withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.green[400],
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tutor Hired',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.green[400],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'This tutor has been successfully hired.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green[300],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else if (status == 'rejected')
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.orange.withOpacity(0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.cancel_outlined,
                        color: Colors.orange[400],
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Application Rejected',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.orange[400],
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'This application has been rejected.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange[300],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color badgeColor;
    Color textColor;
    IconData icon;

    switch (status) {
      case 'pending':
        badgeColor = Colors.blue.withOpacity(0.2);
        textColor = Colors.blue[300]!;
        icon = Icons.hourglass_empty;
        break;
      case 'hired':
        badgeColor = Colors.green.withOpacity(0.2);
        textColor = Colors.green[300]!;
        icon = Icons.check_circle;
        break;
      case 'rejected':
        badgeColor = Colors.orange.withOpacity(0.2);
        textColor = Colors.orange[300]!;
        icon = Icons.cancel;
        break;
      default:
        badgeColor = Colors.grey.withOpacity(0.2);
        textColor = Colors.grey[300]!;
        icon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            status[0].toUpperCase() + status.substring(1),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppColors.accent),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}