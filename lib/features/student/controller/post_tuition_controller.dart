import 'package:_6th_sem_project/features/student/api/student_api.dart';
import 'package:flutter/material.dart';
import 'package:_6th_sem_project/core/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class PostTuitionController {

  // --- Data Variables ---
  String? selectedGradeLevel;
  String? selectedSubjectId;
  int currentStep = 1;
  final int totalSteps = 2;

  bool isLoadingSubjects = true;
  bool isLoadingPost = false;

  TimeOfDay startTime = const TimeOfDay(hour: 19, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 21, minute: 0);

  List<String> mySelectedDays = [];
  List<Map<String, dynamic>> subjects = []; //from db value will be saved here

  // --- Controllers ---
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  // --- Logic: Load Subjects ---
  Future<void> loadSubjects(VoidCallback onUpdate) async {
    if (subjects.isNotEmpty) return; //if subject has data then no need to call api
    isLoadingSubjects = true;
    onUpdate();
    try {
      subjects = await SubjectsApiService().getSubject();
    } catch (e) {
      debugPrint("Error loading subjects: $e");
    } finally {
      isLoadingSubjects = false;
      onUpdate();
    }
  }

  // --- Logic: Handle Subject Selection (Mapping ID) ---
  void handleSubjectSelection(String name, VoidCallback onUpdate) {
    // 1. Update the visible text field
    subjectController.text = name;
    // 2. Search our data list to find the object that matches the name
    // .firstWhere goes through each 'Map' in the '_subjects' list
    final selected = subjects.firstWhere(
      (el) => el['name'] == name,
      orElse: () => {},
    );
    // 3. Extract the ID if the subject was found
    if (selected.isNotEmpty) {
      selectedSubjectId = selected['id']?.toString();
    }
    onUpdate();
  }

  // Send string type data formate
  String formatTimeOfDay(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return "$hours:$minutes:00";
  }

// ----Handle: Post Tuition ----
  Future<bool> postTuition(VoidCallback onUpdate) async {
    // 1. Set loading to true and notify UI
    isLoadingPost = true;
    onUpdate();

    try {
      // 2. Get the Current User
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        debugPrint('PostTuition: No logged-in user found');
        return false;
      }

      // 3. Format/Prepare Data
      String dayString = mySelectedDays.join(', ');

      // Ensure budget is valid
      int budgetValue = int.tryParse(budgetController.text) ?? 0;

      // 4. API Call
      await StudentApiService().postTuition(
        subjectId: selectedSubjectId!,
        studentId: user.id,
        title: titleController.text,
        grade: selectedGradeLevel!,
        location: locationController.text,
        days: dayString,
        startTime: formatTimeOfDay(startTime),
        endTime: formatTimeOfDay(endTime),
        budget: budgetValue,
        details: detailsController.text,
      );

      return true; // Success!
    } catch (e) {
      debugPrint('postTuition error: $e');
      return false; // Failure
    } finally {
      isLoadingPost = false;
      onUpdate();
    }
  }

  Future<bool> updateTuition(String postId, VoidCallback onUpdate) async {
    isLoadingPost = true;
    onUpdate();
    try{
      final Map<String, dynamic> updatedData = {
        'post_title': titleController.text.trim(),
        'student_location': locationController.text.trim(),
        'salary': budgetController.text.trim(),
        'description': detailsController.text.trim(),
        'grade': selectedGradeLevel,
        'subject_id': selectedSubjectId,
        'preferred_day': mySelectedDays.join(", "),
        'start_time': formatTimeOfDay(startTime),
        'end_time': formatTimeOfDay(endTime),
        'updated_at': DateTime.now().toIso8601String(),
      };
      await StudentApiService().updatePost(
        postId: postId,
        updatedData: updatedData,
      );
      return true;
    } catch (e){
      debugPrint('updateTuition error: $e');
      return false;
    } finally {
      isLoadingPost = false;
      onUpdate();
    }
  }



  // --- Logic: Validation ---
  String? validateForm() {
    if (subjectController.text.isEmpty ||
        titleController == null ||
        selectedGradeLevel == null ||
        mySelectedDays.isEmpty ||
        locationController.text.isEmpty ||
        budgetController.text.isEmpty) {
      return "Please fill in all details";
    }

    final budget = int.tryParse(budgetController.text) ?? 0;
    if (budget <= 1000) return "Minimum budget is 2000";

    if (mySelectedDays.length < 3) return "At least three days are required";

    double start = startTime.hour + startTime.minute / 60.0;
    double end = endTime.hour + endTime.minute / 60.0;
    if (start >= end) return "End time must be after start time";

    return null;
  }

  void dispose() {
    subjectController.dispose();
    locationController.dispose();
    budgetController.dispose();
    detailsController.dispose();
  }
}

