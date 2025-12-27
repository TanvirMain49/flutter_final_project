import 'package:_6th_sem_project/features/student/api/student_api.dart';
import 'package:flutter/material.dart';


class getTuitionPost {
  List<Map<String, dynamic>>? tuitionData;
  bool isLoading = true;

  //  get tuition
  Future<void> getTuition(VoidCallback onUpdate) async {
    isLoading = true;
    onUpdate();
    try{
      final data = await StudentApiService().getTuition();
      debugPrint(data.toString());
      if(data!= null){
        tuitionData = data;
      }
    } catch (e) {
      debugPrint('getTuition error: $e');
    }finally{
      isLoading = false;
      onUpdate();
    }
  }

}