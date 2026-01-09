import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/Skeleton/card_skeleton.dart';
import 'package:_6th_sem_project/core/widgets/student_home_cart.dart';
import 'package:_6th_sem_project/features/profile/controller/profile_data_controller.dart';
import 'package:_6th_sem_project/features/student/screen/tuition_details.dart';
import 'package:_6th_sem_project/features/tutor/controller/tutor_data_controller.dart';
import 'package:_6th_sem_project/utils/Student.utils.dart';
import 'package:flutter/material.dart';

class SaveTuitionScreen extends StatefulWidget {
  const SaveTuitionScreen({super.key});

  @override
  State<SaveTuitionScreen> createState() => _SaveTuitionScreenState();
}

class _SaveTuitionScreenState extends State<SaveTuitionScreen> {
  final _con = TutorDataController();
  final _con2 = ProfileDataController();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    if (!mounted) return;

    try {
      // 1. Run both requests.
      // Use Future.wait if you want them to run at the same time for speed.
      await Future.wait([
        _con.getSavedPosts(() {}),
        _con2.fetchUserProfile(() {}),
        _con.isCompleteTutorProfile(() {}),
      ]);

      // 2. Update the UI once after both are done
      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredPosts = _con.savedPosts
        .where((post) => post['status'] != 'closed')
        .toList();

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        title: const Text(
          'Saved Tuition',
          style: TextStyle(color: AppColors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: AppColors.white),
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: _con.isFetchSavePost
          ? ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: 3,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) => const CardSkeleton(),
            )
          : filteredPosts.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: _loadInitialData,
              color: AppColors.primaryDark,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: filteredPosts.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final post = filteredPosts[index];
                  final savedPost = post['tuition_post'];
                  final timeAgo = StudentUtils.formatTimeAgo(
                    savedPost['created_at'],
                  );
                  final startTime = StudentUtils.formatToBDTime(
                    savedPost['start_time'],
                  );
                  final endTime = StudentUtils.formatToBDTime(
                    savedPost['end_time'],
                  );

                  return StudentHomeCard(
                    title: savedPost['post_title'] ?? 'N/A',
                    location: savedPost['student_location'] ?? 'N/A',
                    studyDays: savedPost['preferred_day'] ?? 'N/A',
                    price: savedPost['salary'] ?? 'N/A',
                    status: savedPost['status'] ?? 'N/A',
                    startTime: startTime,
                    endTime: endTime,
                    subject: savedPost['subjects']?['name'] ?? 'N/A',
                    studentName: savedPost['users']?['full_name'] ?? 'N/A',
                    postTime: timeAgo,
                    onTap: () {
                      if (savedPost['id'] != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TuitionDetails(
                              tuitionId: savedPost['id'].toString(),
                              isProfileComplete: _con.isCompleteProfile,
                            ),
                          ),
                        ).then((_) => _loadInitialData());
                      }
                    },
                  );
                },
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      decoration: BoxDecoration(color: AppColors.primaryDark),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_border, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No Saved Tuitions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Save tuition posts to view them here',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to home or explore screen
                Navigator.pop(context);
              },
              icon: const Icon(Icons.explore, color: AppColors.black),
              label: const Text(
                'Explore Tuition',
                style: TextStyle(color: AppColors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
