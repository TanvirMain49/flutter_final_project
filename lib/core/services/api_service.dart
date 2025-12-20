import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserApiService {
  final _supabase = Supabase.instance.client;

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
          .single();
      return data;
    } catch (e, stackTrace){
      debugPrint('getUserProfile error: $e');
      debugPrintStack(stackTrace: stackTrace);
      return null;
    }
  }

}
