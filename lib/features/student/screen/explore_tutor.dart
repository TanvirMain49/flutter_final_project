import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/Skeleton/explore_tutor_skeleton.dart';
import 'package:_6th_sem_project/core/widgets/search_field.dart';
import 'package:_6th_sem_project/core/widgets/tutor_card.dart';
import 'package:_6th_sem_project/features/student/controller/get_tuition_controller.dart';
import 'package:flutter/material.dart';


class ExploreTutorScreen extends StatefulWidget {
  final List<Map<String, dynamic>>? tutors;

  const ExploreTutorScreen({
    super.key,
    this.tutors,
  });

  @override
  State<ExploreTutorScreen> createState() => _ExploreTutorScreenState();
}

class _ExploreTutorScreenState extends State<ExploreTutorScreen> {
  final controller = GetTuitionController();
  final searchController = TextEditingController();
  List<Map<String, dynamic>> filteredTutors = [];
  String selectedFilter = 'All';

  final List<String> filterOptions = [
    'All',
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
    'English',
    'ICT',
  ];

  @override
  void initState() {
    super.initState();
    controller.getAllTuition((){
      if (mounted) setState(() {});
    });
  }

  // void _filterTutors(String query) {
  //   setState(() {
  //     final tutorsToUse = widget.tutors ?? dummyTutorData;
  //     if (query.isEmpty && selectedFilter == 'All') {
  //       filteredTutors = tutorsToUse
  //           .where((tutor) =>
  //       tutor['role']?.toString().toLowerCase() == 'tutor' &&
  //           (tutor['tutor_skills'] as List?)?.isNotEmpty == true)
  //           .toList();
  //     } else {
  //       filteredTutors = tutorsToUse.where((tutor) {
  //         final isTutor =
  //             tutor['role']?.toString().toLowerCase() == 'tutor' &&
  //                 (tutor['tutor_skills'] as List?)?.isNotEmpty == true;
  //
  //         if (!isTutor) return false;
  //
  //         final name = tutor['full_name']?.toString().toLowerCase() ?? '';
  //         final skills = tutor['tutor_skills'] as List? ?? [];
  //
  //         final matchesQuery = query.isEmpty ||
  //             name.contains(query.toLowerCase()) ||
  //             skills.any((skill) =>
  //                 skill['subjects']['name']
  //                     .toString()
  //                     .toLowerCase()
  //                     .contains(query.toLowerCase()));
  //
  //         final matchesFilter = selectedFilter == 'All' ||
  //             skills.any((skill) =>
  //                 skill['subjects']['name']
  //                     .toString()
  //                     .toLowerCase()
  //                     .contains(selectedFilter.toLowerCase()));
  //
  //         return matchesQuery && matchesFilter;
  //       }).toList();
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        title: const Text(
          'Find Tutors',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchField(
              controller: searchController,
              onChanged: (value) {
                controller.getAllTuition(
                      () => setState(() {}),
                  searchQuery: value,
                  subject: selectedFilter == 'All' ? null : selectedFilter, // Keep existing filter
                );
              },
              onClear: () {
                searchController.clear();
               controller.getAllTuition((){
                  if (mounted) setState(() {});
                }, searchQuery: '');
              },
            ),
          ),
          //
          // // Filter Chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filterOptions.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedFilter == filterOptions[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(filterOptions[index]),
                      selected: isSelected,
                      onSelected: (bool selected) {
                        if (selected) {
                          setState(() {
                            selectedFilter = filterOptions[index];
                          });
                          // Pass BOTH filters to the controller
                          controller.getAllTuition(
                                () => setState(() {}),
                            subject: selectedFilter == 'All' ? null : selectedFilter,
                            searchQuery: searchController.text, // Keep existing search text
                          );
                        }
                      },
                      selectedColor: AppColors.accent,
                      backgroundColor: AppColors.secondary,
                      labelStyle: TextStyle(
                        color:
                        isSelected ? AppColors.black : AppColors.white,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      side: BorderSide.none,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Tutor List
          Expanded(
            child: controller.isAllTutorLoading ?
            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 5, // number of skeleton cards
              itemBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: ExploreTutorSkeleton(),
                );
              },
            ) :
            controller.tutors.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_search,
                    size: 64,
                    color: AppColors.textMuted.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tutors found',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Try adjusting your filters or search query',
                    style: TextStyle(
                      color: AppColors.textMuted.withOpacity(0.7),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.tutors.length,
              itemBuilder: (context, index) {
                final tutor = controller.tutors[index];
                final tutorSkills = tutor['tutor_skills'] as List? ?? [];
                final firstSkill = tutorSkills.isNotEmpty
                    ? tutorSkills[0] as Map<String, dynamic>
                    : null;
                if (firstSkill == null) {
                  return const SizedBox.shrink();
                }

                final subjectMap = firstSkill['subjects'] as Map<String, dynamic>?;

                debugPrint("Tutor: $tutor");

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TutorCard(
                    name: tutor['full_name'] ?? 'Unknown',
                    subject: subjectMap?['name'] ?? 'N/A',
                    price: firstSkill['salary'] ?? 'N/A',
                    gender: tutor['gender'],
                    experience:
                    '${firstSkill['experience_years'] ?? 0} yrs',
                    education: firstSkill['education_at'] ?? 'N/A',
                  ),
                );
              },
            ),
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


