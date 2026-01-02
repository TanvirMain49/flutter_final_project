import 'package:_6th_sem_project/core/services/tutor_api_service.dart';
import 'package:flutter/material.dart';

class TutorDataController {
  final _tuitionApiService = TutorApiService();
  List<Map<String, dynamic>> postTuition = [];
  String? errorMessage = '';
  bool isLoading = false;

  // get all tuition controller
  Future<void> getTuition(VoidCallback onUpdate) async {
    try {
      isLoading = true;
      errorMessage = '';
      onUpdate();
      final response = await _tuitionApiService.getTuition();
      if (response == null) errorMessage = 'No posts found';
      postTuition = response!;
    } catch (e) {
      debugPrint('getUserProfile error: $e');
      errorMessage = "Failed to load profile: $e";
    } finally {
      isLoading = false;
      onUpdate();
    }
  }
}
