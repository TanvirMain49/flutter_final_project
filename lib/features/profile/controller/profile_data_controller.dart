import 'package:_6th_sem_project/core/services/api_service.dart';
import 'package:flutter/material.dart';

class ProfileDataController {

  final _userApiService = UserApiService();
  final Map<String, dynamic> userProfile = {};
  String? errorMessage = '';
  bool isLoading = false;

  Future<void> getUserProfile(VoidCallback onUpdate) async{
    try{
      isLoading = true;
      errorMessage = '';
      onUpdate();
      final response = await _userApiService.getUserProfile();
      if(response != null){
        userProfile.addAll(response);
      }
    } catch (e){
      debugPrint('getUserProfile error: $e');
      errorMessage = "Failed to load profile: $e";
    } finally{
      isLoading = false;
      onUpdate();
    }
  }

}