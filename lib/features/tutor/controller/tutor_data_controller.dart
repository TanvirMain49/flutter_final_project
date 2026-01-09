import 'package:_6th_sem_project/core/services/tutor_api_service.dart';
import 'package:flutter/material.dart';

class TutorDataController {
  final _tuitionApiService = TutorApiService();
  // Text-controller
  List<Map<String, dynamic>> postTuition = [];
  List<Map<String, dynamic>> tutorApplications = [];
  List<Map<String, dynamic>> savedPosts = [];
  List<String> savedPostIds = [];
  List<String> appliedPostIds = [];
  String? successMessage = '';
  bool isSavedPost = false;
  bool isCompleteProfile = false;
  bool hasApplied = false;
  bool isLoading = false;
  bool isSave = false;
  bool isApply = false;
  bool isApplications = false;
  bool isFetchSavePost = false;

  // get all tuition controller
  Future<void> getTuition(
    VoidCallback onUpdate, {
    String? searchQuery,
    String? filterQuery,
  }) async {
    try {
      isLoading = true;
      onUpdate();
      final response = await _tuitionApiService.getTuition(
        searchQuery: searchQuery,
        filterQuery: filterQuery,
      );
      postTuition = response;
    } catch (e) {
      debugPrint('getUserProfile error: $e');
    } finally {
      isLoading = false;
      onUpdate();
    }
  }

  Future<void> getTuitionDetails(VoidCallback onUpdate) async {
    try {
      isLoading = true;
      onUpdate();
      final response = await _tuitionApiService.getTuition();
      postTuition = response;
    } catch (e) {
      debugPrint('getUserProfile error: $e');
    } finally {
      isLoading = false;
      onUpdate();
    }
  }

  Future<String?> toggleSave(
    String postId,
    VoidCallback onUpdate,
    bool wasSaved,
  ) async {
    // final bool wasSaved = savedPostIds.contains(postId);
    isSave = true;
    onUpdate();

    // locally save the id so that we can update the ui fast
    // if (wasSaved) {
    //   savedPostIds.remove(postId);
    // } else {
    //   savedPostIds.add(postId);
    // }
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

  Future<void> isSavedTuitionPost(String postId, VoidCallback onUpdate) async {
    try {
      isSavedPost = await _tuitionApiService.isSavedPost(postId);
      // isSavedPost =  response;
      onUpdate();
    } catch (e) {
      debugPrint('Check saved status error: $e');
      isSavedPost = false;
    }
  }

  Future<void> getSavedPosts(VoidCallback onUpdate) async {
    try {
      isFetchSavePost = true;
      onUpdate();
      final response = await _tuitionApiService.fetchSavedPosts();
      savedPosts = response;
    } catch (e) {
      debugPrint("Controller getSavedPosts error: $e");
    } finally {
      isFetchSavePost = false;
      onUpdate();
    }
  }

  Future<bool> applyForTuition(
    String postId,
    String? tutorMessage,
    VoidCallback onUpdate,
  ) async {
    isApply = true;
    onUpdate();
    try {
      await _tuitionApiService.postTuitionApplication(
        postId: postId,
        message: tutorMessage,
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

  Future<void> isCompleteTutorProfile(VoidCallback refreshUI) async {
    isCompleteProfile = await _tuitionApiService.isCompleteProfile();
    refreshUI();
  }

  //   get one user applications
  Future<void> getTutorApplications({
    String? status,
    required VoidCallback onUpdate,
  }) async {
    try {
      isApplications = true;
      onUpdate();
      final response = await _tuitionApiService.getTutorApplications(
        status: status,
      );
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
