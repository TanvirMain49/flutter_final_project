import 'package:_6th_sem_project/core/services/api_service.dart';
import 'package:_6th_sem_project/core/services/tutor_api_service.dart';
import 'package:flutter/material.dart';


class GetTuitionController {
  List<Map<String, dynamic>>? tuitionData;
  Map<String, dynamic>? tuitionDetails;
  bool isLoading = true;
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

}