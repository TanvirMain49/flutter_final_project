import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/Skeleton/tutor_profile.dart';
import 'package:_6th_sem_project/core/widgets/gradient_background.dart';
import 'package:_6th_sem_project/features/student/controller/get_tuition_controller.dart';
import 'package:flutter/material.dart';

class TutorDetails extends StatefulWidget {
  final String tutorId;
  const TutorDetails({super.key, required this.tutorId});

  @override
  State<TutorDetails> createState() => _TutorDetailsState();
}

class _TutorDetailsState extends State<TutorDetails> {
  final _con = GetTuitionController();

  @override
  void initState() {
    super.initState();
    _con.getTutorDetails(widget.tutorId, () {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final tutor = _con.tutorDetails;

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_outlined, color: AppColors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_outline, color: AppColors.accent),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share_outlined, color: AppColors.white),
          ),
        ],
      ),
      body: tutor == null || tutor.isEmpty
          ? const TutorProfileSkeleton()
          : GradientBackground(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero Avatar Section
                    _buildAvatarSection(tutor),
                    const SizedBox(height: 24),

                    // Name and Subject
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildNameAndSubject(tutor),
                    ),
                    const SizedBox(height: 20),

                    // Key Information Cards
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildKeyInfoCards(tutor),
                    ),
                    const SizedBox(height: 24),

                    // About Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildAboutSection(tutor),
                    ),
                    const SizedBox(height: 24),

                    // Availability Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildAvailabilitySection(tutor),
                    ),
                    const SizedBox(height: 24),

                    // Contact Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildContactSection(tutor),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
      // bottomNavigationBar: tutor == null
      //     ? const SizedBox.shrink()
      //     : _buildBottomActionBar(tutor),
    );
  }

  Widget _buildAvatarSection(Map<String, dynamic> tutor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        border: Border(
          bottom: BorderSide(color: AppColors.border.withOpacity(0.3)),
        ),
      ),
      child: Center(
        child: Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                AppColors.accent.withOpacity(0.3),
                AppColors.accent.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: AppColors.accent.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Center(
            child: Icon(
              tutor['gender']?.toString().toLowerCase() == 'female'
                  ? Icons.woman_rounded
                  : Icons.man_rounded,
              size: 70,
              color: AppColors.accent,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameAndSubject(Map<String, dynamic> tutor) {
    final subject = (tutor['tutor_id'] as List?)?.isNotEmpty == true
        ? tutor['tutor_id'][0]['subject_id']['name']
        : 'N/A';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tutor['full_name'] ?? 'Unknown',
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.accent.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Text(
            subject.toString().toUpperCase(),
            style: const TextStyle(
              color: AppColors.accent,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingAndStats(Map<String, dynamic> tutor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('4.8', 'Rating', Icons.star),
          Container(
            width: 1,
            height: 40,
            color: AppColors.border.withOpacity(0.3),
          ),
          _buildStatItem('127', 'Students', Icons.people),
          Container(
            width: 1,
            height: 40,
            color: AppColors.border.withOpacity(0.3),
          ),
          _buildStatItem('5+', 'Years Exp', Icons.trending_up),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.accent, size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildKeyInfoCards(Map<String, dynamic> tutor) {
    final tutorInfo = (tutor['tutor_id'] as List?)?.isNotEmpty == true
        ? tutor['tutor_id'][0]
        : null;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                'Hourly Rate',
                '৳${tutorInfo?['salary'] ?? 'N/A'}',
                AppColors.accent,
                Icons.attach_money,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInfoCard(
                'Experience',
                '${tutorInfo?['experience_years'] ?? 0} Years',
                Colors.blue,
                Icons.auto_awesome,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                'Education',
                tutorInfo?['education_at'] ?? 'N/A',
                Colors.purple,
                Icons.school,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInfoCard(
                'Gender',
                tutor['gender'] ?? 'N/A',
                Colors.pink,
                Icons.person,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(Map<String, dynamic> tutor) {
    final tutorInfo = (tutor['tutor_id'] as List?)?.isNotEmpty == true
        ? tutor['tutor_id'][0]
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.border.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tutorInfo?['experience_at'] ?? 'No bio provided',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvailabilitySection(Map<String, dynamic> tutor) {
    final tutorInfo = (tutor['tutor_id'] as List?)?.isNotEmpty == true
        ? tutor['tutor_id'][0]
        : null;
    final availability = tutorInfo?['availability'] ?? 'N/A';

    final dayMap = {
      'M': 'Monday',
      'T': 'Tuesday',
      'W': 'Wednesday',
      'R': 'Thursday',
      'F': 'Friday',
      'S': 'Saturday',
      'U': 'Sunday',
    };

    final availableDays = availability
        .toString()
        .split(',')
        .map((d) => dayMap[d.trim()] ?? d.trim())
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Days',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableDays
              .map(
                (day) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.accent.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    day,
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildContactSection(Map<String, dynamic> tutor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contact Information',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildContactItem(
          Icons.email_outlined,
          'Email',
          tutor['email'] ?? 'N/A',
        ),
        const SizedBox(height: 10),
        _buildContactItem(
          Icons.phone_outlined,
          'Phone',
          tutor['phone_number'] ?? 'Not provided',
        ),
        const SizedBox(height: 10),
        _buildContactItem(
          Icons.location_on_outlined,
          'Location',
          tutor['location'] ?? 'Not specified',
        ),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accent, size: 18),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(Map<String, dynamic> tutor) {
    return Container(
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
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
              label: const Text('Message'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.accent,
                side: const BorderSide(color: AppColors.accent, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.check_circle_outline, size: 18),
              label: const Text('Hire Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
