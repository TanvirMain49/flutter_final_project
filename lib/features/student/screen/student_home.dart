import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/gradient_background.dart';
import 'package:_6th_sem_project/core/widgets/search_field.dart';
import 'package:_6th_sem_project/core/widgets/student_home_cart.dart';
import 'package:_6th_sem_project/core/widgets/tutor_home_card.dart';
import 'package:_6th_sem_project/features/auth/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

final List<Map<String, dynamic>> tuitionData = [
  {
    'title': "Need Math Tutor",
    'location': "Dhanmondi, Dhaka",
    'studyDays': ["Sun", "Tue", "Thu"],
    'studyType': "offline",
    'subject': "Mathematics",
    'price': 25,
    'imageUrl': 'https://randomuser.me/api/portraits/women/44.jpg',
    'rating': 4.9,
  },
  {
    'title': "Need Physics Tutor",
    'location': "Gulshan, Dhaka",
    'studyDays': ["Mon", "Wed", "Fri"],
    'studyType': "online",
    'subject': "Physics",
    'price': 30,
    'imageUrl': 'https://randomuser.me/api/portraits/men/34.jpg',
    'rating': 4.7,
  },
  {
    'title': "Need Chemistry Tutor",
    'location': "Banani, Dhaka",
    'studyDays': ["Tue", "Thu"],
    'studyType': "offline",
    'subject': "Chemistry",
    'price': 28,
    'imageUrl': 'https://randomuser.me/api/portraits/women/55.jpg',
    'rating': 4.8,
  },
  {
    'title': "Need English Tutor",
    'location': "Dhanmondi, Dhaka",
    'studyDays': ["Sun", "Wed", "Fri"],
    'studyType': "online",
    'subject': "English",
    'price': 20,
    'imageUrl': 'https://randomuser.me/api/portraits/men/45.jpg',
    'rating': 4.6,
  },
  {
    'title': "Need Biology Tutor",
    'location': "Uttara, Dhaka",
    'studyDays': ["Mon", "Thu"],
    'studyType': "offline",
    'subject': "Biology",
    'price': 27,
    'imageUrl': 'https://randomuser.me/api/portraits/women/66.jpg',
    'rating': 4.9,
  },
];

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

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

    return GradientBackground(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          children: [
            studentTopBar(displayName),
            const SizedBox(height: 20),
            SearchField(),
            const SizedBox(height: 20),
            findTutorCard(),
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
    );
  }

  // Find a Tutor card
  Container findTutorCard() {
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
                onPressed: () {},
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
          decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
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
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
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
              padding: EdgeInsets.zero, // Removes internal button padding
              tapTargetSize:
                  MaterialTapTargetSize.shrinkWrap, // Shrinks the hit area
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

      ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: tuitionData.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final tuition = tuitionData[index];
          return StudentHomeCard(
            title: tuition['title'],
            location: tuition['location'],
            studyDays: tuition['studyDays'],
            studyType: tuition['studyType'],
            subject: tuition['subject'],
            price: (tuition['price'] as num).toDouble(),
            onTap: () {},
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
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(20),
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

        const SizedBox(height: 8,),

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "on your first 3 session with\nany new tutor's class",
              style: TextStyle(
                color: AppColors.white60,
                fontSize: 14,
              ),
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
                onPressed: (){},
                child: Text("Get the offer"))

          ],
        )
      ],
    ),
  );
}
