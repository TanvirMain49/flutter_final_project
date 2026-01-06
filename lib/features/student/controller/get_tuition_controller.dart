import 'package:_6th_sem_project/core/services/api_service.dart';
import 'package:_6th_sem_project/core/services/tutor_api_service.dart';
import 'package:_6th_sem_project/features/student/api/student_api.dart';
import 'package:flutter/material.dart';

class GetTuitionController {
  List<Map<String, dynamic>> tuitionData = [];
  List<Map<String, dynamic>> applicationTuition = [];
  List<Map<String, dynamic>> tutors = [];
  Map<String, dynamic>? tuitionDetails;
  Map<String, dynamic> tutorDetails={};
  bool isLoading = false;
  bool isApplicationLoading = false;
  bool isAllTutorLoading = false;
  bool isDeleteLoading = false;
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
    try {
      final data = await TutorApiService().getTuition();
      if (data == null || data.isEmpty) tuitionData;

      tuitionData = data;
    } catch (e) {
      debugPrint('getTuition error: $e');
    } finally {
      isLoading = false;
      onUpdate();
    }
  }

  //  get tuition details by id
  Future<void> getTuitionDetails(String postId, VoidCallback onUpdate) async {
    isLoading = true;
    onUpdate();
    try {
      final data = await TutorApiService().getTuitionDetails(postId);
      if (data != null) {
        tuitionDetails = data;
      }
    } catch (e) {
      debugPrint('getTuitionDetails error: $e');
    } finally {
      isLoading = false;
      onUpdate();
    }
  }

  //  get all applied post
  Future<void> getAllAppliedPost(String postId, VoidCallback onUpdate) async {
    try {
      isApplicationLoading = true;
      onUpdate();
      final data = await StudentApiService().getAllApplicationForPost(postId);
      applicationTuition = data;
    } catch (e) {
      debugPrint('getAllAppliedPost error: $e');
    } finally {
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


  Future<void> rejectTutor({
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
      final success = await StudentApiService().processRejecting(
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

  Future<void> getAllTuition(VoidCallback onUpdate, {String? searchQuery, String? subject}) async {
    try {
      isAllTutorLoading = true;
      onUpdate();
      final data = await StudentApiService().getAllTutor(searchQuery: searchQuery, subject: subject);
      tutors = data;
    } catch (e) {
      debugPrint('getAllTutor error: $e');
    } finally {
      isAllTutorLoading = false;
      onUpdate();
    }
  }

  Future<void> deletePost(String postId, VoidCallback onUpdate) async{
    try {
      isDeleteLoading = true;
      onUpdate();
     await StudentApiService().deletePost(postId);
    } catch (e) {
    debugPrint('getAllTutor error: $e');
    } finally {
      isDeleteLoading = false;
    onUpdate();
    }
  }

  Future<void> getTutorDetails(String tutorId, VoidCallback onUpdate) async {
    isLoading = true;
    onUpdate();

    try {
      // We select all user fields (*) and all related tutor_skill fields
      final response = await StudentApiService().getTutorDetails(tutorId);
      tutorDetails = response;
    } catch (e) {
      debugPrint('Error fetching tutor details: $e');
    } finally {
      isLoading = false;
      onUpdate();
    }
  }

}
