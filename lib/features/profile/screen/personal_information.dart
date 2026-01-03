// lib/screens/profile_screen.dart

import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/gradient_background.dart';
import 'package:_6th_sem_project/core/widgets/primary_button.dart';
import 'package:_6th_sem_project/features/profile/controller/profile_data_controller.dart';
import 'package:_6th_sem_project/features/profile/screen/complete_profile_screen.dart';
import 'package:flutter/material.dart';

class PersonalProfileScreen extends StatefulWidget {
  const PersonalProfileScreen({super.key});

  @override
  State<PersonalProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<PersonalProfileScreen> {
  final _controller = ProfileDataController();

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    await _controller.fetchUserProfile(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = _controller.userProfile;
    final bool isTutor = user['role'] == 'tutor';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchInitialData,
          ),
        ],
      ),
      body: GradientBackground(
        child: _controller.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.white),
              )
            : RefreshIndicator(
                onRefresh: _fetchInitialData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildUserInfoContainer(user),
                      const SizedBox(height: 24),
                      if (isTutor) _buildTutorProfileSection(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  // --- Main Containers ---

  Widget _buildUserInfoContainer(Map<String, dynamic> user) {
    return Container(
      decoration: _cardDecoration(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader('Personal Information'),
          const SizedBox(height: 20),
          _buildInfoRow('Full Name', user['full_name'] ?? 'N/A', Icons.person),
          _buildDivider(),
          _buildInfoRow('Email', user['email'] ?? 'N/A', Icons.email),
          _buildDivider(),
          _buildInfoRow(
            'Location',
            user['location'] ?? 'Not provided',
            Icons.location_on,
          ),
          _buildDivider(),
          _buildInfoRow(
            'Phone',
            user['phone_number'] ?? 'Not provided',
            Icons.phone,
          ),
          const SizedBox(height: 16),
          // --- Re-included Bio Section ---
          _buildBioSection(user['bio']),
          const SizedBox(height: 16),
          // _buildActionButton(
          //   label: 'Edit Profile',
          //   onPressed: () => _navigateToCompleteProfile(),
          // ),
          PrimaryButton(text: "Edit Profile", onPressed: ()=> _navigateToCompleteProfile(),)
        ],
      ),
    );
  }

  Widget _buildTutorProfileSection() {
    final tutorData = _controller.tutorDetails;

    return Container(
      decoration: _cardDecoration(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader('Tutor Profile'),
          const SizedBox(height: 20),
          if (tutorData == null)
            _buildIncompleteProfileCta()
          else
            _buildTutorDataView(tutorData),
        ],
      ),
    );
  }

  // --- Specialized Sections ---

  Widget _buildBioSection(String? bio) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bio',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.white60,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            bio ?? 'No bio available',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.white,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIncompleteProfileCta() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.accent.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.accent, size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Complete your profile to start teaching',
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Add your teaching details to stand out and help students find you.',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.white60,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          _buildActionButton(
            label: 'Complete Profile',
            onPressed: () => _navigateToCompleteProfile(),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorDataView(Map<String, dynamic> data) {
    return Column(
      children: [
        // Senior Tip: Later we will join the subject name, for now displaying ID
        _buildInfoRow(
            'Expertise',
            data['experience_at'] ?? 'N/A',
            Icons.psychology_outlined // Updated Logo for skills/experience at
        ),
        _buildDivider(),
        _buildInfoRow(
          'Experience',
          '${data['experience_years']} Years',
          Icons.work,
        ),
        _buildDivider(),
        _buildInfoRow('Salary', '৳${data['salary']}/month', Icons.payments),
        _buildDivider(),
        _buildInfoRow(
          'Availability',
          data['availability'] ?? 'N/A',
          Icons.event_available,
        ),
        _buildDivider(),
        _buildInfoRow(
          'Education',
          data['education_at'] ?? 'N/A',
          Icons.school_outlined,
        ),
        const SizedBox(height: 20),
        // _buildActionButton(
        //   label: 'Edit Tutor Profile',
        //   isOutlined: true,
        //   onPressed: () => _navigateToEditProfile(),
        // ),
        PrimaryButton(
          text: "Edit Tutor Profile",
          onPressed: ()=> _navigateToCompleteProfile(),
        )
      ],
    );
  }

  // --- Reusable UI Elements ---

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: AppColors.primaryDark,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      const BoxShadow(
        color: Colors.black26,
        blurRadius: 8,
        offset: Offset(0, 4),
      ),
    ],
  );

  Widget _buildHeader(String title) => Text(
    title,
    style: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: AppColors.white,
    ),
  );

  Widget _buildDivider() => Padding(
    padding: EdgeInsets.symmetric(vertical: 12.0),
    child: Divider(color: AppColors.inputBackground, height: 1),
  );

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.accent, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: AppColors.white60),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback onPressed,
    bool isOutlined = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: isOutlined
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.accent),
              ),
              child: Text(
                label,
                style: const TextStyle(color: AppColors.accent),
              ),
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
              ),
              child: Text(
                label,
                style: const TextStyle(color: AppColors.white),
              ),
            ),
    );
  }

  // --- Navigation ---

  void _navigateToCompleteProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CompleteTutorProfileScreen(),
      ),
    ).then((_) => _fetchInitialData()); // Refresh data when coming back
  }

  void _navigateToEditProfile() {
    // Implement your edit screen here
  }
}
