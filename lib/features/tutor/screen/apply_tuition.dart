import 'package:_6th_sem_project/core/widgets/custom_text_field.dart';
import 'package:_6th_sem_project/core/widgets/primary_button.dart';
import 'package:_6th_sem_project/features/profile/controller/profile_data_controller.dart';
import 'package:_6th_sem_project/features/student/controller/get_tuition_controller.dart';
import 'package:_6th_sem_project/features/tutor/controller/tutor_data_controller.dart';
import 'package:flutter/material.dart';
import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/gradient_background.dart';

class ApplyForTuitionScreen extends StatefulWidget {
  final String postId;
  const ApplyForTuitionScreen({super.key, required this.postId});

  @override
  State<ApplyForTuitionScreen> createState() => _ApplyForTuitionScreenState();
}

class _ApplyForTuitionScreenState extends State<ApplyForTuitionScreen> {
  final _con = TutorDataController();
  final _tuitionCon = GetTuitionController();
  final _profileCon = ProfileDataController();
  late TextEditingController tutorMessageController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      _tuitionCon.getTuitionDetails(widget.postId, () {
        if (mounted) setState(() {});
      }),
      _profileCon.fetchUserProfile(() {
        if (mounted) setState(() {});
      }),
      _con.cheekIfApplied(widget.postId, () {
        if (mounted) setState(() {});
      }),
    ]);
  }

  @override
  void dispose() {
    tutorMessageController.dispose();
    super.dispose();
  }

  // Function to submit application
  void _submitApplication() async {
    // 1. Capture the result of the operation
    final bool isSuccess = await _con.applyForTuition(
      widget.postId,
      tutorMessageController.text.trim(),
      () {
        if (mounted) {
          setState(() {});
        }
      },
    );

    if (!mounted) return;

    // 3. Conditional Error Handling
    if (!isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Application failed! Please check your connection.'),
          backgroundColor: Colors.red,
        ),
      );
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Application applied successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context); // Only close the screen if successful
  }

  @override
  Widget build(BuildContext context) {
    final post = _tuitionCon.tuitionDetails;
    final userProfile = _profileCon.userProfile;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply for Tuition'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: GradientBackground(
        child: (_tuitionCon.isLoading || _profileCon.isLoading)
            ? const Center(
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.accent),
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ===== Tuition Card Section =====
                      _buildTuitionCard(post!),
                      const SizedBox(height: 24),

                      // ===== Student Requirements Section =====
                      if (post['description'] != null &&
                          post['description'].toString().trim().isNotEmpty &&
                          post['description'] != 'null') ...[
                        _buildStudentRequirementsSection(post['description']),
                        const SizedBox(height: 24),
                      ],
                      // ===== Message Section =====
                      _buildMessageSection(),
                      const SizedBox(height: 24),

                      // ===== Submit Button =====
                      PrimaryButton(
                        text: _con.hasApplied
                            ? 'Applied'
                            : 'Submit Application',
                        isLoading: _con.isApply,
                        onPressed: (_con.isLoading || _con.hasApplied)
                            ? null
                            : () {
                                _submitApplication();
                              },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  // ===== Tuition Card Widget =====
  Widget _buildTuitionCard(Map<String, dynamic> post) {
    // Senior Tip: Format time range for better readability
    final String timeRange =
        "${post['start_time'] ?? ''} - ${post['end_time'] ?? ''}";

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.white),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBadge(post['grade'] ?? 'N/A'),
              Text(
                '৳${post['salary']}', // Using local currency
                style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            post['subjects']?['name'] ?? 'General Subject',
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(height: 32, color: AppColors.white),

          // Location Row
          _buildDetailRow(
            Icons.location_on,
            'LOCATION',
            post['student_location'] ?? 'Sylhet',
          ),
          const SizedBox(height: 16),

          // Schedule Row
          _buildDetailRow(
            Icons.calendar_month,
            'DAYS',
            post['preferred_day'] ?? 'Contact for days',
          ),
          const SizedBox(height: 16),

          // Time Row
          _buildDetailRow(Icons.access_time_filled, 'TIME SLOT', timeRange),
        ],
      ),
    );
  }

  // ===== Student Requirements Section =====
  Widget _buildStudentRequirementsSection(String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with Icon
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.assignment,
                color: AppColors.accent,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Student Requirements',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Requirements Text
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryDark,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '"$description"',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontStyle: FontStyle.italic,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  // ===== Message Section =====
  Widget _buildMessageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text Input Field
        CustomTextField(
          label: 'Your message to the student',
          labelFontSize: 17,
          controller: tutorMessageController,
          hintText:
              "Introduce yourself and explain why you are good fit for this tuition...",
        ),
        const SizedBox(height: 12),

        // Info text
        Text(
          'Keep it professional. Your profile link will be automatically attached.',
          style: TextStyle(color: AppColors.textMuted, fontSize: 12),
        ),
      ],
    );
  }

  // --- UI Helper Components ---
  Widget _buildBadge(String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: AppColors.accent.withOpacity(0.1),
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: AppColors.accent),
    ),
    child: Text(
      label,
      style: const TextStyle(
        color: AppColors.accent,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.accent, size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.white60,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
