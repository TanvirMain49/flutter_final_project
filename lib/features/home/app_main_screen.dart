import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/services/api_service.dart';
import 'package:_6th_sem_project/features/student/controller/get_tuition_controller.dart';
import 'package:_6th_sem_project/features/student/screen/explore_tutor.dart';
import 'package:_6th_sem_project/features/student/screen/my_tuition_posts.dart';
import 'package:_6th_sem_project/features/student/screen/post_tuition.dart';
import 'package:_6th_sem_project/features/student/screen/student_home.dart';
import 'package:_6th_sem_project/features/profile/screen/user_profile.dart';
import 'package:_6th_sem_project/features/tutor/screen/explore_tuition_screen.dart';
import 'package:_6th_sem_project/features/tutor/screen/my_application_page.dart';
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

  List<BottomNavigationBarItem> _navItems =  [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
  ];

  List<Widget> _pages = [
    const Scaffold(),
    const Scaffold(),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final role = await UserApiService().getUserRole();
    _role = role?.toLowerCase() ?? 'student';

    _setupNavigation();

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _setupNavigation() {
    if (_role == 'student') {
      _navItems = const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Explore"),
        BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined), label: "Post"),
        BottomNavigationBarItem(icon: Icon(Icons.work_outline), label: "My Posts"),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
      ];
      _pages = [
        const StudentHomeScreen(),
        const ExploreTutorScreen(),
        const SizedBox(), // Placeholder for the Nav push logic
        const MyTuitionPosts(),
        const UserProfile(),
      ];
    } else {
      // TUTOR ROLE: Remove the "Post" item entirely
      _navItems = [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Tuitions"),
        BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: "My Applications"),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
      ];
      _pages = [
        const TutorHomeScreen(),
        const ExploreTuitionScreen(),
        const MyApplicationsScreen(),
        const UserProfile(),
      ];
    }
  }

  void _onItemTapped(int index) async {
    // Check if user clicked "Post" (Index 2 for Student)
    if (_role == 'student' && index == 2) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PostTuitionScreen()),
      );
      // if (_role != 'student' && index == 2) {
      //   await Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => const MyApplicationsScreen()),
      //   );
      // }
      // Refresh Home data after returning
      GetTuitionController().getTuition(() => _safeSetState());
      return;
    }

    setState(() => selectedIndex = index);
  }

  void _safeSetState() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // 1. Show loading screen until the role and navigation items are ready
    if (_isLoading || _navItems.isEmpty) {
      return _buildLoading();
    }

    // 2. Only render this once _navItems is guaranteed to be filled (length 4 or 5)
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: IndexedStack(
        index: selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        unselectedItemColor: AppColors.white60,
        selectedItemColor: AppColors.accent,
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
        items: _navItems, // This is now safe
      ),
    );
  }

  Widget _buildLoading() {
    return const Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Center(child: CircularProgressIndicator(color: AppColors.accent)),
    );
  }
}
