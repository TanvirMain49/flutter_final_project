import 'package:_6th_sem_project/core/services/api_service.dart';
import 'package:_6th_sem_project/core/services/tutor_api_service.dart';
import 'package:_6th_sem_project/features/student/api/student_api.dart';
import 'package:flutter/material.dart';


class GetTuitionController {
  List<Map<String, dynamic>>? tuitionData;
  List<Map<String, dynamic>> applicationTuition=[];
  Map<String, dynamic>? tuitionDetails;
  bool isLoading = true;
  bool isApplicationLoading = true;
  String? role;

  // 2. Create a function to load the role
  Future<void> initRole() async {
    role = await UserApiService().getUserRole();
    debugPrint("User Role Loaded: $role");
  }

  //  get tuition
  Future<void> getTuition(VoidCallback onUpdate) async {
    isLoading = true;
    onUpdate();
    try{
      final data = await TutorApiService().getTuition();
      if(data== null || data.isEmpty) tuitionData;

      tuitionData = data;
    } catch (e) {
      debugPrint('getTuition error: $e');
    }finally{
      isLoading = false;
      onUpdate();
    }
  }

  //  get tuition details by id
  Future<void> getTuitionDetails(String postId, VoidCallback onUpdate) async {
    isLoading = true;
    onUpdate();
    try{
      final data = await TutorApiService().getTuitionDetails(postId);
      if(data != null){
        tuitionDetails = data;
      }
    } catch (e){
      debugPrint('getTuitionDetails error: $e');
    }finally{
      isLoading = false;
      onUpdate();
    }
  }

  //  get all applied post
  Future<void> getAllAppliedPost(String postId, VoidCallback onUpdate) async {
  try{
    isApplicationLoading = true;
    onUpdate();
    final data = await StudentApiService().getAllApplicationForPost(postId);
    applicationTuition = data;
    } catch (e){
    debugPrint('getAllAppliedPost error: $e');
  }finally{
    isApplicationLoading = false;
    onUpdate();
  }
  }

  Future<void> hireTutor({
    required String applicationId,
    required String postId,
    required VoidCallback onSuccess,
    required VoidCallback refreshUI,
  }) async {
    try {
      isLoading = true;
      refreshUI();

      // 1. Mark selected application as 'hired'
      // 2. Mark other applications for this post as 'rejected'
      // 3. Update tuition_post status to 'closed'
      final success = await StudentApiService().processHiring(
        tutorId: applicationId,
        postId: postId,
      );
      onSuccess();
      await getAllAppliedPost(postId, refreshUI);
    } catch (e) {
      debugPrint('hireTutor error: $e');
    } finally {
      isLoading = false;
      refreshUI();
    }
  }

}