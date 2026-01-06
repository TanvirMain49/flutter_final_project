import 'dart:math';
import 'package:_6th_sem_project/core/widgets/custom_home_navbar.dart';
import 'package:_6th_sem_project/core/widgets/gradient_background.dart';
import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/Skeleton/card_skeleton.dart';
import 'package:_6th_sem_project/core/widgets/student_home_cart.dart';
import 'package:_6th_sem_project/features/profile/controller/profile_data_controller.dart';
import 'package:_6th_sem_project/features/student/screen/tuition_details.dart';
import 'package:_6th_sem_project/features/tutor/controller/tutor_data_controller.dart';
import 'package:_6th_sem_project/utils/Student.utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class TutorHomeScreen extends StatefulWidget {
  const TutorHomeScreen({super.key});

  @override
  State<TutorHomeScreen> createState() => _TutorHomeScreenState();
}

class _TutorHomeScreenState extends State<TutorHomeScreen> {
  final _con = TutorDataController();
  final _con2 = ProfileDataController();

  final user = Supabase.instance.client.auth.currentUser;

  final List<Map<String, dynamic>> activeTuitionPosts = [
    {
      'title': 'Mathematics Tutoring - Grade 10',
      'subject': 'Mathematics',
      'level': 'Grade 10',
      'location': 'Downtown Area',
      'salary': '25',
      'timeAgo': '2h ago',
      'studentName': 'Ahmed Khan',
      'status': 'Active',
    },
    {
      'title': 'English Literature Classes',
      'subject': 'English',
      'level': 'Grade 12',
      'location': 'Uptown District',
      'salary': '30',
      'timeAgo': '4h ago',
      'studentName': 'Fatima Ali',
      'status': 'Active',
    },
    {
      'title': 'Physics Coaching - Advanced Level',
      'subject': 'Physics',
      'level': 'College',
      'location': 'Central Hub',
      'salary': '35',
      'timeAgo': '6h ago',
      'studentName': 'Hassan Mahmud',
      'status': 'Pending',
    },
  ];

  final List<Map<String, dynamic>> myApplications = [
    {
      'title': 'Biology Class - Online',
      'school': 'Green Valley School',
      'status': 'Applied',
      'appliedDate': '2 days ago',
    },
    {
      'title': 'Chemistry Tutor Needed',
      'school': 'Riverside Academy',
      'status': 'In Review',
      'appliedDate': '5 days ago',
    },
    {
      'title': 'Mathematics Expert',
      'school': 'Elite Learning Center',
      'status': 'Accepted',
      'appliedDate': '1 week ago',
    },
  ];

  final List<Map<String, String>> savedItems = [
    {'title': 'Advanced Mathematics', 'jobs': '12 jobs'},
    {'title': 'Online Classes', 'jobs': '8 jobs'},
    {'title': 'Science Tutoring', 'jobs': '15 jobs'},
  ];
  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    // 1. Start loading state immediately
    // Senior Tip: We pass an empty function because we will manually
    // call setState once at the end or use the controller's internal loading flag.
    if (mounted) setState(() {});

    try {
      // 2. Parallel Execution
      // This fires all 3 requests at once. The total wait time is equal
      // to the SLOWEST single API call, not the sum of all three.
      await Future.wait([
        _con.getTuition(() {}),
        _con.syncSavedPosts(),
        _con.isCompleteTutorProfile((){}),
        _con.getTutorApplications(status: 'All', onUpdate: () {}),
        _con2.fetchUserProfile(() {}),
      ]);
    } catch (e) {
      debugPrint("Error loading home data: $e");
      // Handle global error if necessary
    } finally {
      // 3. Final UI Update
      // Once all data is in memory, we trigger one single build cycle.
      if (mounted) setState(() {});
    }
  }

  void ifMounted(VoidCallback fn) {
    if (mounted) fn();
  }

  @override
  Widget build(BuildContext context) {
    // todo: user remove:
    late final userEmail = user?.email ?? "Guest User";
    late final displayName = userEmail.contains('@')
        ? userEmail.split('@')[0]
        : userEmail;
    bool hasSaved = !savedItems.isNotEmpty;
    bool profileComplete = _con.isCompleteProfile;


    return Scaffold(
      body: RefreshIndicator(
        color: AppColors.accent,
        backgroundColor: AppColors.primaryDark,
        onRefresh: _loadAllData,
        child: GradientBackground(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                CustomHomeNavbar(displayName: displayName.toUpperCase()),
                if (!_con2.isLoading &&
                    _con2.userProfile.isNotEmpty &&
                    !profileComplete)
                  const SizedBox(height: 20),

                // Profile Alert Card (Gatekeeper)
                if (!_con2.isLoading &&
                    _con2.userProfile.isNotEmpty &&
                    !profileComplete)
                  _buildProfileAlertCard(),

                const SizedBox(height: 32),

                // Active Feed Section
                _buildSectionHeader('Recent Tuition', () {}),
                const SizedBox(height: 12),
                _buildActiveFeedCards(profileComplete),

                const SizedBox(height: 32),

                // My Applications Section
                _buildSectionHeader('My Applications', () {}),
                const SizedBox(height: 12),
                _con.tutorApplications.isNotEmpty
                    ? _buildApplicationsCards(_con.tutorApplications)
                    : _buildEmptyState(
                        Icons.assignment_outlined,
                        "No Applications Yet",
                        "You haven't applied to any jobs. Start\napplying to find your perfect student!",
                        "Apply Now",
                      ),

                const SizedBox(height: 32),

                // Saved Items Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Saved Items',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // hasSaved
                      //     ? _buildSavedItemsList()
                      //     : _buildEmptyState(
                      //         Icons.bookmark_border_rounded,
                      //         "No Saved Jobs Yet",
                      //         "Tap the bookmark icon on any job\npost to save it for later.",
                      //         "Browse Jobs",
                      //       ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Quick Stats Section
                // _buildQuickStatsSection(),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileAlertCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.accent, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadiusGeometry.circular(12),
        boxShadow: [
          BoxShadow(color: AppColors.accent.withOpacity(0.2), blurRadius: 4),
        ],
      ),

      child: Padding(
        padding: EdgeInsetsGeometry.all(16),
        child: Row(
          children: [
            const Icon(Icons.info_outline, color: AppColors.black, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Complete Your Profile',
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Finish your profile to start applying!',
                    style: TextStyle(
                      color: AppColors.black.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                // Navigate to profile completion
              },
              child: const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.black,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onViewAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: onViewAll,
          child: const Text(
            'View All',
            style: TextStyle(
              color: AppColors.accent,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveFeedCards(bool profileComplete) {
    if (_con.isLoading && _con.postTuition.isEmpty) {
      return Column(
        children: List.generate(3, (index) => const CardSkeleton()),
      );
    }

    // Filter posts where status is not 'closed'
    final filteredPosts = _con.postTuition
        .where((post) => post['status']?.toString().toLowerCase() != 'closed')
        .toList();

    // If loading is done and filtered list is still empty, show empty state
    if (!_con.isLoading && filteredPosts.isEmpty) {
      return _buildEmptyState(
        Icons.bookmark_border_rounded,
        "No Tuitions Available",
        "Check back later for new posts.",
        "Browse Jobs",
      );
    }

    return Column(
      children: List.generate(filteredPosts.length, (index) {
        final post = filteredPosts[index];
        debugPrint('Post $post');
        final timeAgo = StudentUtils.formatTimeAgo(
          post['created_at'],
        );
        final startTime = StudentUtils.formatToBDTime(
          post['start_time'],
        );
        final endTime = StudentUtils.formatToBDTime(
          post['end_time'],
        );
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: StudentHomeCard(
            title: post['post_title'],
            location: post['student_location'],
            studyDays: post['preferred_day'],
            price: post['salary'],
            status: post['status'],
            startTime: startTime,
            endTime: endTime,
            subject: post['subjects']['name'],
            studentName: post['users']['full_name'],
            postTime: timeAgo,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TuitionDetails(
                    isProfileComplete: profileComplete,
                    tuitionId: post['id'].toString(),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildApplicationsCards(List<Map<String, dynamic>> myApplications) {
    return Column(
      children: List.generate(min(myApplications.length, 3), (index) {
        final app = myApplications[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildApplicationCard(app),
        );
      }),
    );
  }

  Widget _buildApplicationCard(Map<String, dynamic> app) {
    // Extract nested data
    final tuitionPost = app['tuition_post'] as Map<String, dynamic>?;
    final subject = tuitionPost?['subject_id'] as Map<String, dynamic>?;

    // Get values with fallback
    final title = subject?['name'] ?? 'Unknown Subject';
    final grade = tuitionPost?['grade'] ?? 'N/A';
    final location = tuitionPost?['student_location'] ?? 'N/A';
    final salary = tuitionPost?['salary'] ?? 'N/A';
    final status = app['status'] ?? 'pending';
    final createdAt = app['created_at'] ?? '';

    // Format date
    String formattedDate = StudentUtils.formatToMMDDYYYY(createdAt);

    // Determine status color and icon
    Color statusColor = AppColors.accent;
    IconData statusIcon = Icons.hourglass_bottom;

    if (status.toLowerCase() == 'pending') {
      statusColor = Colors.blue;
      statusIcon = Icons.pending;
    } else if (status.toLowerCase() == 'accepted') {
      statusColor = AppColors.success;
      statusIcon = Icons.check_circle;
    } else if (status.toLowerCase() == 'rejected') {
      statusColor = Colors.red;
      statusIcon = Icons.cancel;
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Subject Title
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Grade
                  Text(
                    grade,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Location and Salary
                  Text(
                    '$location • \$$salary',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Applied Date
                  Text(
                    'Applied $formattedDate',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: statusColor, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(statusIcon, color: statusColor, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    status[0].toUpperCase() + status.substring(1),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
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

  // Helper function to format date
  //   String _formatDate(String dateString) {
  //     try {
  //       final dateTime = DateTime.parse(dateString);
  //       final now = DateTime.now();
  //       final difference = now.difference(dateTime);
  //
  //       if (difference.inDays == 0) {
  //         return 'today';
  //       } else if (difference.inDays == 1) {
  //         return 'yesterday';
  //       } else if (difference.inDays < 7) {
  //         return '${difference.inDays} days ago';
  //       } else {
  //         return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  //       }
  //     } catch (e) {
  //       return 'N/A';
  //     }
  //   }

  // Widget _buildSavedItemsList() {
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Row(
  //       children: List.generate(3, (index) {
  //         final item = savedItems[index];
  //         return Padding(
  //           padding: EdgeInsets.only(
  //             right: index == savedItems.length - 1 ? 0 : 12,
  //           ),
  //           child: _buildSavedItemCard(item),
  //         );
  //       }),
  //     ),
  //   );
  // }
  //
  // Widget _buildSavedItemCard(Map<String, String> item) {
  //   return Container(
  //     width: 160,
  //     decoration: BoxDecoration(
  //       color: AppColors.primaryDark,
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border.all(color: AppColors.border, width: 1),
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.all(12),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             item['title']!,
  //             style: const TextStyle(
  //               color: AppColors.white,
  //               fontSize: 14,
  //               fontWeight: FontWeight.bold,
  //             ),
  //             maxLines: 2,
  //             overflow: TextOverflow.ellipsis,
  //           ),
  //           const SizedBox(height: 12),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 item['jobs']!,
  //                 style: const TextStyle(
  //                   color: AppColors.textMuted,
  //                   fontSize: 12,
  //                 ),
  //               ),
  //               const Icon(
  //                 Icons.arrow_forward_ios,
  //                 color: AppColors.accent,
  //                 size: 14,
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _buildQuickStatsSection() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: AppColors.secondary,
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border.all(color: AppColors.border, width: 1),
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           const Text(
  //             'Quick Stats',
  //             style: TextStyle(
  //               color: AppColors.white,
  //               fontSize: 16,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //           const SizedBox(height: 16),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceAround,
  //             children: [
  //               _buildStatItem('Applied', '8', AppColors.accent),
  //               Container(width: 1, height: 50, color: AppColors.border),
  //               _buildStatItem('In Review', '3', Colors.blue),
  //               Container(width: 1, height: 50, color: AppColors.border),
  //               _buildStatItem('Accepted', '2', AppColors.success),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildStatItem(String label, String count, Color color) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            color: color,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accent, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    IconData icon,
    String title,
    String subtitle,
    String buttonText,
  ) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(icon, size: 80, color: AppColors.textMuted.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Navigate back to the home/browse tab
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
              ),
              child: Text(
                buttonText,
                style: const TextStyle(color: AppColors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
