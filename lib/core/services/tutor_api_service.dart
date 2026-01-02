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
    if(userId == null) return;
    try{
      await _supabase.from('save_post').insert({
        'user_id': userId,
        'post_id': postId
      });
    } catch (e){
      debugPrint('saveTuition error: $e');
    }
  }

  //get save tuition
  Future<List<Map<String, dynamic>>> fetchSavedPostIds() async{
    final userId =  _supabase.auth.currentUser?.id;
    if(userId == null) return [];
    try{
      final response = await _supabase.from('save_post').select('post_id').eq('user_id', userId);
      return response;
    } catch (e){
      debugPrint('fetchSavedPostIds error: $e');
      return[];
    }
  }

  // delete save tuition post
  Future<void> deleteSavedPost(String postId) async {
    final userId = _supabase.auth.currentUser?.id;
    try{
      await _supabase
          .from("save_post")
          .delete()
          .match({'user_id': userId!, 'post_id': postId});
    } catch (e){
      debugPrint('deleteSavedPost error: $e');
    }
  }


}
