// import 'package:flutter/material.dart';
//
// class PostTuitionController {
//   // ---------------- STATE ----------------
//   String? selectedGradeLevel;
//   List<String> mySelectedDays = [];
//
//   TimeOfDay startTime = const TimeOfDay(hour: 19, minute: 0);
//   TimeOfDay endTime = const TimeOfDay(hour: 21, minute: 0);
//
//   final TextEditingController subjectController = TextEditingController();
//   final TextEditingController locationController = TextEditingController();
//   final TextEditingController budgetController = TextEditingController();
//   final TextEditingController detailsController = TextEditingController();
//
//   int currentStep = 1;
//
//   // ---------------- VALIDATION ----------------
//   bool _validateForm() {
//     // Basic field check
//     if (subjectController.text.trim().isEmpty ||
//         selectedGradeLevel == null ||
//         mySelectedDays.isEmpty ||
//         locationController.text.trim().isEmpty ||
//         budgetController.text.trim().isEmpty) {
//       _showError("Please fill in all details");
//       return false;
//     }
//
//     // budget cheek
//     if(!RegExp(r'^\d+$').hasMatch(budgetController.text)){
//       _showError("Budget must be a number");
//       return false;
//     }
//     if(int.parse(budgetController.text) < 0 || int.parse(budgetController.text) <= 1000){
//       _showError("Minimum budget is 2000 and also budget can't be negative");
//       return false;
//     }
//
//     // At lest two class in a week
//     if( mySelectedDays.length < 3){
//       _showError("At least three days are required");
//       return false;
//     }
//
//     // Time logic check
//     double start = startTime.hour + startTime.minute / 60.0;
//     double end = endTime.hour + endTime.minute / 60.0;
//     if (start >= end) {
//       _showError("End time must be after start time");
//       return false;
//     }
//     return true;
//   }
//
//   // ---------------- HELPERS ----------------
//   void toggleDay(String day) {
//     selectedDays.contains(day)
//         ? selectedDays.remove(day)
//         : selectedDays.add(day);
//   }
//
//   String formattedDays() {
//     return selectedDays.length == 7
//         ? "Daily (Mon-Sun)"
//         : selectedDays.join(", ");
//   }
//   void _showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.redAccent,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }
//
//   void nextStep() => currentStep++;
//   void previousStep() => currentStep--;
//
//   void dispose() {
//     subjectController.dispose();
//     locationController.dispose();
//     budgetController.dispose();
//     detailsController.dispose();
//   }
// }

import 'package:_6th_sem_project/core/services/api_service.dart';
import 'package:flutter/cupertino.dart';

class SubjectController extends ChangeNotifier {
  List<Map<String, dynamic>> _subjects = [];

  List<Map<String, dynamic>> get subjects => _subjects;

  Future<void> fetchSubjects() async {
    if (_subjects.isNotEmpty) return; // simple in-memory cache
    _subjects = await UserApiService().getSubject();
    notifyListeners();
  }
}

