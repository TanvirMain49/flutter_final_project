import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TutorApiService {
  final _supabase = Supabase.instance.client;

  //get all tuition
  Future<List<Map<String, dynamic>>?> getTuition() async {
    try {
      final response = await _supabase.from("tuition_post").select('''
            *,
            subjects: subject_id(
              name
            ),
            users: student_id(
              full_name
            )
          ''');
      return response;
    } catch (e) {
      debugPrint('getTuition error: $e');
      return null;
    }
  }

  // get tuition details
  Future<Map<String, dynamic>?> getTuitionDetails(String postId) async {
    try {
      return await _supabase
          .from('tuition_post')
          .select('''
          *,
          subjects: subject_id(
            name
          ),
          users: student_id(
            id,
            full_name,
            role,
            phone_number,
            email,
            profile_photo
          )
          ''')
          .eq('id', postId)
          .maybeSingle();
    } catch (e) {
      debugPrint('getTuitionDetails error: $e');
      return null;
    }
  }

  // save tuition
  Future<void> saveTuition(String postId) async {
    final userId = await _supabase.auth.currentUser?.id;
    if (userId == null) return;
    try {
      await _supabase.from('save_post').insert({
        'user_id': userId,
        'post_id': postId,
      });
    } catch (e) {
      debugPrint('saveTuition error: $e');
    }
  }

  //get save tuition
  Future<List<Map<String, dynamic>>> fetchSavedPostIds() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];
    try {
      final response = await _supabase
          .from('save_post')
          .select('post_id')
          .eq('user_id', userId);
      return response;
    } catch (e) {
      debugPrint('fetchSavedPostIds error: $e');
      return [];
    }
  }

  // delete save tuition post
  Future<void> deleteSavedPost(String postId) async {
    final userId = _supabase.auth.currentUser?.id;
    try {
      await _supabase.from("save_post").delete().match({
        'user_id': userId!,
        'post_id': postId,
      });
    } catch (e) {
      throw 'An unexpected error occurred: $e';
      debugPrint('deleteSavedPost error: $e');
    }
  }


  // post tuition
  Future<void> postTuitionApplication({required String postId, String? message,}) async {
    try {
      // 1. Get the current logged-in user (Tutor)
      final userId = _supabase.auth.currentUser?.id;

      if (userId == null) {
        throw 'User must be logged in to complete a tutor profile.';
      }
      await _supabase.from('tuition_application').insert({
        'tuition_post_id': postId,
        'tutor_id': userId,
        'message': message,
        'status': 'pending',
      });

    } on PostgrestException catch (e) {
      // Handle database-specific errors (like duplicate applications)
      debugPrint('Postgrest Error: ${e.message}');
      throw e.message;
    } catch (e) {
      debugPrint('postTuition error: $e');
      throw 'An unexpected error occurred.';
    }
  }

  // cheek user if he applied it or not
  Future<bool> checkIfApplied(String postId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return false;

    final response = await _supabase
        .from('tuition_application')
        .select()
        .eq('tuition_post_id', postId)
        .eq('tutor_id', userId)
        .maybeSingle();

    return response != null;
  }
  
  // cheek which which id has been applied
  Future<List<Map<String, dynamic>>> syncAppliedPosts() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [] ;

    final response = await _supabase
        .from('tuition_application')
        .select('tuition_post_id')
        .eq('tutor_id', userId);
    return response;
  }


  Future<List<Map<String, dynamic>>> getTutorApplications({String? status}) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return [];

      // Build the query with all necessary fields
      var query = _supabase
          .from('tuition_application')
          .select('''
          *,
          tuition_post: tuition_post_id(
            id,
            grade,
            student_location,
            salary,
            status,
            subject_id: subjects(name)
          )
        ''')
          .eq('tutor_id', userId);

      // Apply status filter if provided
      if (status != null && status != 'All') {
        query = query.eq('status', status.toLowerCase());
      }

      // Get data ordered by newest first
      final response = await query.order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);

    } on PostgrestException catch (e) {
      debugPrint('Database Error: ${e.message}');
      throw e.message;
    } catch (e) {
      debugPrint('Error: $e');
      throw 'An unexpected error occurred.';
    }
  }












  // post tutor skill
  Future<void> tuitionSkillPost({
    required String subjectId,
    required String experienceAt,
    required String educationAt,
    required String salary,
    required String experienceYears,
    required String availability,
  }) async {
    try {
      // 1. Get the current user ID inside the function
      final userId = _supabase.auth.currentUser?.id;

      if (userId == null) {
        throw 'User must be logged in to complete a tutor profile.';
      }
      // 2. Map variables to the exact database column names
      final Map<String, dynamic> tutorData = {
        'tutor_id': userId, // UUID
        'subject_id': subjectId, // UUID
        'experience_at': experienceAt, // text
        'education_at': educationAt, // text
        'salary': salary, // text
        'experience_years': experienceYears, // text
        'availability': availability, // text
      };

      // 3. Perform the insert
      await _supabase.from('tutor_skills').insert(tutorData);
    } on PostgrestException catch (error) {
      // Handles specific Supabase errors like Foreign Key violations
      throw error.message;
    } catch (error) {
      throw 'An unexpected error occurred: $error';
    }
  }
}
