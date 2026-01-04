import 'package:flutter/material.dart';
import 'package:_6th_sem_project/core/services/api_service.dart';
import 'package:_6th_sem_project/features/student/api/student_api.dart';

class ProfileDataController {
  // --- Services ---
  final _userApiService = UserApiService();
  final _studentApiService = StudentApiService();

  // --- State Variables ---
  // Senior Tip: Use final for collections to prevent accidental reassignment
  final Map<String, dynamic> userProfile = {};
  List<Map<String, dynamic>> myTuitionPosts = []; // Fixed naming to plural

  String? errorMessage;
  bool isLoading = false;

  // --- Computed Properties ---

  /// Determines if the user is a tutor based on the existence of tutor_skills
  bool get isTutor {
    if (userProfile.isEmpty) return false;
    final skills = userProfile['tutor_skills'] as List?;
    return skills != null && skills.isNotEmpty;
  }
  bool get isTutorRole => userProfile['role'] == 'tutor';

  /// The logic you wanted: Is the user a tutor who HAS NOT finished their profile?
  bool get needsCompletion => isTutorRole && !isTutor;

  /// Safely retrieves tutor data if it exists
  Map<String, dynamic>? get tutorDetails {
    final skills = userProfile['tutor_skills'] as List?;
    return (skills != null && skills.isNotEmpty) ? skills.first : null;
  }

  // --- Methods ---

  /// Fetches the core user profile data including related tutor skills
  Future<void> fetchUserProfile(VoidCallback refreshUI, {bool forceRefresh = false}) async {
    debugPrint("called");
    debugPrint("User: $userProfile");
    if (userProfile.isNotEmpty && !forceRefresh) return;
    try {
      _setLoading(true, refreshUI);
      errorMessage = null;

      final response = await _userApiService.getUserProfile();

      if (response != null) {
        userProfile.clear(); // Clear old data before updating
        userProfile.addAll(response);
      } else {
        errorMessage = "User profile not found.";
      }
    } catch (e) {
      debugPrint('fetchUserProfile error: $e');
      errorMessage = "Failed to load profile. Please try again.";
    } finally {
      _setLoading(false, refreshUI);
    }
  }

  /// Fetches the tuition posts created by the current student
  Future<void> fetchMyTuitionPosts(VoidCallback refreshUI) async {
    try {
      _setLoading(true, refreshUI);
      errorMessage = null;

      final response = await _studentApiService.getMyTuitionPost();

      // Senior Tip: Always handle null/empty responses gracefully
      myTuitionPosts = response ?? [];

      if (myTuitionPosts.isEmpty) {
        debugPrint('No tuition posts found for this user.');
      }
    } catch (e) {
      debugPrint('fetchMyTuitionPosts error: $e');
      errorMessage = "Failed to load tuition posts.";
    } finally {
      _setLoading(false, refreshUI);
    }
  }

  // --- Private Helpers ---

  /// Internal helper to manage loading state and UI updates
  void _setLoading(bool value, VoidCallback refreshUI) {
    isLoading = value;
    refreshUI();
  }
}