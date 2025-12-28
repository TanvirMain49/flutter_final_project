import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/services/api_service.dart';
import 'package:_6th_sem_project/core/widgets/gradient_background.dart';
import 'package:_6th_sem_project/features/student/controller/get_tuition_controller.dart';
import 'package:_6th_sem_project/features/student/screen/post_tuition.dart';
import 'package:_6th_sem_project/features/student/screen/student_home.dart';
import 'package:_6th_sem_project/features/tutor/screen/tutor_home.dart';
import 'package:flutter/material.dart';

class AppMainScreen extends StatefulWidget {
  const AppMainScreen({super.key});

  @override
  State<AppMainScreen> createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {
  String? _role;
  int selectedIndex = 0;
  bool _isLoading = true;
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      const Scaffold(),
      const Scaffold(),
      const Scaffold(),
      const Scaffold(),
      const Scaffold(),
    ];
    _loadUserRole();
  }

  // Role wise pages
  Future<void> _loadUserRole() async {
    final role = await UserApiService().getUserRole();
    setState(() {
      _role = role ?? 'student';
      _isLoading = false;

     if(_role == 'student'){
       pages= [
         const StudentHomeScreen(),
         const Scaffold(body: Center(child: Text("Student Search"))),
         const SizedBox(),
         const Scaffold(body: Center(child: Text("Student Notification"))),
         const Scaffold(body: Center(child: Text("Student profile"))),
       ];
     } else{
       pages= [
         const TuitorHomeScreen(),
         const Scaffold(body: Center(child: Text("Tutor Search"))),
         const Scaffold(body: Center(child: Text("Tutor post"))),
         const Scaffold(body: Center(child: Text("Tutor Notification"))),
         const Scaffold(body: Center(child: Text("Tutor profile"))),
       ];
     }
    });

  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
          body: Center(
              child: GradientBackground(
                  child: CircularProgressIndicator()
              )
          )
      );

    }

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        unselectedItemColor: AppColors.white60,
        selectedItemColor: AppColors.accent,
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: (value) async { // <--- 1. async goes here
          if (value == 2 && _role == 'student') {
            // 2. Wait for the user to return from the Post screen
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PostTuitionScreen()),
            );

            // 3. Once they are back, refresh the data
            GetTuitionController().getTuition(() {
              if (mounted) {
                setState(() {}); // Trigger rebuild of Home Screen with new data
              }
            });

            // We do NOT call setState for selectedIndex here
            // because we want the BottomNav to stay on the "Home" icon.
          } else {
            // 4. Normal navigation for other tabs
            setState(() {
              selectedIndex = value;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: "Post",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notification_add_outlined),
            label: "Notification",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle_outlined),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
