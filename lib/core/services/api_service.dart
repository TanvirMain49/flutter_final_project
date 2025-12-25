import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserApiService {
  final _supabase = Supabase.instance.client;
  static List<Map<String, dynamic>>? _cachedSubjects;

  // 1. Create User Profile (Run after Sign-up)
  Future<void> createUserProfile({
    required String id,
    required String email,
    required String fullName,
    required String role,
    String? phoneNumber,
    String? profilePhoto,
    String? bio,
    String? gender,
    String? location,
  }) async {
    try{
      await _supabase.from('users').insert({
        'id': id,
        'email': email,
        'full_name': fullName,
        'role': role,
        'phone_number': phoneNumber,
        'profile_photo': profilePhoto,
        'bio': bio,
        'gender': gender,
        'location': location,
      });
    } on PostgrestException catch (error) {
      // If RLS is blocking you, the code is usually '42501'
      debugPrint("Supabase Error Code: ${error.code}");
      debugPrint("Message: ${error.message}");
      rethrow;
    }
  }

  //Fetch Current User Details
  Future<Map<String, dynamic>?> getUserProfile() async{
    try{
      final userId = _supabase.auth.currentUser?.id;
      if(userId == null) return null;

      final data = await _supabase
          .from("users")
          .select()
          .eq("id", userId)
          .maybeSingle();

      debugPrint(data.toString());

    } catch (e, stackTrace){
      debugPrint('getUserProfile error: $e');
      debugPrintStack(stackTrace: stackTrace);
      return null;
    }
  }

  Future<String?> getUserRole() async{
    try{
      final userId = await _supabase.auth.currentUser?.id;
      if(userId == null) return null;

      final response = await _supabase
          .from("users")
          .select('role')
          .eq("id", userId)
          .single();
      final role = response['role'] as String;
      return role;
    } catch(e, stackTrace){
      debugPrint('getUserProfile error: $e');
      debugPrintStack(stackTrace: stackTrace);
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getSubject() async{
    if(_cachedSubjects != null) return _cachedSubjects!;
    try{
      final response = await _supabase.from('subjects').select();
      _cachedSubjects = response;
      return _cachedSubjects!;
    } catch (e, stackTrace){
      debugPrint('getUserProfile error: $e');
      debugPrintStack(stackTrace: stackTrace);
      return [];
    }
  }


}
