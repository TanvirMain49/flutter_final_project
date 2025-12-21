import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/services/api_service.dart';
import 'package:_6th_sem_project/core/widgets/gradient_background.dart';
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

      // first page scaffold
      pages[0] = role == 'student'?
          const StudentHomeScreen()
          : const TuitorHomeScreen();
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
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
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
