import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudentApiService {
  final _supabase = Supabase.instance.client;

  // Post Tuition
  Future<void> postTuition({
    required String title,
    required String subjectId,
    required String studentId,
    required String grade,
    required String location,
    required String days,
    required String startTime,
    required String endTime,
    required int budget,
    String? details,
  }) async {
    try {
      await _supabase.from('tuition_post').insert({
        'subject_id': subjectId,
        'student_id': studentId,
        'post_title': title,
        'grade': grade,
        'student_location': location,
        'preferred_day': days,
        'start_time': startTime,
        'end_time': endTime,
        'salary': budget,
        'description': details ?? '',
        'status': "active",
      });
    } catch (e) {
      debugPrint('postTuition error: $e');
      rethrow;
    }
  }

  //   get my tuition post
  Future<List<Map<String, dynamic>>?> getMyTuitionPost() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return null;

      final response = await _supabase
          .from('tuition_post')
          .select('''
        *,
        subjects: subject_id(
        name
        )
        ''')
          .eq('student_id', userId);
      if (response.isEmpty) return null;
      return response;
    } catch (e) {
      debugPrint('getTuitionDetails error: $e');
      return null;
    }
  }
}
