import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/Skeleton/my_tuition_post_skeleton.dart';
import 'package:_6th_sem_project/core/widgets/Skeleton/skeleton_box.dart';
import 'package:_6th_sem_project/core/widgets/gradient_background.dart';
import 'package:_6th_sem_project/core/widgets/primary_button.dart';
import 'package:_6th_sem_project/features/profile/controller/profile_data_controller.dart';
import 'package:_6th_sem_project/features/student/screen/post_tuition.dart';
import 'package:_6th_sem_project/features/student/screen/tuition_details.dart';
import 'package:_6th_sem_project/features/student/screen/view_applications.dart';
import 'package:_6th_sem_project/utils/Student.utils.dart';
import 'package:flutter/material.dart';

class MyTuitionPosts extends StatefulWidget {
  const MyTuitionPosts({super.key});

  @override
  State<MyTuitionPosts> createState() => _MyTuitionPostsState();
}

class _MyTuitionPostsState extends State<MyTuitionPosts> {
  final _dataCon = ProfileDataController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dataCon.fetchMyTuitionPosts(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalPost = _dataCon.myTuitionPosts.length;
    return RefreshIndicator(
      onRefresh: () async {
        await _dataCon.fetchMyTuitionPosts(() {
          if (mounted) setState(() {});
        });
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          title: const Text(
            'My Tuition Posts',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: GradientBackground(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Overview Section
                  const Text(
                    'Overview',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      // Total Posts Card
                      Expanded(
                        child: _dataCon.isLoading
                            ? const SkeletonBox(
                                height: 110,
                                width: double.infinity,
                              ) // Responsive width
                            : Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.description_outlined,
                                          color: AppColors.accent,
                                          size: 22,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Total Posts',
                                          style: TextStyle(
                                            color: AppColors.textMuted,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      _dataCon.isLoading
                                          ? 'Loading...'
                                          : "$totalPost",
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: _dataCon.isLoading ? 16 : 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                      const SizedBox(width: 12),
                      // Hired Card
                      Expanded(
                        child: _dataCon.isLoading
                            ? const SkeletonBox(
                                height: 110,
                                width: double.infinity,
                              ) // Responsive width
                            : Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: AppColors.success,
                                          size: 22,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Hired',
                                          style: TextStyle(
                                            color: AppColors.textMuted,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      _dataCon.isLoading ? 'Loading...' : '2',
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: _dataCon.isLoading ? 16 : 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Posts List
                  Text(
                    _dataCon.isLoading ? '' : 'Posts',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // List map--------------------------
                  _dataCon.isLoading
                      ? const MyTuitionPostsSkeleton()
                      : _dataCon.myTuitionPosts.isEmpty
                      ? const Center(
                          child: Text(
                            'No Tuition Posts Available',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _dataCon.myTuitionPosts.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final tuition = _dataCon.myTuitionPosts[index];
                            debugPrint("tuition: $tuition");
                            // TODO: time ago
                            final timeAgo = StudentUtils.formatTimeAgo(
                              tuition!['created_at'],
                            );
                            final startTime = StudentUtils.formatToBDTime(
                              tuition['start_time'],
                            );
                            final endTime = StudentUtils.formatToBDTime(
                              tuition['end_time'],
                            );
                            return _buildPostCard(
                              status: tuition['status'] ?? 'Active',
                              statusColor: _getStatusColor(tuition['status']),
                              title: tuition['post_title'],
                              subject: tuition['subjects']['name'],
                              days: tuition['preferred_day'],
                              rate: tuition['salary'],
                              startTime: startTime,
                              endTime: endTime,
                              onApplicantsPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewApplicationScreen(
                                      postId: tuition['id'],
                                    ),
                                  ),
                                );
                              },
                              onDetailsPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TuitionDetails(
                                      tuitionId: tuition['id'],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.accent,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PostTuitionScreen(),
              ),
            );
          },
          child: const Icon(Icons.add, color: AppColors.white),
        ),
      ),
    );
  }

  Widget _buildPostCard({
    required String status,
    required Color statusColor,
    required String title,
    required String subject,
    required String days,
    required String rate,
    required String startTime,
    required String endTime,
    VoidCallback? onApplicantsPressed,
    VoidCallback? onDetailsPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TOP ROW: Status Badge and Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Status Badge (Active/Inactive/Closed)
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      status == 'active' ? 'Active' : 'Closed',
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              // Price Tag
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  const Text(
                    '৳ ',
                    style: TextStyle(color: AppColors.accent, fontSize: 16),
                  ),
                  Text(
                    rate,
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    ' / mth',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // TITLE
          Text(
            title,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),
          const Divider(color: AppColors.border, thickness: 1),
          const SizedBox(height: 8),

          // DETAILS: Subject
          Row(
            children: [
              const Icon(
                Icons.book_rounded,
                color: AppColors.textMuted,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                subject,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Preferred Days
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                color: AppColors.textMuted,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                days,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Time Duration
          Row(
            children: [
              const Icon(
                Icons.watch_later,
                color: AppColors.textMuted,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                "$startTime - $endTime",
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ACTION BUTTONS
          Row(
            children: [
              // 1. View Details (Outlined Style)
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AppColors.accent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: onDetailsPressed,
                  child: const Text(
                    "Details",
                    style: TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // 2. View Applicants (PrimaryButton)
              Expanded(
                child: PrimaryButton(
                  text: "Applicants",
                  onPressed: onApplicantsPressed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper function to get status color based on status string
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return const Color(0xFF4CAF84); // Green - Success
      case 'pending':
        return Colors.amber; // Amber/Yellow
      case 'closed':
        return Colors.red; // Red
      case 'inactive':
        return Colors.grey; // Grey
      default:
        return AppColors.textMuted;
    }
  }
}
