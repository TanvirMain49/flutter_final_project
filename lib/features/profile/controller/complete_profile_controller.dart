import 'package:flutter/material.dart';
import 'package:_6th_sem_project/core/services/api_service.dart';
import 'package:_6th_sem_project/core/services/tutor_api_service.dart';

class CompleteProfileController {
  // --- Controllers ---
  // Senior Tip: Keep controllers final so they aren't accidentally reassigned
  final experienceAtController = TextEditingController();
  final salaryController = TextEditingController();
  final educationAtController = TextEditingController();
  final experienceYearController = TextEditingController();
  final subjectController = TextEditingController();

  // --- State Variables ---
  List<String> mySelectedDays = [];
  List<Map<String, dynamic>> subjects = [];
  String? selectedSubjectId;
  String? errorMessage;

  bool isLoading = false; // For fetching subjects
  bool isSubmitting = false; // For the POST request

  /// Senior Tip: Move validation logic to a getter for readability
  bool get isFormValid {
    return selectedSubjectId != null &&
        mySelectedDays.isNotEmpty &&
        salaryController.text.trim().isNotEmpty &&
        educationAtController.text.trim().isNotEmpty &&
        experienceYearController.text.trim().isNotEmpty;
  }

  // --- Methods ---

  Future<void> handleSave(BuildContext context, VoidCallback refreshUI) async {
    if (!isFormValid) {
      _showSnackBar(context, 'Please fill all required fields correctly', Colors.orange);
      return;
    }

    try {
      isSubmitting = true;
      refreshUI();

      await TutorApiService().tuitionSkillPost(
        subjectId: selectedSubjectId!,
        experienceAt: experienceAtController.text.trim(),
        educationAt: educationAtController.text.trim(),
        salary: salaryController.text.trim(),
        experienceYears: experienceYearController.text.trim(),
        availability: mySelectedDays.join(', '),
      );

      if (context.mounted) {
        _showSnackBar(context, 'Tutor profile completed successfully!', Colors.green);
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint("Save Error: $e");
      if (context.mounted) {
        _showSnackBar(context, 'Error: ${e.toString()}', Colors.red);
      }
    } finally {
      isSubmitting = false;
      refreshUI();
    }
  }

  Future<void> fetchSubjects(VoidCallback refreshUI) async {
    try {
      isLoading = true;
      errorMessage = null;
      refreshUI();

      final response = await SubjectsApiService().getSubject();
      subjects = response;

      if (subjects.isEmpty) {
        errorMessage = 'No subjects found';
      }
    } catch (e) {
      debugPrint('fetchSubjects error: $e');
      errorMessage = "Failed to load subjects: $e";
    } finally {
      isLoading = false;
      refreshUI();
    }
  }

  void handleSubjectSelection(String name, VoidCallback refreshUI) {
    subjectController.text = name;

    // Find the subject object. Using .cast<Map<String, dynamic>?>() for safety.
    final selected = subjects.firstWhere(
          (el) => el['name'] == name,
      orElse: () => <String, dynamic>{},
    );

    if (selected.isNotEmpty) {
      selectedSubjectId = selected['id']?.toString();
      debugPrint('Selected Subject ID: $selectedSubjectId');
    }

    refreshUI();
  }

  // Helper method to keep code DRY (Don't Repeat Yourself)
  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  /// Senior Tip: Always provide a dispose method in controllers
  /// that hold TextEditingControllers to prevent memory leaks.
  void dispose() {
    experienceAtController.dispose();
    salaryController.dispose();
    educationAtController.dispose();
    experienceYearController.dispose();
    subjectController.dispose();
  }
}