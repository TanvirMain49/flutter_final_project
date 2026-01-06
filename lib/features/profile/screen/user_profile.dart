import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/Custom_avatar.dart';
import 'package:_6th_sem_project/core/widgets/Skeleton/profile_skeleton.dart';
import 'package:_6th_sem_project/core/widgets/gradient_background.dart';
import 'package:_6th_sem_project/features/auth/screen/login_screen.dart';
import 'package:_6th_sem_project/features/profile/controller/profile_data_controller.dart';
import 'package:_6th_sem_project/features/profile/screen/personal_information.dart';
import 'package:_6th_sem_project/features/profile/screen/user_setting.dart';
import 'package:_6th_sem_project/features/student/screen/my_tuition_posts.dart';
import 'package:_6th_sem_project/features/tutor/screen/my_application_page.dart';
import 'package:_6th_sem_project/features/tutor/screen/save_tuition_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum UserRole { student, tutor }

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final _dataCon = ProfileDataController();

  @override
  void initState() {
    super.initState();
    _dataCon.fetchUserProfile(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
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
          ? ProfileSkeleton()
          : GradientBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Profile Card with Avatar, Name, Role, Rating
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border, width: 1),
                  ),
                  child: Column(
                    children: [
                      // Avatar with online indicator
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CustomAvatar(),
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.accent,
                              border: Border.all(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Name
                      Text(
                        _dataCon.userProfile['full_name'] ?? 'Unknown',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Role Display
                      Text(
                        _dataCon.userProfile['role'] == 'student'
                            ? 'STUDENT'
                            : 'TUTOR',
                        style: const TextStyle(
                          color: AppColors.accent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color(0xFFfbbf24),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '4.9',
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '· 120 Reviews',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Edit Profile Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: Colors.black,
                            padding:
                            const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => const PersonalInformationScreen()));
                          },
                          child: const Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Account Settings Section Header
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ACCOUNT SETTINGS',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Account Settings Menu Items
                _buildMenuItem(
                  icon: Icons.person,
                  title: _dataCon.userProfile['role'] == 'student'? 'Student Profile': 'Personal & tutor Information',
                  subtitle: 'Update your profile details',
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PersonalProfileScreen(),
                      ),
                    );
                  }
                ),
                const SizedBox(height: 8),
                _buildMenuItem(
                  icon: Icons.credit_card,
                  title: 'Payments & Payouts',
                  subtitle: 'Manage payment methods',
                ),
                const SizedBox(height: 8),
                _buildMenuItem(
                  icon: Icons.lock,
                  title: 'Security & Privacy',
                  subtitle: 'Control your privacy settings',
                ),
                const SizedBox(height: 8),
                _buildMenuItem(
                  icon: Icons.tune,
                  title: 'App Preferences',
                  subtitle: 'Customize your experience',
                ),
                const SizedBox(height: 24),

                // Dynamic Menu Items Based on Role
                if (_dataCon.userProfile['role'] == 'student') ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'MY TUITION',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuItem(
                    icon: Icons.assignment,
                    title: 'My Tuition Posts',
                    subtitle: 'Manage your requests',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyTuitionPosts(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildMenuItem(
                    icon: Icons.bookmark,
                    title: 'Saved Tutors',
                    subtitle: 'View favorite tutors',
                  ),
                ] else ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'MY TUITION',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuItem(
                    icon: Icons.assignment,
                    title: 'My Applied Tuition',
                    subtitle: 'Manage your applied tuition',
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyApplicationsPage(),
                        ),
                      );
                    }
                  ),
                  const SizedBox(height: 8),
                  _buildMenuItem(
                    icon: Icons.bookmark,
                    title: 'Saved Tuition',
                    subtitle: 'View saved opportunities',
                    onTap:(){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SaveTuitionScreen(),
                        )
                      );
                    }
                  ),
                ],
                const SizedBox(height: 24),

                // More Section
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'MORE',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildMenuItem(
                  icon: Icons.emoji_events,
                  title: 'Achievement & Badges',
                  subtitle: 'View your earned awards',
                ),
                const SizedBox(height: 8),
                _buildMenuItem(
                  icon: Icons.auto_graph,
                  title: 'Learning Process',
                  subtitle: 'Track your improvement',
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        decoration: const BoxDecoration(
          color: Colors.black,
          border: Border(
            top: BorderSide(color: AppColors.border, width: 1),
          ),
        ),
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
            onPressed: () async {
              await Supabase.instance.client.auth.signOut(scope: SignOutScope.global);
            },
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
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}