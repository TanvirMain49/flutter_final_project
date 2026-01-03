import 'package:_6th_sem_project/core/widgets/custom_home_navbar.dart';
import 'package:_6th_sem_project/core/widgets/gradient_background.dart';
import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/Skeleton/card_skeleton.dart';
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
  final user = Supabase.instance.client.auth.currentUser;
  bool profileComplete = false;

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

  // void handelSave(String postId) async{
  //   final result = await _con.saveTuition(() {
  //     if (mounted) setState(() {});
  //   }, postId);
  //
  //   if(result != null){
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //             content: Container(
  //               decoration: BoxDecoration(
  //                 color: AppColors.accent,
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //                 child: Text(result, style: TextStyle(
  //                   color: AppColors.black,
  //                 ),),
  //             )
  //
  //         )
  //     );
  //   }
  // }
  @override
  void initState() {
    super.initState();
    _con.getTuition(() {
      if (mounted) setState(() {});
    });
    _con.syncSavedPosts().then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {

    late final userEmail = user?.email ?? "Guest User";
    late final displayName = userEmail.contains('@')
        ? userEmail.split('@')[0]
        : userEmail;
    bool hasSaved = !savedItems.isNotEmpty;
    bool hasApplied = !myApplications.isNotEmpty;

    return Scaffold(
      body: RefreshIndicator(
        color: AppColors.accent,
        backgroundColor: AppColors.primaryDark,
        onRefresh: () async {
          await _con.getTuition(() {
            if (mounted) setState(() {});
          });
          await _con.syncSavedPosts().then((_) {
            if (mounted) setState(() {});
          });
          setState(() {});
        },
        child: GradientBackground(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                CustomHomeNavbar(displayName: displayName.toUpperCase()),
                const SizedBox(height: 20),

                // Profile Alert Card (Gatekeeper)
                if (!profileComplete) _buildProfileAlertCard(),

                const SizedBox(height: 32),

                // Active Feed Section
                _buildSectionHeader('Recent Tuition', () {}),
                const SizedBox(height: 12),
                _buildActiveFeedCards(),

                const SizedBox(height: 32),

                // My Applications Section
                _buildSectionHeader('My Applications', () {}),
                const SizedBox(height: 12),
                hasApplied
                    ? _buildApplicationsCards()
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
                      hasSaved
                          ? _buildSavedItemsList()
                          : _buildEmptyState(
                              Icons.bookmark_border_rounded,
                              "No Saved Jobs Yet",
                              "Tap the bookmark icon on any job\npost to save it for later.",
                              "Browse Jobs",
                            ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Quick Stats Section
                _buildQuickStatsSection(),

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

  Widget _buildActiveFeedCards() {

    if(_con.isLoading && _con.postTuition.isEmpty) {
      return Column(
        children: List.generate(3, (index) => const CardSkeleton()),
      );
    }

    // If loading is done and list is still empty, show empty state
    if (!_con.isLoading && _con.postTuition.isEmpty) {
      return _buildEmptyState(
          Icons.bookmark_border_rounded,
          "No Tuitions Available",
          "Check back later for new posts.",
          "Browse Jobs"
      );
    }

    return Column(
      children: List.generate(_con.postTuition.length, (index) {
        final post = _con.postTuition[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildTuitionCard(post),
        );
      }),
    );
  }

  Widget _buildTuitionCard(Map<String, dynamic> post) {
    String timeAgo = StudentUtils.formatTimeAgo(post['created_at'].toString());
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: InkWell(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TuitionDetails(tuitionId: post['id'].toString()),
            )
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Saved button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      post['post_title'],
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // saved button
                  GestureDetector(
                    onTap: _con.isSave? null : () async {
                      final String? result = await _con.toggleSave(
                          post['id'].toString(),
                          ()=> setState((){})
                      );
                      if (!mounted) return;
                      if (result == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Connection error. Try again."))
                        );
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(result, style: const TextStyle(color: AppColors.white)),
                          backgroundColor: AppColors.inputBackground,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.inputBackground,
                      ),
                      child: Center(
                        child: Icon(
                          _con.savedPostIds.contains(post['id'].toString())
                              ? Icons.bookmark
                              : Icons.bookmark_outline,
                          color: AppColors.accent,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Subject and Level
              Row(
                children: [
                  _buildInfoChip(Icons.book, post['subjects']['name']),
                  const SizedBox(width: 8),
                  _buildInfoChip(Icons.school, post['grade']),
                ],
              ),
              const SizedBox(height: 12),

              // Location and Time
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: AppColors.textMuted,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    post['student_location'],
                    style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                  ),
                  const Spacer(),
                  // ADD THIS PART:
                  const Icon(
                    Icons.people_outline,
                    color: AppColors.textMuted,
                    size: 15,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "400 applied",
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 13,
                    ),
                  ),
                  const Text(
                    " • ",
                    style: TextStyle(color: AppColors.textMuted),
                  ), // Separator
                  Text(
                    timeAgo,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Container(height: 1, color: AppColors.border),
              const SizedBox(height: 12),

              // Price and Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${post['salary']}',
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          // Apply action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: profileComplete
                              ? AppColors.accent
                              : Colors.grey[800],
                          disabledBackgroundColor: Colors.grey[800],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: profileComplete ? 2 : 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        child: Text(
                          'Apply',
                          style: TextStyle(
                            color: profileComplete
                                ? AppColors.black
                                : Colors.white38,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildApplicationsCards() {
    return Column(
      children: List.generate(myApplications.length, (index) {
        final app = myApplications[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildApplicationCard(app),
        );
      }),
    );
  }

  Widget _buildApplicationCard(Map<String, dynamic> app) {
    Color statusColor = AppColors.accent;
    IconData statusIcon = Icons.hourglass_bottom;

    if (app['status'] == 'In Review') {
      statusColor = Colors.blue;
      statusIcon = Icons.pending;
    } else if (app['status'] == 'Accepted') {
      statusColor = AppColors.success;
      statusIcon = Icons.check_circle;
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
                  Text(
                    app['title'],
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
                    app['school'],
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Applied ${app['appliedDate']}',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
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
                    app['status'],
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

  Widget _buildSavedItemsList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(3, (index) {
          final item = savedItems[index];
          return Padding(
            padding: EdgeInsets.only(
              right: index == savedItems.length - 1 ? 0 : 12,
            ),
            child: _buildSavedItemCard(item),
          );
        }),
      ),
    );
  }

  Widget _buildSavedItemCard(Map<String, String> item) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item['title']!,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item['jobs']!,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.accent,
                  size: 14,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatsSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Stats',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Applied', '8', AppColors.accent),
                Container(width: 1, height: 50, color: AppColors.border),
                _buildStatItem('In Review', '3', Colors.blue),
                Container(width: 1, height: 50, color: AppColors.border),
                _buildStatItem('Accepted', '2', AppColors.success),
              ],
            ),
          ],
        ),
      ),
    );
  }

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
