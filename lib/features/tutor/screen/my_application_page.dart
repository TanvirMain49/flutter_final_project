import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/Skeleton/application_card_skeleton.dart';
import 'package:_6th_sem_project/core/widgets/gradient_background.dart';
import 'package:_6th_sem_project/core/widgets/primary_button.dart';
import 'package:_6th_sem_project/features/student/screen/tuition_details.dart';
import 'package:_6th_sem_project/features/tutor/controller/tutor_data_controller.dart';
import 'package:_6th_sem_project/utils/Student.utils.dart';
import 'package:flutter/material.dart';

class MyApplicationsPage extends StatefulWidget {
  const MyApplicationsPage({super.key});

  @override
  State<MyApplicationsPage> createState() => _MyApplicationsPageState();
}

class _MyApplicationsPageState extends State<MyApplicationsPage> {
  final _con = TutorDataController();
  String selectedTab = 'All';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _con.getTutorApplications(
      status: 'All',
      onUpdate: () {
        if (mounted) setState(() {});
      },
    );
  }

  // Helper to get color based on status string
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return AppColors.success;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.redAccent;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> allApplications = _con.tutorApplications;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
        ),
        title: const Text(
          'My Applications',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: GradientBackground(
        child: Column(
          children: [
            // Tab Navigation
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTab('All', selectedTab == 'All'),
                  _buildTab('Accepted', selectedTab == 'Accepted'),
                  _buildTab('Pending', selectedTab == 'Pending'),
                  _buildTab('Rejected', selectedTab == 'Rejected'),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Applications List
            Expanded(
              child: (_con.isApplications && allApplications.isEmpty)
                  ? const ApplicationsLoadingList()
                  : allApplications.isEmpty
                  ? const Center(
                      child: Text(
                        "No applications found",
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 10,
                      ),
                      itemCount: allApplications.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final app = allApplications[index];
                        final post = app['tuition_post'] ?? {};

                        // Formatting the date from "2026-01-04T08:36..." to a readable format
                        DateTime date = DateTime.parse(app['created_at']);
                        String formattedDate = StudentUtils.formatToMMDDYYYY(
                          date.toString(),
                        );
                        debugPrint("Tuition post Id: " + post['id']);

                        return _buildApplicationCard(
                          tuitionId: post['id'],
                          title: post['subject_id']?['name'] ?? 'N/A',
                          grade: post['grade'] ?? 'N/A',
                          location: post['student_location'] ?? 'N/A',
                          price: '৳${post['salary'] ?? '0'}/month',
                          appliedDate: formattedDate,
                          status: app['status'].toString().toUpperCase(),
                          statusColor: _getStatusColor(app['status']),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        if (selectedTab == label) return;
        setState(() {
          selectedTab = label;
        });
        _con.getTutorApplications(
          status: label,
          onUpdate: () {
            if (mounted) setState(() {});
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.white : AppColors.textMuted,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildApplicationCard({
    required String tuitionId,
    required String title,
    required String grade,
    required String location,
    required String price,
    required String appliedDate,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(
        20,
      ), // Increased padding for a more spacious feel
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 20, // Increased font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12, // Slightly larger
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Grade
          Text(
            grade,
            style: const TextStyle(fontSize: 15, color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),
          // Location and Price Row
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 18,
                color: AppColors.accent,
              ),
              const SizedBox(width: 6),
              Text(
                location,
                style: const TextStyle(fontSize: 14, color: AppColors.white60),
              ),
              const SizedBox(width: 20),
              const Icon(
                Icons.monetization_on_outlined,
                size: 18,
                color: AppColors.accent,
              ),
              const SizedBox(width: 6),
              Text(
                price,
                style: const TextStyle(fontSize: 14, color: AppColors.white60),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Applied Date
          Text(
            "Applied on: $appliedDate",
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textMuted,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 20),
          // Unified Primary Button
          PrimaryButton(
            text: 'View Details',
            icon: Icons.visibility_outlined,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TuitionDetails(tuitionId: tuitionId),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
