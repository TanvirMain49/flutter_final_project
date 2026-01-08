import 'package:_6th_sem_project/core/widgets/Skeleton/card_skeleton.dart';
import 'package:_6th_sem_project/core/widgets/search_field.dart';
import 'package:_6th_sem_project/core/widgets/student_home_cart.dart';
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
  final searchController = TextEditingController();
  String selectedSubject = "All";

  final List<String> subjects = [
    'All', 'General Mathematics', 'Higher Mathematics', 'Physics', 'Chemistry', 'Biology', 'English', 'Accounting', 'ICT',
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      _con.getTuition(() => _safeSetState()),
      _con.isCompleteTutorProfile(() => _safeSetState()),
    ]);
  }

  void _safeSetState() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchSection(),
          _buildFilterRow(),
          Expanded(child: _buildMainContent()),
        ],
      ),
    );
  }

  // --- UI Components ---

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryDark,
      elevation: 0,
      title: const Text(
        "Explore Tuitions",
        style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: _loadInitialData,
          icon: const Icon(Icons.refresh, color: AppColors.white),
        ),
      ],
    );
  }

  Widget _buildSearchSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: SearchField(
        controller: searchController,
        onChanged: (value) => _con.getTuition(_safeSetState, searchQuery: value, filterQuery: selectedSubject),
        onClear: () {
          searchController.clear();
          _con.getTuition(_safeSetState, searchQuery: '');
        },
      ),
    );
  }

  Widget _buildFilterRow() {
    return SizedBox(
      height: 50,
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
                if (selected) {
                  setState(() => selectedSubject = subjects[index]);
                  // Trigger search/filter by subject
                  _con.getTuition(_safeSetState, filterQuery: subjects[index] == "All" ? "" : subjects[index]);
                }
              },
              selectedColor: AppColors.accent,
              backgroundColor: AppColors.inputBackground,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.black : AppColors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              side: BorderSide.none,
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainContent() {
    // 1. Loading State
    if (_con.isLoading) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 4,
        itemBuilder: (_, __) => const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: CardSkeleton(),
        ),
      );
    }

    // Filter closed posts locally
    final filteredPosts = _con.postTuition
        .where((post) => post['status']?.toString().toLowerCase() != 'closed')
        .toList();

    // 2. Empty State
    if (filteredPosts.isEmpty) {
      return _buildEmptyState();
    }

    // 3. Data List
    return RefreshIndicator(
      onRefresh: _loadInitialData,
      color: AppColors.accent,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: filteredPosts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 4), // Small gap
        itemBuilder: (context, index) {
          final post = filteredPosts[index];
          return _buildTuitionCard(post);
        },
      ),
    );
  }

  Widget _buildTuitionCard(Map<String, dynamic> post) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: StudentHomeCard(
        title: post['post_title'] ?? 'Untitled Post',
        location: post['student_location'] ?? 'Location N/A',
        studyDays: post['preferred_day'] ?? 'Not specified',
        price: post['salary'] ?? 'Negotiable',
        status: post['status'],
        startTime: StudentUtils.formatToBDTime(post['start_time']),
        endTime: StudentUtils.formatToBDTime(post['end_time']),
        subject: post['subjects']?['name'] ?? 'General',
        studentName: post['users']?['full_name'] ?? 'Student',
        postTime: StudentUtils.formatTimeAgo(post['created_at']),
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
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: AppColors.textMuted.withOpacity(0.5)),
          const SizedBox(height: 16),
          const Text(
            "No tuition found matching your criteria",
            style: TextStyle(color: AppColors.textMuted, fontSize: 16),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}