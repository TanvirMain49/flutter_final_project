import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/gradient_background.dart';
import 'package:_6th_sem_project/core/widgets/search_field.dart';
import 'package:_6th_sem_project/core/widgets/student_home_cart.dart';
import 'package:_6th_sem_project/core/widgets/tutor_home_card.dart';
import 'package:_6th_sem_project/features/auth/screen/login_screen.dart';
import 'package:_6th_sem_project/features/student/controller/get_tuition_controller.dart';
import 'package:_6th_sem_project/features/student/screen/post_tuition.dart';
import 'package:_6th_sem_project/features/student/screen/tuition_details.dart';
import 'package:_6th_sem_project/utils/Student.utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

final List<Map<String, dynamic>> tutorsData = [
  {
    'name': 'Sarah K.',
    'subject': 'Mathematics',
    'price': 25,
    'rating': 4.9,
    'imageUrl': 'https://randomuser.me/api/portraits/women/44.jpg',
  },
  {
    'name': 'John D.',
    'subject': 'Physics',
    'price': 30,
    'rating': 4.7,
    'imageUrl': 'https://randomuser.me/api/portraits/men/34.jpg',
  },
  {
    'name': 'Emma W.',
    'subject': 'Chemistry',
    'price': 28,
    'rating': 4.8,
    'imageUrl': 'https://randomuser.me/api/portraits/women/55.jpg',
  },
  {
    'name': 'Mike B.',
    'subject': 'English',
    'price': 20,
    'rating': 4.6,
    'imageUrl': 'https://randomuser.me/api/portraits/men/45.jpg',
  },
  {
    'name': 'Lucy A.',
    'subject': 'Biology',
    'price': 27,
    'rating': 4.9,
    'imageUrl': 'https://randomuser.me/api/portraits/women/66.jpg',
  },
];

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
    controller.getTuition(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }

    final userEmail = user?.email ?? "Guest User";

    final displayName = userEmail.contains('@')
        ? userEmail.split('@')[0]
        : userEmail;

    return Scaffold(
      body: GradientBackground(
        child: RefreshIndicator(
          // This RefreshIndicator allows the user to pull down to refresh the list manually.
          // The loading spinner will disappear once the API call to fetch tuition posts is complete.

          // Color and backgroundColors for the loader design or color
          color: AppColors.accent,
          backgroundColor: AppColors.primaryDark,

          // this onRefresh tell what to do after refresh
          onRefresh: () async {
            // This allows the user to pull down to refresh manually
            await controller.getTuition(() {
              if (mounted) setState(() {});
            });
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 14),
            physics:
                const AlwaysScrollableScrollPhysics(), //// Important for RefreshIndicator
            child: Column(
              children: [
                studentTopBar(displayName),
                const SizedBox(height: 20),
                SearchField(),
                const SizedBox(height: 20),
                findTutorCard(context),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: simpleCard(
                        icon: Icons.group,
                        title: 'Browse Tutors',
                        subtitle: 'Explore profiles',
                        iconColor: Color(0xFFDBEAFE),
                        iconBgColor: Color(0xFF3658C5),
                      ),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: simpleCard(
                        icon: Icons.post_add,
                        title: 'My Posts',
                        subtitle: 'View active requests',
                        iconColor: Color(0xFFDBEAFE),
                        iconBgColor: Colors.purple,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
                recentTutor(),
                const SizedBox(height: 38),
                get20Off(),
                const SizedBox(height: 32),
                recentStudentReq(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Find a Tutor card
  Container findTutorCard(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3F5E4E), Color(0xFF0E1F18)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Find a Tutor",
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          Text(
            "Tell us what you need and get matched with\nqualified tutors in minutes.",
            style: TextStyle(
              color: AppColors.white60,
              fontSize: 13.5,
              height: 1.5,
            ),
          ),

          const Spacer(),

          Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PostTuitionScreen(),
                    ),
                  );
                  controller.getTuition(() {
                    if (mounted) setState(() {});
                  });
                },
                child: const Row(
                  children: [
                    Text(
                      "Post Request",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_forward, size: 18, color: Colors.black),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //Student top Navbar
  Center studentTopBar(String displayName) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //   header part
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.supervised_user_circle_rounded,
                  size: 33,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),

              /// User and welcome message
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Good morning,",
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    displayName,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white60,
                  minimumSize: Size(35, 35),
                  padding: EdgeInsets.zero,
                  shape: const CircleBorder(),
                ),
                onPressed: () {},
                child: Icon(Icons.notifications, color: Colors.white, size: 23),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //Browse Tutor and Post simple card
  Widget simpleCard({
    required String subtitle,
    Color iconColor = Colors.black12,
    required Color iconBgColor,
    required IconData icon,
    required String title,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // Recent Tutor
  Column recentTutor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recent Tutor",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            TextButton(
              onPressed: () {},
              child: Text(
                "See all",
                style: TextStyle(color: AppColors.accent, fontSize: 14),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: tutorsData.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final tutor = tutorsData[index];
              return TutorHomeCard(
                name: tutor['name'],
                subject: tutor['subject'],
                price: (tutor['price'] as num).toDouble(),
                rating: tutor['rating'],
                imageUrl: tutor['imageUrl'],
              );
            },
          ),
        ),
      ],
    );
  }

  //Tuition card
  Widget recentStudentReq() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Student Requests",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () {},
              child: Text(
                "View all",
                style: TextStyle(color: AppColors.accent, fontSize: 14),
              ),
            ),
          ],
        ),

        const SizedBox(height: 22),

        controller.isLoading
            ? const CircularProgressIndicator() // if loader is active show the loading animation
            : controller.tuitionData == null ||
                  controller
                      .tuitionData!
                      .isEmpty // cheek if data is empty or not
            ? const Center(
                child: Text(
                  "No Tuition Posts Available",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ) // if data is empty then show this message
            : ListView.separated(
                // and if data not empty show the data
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: math.min(controller.tuitionData!.length, 3),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final tuition = controller.tuitionData![index];
                  final timeAgo = StudentUtils.formatTimeAgo(
                    tuition['created_at'],
                  );
                  final startTime = StudentUtils.formatToBDTime(
                    tuition['start_time'],
                  );
                  final endTime = StudentUtils.formatToBDTime(
                    tuition['end_time'],
                  );

                  return StudentHomeCard(
                    title: tuition['post_title'],
                    location: tuition['student_location'],
                    studyDays: tuition['preferred_day'],
                    startTime: startTime,
                    endTime: endTime,
                    status: tuition['status'],
                    subject: tuition['subjects']['name'],
                    price: (tuition['salary']),
                    studentName:
                        tuition['users']?['full_name'] ?? 'Unknown Student',
                    postTime: timeAgo,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TuitionDetails(
                            tuitionId: tuition['id'].toString(),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
      ],
    );
  }

  // Get 20% off
  Container get20Off() {
    return Container(
      width: double.infinity,
      height: 130,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(20),
        border: BorderDirectional(
          bottom: BorderSide(color: AppColors.white60, width: 1),
          top: BorderSide(color: AppColors.white60, width: 1),
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Get 20% off",
            style: TextStyle(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "on your first 3 session with\nany new tutor's class",
                style: TextStyle(color: AppColors.white60, fontSize: 14),
              ),
              Spacer(),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                onPressed: () {},
                child: Text("Get the offer"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
