import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/Custom_avatar.dart';
import 'package:_6th_sem_project/core/widgets/gradient_background.dart';
import 'package:_6th_sem_project/features/profile/controller/profile_data_controller.dart';
import 'package:_6th_sem_project/features/profile/screen/user_setting.dart';
import 'package:flutter/material.dart';

enum UserRole { student, tutor }

class UserProfile extends StatefulWidget {
  final UserRole userRole;
  const UserProfile({super.key, this.userRole = UserRole.student});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late UserRole currentRole;
  final _dataCon = ProfileDataController();

  @override
  void initState() {
    super.initState();
    _dataCon.getUserProfile(() {
      if (mounted) setState(() {});
    });
    currentRole = widget.userRole;
  }

  // !!!!!!!!!!!!!!! End !!!!!!!!!!!!!!!!

  @override
  Widget build(BuildContext context) {
    debugPrint(_dataCon.userProfile.toString());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserSetting()),
              );
            },
          ),
        ],
      ),
      body: _dataCon.isLoading
          ? const Center(
              child: GradientBackground(
                child: CircularProgressIndicator(color: AppColors.accent),
              ),
            )
          : GradientBackground(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Profile Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border, width: 1),
                        ),
                        child: Column(
                          children: [
                            // Avatar
                            CustomAvatar(),
                            const SizedBox(height: 16),
                            // Name
                            Text(
                              _dataCon.userProfile['full_name'] ?? 'Unknown',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Role Display
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _dataCon.userProfile['role']  == 'student'
                                      ? 'Student Member'
                                      : 'Tutor Member',
                                  style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Dynamic Menu Items Based on Role
                      if (currentRole == UserRole.student) ...[
                        _buildMenuItem(
                          icon: Icons.assignment,
                          title: 'My Tuition Posts',
                          subtitle: 'Manage your requests',
                        ),
                        const SizedBox(height: 12),

                        _buildMenuItem(
                          icon: Icons.favorite,
                          title: 'Saved Tutors',
                          subtitle: 'View favorite tutors',
                        ),
                      ] else ...[
                        _buildMenuItem(
                          icon: Icons.assignment,
                          title: 'My Applied Tuition',
                          subtitle: 'Manage your applications',
                        ),
                        const SizedBox(height: 12),
                        _buildMenuItem(
                          icon: Icons.bookmark,
                          title: 'Saved Tuition',
                          subtitle: 'View saved opportunities',
                        ),
                      ],
                      const SizedBox(height: 12),
                      _buildMenuItem(
                        icon: Icons.emoji_events,
                        title: 'Achievement & Badges',
                        subtitle: "view your earned awards",
                      ),
                      const SizedBox(height: 12),
                      _buildMenuItem(
                        icon: Icons.auto_graph,
                        title: 'Learning process',
                        subtitle: 'Track your improve',
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        decoration: BoxDecoration(color: Colors.black),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.surface,
              foregroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {},
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout, size: 18),
                SizedBox(width: 8),
                Text(
                  'Log Out',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.accent, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
        ],
      ),
    );
  }
}
