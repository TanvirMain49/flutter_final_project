import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TutorApiService{
  final _supabase = Supabase.instance.client;

  //get all tutors
  Future<List<Map<String, dynamic>>?> getTutors() async {
    try{
      await _supabase
          .from('users')
          .select('''
            full_name,
            photo_photo,
          ''')
          .eq('role', 'tutor');
    } catch (e){
      debugPrint('getTutors error: $e');
      return null;
    }
  }

}