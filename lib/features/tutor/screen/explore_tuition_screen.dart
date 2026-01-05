import 'package:_6th_sem_project/core/widgets/Skeleton/card_skeleton.dart';
import 'package:_6th_sem_project/core/widgets/search_field.dart';
import 'package:_6th_sem_project/core/widgets/student_home_cart.dart';
import 'package:_6th_sem_project/features/student/controller/get_tuition_controller.dart';
import 'package:_6th_sem_project/features/student/screen/tuition_details.dart';
import 'package:_6th_sem_project/utils/Student.utils.dart';
import 'package:flutter/material.dart';
import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/features/tutor/controller/tutor_data_controller.dart';


class ExploreTuitionScreen extends StatefulWidget {
  const ExploreTuitionScreen({super.key});

  @override
  State<ExploreTuitionScreen> createState() => _ExploreTuitionScreenState();
}

class _ExploreTuitionScreenState extends State<ExploreTuitionScreen> {
  final _con = TutorDataController();
  String selectedSubject = "All";
  final searchController = TextEditingController();

  final List<String> subjects = [
    "All",
    "Mathematics",
    "Physics",
    "English",
    "Chemistry",
    "Biology",
    "ICT",
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    // Load posts and sync IDs globally once
    await Future.wait([
      _con.getTuition(() => setState(() {})),
      _con.syncSavedPosts(),
      _con.isCompleteTutorProfile(() => setState(() {})),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        title: const Text(
          "Explore Tuitions",
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () => _loadInitialData(),
            icon: const Icon(Icons.refresh, color: AppColors.accent),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SearchField(
              controller: searchController,
              onChanged: (value) {
                  _con.getTuition(() => setState(() {}),  searchQuery: value);
              },
              onClear: () {
                searchController.clear();
                _con.getTuition(
                      () { if (mounted) setState(() {}); },
                  searchQuery: '',
                );
              },
            )
          ),

          const SizedBox(height: 10),

          // 1. Horizontal Scroll Subjects Filter
          _buildFilterRow(),

          // 2. Main Content (List of Cards)
          Expanded(
            child: _con.isLoading
                ? Column(
                    children: List.generate(2, (index) => const CardSkeleton()),
                  )
                : _con.postTuition.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    onRefresh: _loadInitialData,
                    color: AppColors.accent,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _con.postTuition.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final post = _con.postTuition[index];
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
                                    tuitionId: post['id'].toString(),
                                    isProfileComplete: _con.isCompleteProfile,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          final isSelected = selectedSubject == subjects[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(subjects[index]),
              selected: isSelected,
              onSelected: (bool selected) {
                setState(() {
                  selectedSubject = subjects[index];
                  // You can add filtering logic here: _con.filterBySubject(selectedSubject);
                });
              },
              selectedColor: AppColors.accent,
              backgroundColor: AppColors.inputBackground,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.black : AppColors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              side: BorderSide.none,
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: AppColors.textMuted),
          const SizedBox(height: 16),
          const Text(
            "No tuitions available right now",
            style: TextStyle(color: AppColors.textMuted, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
