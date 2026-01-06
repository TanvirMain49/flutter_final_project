import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/gradient_background.dart';
import 'package:_6th_sem_project/core/widgets/tutor_card.dart';
import 'package:_6th_sem_project/core/widgets/Skeleton/explore_tutor_skeleton.dart';
import 'package:_6th_sem_project/features/student/controller/get_tuition_controller.dart';
import 'package:_6th_sem_project/features/student/screen/post_tuition.dart';
import 'package:_6th_sem_project/features/auth/screen/login_screen.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  final controller = GetTuitionController();
  final user = Supabase.instance.client.auth.currentUser;

  @override
  void initState() {
    super.initState();
    // Use a post-frame callback for navigation logic
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (user == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });

    // all fetched data
    _refreshData();
  }

  void _refreshData() {
    controller.getTuition(() => ifMountedSetState());
    controller.getAllTuition(() => ifMountedSetState());
  }

  void ifMountedSetState() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final displayName = user?.email?.split('@')[0] ?? "Guest User";

    return Scaffold(
      body: GradientBackground(
        child: RefreshIndicator(
          color: AppColors.accent,
          onRefresh: () async => _refreshData(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBar(displayName),
                const SizedBox(height: 24),
                _buildPromotionCard(context),
                const SizedBox(height: 32),
                _buildRecentTutorsHeader(),
                const SizedBox(height: 16),
                _buildTutorsList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- UI Components ---

  Widget _buildTopBar(String name) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Row(
        children: [
          Container(
            width: 45, height: 45,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Good morning,", style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              Text(name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications, color: Colors.white),
            style: IconButton.styleFrom(backgroundColor: Colors.white10),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF3F5E4E), Color(0xFF0E1F18)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Find a Tutor", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text("Get matched with qualified tutors in minutes.", style: TextStyle(color: Colors.white60, fontSize: 14)),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PostTuitionScreen())),
            child: const Text("Post Request", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTutorsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Available Tutors", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        TextButton(
          onPressed: () {},
          child: const Text("View all", style: TextStyle(color: AppColors.accent)),
        ),
      ],
    );
  }

  Widget _buildTutorsList() {
    if (controller.isAllTutorLoading) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (_, __) => const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: ExploreTutorSkeleton(),
        ),
      );
    }

    if (controller.tutors.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 40),
          child: Text("No Tutors Available", style: TextStyle(color: Colors.white70)),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: controller.tutors.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final tutor = controller.tutors[index];
        final skill = (tutor['tutor_skills'] as List?)?.firstOrNull;
        if (skill == null) return const SizedBox.shrink();

        return TutorCard(
          name: tutor['full_name'] ?? 'Unknown',
          subject: skill['subjects']?['name'] ?? 'N/A',
          price: skill['salary'] ?? 'N/A',
          gender: tutor['gender'],
          experience: '${skill['experience_years'] ?? 0} yrs',
          education: skill['education_at'] ?? 'N/A',
        );
      },
    );
  }
}