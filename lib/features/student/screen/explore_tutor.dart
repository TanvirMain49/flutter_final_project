import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/search_field.dart';
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
            child: controller.tutors.isEmpty
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
                final tutorSkills =
                    tutor['tutor_skills'] as List? ?? [];
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

// Tutor Card Widget
class TutorCard extends StatelessWidget {
  final String name;
  final String subject;
  final String price;
  final String? gender;
  final String experience;
  final String education;

  const TutorCard({
    super.key,
    required this.name,
    required this.subject,
    required this.price,
    this.gender,
    required this.experience,
    required this.education,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Avatar and Name
          Row(
            children: [
              // Avatar with Gender Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.accent.withOpacity(0.2), // Themed background
                      AppColors.accent.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: AppColors.accent.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.school_rounded, // Standard Tutor/Education icon
                    size: 30,
                    color: AppColors.accent,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.school,
                          size: 14,
                          color: AppColors.accent,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            subject,
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Details Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildDetailChip(
                  Icons.trending_up,
                  experience,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDetailChip(
                  Icons.business,
                  education,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildPriceChip(price),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.accent),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceChip(String price) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.attach_money, size: 12, color: AppColors.accent),
          const SizedBox(width: 2),
          Expanded(
            child: Text(
              '$price/hr',
              style: const TextStyle(
                color: AppColors.accent,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}