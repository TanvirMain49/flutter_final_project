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

  //  get all application for one post
  Future<List<Map<String, dynamic>>> getAllApplicationForPost(String postId) async {
    try{
      return await _supabase
          .from('tuition_application')
          .select('''
    *,
    users:tutor_id (
      id,
      full_name,
      email,
      phone_number,
      tutor_skills (
        experience_years,
        education_at,
        salary,
        availability,
        experience_at
      )
    )
  ''')
          .eq('tuition_post_id', postId);
    } catch(e){
      debugPrint('getAllApplicationForPost error: $e');
      rethrow;
    }
  }

  Future<void> processHiring({
    required String tutorId,
    required String postId,
  }) async {
    try {
      // 1. Mark the selected tutor as hired
      await _supabase
          .from('tuition_application')
          .update({'status': 'hired'})
          .eq('tutor_id', tutorId)
          .eq('tuition_post_id', postId);

      // 2. Automatically reject everyone else for this specific post
      await _supabase
          .from('tuition_application')
          .update({'status': 'rejected'})
          .eq('tuition_post_id', postId)
          .neq('tutor_id', tutorId); // Do not reject the person we just hired

      // 3. Close the tuition post so it's no longer 'Open'
      await _supabase
          .from('tuition_post')
          .update({'status': 'closed'})
          .eq('id', postId);

    } catch (e) {
      debugPrint("Hiring Process Error: $e");
    }
  }

    // reject tutor
  Future<void> processRejecting({
    required String tutorId,
    required String postId,
  }) async {
    try {

      // 1. reject the person for this specific post
      await _supabase
          .from('tuition_application')
          .update({'status': 'rejected'})
          .eq('tuition_post_id', postId)
          .eq('tutor_id', tutorId); // Do not reject the person we just hired

      // 3. Close the tuition post so it's no longer 'Open'
      await _supabase
          .from('tuition_post')
          .update({'status': 'closed'})
          .eq('id', postId);

    } catch (e) {
      debugPrint("Rejecting Process Error: $e");
    }
  }


    //  get all tutor
  Future<List<Map<String, dynamic>>> getAllTutor({String? searchQuery, String? subject}) async{
    try{
      var query = _supabase
          .from('users')
          .select('''
          *,
          tutor_skills!inner(
          *,
          subjects!inner(
            name
          )
          )
          ''')
          .eq('role', 'Tutor');

      if(subject != null){
        query = query.eq('tutor_skills.subjects.name', subject);
      }
      if(searchQuery != null && searchQuery.isNotEmpty){
        query = query.ilike('full_name', '%$searchQuery%');
      }

      final response = await query.order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);

    } catch(e){
      debugPrint('getAllTutor error: $e');
      rethrow;
    }
  }

}
