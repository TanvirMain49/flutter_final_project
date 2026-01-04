import 'package:_6th_sem_project/core/services/tutor_api_service.dart';
import 'package:flutter/material.dart';

class TutorDataController {
  final _tuitionApiService = TutorApiService();

  // Text-controller
  TextEditingController tutorMessageController = TextEditingController();

  List<Map<String, dynamic>> postTuition = [];
  List<Map<String, dynamic>> tutorApplications = [];
  List<String> savedPostIds = [];
  List<String> appliedPostIds = [];
  String? errorMessage = '';
  String? successMessage = '';
  bool hasApplied = false;
  bool isLoading = false;
  bool isSave = false;
  bool isApply = false;
  bool isApplications = false;


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

  Future<void> getTuitionDetails(VoidCallback onUpdate) async {
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

  Future<void> syncSavedPosts() async {
    // 1. Fetch the raw data from your API service
    final List<Map<String, dynamic>> data = await _tuitionApiService
        .fetchSavedPostIds();
    savedPostIds = data.map((item) => item['post_id'].toString()).toList();
    // debugPrint("Synced Saved Posts: $savedPostIds");
  }

  Future<String?> toggleSave(String postId, VoidCallback onUpdate) async {
    final bool wasSaved = savedPostIds.contains(postId);
    isSave = true;
    onUpdate();

    // locally save the id so that we can update the ui fast
    if (wasSaved) {
      savedPostIds.remove(postId);
    } else {
      savedPostIds.add(postId);
    }
    try {
      if (wasSaved) {
        await _tuitionApiService.deleteSavedPost(postId);
        return "Post removed from saved";
      }
      await _tuitionApiService.saveTuition(postId);
      return "Saved successfully!";
    } catch (e) {
      if (wasSaved) {
        savedPostIds.add(postId);
      } else {
        savedPostIds.remove(postId);
      }
      isSave = false;
      onUpdate();
      debugPrint("Toggle Save Error: $e");
      return null;
    } finally {
      isSave = false;
      onUpdate();
    }
  }

  Future<bool> applyForTuition(String postId, VoidCallback onUpdate) async {
    isApply = true;
    onUpdate();
    try {
      await _tuitionApiService.postTuitionApplication(
        postId: postId,
        message: tutorMessageController.text.trim(),
      );
      return true; // Return true if API call succeeds
    } catch (e) {
      debugPrint("Apply Tuition Error: $e");
      return false; // Return false if it fails
    } finally {
      isApply = false;
      onUpdate();
    }
  }

  Future<void> cheekIfApplied(String postId, VoidCallback onUpdate) async {
    hasApplied = await _tuitionApiService.checkIfApplied(postId);
    debugPrint("hasApplied: $hasApplied");
    onUpdate();
  }

  Future<void> syncAppliedPosts(VoidCallback onUpdate) async{
    try{
      final response = await _tuitionApiService.syncAppliedPosts();
      if (response.isNotEmpty){
        appliedPostIds = response
            .map((item)=> item['tuition_post_id'].toString()).toList();
        debugPrint("Applied posts synced: ${appliedPostIds.length}");
      }
    } catch (e){
      debugPrint("Controller syncAppliedPosts error: $e");
    } finally {
      onUpdate();
    }
  }

//   get one user applications
Future<void> getTutorApplications({String? status,required VoidCallback onUpdate}) async {
  try {
    isApplications = true;
    onUpdate();
    final response = await _tuitionApiService.getTutorApplications(status: status);
    tutorApplications = response;

  } catch (e) {
    debugPrint('getUserProfile error: $e');
    throw "Failed to load profile: $e";
  } finally {
    isApplications = false;
    onUpdate();
  }
}

}
