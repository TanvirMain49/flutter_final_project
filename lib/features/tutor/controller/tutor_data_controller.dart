import 'package:_6th_sem_project/core/services/tutor_api_service.dart';
import 'package:flutter/material.dart';

class TutorDataController {
  final _tuitionApiService = TutorApiService();
  List<Map<String, dynamic>> postTuition = [];
  List<String> savedPostIds = [];
  String? errorMessage = '';
  String? successMessage= '';
  bool isLoading = false;
  bool isSave = false;

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

  Future<void> syncSavedPosts() async {
    // 1. Fetch the raw data from your API service
    final List<Map<String, dynamic>> data = await _tuitionApiService.fetchSavedPostIds();
    savedPostIds = data.map((item) => item['post_id'].toString()).toList();
    // debugPrint("Synced Saved Posts: $savedPostIds");
  }

  Future<String?> toggleSave(String postId, VoidCallback onUpdate) async{
    final bool wasSaved = savedPostIds.contains(postId);
    isSave = true;
    onUpdate();

    // locally save the id so that we can update the ui fast
    if(wasSaved){
      savedPostIds.remove(postId);
    } else{
      savedPostIds.add(postId);
    }
    try{
      if(wasSaved) {
        await _tuitionApiService.deleteSavedPost(postId);
        return "Post removed from saved";
      }
      await _tuitionApiService.saveTuition(postId);
      return "Saved successfully!";

    } catch(e){
      if(wasSaved){
        savedPostIds.add(postId);
      }else{
        savedPostIds.remove(postId);
      }
      isSave= false;
      onUpdate();
      debugPrint("Toggle Save Error: $e");
      return null;
    } finally{
      isSave = false;
      onUpdate();
    }
  }
}
