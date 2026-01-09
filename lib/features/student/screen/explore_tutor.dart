import 'package:_6th_sem_project/features/student/screen/student_home.dart';
import 'package:_6th_sem_project/features/tutor/screen/tutor_details.dart';
import 'package:flutter/material.dart';
import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/Skeleton/explore_tutor_skeleton.dart';
import 'package:_6th_sem_project/core/widgets/search_field.dart';
import 'package:_6th_sem_project/core/widgets/tutor_card.dart';
import 'package:_6th_sem_project/features/student/controller/get_tuition_controller.dart';

class ExploreTutorScreen extends StatefulWidget {
  final List<Map<String, dynamic>>? tutors;
  const ExploreTutorScreen({super.key, this.tutors});

  @override
  State<ExploreTutorScreen> createState() => _ExploreTutorScreenState();
}

class _ExploreTutorScreenState extends State<ExploreTutorScreen> {
  final controller = GetTuitionController();
  final searchController = TextEditingController();

  String selectedFilter = 'All';
  final List<String> filterOptions = [
    'All',
    'General Mathematics',
    'Higher Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
    'English',
    'Accounting',
    'ICT',
  ];

  @override
  void initState() {
    super.initState();
    _fetchTutors();
  }

  void _fetchTutors() {
    controller.getAllTuition(
      () {
        if (mounted) setState(() {});
      },
      searchQuery: searchController.text,
      subject: selectedFilter == 'All' ? null : selectedFilter,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterChips(),
          const SizedBox(height: 16),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  // --- UI Sections ---

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryDark,
      elevation: 0,
      title: const Text(
        'Find Tutors',
        style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SearchField(
        controller: searchController,
        onChanged: (_) => _fetchTutors(),
        onClear: () {
          searchController.clear();
          _fetchTutors();
        },
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filterOptions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filterOptions[index];
          final isSelected = selectedFilter == filter;
          return ChoiceChip(
            label: Text(filter),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                setState(() => selectedFilter = filter);
                _fetchTutors();
              }
            },
            selectedColor: AppColors.accent,
            backgroundColor: AppColors.secondary,
            labelStyle: TextStyle(
              color: isSelected ? AppColors.black : AppColors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            side: BorderSide.none,
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    if (controller.isAllTutorLoading) return _buildLoadingState();
    if (controller.tutors.isEmpty) return _buildEmptyState();
    return _buildTutorList();
  }

  // --- Helper States ---

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 5,
      itemBuilder: (_, __) => const Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: ExploreTutorSkeleton(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_search,
            size: 64,
            color: AppColors.textMuted.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No tutors found',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Try adjusting your filters',
            style: TextStyle(
              color: AppColors.textMuted.withOpacity(0.7),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: controller.tutors.length,
      itemBuilder: (context, index) {
        final tutor = controller.tutors[index];
        final skill = (tutor['tutor_skills'] as List?)?.firstOrNull;

        if (skill == null) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TutorCard(
            name: tutor['full_name'] ?? 'Unknown',
            subject: skill['subjects']?['name'] ?? 'N/A',
            price: skill['salary'] ?? 'N/A',
            gender: tutor['gender'],
            experience: '${skill['experience_years'] ?? 0} yrs',
            education: skill['education_at'] ?? 'N/A',
            onpressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TutorDetails(tutorId: tutor['id']),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
